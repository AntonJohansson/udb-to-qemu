#bin/sh
tc=$1

cflags="--target=riscv32 -march=rv32ima_zba_zbb_zbs_zca_zcb_zilsd1p0_zclsd1p0_xqci_xqccmp0p3_xqcili0p2_xqcia0p7 -menable-experimental-extensions -static -mabi=ilp32 -c"
lflags="-T link.ld -m elf32lriscv -X -static -L${tc}/riscv32-linux-gnu/libc/lib -L${tc}/lib/clang/21/lib/linux -L/lib/../lib32 -L/usr/lib/../lib32 -L/lib -L/usr/lib -mtriple=riscv32-unknown-linux-gnu"

[ ! -d build ] && mkdir build
[ ! -d build/functions ] && mkdir build/functions

for file in functions/*.s; do
    obj=${file%*.s}.o
    ${tc}/bin/clang ${cflags} $file -o build/$obj
done

for file in *.s; do
    obj=${file%*.s}.o
    bin=${file%*.s}.out
    ${tc}/bin/clang ${cflags} $file -o build/$obj
    ${tc}/bin/riscv-link ${lflags} build/$obj -o build/$bin 
done

for file in *.c; do
    obj=${file%*.c}.o
    bin=${file%*.c}.out
    ${tc}/bin/clang ${cflags} $file -o build/$obj
    ${tc}/bin/riscv-link ${lflags} build/functions/start.o build/$obj -o build/$bin 
done
