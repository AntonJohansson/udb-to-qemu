  .globl  main
  .p2align  1
  .type main,@function
main:
  li t1, 0x10000
  qc.e.ori t0, t1, 0xffff
  qc.insbi t1, -1, 16, 0
  li a0, 0
  ret
