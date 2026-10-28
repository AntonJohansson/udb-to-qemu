#!/bin/sh

#
# Main script to build all artifacts required for a QEMU frontend.
#
# Copyright (c) 2025 rev.ng Labs Srl.
#
# This work is licensed under the terms of the GNU GPL, version 2 or
# (at your option) any later version.
#
# See the LICENSE file in the top-level directory for details.
#

clangpp=$1
klee=$2
out=$3

rudb_dir=submodules/riscv-unified-db

[ ! -d build ] && mkdir build
[ ! -d ${out} ] && mkdir -p ${out}

for file in ${rudb_dir}/spec/std/isa/inst/*; do
    base=$(basename $file)
    out_ext=${out}/out-test-${base}
    [ ! -d ${out_ext} ] && mkdir -p ${out_ext}
    if [ -d $file ]; then
        echo "Generating KLEE input:"
        ./scripts/udb-to-klee.py \
            --csrs "${rudb_dir}/spec/std/isa/csr" \
            --inst-dir ${file} \
            --out ${out_ext}
        
        #echo "Running klee"
        sh build-tests.sh $clangpp $klee ${out_ext}
    fi
done

