.section .text
.globl exit

        .option push
        .option norvc
	.type   exit,@function
exit:
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
