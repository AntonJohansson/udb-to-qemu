#!/bin/bash

tc="$(pwd)/toolchain"
dir=$(pwd)

rm -r build/embench/build-logs
rm -r build/embench/run-logs
[ ! -d ${dir}/build/embench ] && mkdir -p ${dir}/build/embench

pushd submodules/embench
./build_all.py \
    --chip='generic' \
    --arch='riscv32' \
    --board='ri5cyverilator' \
    --cc="${dir}/clang-musl" \
    --cflags="-fuse-ld=eld -c -Oz  -march=rv32imac_xqci_xqccmp0p3  -menable-experimental-extensions -mabi=ilp32" \
    --ldflags="-fuse-ld=eld -static" \
    --builddir=${dir}/build/embench \
    --logdir=${dir}/build/embench/build-logs
./benchmark_speed.py \
    --target-module=run_qemu \
    --qemu-path=${dir}/build/qemu/qemu-riscv32 \
    --qemu-args="-cpu qc_iu" \
    --builddir=${dir}/build/embench \
    --logdir=${dir}/build/embench/run-logs
popd

for file in $(find build/embench/src -type f -executable); do
    ./build/qemu/qemu-riscv32 -cpu qc_iu $file
    echo $? $file
done
