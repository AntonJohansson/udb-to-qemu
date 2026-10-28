

    .text
    .globl  test                            # -- Begin function test
    .p2align        1
    .type   test,@function
test:
    addi    sp, sp, -16
    sw      a0, 12(sp)
    li      a0, 0
    sw      a0, 8(sp)
    j       .LBB0_1
    .LBB0_1:
    lw      a0, 8(sp)
    lui     a1, %hi(n)
    lw      a1, %lo(n)(a1)
    bge     a0, a1, .LBB0_4
    j       .LBB0_2
    .LBB0_2:
    lw      a0, 8(sp)
    lw      a1, 12(sp)
    add     a1, a1, a0
    sb      a0, 0(a1)
    j       .LBB0_3
    .LBB0_3:
    lw      a0, 8(sp)
    addi    a0, a0, 1
    sw      a0, 8(sp)
    j       .LBB0_1
    .LBB0_4:
    addi    sp, sp, 16
    ret

    .globl  foo                             # -- Begin function foo
    .p2align        1
    .type   foo,@function
foo:
    qc.cm.push      {ra}, -64
    addi    sp, sp, -464
    mv      a0, sp
    call    test
    li      a0, 0
    addi    sp, sp, 464
    qc.cm.pop       {ra}, 64
    ret

    .globl  main                            # -- Begin function main
    .p2align        1
    .type   main,@function
main:
    qc.cm.push      {ra}, -32
    li      a0, 0
    sw      a0, 8(sp)
    sw      a0, 12(sp)
    call    foo
    lw      a0, 8(sp)
    qc.cm.pop       {ra}, 32
    ret

    .type   n,@object                       # @n
    .data
    .globl  n
    .p2align        2, 0x0
n:
    .word   100
    .size   n, 4
