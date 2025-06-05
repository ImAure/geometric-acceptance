	.file	"ext-source.c"
	.text
	.p2align 4
	.globl	rand_dir
	.type	rand_dir, @function
rand_dir:
.LFB22:
	.cfi_startproc
	testq	%rdi, %rdi
	je	.L3
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	call	rand@PLT
	pxor	%xmm0, %xmm0
	movsd	.LC1(%rip), %xmm1
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	addsd	%xmm0, %xmm0
	subsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	call	acos@PLT
	movsd	%xmm0, (%rbx)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	xorl	%eax, %eax
	mulsd	.LC2(%rip), %xmm0
	movsd	%xmm0, 8(%rbx)
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L3:
	.cfi_restore 3
	movl	$-1, %eax
	ret
	.cfi_endproc
.LFE22:
	.size	rand_dir, .-rand_dir
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC3:
	.string	"Error: argument is NULL.\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC5:
	.string	"Error: max_rho must be greater than 0.\n"
	.text
	.p2align 4
	.globl	rand_polar
	.type	rand_polar, @function
rand_polar:
.LFB23:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	testq	%rdi, %rdi
	je	.L23
	pxor	%xmm2, %xmm2
	comisd	%xmm0, %xmm2
	jnb	.L24
	movsd	%xmm0, 8(%rsp)
	movq	%rdi, %rbx
	call	rand@PLT
	movsd	8(%rsp), %xmm1
	pxor	%xmm0, %xmm0
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	mulsd	%xmm1, %xmm1
	mulsd	%xmm1, %xmm0
	ucomisd	%xmm0, %xmm2
	ja	.L21
	sqrtsd	%xmm0, %xmm0
.L17:
	movsd	%xmm0, (%rbx)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	xorl	%eax, %eax
	mulsd	.LC2(%rip), %xmm0
	movsd	%xmm0, 8(%rbx)
.L9:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L24:
	.cfi_restore_state
	movq	stderr(%rip), %rcx
	movl	$39, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
.L11:
	movl	$-1, %eax
	jmp	.L9
.L23:
	movq	stderr(%rip), %rcx
	movl	$25, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	jmp	.L11
.L21:
	call	sqrt@PLT
	jmp	.L17
	.cfi_endproc
.LFE23:
	.size	rand_polar, .-rand_polar
	.p2align 4
	.globl	intcept
	.type	intcept, @function
intcept:
.LFB24:
	.cfi_startproc
	comisd	.LC6(%rip), %xmm0
	jb	.L38
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L38:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movapd	%xmm2, %xmm6
	movapd	%xmm0, %xmm5
	pxor	%xmm0, %xmm0
	mulsd	%xmm2, %xmm6
	movq	%xmm1, %rbx
	mulsd	%xmm4, %xmm4
	subq	$64, %rsp
	.cfi_def_cfa_offset 80
	ucomisd	%xmm3, %xmm0
	movsd	%xmm6, 8(%rsp)
	movsd	%xmm4, 16(%rsp)
	ja	.L32
	movapd	%xmm3, %xmm7
	sqrtsd	%xmm7, %xmm7
	movsd	%xmm7, (%rsp)
.L29:
	leaq	56(%rsp), %rdi
	leaq	48(%rsp), %rsi
	movapd	%xmm5, %xmm0
	movsd	%xmm3, 40(%rsp)
	movsd	%xmm2, 32(%rsp)
	call	sincos@PLT
	movq	%rbx, %xmm0
	movsd	56(%rsp), %xmm1
	divsd	48(%rsp), %xmm1
	movsd	%xmm1, 24(%rsp)
	call	sin@PLT
	movsd	32(%rsp), %xmm2
	movsd	24(%rsp), %xmm1
	xorl	%eax, %eax
	movapd	%xmm0, %xmm4
	movsd	40(%rsp), %xmm3
	addsd	%xmm2, %xmm2
	mulsd	(%rsp), %xmm2
	movapd	%xmm1, %xmm0
	mulsd	%xmm1, %xmm0
	mulsd	8(%rsp), %xmm0
	mulsd	%xmm1, %xmm2
	mulsd	%xmm4, %xmm2
	subsd	%xmm2, %xmm0
	addsd	%xmm0, %xmm3
	subsd	16(%rsp), %xmm3
	pxor	%xmm0, %xmm0
	comisd	%xmm3, %xmm0
	setnb	%al
	addq	$64, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L32:
	.cfi_restore_state
	movapd	%xmm3, %xmm0
	movsd	%xmm2, 40(%rsp)
	movsd	%xmm5, 32(%rsp)
	movsd	%xmm3, 24(%rsp)
	call	sqrt@PLT
	movsd	40(%rsp), %xmm2
	movsd	32(%rsp), %xmm5
	movsd	24(%rsp), %xmm3
	movsd	%xmm0, (%rsp)
	jmp	.L29
	.cfi_endproc
.LFE24:
	.size	intcept, .-intcept
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"Usage: %s <n> <h> <d> <r> <R>\nWhere\n\tn: number of points to be generated (positive integer);\n\th: height of the detector (positive);\n\td: horizontal offset of the detector;\n\tr: radius of the source (non negative)\n\tR: radius of the detector (positive).\n"
	.align 8
.LC8:
	.string	"Error: number of points must be a positive integer.\n"
	.align 8
.LC9:
	.string	"Error: detector radius and height must be positive numbers.\n"
	.align 8
.LC10:
	.string	"Error: source radius must be a non-negative number.\n"
	.align 8
.LC11:
	.string	"Error: could not open output file.\n"
	.align 8
.LC12:
	.string	"Error: random number generation failed.\n"
	.text
	.p2align 4
	.globl	myexit
	.type	myexit, @function
myexit:
.LFB25:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leal	1(%rdi), %eax
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movl	%edi, %ebx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	cmpl	$6, %eax
	ja	.L40
	movq	%rdx, %rcx
	leaq	.L42(%rip), %rdx
	movslq	(%rdx,%rax,4), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L42:
	.long	.L47-.L42
	.long	.L40-.L42
	.long	.L46-.L42
	.long	.L45-.L42
	.long	.L44-.L42
	.long	.L43-.L42
	.long	.L41-.L42
	.text
	.p2align 4,,10
	.p2align 3
.L47:
	movq	stderr(%rip), %rdi
	movq	%rcx, %rdx
	leaq	.LC7(%rip), %rsi
	xorl	%eax, %eax
	call	fprintf@PLT
	.p2align 4
	.p2align 3
.L40:
	testq	%rbp, %rbp
	je	.L48
	movq	%rbp, %rdi
	call	fclose@PLT
.L48:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movl	%ebx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L41:
	.cfi_restore_state
	movq	stderr(%rip), %rcx
	movl	$40, %edx
	movl	$1, %esi
	leaq	.LC12(%rip), %rdi
	call	fwrite@PLT
	jmp	.L40
	.p2align 4,,10
	.p2align 3
.L46:
	movq	stderr(%rip), %rcx
	movl	$52, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	jmp	.L40
	.p2align 4,,10
	.p2align 3
.L45:
	movq	stderr(%rip), %rcx
	movl	$60, %edx
	movl	$1, %esi
	leaq	.LC9(%rip), %rdi
	call	fwrite@PLT
	jmp	.L40
	.p2align 4,,10
	.p2align 3
.L44:
	movq	stderr(%rip), %rcx
	movl	$52, %edx
	movl	$1, %esi
	leaq	.LC10(%rip), %rdi
	call	fwrite@PLT
	jmp	.L40
	.p2align 4,,10
	.p2align 3
.L43:
	movq	stderr(%rip), %rcx
	movl	$35, %edx
	movl	$1, %esi
	leaq	.LC11(%rip), %rdi
	call	fwrite@PLT
	jmp	.L40
	.cfi_endproc
.LFE25:
	.size	myexit, .-myexit
	.section	.rodata.str1.1
.LC13:
	.string	"w"
.LC14:
	.string	"./tmp/out.txt"
.LC15:
	.string	"%f %f %f %f 1"
.LC16:
	.string	"%f %f %f %f 0"
.LC17:
	.string	"Ratio: %.6f\n"
.LC18:
	.string	"./tmp/image.png"
.LC19:
	.string	"python3 plot.py %s %s"
.LC20:
	.string	"Image generated in %s\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB26:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movl	%edi, %ebp
	xorl	%edi, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$1144, %rsp
	.cfi_def_cfa_offset 1200
	movq	%fs:40, %rbx
	movq	%rbx, 1128(%rsp)
	movq	%rsi, %rbx
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	cmpl	$6, %ebp
	je	.L54
	movq	(%rbx), %rdx
	movq	stderr(%rip), %rdi
	leaq	.LC7(%rip), %rsi
	xorl	%eax, %eax
	call	fprintf@PLT
	orl	$-1, %eax
.L53:
	movq	1128(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L93
	addq	$1144, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L54:
	.cfi_restore_state
	leaq	.LC13(%rip), %rsi
	leaq	.LC14(%rip), %rdi
	call	fopen@PLT
	movq	8(%rbx), %rdi
	movl	$10, %edx
	xorl	%esi, %esi
	movq	%rax, %rbp
	call	__isoc23_strtol@PLT
	movq	16(%rbx), %rdi
	xorl	%esi, %esi
	movq	%rax, %r12
	call	strtod@PLT
	movq	24(%rbx), %rdi
	xorl	%esi, %esi
	movsd	%xmm0, 64(%rsp)
	call	strtod@PLT
	movq	32(%rbx), %rdi
	xorl	%esi, %esi
	movsd	%xmm0, 72(%rsp)
	call	strtod@PLT
	movq	40(%rbx), %rdi
	xorl	%esi, %esi
	movsd	%xmm0, (%rsp)
	call	strtod@PLT
	testl	%r12d, %r12d
	movsd	(%rsp), %xmm1
	movsd	%xmm0, 56(%rsp)
	jle	.L94
	pxor	%xmm0, %xmm0
	comisd	56(%rsp), %xmm0
	jnb	.L58
	comisd	64(%rsp), %xmm0
	jnb	.L58
	comisd	%xmm1, %xmm0
	ja	.L95
	testq	%rbp, %rbp
	je	.L65
	comisd	%xmm1, %xmm0
	jnb	.L96
	mulsd	%xmm1, %xmm1
	leal	-1(%r12), %r13d
	xorl	%r14d, %r14d
	xorl	%ebx, %ebx
	movsd	%xmm1, 24(%rsp)
	.p2align 4
	.p2align 3
.L81:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm4, %xmm4
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	mulsd	24(%rsp), %xmm0
	ucomisd	%xmm0, %xmm4
	ja	.L89
	sqrtsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
.L72:
	call	rand@PLT
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	divsd	.LC0(%rip), %xmm1
	mulsd	.LC2(%rip), %xmm1
	movsd	%xmm1, 16(%rsp)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	movsd	.LC1(%rip), %xmm2
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	addsd	%xmm0, %xmm0
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	call	acos@PLT
	movsd	%xmm0, 8(%rsp)
	call	rand@PLT
	movsd	8(%rsp), %xmm2
	pxor	%xmm3, %xmm3
	comisd	.LC6(%rip), %xmm2
	cvtsi2sdl	%eax, %xmm3
	movsd	16(%rsp), %xmm1
	divsd	.LC0(%rip), %xmm3
	mulsd	.LC2(%rip), %xmm3
	jnb	.L73
	movapd	%xmm1, %xmm0
	movsd	%xmm3, 16(%rsp)
	movsd	%xmm1, 8(%rsp)
	movsd	%xmm2, 32(%rsp)
	call	sin@PLT
	movsd	(%rsp), %xmm6
	movsd	72(%rsp), %xmm7
	movapd	%xmm0, %xmm5
	movsd	8(%rsp), %xmm1
	movsd	16(%rsp), %xmm3
	movapd	%xmm6, %xmm0
	movapd	%xmm7, %xmm4
	mulsd	%xmm6, %xmm0
	mulsd	%xmm7, %xmm4
	addsd	%xmm0, %xmm4
	movapd	%xmm7, %xmm0
	addsd	%xmm7, %xmm0
	mulsd	%xmm6, %xmm0
	pxor	%xmm6, %xmm6
	mulsd	%xmm5, %xmm0
	subsd	%xmm0, %xmm4
	ucomisd	%xmm4, %xmm6
	ja	.L90
	movsd	32(%rsp), %xmm0
	leaq	80(%rsp), %rsi
	leaq	88(%rsp), %rdi
	movsd	%xmm3, 8(%rsp)
	movsd	%xmm1, 48(%rsp)
	movsd	%xmm4, 40(%rsp)
	call	sincos@PLT
	movsd	8(%rsp), %xmm0
	movsd	88(%rsp), %xmm6
	divsd	80(%rsp), %xmm6
	movsd	%xmm6, 16(%rsp)
	call	sin@PLT
	movsd	64(%rsp), %xmm3
	movsd	16(%rsp), %xmm6
	movapd	%xmm0, %xmm7
	movsd	40(%rsp), %xmm4
	movsd	32(%rsp), %xmm2
	movapd	%xmm3, %xmm5
	movapd	%xmm6, %xmm0
	movsd	48(%rsp), %xmm1
	mulsd	%xmm3, %xmm5
	movapd	%xmm4, %xmm8
	mulsd	%xmm6, %xmm0
	sqrtsd	%xmm8, %xmm8
	mulsd	%xmm5, %xmm0
	movapd	%xmm3, %xmm5
	addsd	%xmm3, %xmm5
	movsd	8(%rsp), %xmm3
	mulsd	%xmm8, %xmm5
	mulsd	%xmm6, %xmm5
	mulsd	%xmm7, %xmm5
	pxor	%xmm7, %xmm7
	subsd	%xmm5, %xmm0
	movsd	56(%rsp), %xmm5
	addsd	%xmm4, %xmm0
	movapd	%xmm5, %xmm4
	mulsd	%xmm5, %xmm4
	subsd	%xmm4, %xmm0
	comisd	%xmm0, %xmm7
	jb	.L73
	movsd	(%rsp), %xmm0
	leaq	.LC15(%rip), %rsi
	movq	%rbp, %rdi
	addl	$1, %r14d
	movl	$4, %eax
	call	fprintf@PLT
	cmpl	%r13d, %ebx
	je	.L78
.L97:
	movq	%rbp, %rsi
	movl	$10, %edi
	addl	$1, %ebx
	call	fputc@PLT
	cmpl	%r12d, %ebx
	jne	.L81
.L80:
	movq	%rbp, %rdi
	call	fclose@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	movq	stdout(%rip), %rdi
	cvtsi2sdl	%r12d, %xmm1
	cvtsi2sdl	%r14d, %xmm0
	divsd	%xmm1, %xmm0
	leaq	.LC17(%rip), %rsi
	movl	$1, %eax
	call	fprintf@PLT
	leaq	.LC18(%rip), %rcx
	leaq	96(%rsp), %rdi
	xorl	%eax, %eax
	leaq	.LC14(%rip), %rdx
	leaq	.LC19(%rip), %rsi
	call	sprintf@PLT
	leaq	96(%rsp), %rdi
	call	system@PLT
	movq	stdout(%rip), %rdi
	leaq	.LC18(%rip), %rdx
	xorl	%eax, %eax
	leaq	.LC20(%rip), %rsi
	call	fprintf@PLT
	xorl	%eax, %eax
	jmp	.L53
.L90:
	movapd	%xmm4, %xmm0
	movsd	%xmm3, 16(%rsp)
	movsd	%xmm1, 8(%rsp)
	call	sqrt@PLT
	movsd	8(%rsp), %xmm1
	movsd	16(%rsp), %xmm3
	movsd	32(%rsp), %xmm2
	.p2align 4
	.p2align 3
.L73:
	movsd	(%rsp), %xmm0
	leaq	.LC16(%rip), %rsi
	movq	%rbp, %rdi
	movl	$4, %eax
	call	fprintf@PLT
	cmpl	%r13d, %ebx
	jne	.L97
.L78:
	addl	$1, %ebx
	cmpl	%r12d, %ebx
	jne	.L81
	jmp	.L80
.L94:
	movq	1128(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L93
	movq	(%rbx), %rdx
	movq	%rbp, %rsi
	movl	$1, %edi
.L92:
	addq	$1144, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	myexit
.L58:
	.cfi_restore_state
	movq	1128(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L93
	movq	(%rbx), %rdx
	movq	%rbp, %rsi
	movl	$2, %edi
	jmp	.L92
.L95:
	movq	1128(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L93
	movq	(%rbx), %rdx
	movq	%rbp, %rsi
	movl	$3, %edi
	jmp	.L92
.L96:
	movq	stderr(%rip), %rcx
	movl	$39, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	movq	1128(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L93
	movq	(%rbx), %rdx
	movq	%rbp, %rsi
	movl	$5, %edi
	jmp	.L92
.L89:
	call	sqrt@PLT
	movsd	%xmm0, (%rsp)
	jmp	.L72
.L93:
	call	__stack_chk_fail@PLT
.L65:
	movq	1128(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L93
	movq	(%rbx), %rdx
	xorl	%esi, %esi
	movl	$4, %edi
	jmp	.L92
	.cfi_endproc
.LFE26:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	-4194304
	.long	1105199103
	.align 8
.LC1:
	.long	0
	.long	1072693248
	.align 8
.LC2:
	.long	1413754136
	.long	1075388923
	.align 8
.LC6:
	.long	1413754136
	.long	1073291771
	.ident	"GCC: (GNU) 15.1.1 20250425"
	.section	.note.GNU-stack,"",@progbits
