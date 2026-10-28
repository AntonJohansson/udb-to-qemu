
  .globl  main                            # -- Begin function main
  .p2align  1
  .type main,@function
main:                                   # @main
  qc.bnei a0, 4, -28
  ret
