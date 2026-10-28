#!/usr/bin/env python3


# UDB to C++ KLEE input.
#
# Copyright (c) 2025 rev.ng Labs Srl.
#
# This work is licensed under the terms of the GNU GPL, version 2 or
# (at your option) any later version.
#
# See the LICENSE file in the top-level directory for details.
#

import yaml
import argparse
import re
import os
import common

def main():
    parser = argparse.ArgumentParser(
        prog='count-test-artifacts',
    )
    parser.add_argument('--inst-dir', required=True,
                        help='Path to extensions instruction directory in the UDB')
    args = parser.parse_args()

    total_tests = 0
    total_supported_insts = 0
    total_total_insts = 0
    for file in sorted(os.listdir(args.inst_dir)):
        ext = file
        dir = os.path.join(args.inst_dir, file)
        io_dir = f'build/out-test-{file}/io'

        if os.path.isdir(dir):
            total_insts = 0
            for file in sorted(os.listdir(dir)):
                total_insts += 1

            supported_insts = 0
            tests = 0
            for file in sorted(os.listdir(io_dir)):
                inst = os.path.join(io_dir, file)
                y = common.load_yaml_or_exit(inst)
                if y:
                    tests += len(y)
                supported_insts += 1

            print(f'{ext} {tests} {supported_insts} {total_insts}')

            total_tests += tests
            total_supported_insts += supported_insts
            total_total_insts += total_insts

    print(total_tests)
    print(total_supported_insts)
    print(total_total_insts)

if __name__ == '__main__':
    main()
