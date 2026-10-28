
  .text
  .globl  test                            # -- Begin function test
  .p2align  1
  .type test,@function
test:                                   # @test
  lui a1, %hi(n)
  lw  a2, %lo(n)(a1)
  blez  a2, .LBB0_3
  li  a2, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
  add a3, a0, a2
  sb  a2, 0(a3)
  lw  a3, %lo(n)(a1)
  addi  a2, a2, 1
  blt a2, a3, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup
  ret

  .globl  foo                             # -- Begin function foo
  .p2align  1
  .type foo,@function
foo:                                    # @foo
  qc.cm.push  {ra}, -64
  addi  sp, sp, -464
  mv  a0, sp
  call  test
  addi  sp, sp, 464
  qc.cm.popretz {ra}, 64

  .globl  main                            # -- Begin function main
  .p2align  1
  .type main,@function
main:                                   # @main
  qc.cm.push  {ra}, -16
  call  foo
  qc.cm.popretz {ra}, 16

  .type n,@object                       # @n
  .data
  .globl  n
  .p2align  2, 0x0
n:
  .word 100                             # 0x64
  .size n, 4
