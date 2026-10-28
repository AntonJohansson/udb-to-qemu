#bin/sh
tc=$1

#$cc -O0 -nostdlib --target=riscv32  -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p1  -menable-experimental-extensions -static  -mabi=ilp32     -fomit-frame-pointer test.c -o t_xqcmp.out

#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p1  -menable-experimental-extensions -static  -mabi=ilp32 test.s -o test.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu
#
#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p1  -menable-experimental-extensions -static  -mabi=ilp32 test2.s -o test2.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t2.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test2.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu

#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_zcmp -menable-experimental-extensions -static  -mabi=ilp32  test3.s -o test3.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t3.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test3.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu

#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_zcmp -menable-experimental-extensions -static  -mabi=ilp32  test4.s -o test4.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t4.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test4.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu

#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_zcmp -menable-experimental-extensions -static  -mabi=ilp32  test5.c -o test5.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t5.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test5.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu

#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_zcmp -menable-experimental-extensions -static  -mabi=ilp32  test6.s -o test6.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t6.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test6.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu

#${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_zcmp -menable-experimental-extensions -static  -mabi=ilp32  test7.s -o test7.o -c
#${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o t7.out -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/20/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib test7.o ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu

[ ! -d build ] && mkdir build
for file in *.s; do
    obj=${file%*.s}.o
    bin=${file%*.s}.out
    ${tc}/bin/clang --target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p1_xqcili0p2_xqcia0p7 -menable-experimental-extensions -static  -mabi=ilp32  $file -o build/$obj -c
    ${tc}/bin/riscv-link -z relro --hash-style=gnu --eh-frame-hdr -m elf32lriscv -X -static -o build/$bin -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/21/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib build/$obj ${tc}/riscv32-linux-gnu/libc/lib/crt1.o  ${tc}/riscv32-linux-gnu/libc/lib/crti.o  ${tc}/riscv32-linux-gnu/libc/lib/crtn.o --start-group -lc -lclang_rt.builtins-riscv32 --end-group -mtriple=riscv32-unknown-linux-gnu
done
