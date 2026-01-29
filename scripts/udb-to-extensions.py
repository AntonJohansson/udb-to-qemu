#!/usr/bin/env python3

import common
import argparse
import os


def qemu_extension_check(ext):
    """
    Return a string that would check if :ext: is enabled in QEMU.
    MISA and vendor extensions are treated differently.
    :param ext: String of extension name, e.g. "Xqci", "D", "Zcmp"
    """
    if len(ext) == 1:
        return f'riscv_has_ext(env, RV{ext})'
    else:
        return f'cpu->cfg.ext_{ext.lower()}'


def create_conflict_check(conflict):
    """
    Create a string such as

        "((riscv_has_ext(env, RVC) && riscv_has_ext(env, RVD)) || cpu->cfg.ext_zcd || ...)"

    that can be used in an if statement when validating extension conflicts
    in QEMU.
    :param conflict: YAML value of a "conflicts:" key in UDB
    """

    ext_checks = []
    ext_arr = []
    children = None
    op = ''

    assert isinstance(conflict, dict)
    if 'anyOf' in conflict:
        op = ' || '
        children = conflict['anyOf']
    elif 'allOf' in conflict:
        op = ' && '
        children = conflict['allOf']

    for child in children:
        if isinstance(child, dict):
            child_str, child_arr = create_conflict_check(child)
            ext_checks.append(f'({child_str})')
            ext_arr += (child_arr)
        else:
            ext_checks.append(qemu_extension_check(child))
            ext_arr.append(child)

    return op.join(ext_checks), ext_arr


def create_require_check(require):
    """
    Create a string such as

        "(!cpu->cfg.ext_zca || ...)"

    that can be used in an if statement when validating extension requirements
    in QEMU.
    :param require: YAML value of a "requires:" key in UDB
    """

    arr = []
    if not isinstance(require, list):
        arr.append(require)
    else:
        arr = require

    ext_names = []
    for child in arr:
        # I think this might be a bug in the UDB, but formats for specifying
        # requirements differ slightly, sometimes a dict is used, sometimes
        # a string:
        #   requires: { name: C, version: * }
        # vs
        #   requires: C.
        name = child['name'] if isinstance(child, dict) else child
        ext_names.append(name)

    ext_checks = [f'!{qemu_extension_check(e)}' for e in ext_names]
    require_check = ' || '.join(ext_checks)
    err_str = ','.join(ext_names)

    return require_check, err_str


def main():
    parser = argparse.ArgumentParser(
        prog='udb-to-extensions.py',
        description='Output QEMU glue code for extension enabling/disabling'
    )
    parser.add_argument('--ext-dirs', required=True,
                        help='Comma separated list of extension directories')
    parser.add_argument('--out', required=True)
    args = parser.parse_args()

    with open(args.out, 'w') as out:

        ext_print_version = {
            "xqciint",
        }

        exts = {}
        for file in sorted(os.listdir(args.ext_dirs)):
            y = common.load_yaml_or_exit(os.path.join(args.ext_dirs, file))
            exts[y['name'].lower()] = y

        out.write('/* Add to RISCVCPUConfig in cpu_cfg.h */\n')
        for name in exts:
            out.write(f'bool ext_{name};\n')

        out.write('\n')

        out.write('/* Add to riscv_cpu_vendor_exts[] in cpu.c */\n')
        for name in exts:
            version = ''
            if name in ext_print_version:
                semantic = exts[name]['versions'][-1]['version'].split('.')
                version = f'{semantic[0]}p{semantic[1]}'
            out.write(f'MULTI_EXT_CFG_BOOL("{name}{
                      version}", ext_{name}, false),\n')

        out.write('\n')

        out.write('/* Add to isa_edata_arr[] in cpu.c */\n')
        for name in exts:
            out.write(
                f'ISA_EXT_DATA_ENTRY({name}, PRIV_VERSION_1_12_0, ext_{name}),\n')

        out.write('\n')

        exts_with_imply = set()
        for name in exts:
            latest_version = exts[name]['versions'][-1]
            if 'implies' in latest_version:
                exts_with_imply.add(name)

        out.write(
            '/* Add defition to top-level and address to riscv_multi_ext_implied_rules[] in cpu.c */\n')
        for name in exts_with_imply:
            latest_version = exts[name]['versions'][-1]
            implied_exts = [f'CPU_CFG_OFFSET(ext_{imp["name"].lower()})'
                            for imp in latest_version['implies']]
            out.write(f'static RISCVCPUImpliedExtsRule {
                      name.upper()}_IMPLIED = {{\n')
            out.write(
                f'    .ext = CPU_CFG_OFFSET(ext_{name.lower()}),\n')
            out.write('    .implied_multi_exts = {\n')
            out.write(f'        {",\n        ".join(implied_exts)},\n')
            out.write('        RISCV_IMPLIED_EXTS_RULE_END\n')
            out.write('    },\n')
            out.write('};\n')

        # Collect all leaf-exensions with the same set of conflicts
        conflicts = {}
        conflicts_err_arr = {}
        for name in exts:
            # skip non-leaf extensions, and extensions without any conflicts
            if name in exts_with_imply or 'conflicts' not in exts[name]:
                continue
            check_str, check_arr = create_conflict_check(
                exts[name]['conflicts'])
            if check_str not in conflicts:
                conflicts[check_str] = set()
                conflicts_err_arr[check_str] = check_arr
            conflicts[check_str].add(name)

        for check_str in conflicts:
            exts_conflicts = conflicts[check_str]
            exts_qemu_check = [qemu_extension_check(e) for e in exts_conflicts]
            conflict_str = ",".join(conflicts_err_arr[check_str])
            # if any of the extensions are enabled, we need to check for
            # requirements
            out.write(f'if ({" || ".join(exts_qemu_check)}) {{\n')
            out.write(f'    if ({check_str}) {{\n')
            out.write(f'        error_setg(errp, "Any of the extensions: {
                ",".join(exts_conflicts)} conflicts with {conflict_str}");\n')
            out.write('        return;\n')
            out.write('    }\n')
            out.write('}\n')

        # Collect all leaf-exensions with the same set of requirements
        requires = {}
        require_err_strs = {}
        for name in exts:
            # skip non-leaf extensions, and extensions without any conflicts
            latest_version = exts[name]['versions'][-1]
            if name in exts_with_imply or 'requires' not in latest_version:
                continue
            check_str, err_str = create_require_check(
                latest_version['requires'])
            if check_str not in requires:
                requires[check_str] = set()
                require_err_strs[check_str] = err_str
            requires[check_str].add(name)

        for check_str in requires:
            exts_required = requires[check_str]
            exts_qemu_check = [qemu_extension_check(e) for e in exts_required]
            # if any of the extensions are enabled, we need to check for
            # requirements
            out.write(f'if ({" || ".join(exts_qemu_check)}) {{\n')
            out.write(f'    if ({check_str}) {{\n')
            out.write(f'        error_setg(errp, "Any of the extensions: {
                ",".join(exts_required)} requires {require_err_strs[check_str]}");\n')
            out.write('        return;\n')
            out.write('    }\n')
            out.write('}\n')

# static void rv64_thead_c906_cpu_init(Object *obj)
# {
#     CPURISCVState *env = &RISCV_CPU(obj)->env;
#     RISCVCPU *cpu = RISCV_CPU(obj);
#
#     riscv_cpu_set_misa_ext(env, RVG | RVC | RVS | RVU);
#     env->priv_ver = PRIV_VERSION_1_11_0;
#
#     cpu->cfg.ext_zfa = true;
#     cpu->cfg.ext_zfh = true;
#     cpu->cfg.mmu = true;
#     cpu->cfg.ext_xtheadba = true;
#     cpu->cfg.ext_xtheadbb = true;
#     cpu->cfg.ext_xtheadbs = true;
#     cpu->cfg.ext_xtheadcmo = true;
#     cpu->cfg.ext_xtheadcondmov = true;
#     cpu->cfg.ext_xtheadfmemidx = true;
#     cpu->cfg.ext_xtheadmac = true;
#     cpu->cfg.ext_xtheadmemidx = true;
#     cpu->cfg.ext_xtheadmempair = true;
#     cpu->cfg.ext_xtheadsync = true;
#
#     cpu->cfg.mvendorid = THEAD_VENDOR_ID;
# #ifndef CONFIG_USER_ONLY
#     set_satp_mode_max_supported(cpu, VM_1_10_SV39);
#     th_register_custom_csrs(cpu);
# #endif
#
#     /* inherited from parent obj via riscv_cpu_init() */
#     cpu->cfg.pmp = true;
# }


if __name__ == '__main__':
    main()
