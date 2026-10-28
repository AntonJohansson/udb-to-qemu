
  .globl  main                            # -- Begin function main
  .p2align  1
  .type main,@function
main:                                   # @main
  qc.li a0, 123
  qc.e.lw a0, -0x8004(a0)
  ret
