.section .text
.globl _start

_start:
    la      t0, supervisor
    csrw    mepc, t0
    la      t1, m_trap
    csrw    mtvec, t1
    li      t2, 0x1800
    csrc    mstatus, t2
    li      t3, 0x800
    csrs    mstatus, t3
    li      t4, 0x100
    csrs    medeleg, t4
    #mret

    j _exit

m_trap:
    csrr    t0, mepc
    csrr    t1, mcause
    la      t2, supervisor
    csrw    mepc, t2
    mret

supervisor:
    la      t0, user
    csrw    sepc, t0
    la      t1, s_trap
    csrw    stvec, t1
    sret

s_trap:
    csrr    t0, sepc
    csrr    t1, scause
    ecall

user:
    csrr    t0, instret
    ecall

    
# Exit code in a0
        .option push
        .option norvc
_exit:
        li      a0, 0x45
	lla	a1, semiargs
	li	t1, 0x20026	# ADP_Stopped_ApplicationExit
	sd	t1, 0(a1)
	sd	a0, 4(a1)
	li	a0, 0x20	# TARGET_SYS_EXIT_EXTENDED

	# Semihosting call sequence
	.balign	16
	slli	zero, zero, 0x1f
	ebreak
	srai	zero, zero, 0x7
	j	.
        .option pop

	.data
	.balign	16
semiargs:
	.space	8
