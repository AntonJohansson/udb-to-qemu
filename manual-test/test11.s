  .global _start

_start:

  li ra, 0xaaaaaaaa

  qc.e.jal foo1

  li a7, 93

  li a0, 0

  ecall

 

  .global foo1

foo1:

  ret
