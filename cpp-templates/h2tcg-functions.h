//
// Functions required for helper-to-tcg to interface correctly with QEMU.
//
// Copyright (c) 2025 rev.ng Labs Srl.
//
// This work is licensed under the terms of the GNU GPL, version 2 or
// (at your option) any later version.
//
// See the LICENSE file in the top-level directory for details.
//

#pragma once

#include <stdint.h>

#include "base-structs.h"

struct CPUArchState;
using abi_ptr = uint32_t;

uint32_t cpu_ldub_data(CPUArchState *env, abi_ptr ptr);
uint32_t cpu_lduw_le_data(CPUArchState *env, abi_ptr ptr);
uint32_t cpu_ldl_le_data(CPUArchState *env, abi_ptr ptr);
uint64_t cpu_ldq_le_data(CPUArchState *env, abi_ptr ptr);

void cpu_stb_data(CPUArchState *env, abi_ptr ptr, uint32_t val);
void cpu_stw_le_data(CPUArchState *env, abi_ptr ptr, uint32_t val);
void cpu_stl_le_data(CPUArchState *env, abi_ptr ptr, uint32_t val);
void cpu_stq_le_data(CPUArchState *env, abi_ptr ptr, uint64_t val);

#define read_memory_xlen(va, enc) read_memory(32, va, enc)
#define write_memory_xlen(va, reg, enc) write_memory(32, va, reg, enc)

inline void write_memory(size_t size, XReg va, XReg value, uint32_t encoding) {
    switch (size) {
        case 8: return cpu_stb_data(NULL, va.value(), value.value());
        case 16: return cpu_stw_le_data(NULL, va.value(), value.value());
        case 32: return cpu_stl_le_data(NULL, va.value(), value.value());
        default: assert(false);
    }
}

inline XReg read_memory(size_t size, XReg va, uint32_t encoding) {
    switch (size) {
        case 8: return cpu_ldub_data(NULL, va.value());
        case 16: return cpu_lduw_le_data(NULL, va.value());
        case 32: return cpu_ldl_le_data(NULL, va.value());
        default: assert(false);
    }
}

void xqci_raise_IllegalInstruction();
__attribute__((annotate("immediate: 1"))) XReg
ann_get_and_validate_stack_pointer(XReg, int32_t) {}
XReg get_and_validate_stack_pointer(XReg, int32_t);
void xqci_set_mode_M();
void xqci_set_mode_S();
void xqci_set_mode_U();
bool xqci_implemented_U();
bool xqci_implemented_Xqccmp();
bool xqci_implemented_Zcmp();
bool xqci_implemented_Smdbltrp();
__attribute__((annotate("immediate: 0"))) void ann_xqci_syscall(int32_t func,
                                                                int32_t arg) {}
__attribute__((annotate("immediate: 0"))) void xqci_syscall(int32_t func, int32_t arg);

static void iss_syscall(XReg a, XReg b) { xqci_syscall(a.value(), b.value()); }

__attribute__((pure)) uint32_t xqci_get_gpr_xreg(XReg csrno) {
    return xqci_get_gpr(csrno.value());
}
