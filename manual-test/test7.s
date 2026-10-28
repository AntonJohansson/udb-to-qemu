
  .globl  main                            # -- Begin function main
  .p2align  1
  .type main,@function
main:                                   # @main
  li t0, 1
  qc.beqi t0, 1, .neg
.pos:
  qc.beqi t0, 1, .end
.neg:
  qc.bnei t0, -1, .pos
.end:
  li a0, 0
  ret
