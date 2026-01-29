#!/bin/bash
set -x

# Clear, create, enter build directory
rm -rf xqci_build
mkdir xqci_build
cd xqci_build

# Run meson
CLANG_RESOURCE_PATH=`clang --print-resource-dir`
meson setup \
  -Doptimization=s \
  -Dsingle-thread=true \
  -Datomic-ungetc=false \
  -Dthread-local-storage=false \
  -Dc_args="-march=rv32imzba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p3 -menable-experimental-extensions -mabi=ilp32 -Os" \
  -Dcpp_args="-march=rv32imzba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p3 -menable-experimental-extensions -mabi=ilp32 -Os" \
  -Dc_link_args="-L${CLANG_RESOURCE_PATH}/lib/baremetal -lclang_rt.builtins-im-xqci-combo-riscv32" \
  -Dcpp_link_args="-L${CLANG_RESOURCE_PATH}/lib/baremetal -lclang_rt.builtins-im-xqci-combo-riscv32" \
  -Ddebug=false \
  -Dtests=true \
  -Dtests-enable-stack-protector=false \
  -Dincludedir=include \
  -Dlibdir=lib \
  -Dtest-machine=qemu \
  -Dspecsdir=none \
  -Dprefix="$PWD/../xqci_install" \
  --cross-file $PWD/../cross-clang-riscv32-unknown-elf.txt \
  -Dmultilib=false "$@" \
  $PWD/../picolibc

# Command to build
ninja

# Command to run tests.
# - Note that tests are disabled currently (see `-Dtests=false` above). Set to
#   true to enable them.
ninja test

# Command to install
ninja install
