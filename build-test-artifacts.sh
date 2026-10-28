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
csr_dirs=$3
inst_dirs=$4
out=$5

rudb_dir=submodules/riscv-unified-db

[ ! -d build ] && mkdir build
[ ! -d ${out} ] && mkdir -p ${out}

echo "Generating KLEE input:"
./scripts/udb-to-klee.py \
    --csrs "${csr_dirs}" \
    --inst-dir ${inst_dirs} \
    --out ${out}

#echo "Running klee"
sh build-tests.sh $clangpp $klee ${out}
