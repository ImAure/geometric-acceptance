	.file	"simulation.c"
	.text
	.p2align 4
	.globl	rand_dir3D_gen
	.type	rand_dir3D_gen, @function
rand_dir3D_gen:
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
	.size	rand_dir3D_gen, .-rand_dir3D_gen
	.p2align 4
	.globl	rand_polar2D_gen
	.type	rand_polar2D_gen, @function
rand_polar2D_gen:
.LFB23:
	.cfi_startproc
	testq	%rdi, %rdi
	je	.L15
	pxor	%xmm2, %xmm2
	comisd	%xmm0, %xmm2
	ja	.L15
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movsd	%xmm0, 8(%rsp)
	call	rand@PLT
	movsd	8(%rsp), %xmm1
	pxor	%xmm0, %xmm0
	pxor	%xmm2, %xmm2
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	mulsd	%xmm1, %xmm1
	mulsd	%xmm1, %xmm0
	ucomisd	%xmm0, %xmm2
	ja	.L17
	sqrtsd	%xmm0, %xmm0
.L13:
	movsd	%xmm0, (%rbx)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	xorl	%eax, %eax
	mulsd	.LC2(%rip), %xmm0
	movsd	%xmm0, 8(%rbx)
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L15:
	.cfi_restore 3
	movl	$-1, %eax
	ret
.L17:
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -16
	call	sqrt@PLT
	jmp	.L13
	.cfi_endproc
.LFE23:
	.size	rand_polar2D_gen, .-rand_polar2D_gen
	.p2align 4
	.globl	intcept
	.type	intcept, @function
intcept:
.LFB24:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%xmm0, %rdx
	pxor	%xmm0, %xmm0
	movq	%xmm1, %rax
	movq	%rax, %rbx
	movq	%rdx, %rax
	subq	$48, %rsp
	.cfi_def_cfa_offset 64
	ucomisd	%xmm0, %xmm2
	jp	.L26
	movl	$0, %edx
	je	.L22
.L26:
	movq	%rax, %xmm0
	leaq	40(%rsp), %rdi
	leaq	32(%rsp), %rsi
	movsd	%xmm3, 24(%rsp)
	movsd	%xmm2, 16(%rsp)
	movsd	%xmm4, 8(%rsp)
	call	sincos@PLT
	movsd	8(%rsp), %xmm4
	movq	%rbx, %xmm0
	mulsd	%xmm4, %xmm4
	movsd	%xmm4, 8(%rsp)
	call	sin@PLT
	movsd	24(%rsp), %xmm3
	xorl	%edx, %edx
	movsd	16(%rsp), %xmm2
	movsd	8(%rsp), %xmm4
	movsd	40(%rsp), %xmm5
	movapd	%xmm3, %xmm1
	divsd	%xmm2, %xmm1
	mulsd	%xmm3, %xmm3
	mulsd	%xmm2, %xmm2
	addsd	%xmm3, %xmm2
	mulsd	%xmm0, %xmm1
	movapd	%xmm2, %xmm0
	movsd	.LC1(%rip), %xmm2
	movapd	%xmm1, %xmm6
	mulsd	%xmm1, %xmm6
	addsd	%xmm1, %xmm1
	mulsd	%xmm4, %xmm1
	movapd	%xmm6, %xmm3
	addsd	%xmm2, %xmm3
	subsd	%xmm6, %xmm2
	mulsd	%xmm5, %xmm1
	mulsd	%xmm4, %xmm2
	mulsd	%xmm3, %xmm0
	mulsd	32(%rsp), %xmm1
	addsd	%xmm2, %xmm0
	movapd	%xmm5, %xmm2
	mulsd	%xmm5, %xmm2
	mulsd	%xmm2, %xmm0
	subsd	%xmm4, %xmm0
	addsd	%xmm1, %xmm0
	pxor	%xmm1, %xmm1
	comisd	%xmm0, %xmm1
	setnb	%dl
.L22:
	addq	$48, %rsp
	.cfi_def_cfa_offset 16
	movl	%edx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE24:
	.size	intcept, .-intcept
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC4:
	.string	"%f %f %f %f %f %f"
.LC5:
	.string	"%f %f"
	.text
	.p2align 4
	.globl	elab_print
	.type	elab_print, @function
elab_print:
.LFB25:
	.cfi_startproc
	testq	%rdi, %rdi
	je	.L32
	testq	%rsi, %rsi
	je	.L32
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movq	%xmm3, %r15
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movq	%xmm2, %r14
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movsd	%xmm0, 40(%rsp)
	leaq	64(%rsp), %rsi
	movapd	%xmm1, %xmm0
	leaq	72(%rsp), %rdi
	movsd	%xmm5, 56(%rsp)
	movsd	%xmm4, 48(%rsp)
	call	sincos@PLT
	movsd	64(%rsp), %xmm7
	leaq	64(%rsp), %rsi
	leaq	72(%rsp), %rdi
	movq	%r14, %xmm0
	movsd	%xmm7, 32(%rsp)
	movsd	72(%rsp), %xmm7
	movsd	%xmm7, 8(%rsp)
	call	sincos@PLT
	movsd	64(%rsp), %xmm2
	movsd	72(%rsp), %xmm3
	movq	%r15, %xmm0
	leaq	64(%rsp), %rsi
	leaq	72(%rsp), %rdi
	movsd	%xmm2, 16(%rsp)
	movsd	%xmm3, 24(%rsp)
	call	sincos@PLT
	movsd	48(%rsp), %xmm5
	movsd	40(%rsp), %xmm8
	movsd	32(%rsp), %xmm7
	movsd	72(%rsp), %xmm4
	movapd	%xmm5, %xmm2
	divsd	16(%rsp), %xmm2
	movsd	64(%rsp), %xmm3
	movsd	56(%rsp), %xmm6
	mulsd	24(%rsp), %xmm2
	mulsd	%xmm8, %xmm7
	mulsd	8(%rsp), %xmm8
	mulsd	%xmm2, %xmm4
	mulsd	%xmm2, %xmm3
	addsd	%xmm8, %xmm4
	addsd	%xmm7, %xmm3
	addsd	%xmm6, %xmm4
	movapd	%xmm4, %xmm1
	subsd	%xmm6, %xmm1
	movapd	%xmm3, %xmm6
	mulsd	%xmm3, %xmm6
	movapd	%xmm1, %xmm0
	mulsd	%xmm1, %xmm0
	addsd	%xmm0, %xmm6
	pxor	%xmm0, %xmm0
	sqrtsd	%xmm6, %xmm6
	ucomisd	%xmm0, %xmm6
	jp	.L34
	movq	%xmm0, %r12
	jne	.L34
.L30:
	movapd	%xmm8, %xmm1
	movapd	%xmm7, %xmm0
	pxor	%xmm2, %xmm2
	movq	%rbx, %rdi
	leaq	.LC4(%rip), %rsi
	movl	$6, %eax
	movsd	%xmm6, 8(%rsp)
	call	fprintf@PLT
	movsd	8(%rsp), %xmm0
	movq	%rbp, %rdi
	movq	%r12, %xmm1
	leaq	.LC5(%rip), %rsi
	movl	$2, %eax
	call	fprintf@PLT
	addq	$88, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
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
	.p2align 4,,10
	.p2align 3
.L34:
	.cfi_restore_state
	movapd	%xmm3, %xmm0
	movsd	%xmm5, 48(%rsp)
	movsd	%xmm6, 40(%rsp)
	movsd	%xmm4, 32(%rsp)
	movsd	%xmm8, 24(%rsp)
	movsd	%xmm7, 16(%rsp)
	movsd	%xmm3, 8(%rsp)
	call	atan2@PLT
	movsd	48(%rsp), %xmm5
	movsd	40(%rsp), %xmm6
	movsd	32(%rsp), %xmm4
	movsd	24(%rsp), %xmm8
	movq	%xmm0, %r12
	movsd	16(%rsp), %xmm7
	movsd	8(%rsp), %xmm3
	jmp	.L30
	.p2align 4,,10
	.p2align 3
.L32:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	movl	$-1, %eax
	ret
	.cfi_endproc
.LFE25:
	.size	elab_print, .-elab_print
	.section	.rodata.str1.1
.LC6:
	.string	"An error occurred:\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC7:
	.string	"Usage: %s <n> <r> <h> <d> <R> <output_file>\nWhere\n"
	.align 8
.LC8:
	.string	"\tn: number of points to be generated (positive integer);\n"
	.align 8
.LC9:
	.string	"\tr: radius of the source (cm, non negative)\n"
	.align 8
.LC10:
	.string	"\th: height of the detector (cm, positive);\n"
	.align 8
.LC11:
	.string	"\td: horizontal offset of the detector (cm);\n"
	.align 8
.LC12:
	.string	"\tR: radius of the detector (positive).\n"
	.align 8
.LC13:
	.string	"\toutput_file: the name of the file only with no extension, data will be saved in ./tmp/output_file.i.txt for i = 1,2,3.\n"
	.align 8
.LC14:
	.string	"Could not open output file at '%s'\n"
	.section	.rodata.str1.1
.LC15:
	.string	"%s\n"
	.text
	.p2align 4
	.globl	myexit
	.type	myexit, @function
myexit:
.LFB26:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	%edi, %r13d
	leaq	.LC6(%rip), %rdi
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	movl	$1, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movslq	%edx, %rbp
	movl	$19, %edx
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rcx, %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	movq	stderr(%rip), %rcx
	call	fwrite@PLT
	movq	stderr(%rip), %rdi
	movq	%rbx, %rdx
	cmpl	$-2, %r13d
	je	.L40
	cmpl	$-1, %r13d
	jne	.L41
	leaq	.LC7(%rip), %rsi
	xorl	%eax, %eax
	call	fprintf@PLT
	movl	$57, %edx
	movq	stderr(%rip), %rcx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	movl	$44, %edx
	movq	stderr(%rip), %rcx
	movl	$1, %esi
	leaq	.LC9(%rip), %rdi
	call	fwrite@PLT
	movl	$43, %edx
	movq	stderr(%rip), %rcx
	movl	$1, %esi
	leaq	.LC10(%rip), %rdi
	call	fwrite@PLT
	movl	$44, %edx
	movq	stderr(%rip), %rcx
	movl	$1, %esi
	leaq	.LC11(%rip), %rdi
	call	fwrite@PLT
	movl	$39, %edx
	movq	stderr(%rip), %rcx
	movl	$1, %esi
	leaq	.LC12(%rip), %rdi
	call	fwrite@PLT
	movl	$120, %edx
	movq	stderr(%rip), %rcx
	movl	$1, %esi
	leaq	.LC13(%rip), %rdi
	call	fwrite@PLT
.L42:
	testq	%r12, %r12
	je	.L43
	testl	%ebp, %ebp
	jle	.L47
	movq	%r12, %rbx
	leaq	(%r12,%rbp,8), %rbp
	.p2align 4
	.p2align 3
.L46:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L45
	call	fclose@PLT
.L45:
	addq	$8, %rbx
	cmpq	%rbx, %rbp
	jne	.L46
.L47:
	movq	%r12, %rdi
	call	free@PLT
.L43:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	%r13d, %eax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L41:
	.cfi_restore_state
	leaq	.LC15(%rip), %rsi
	xorl	%eax, %eax
	call	fprintf@PLT
	jmp	.L42
	.p2align 4,,10
	.p2align 3
.L40:
	leaq	.LC14(%rip), %rsi
	xorl	%eax, %eax
	call	fprintf@PLT
	jmp	.L42
	.cfi_endproc
.LFE26:
	.size	myexit, .-myexit
	.section	.rodata.str1.1
.LC16:
	.string	".txt"
.LC17:
	.string	"./tmp/"
.LC18:
	.string	"%s%s.%d%s"
.LC19:
	.string	"w"
	.section	.rodata.str1.8
	.align 8
.LC20:
	.string	"Number of points must be a positive integer."
	.align 8
.LC21:
	.string	"Source radius must be a non-negative number."
	.align 8
.LC22:
	.string	"Detector radius and height must be positive numbers."
	.section	.rodata.str1.1
.LC23:
	.string	"\n%f %f %f %f"
.LC24:
	.string	"Hits: %d/%d\nRatio: %.6f\n"
.LC25:
	.string	"python3 newplot.py %s"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB27:
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
	movl	$648, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$20664, %rsp
	.cfi_def_cfa_offset 20720
	movq	%fs:40, %r13
	movq	%r13, 20648(%rsp)
	movq	%rsi, %r13
	call	malloc@PLT
	pxor	%xmm0, %xmm0
	xorl	%edi, %edi
	movq	$0, 16(%rax)
	movq	%rax, %rbx
	movups	%xmm0, (%rax)
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	cmpl	$7, %ebp
	je	.L57
	movq	20648(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L108
	movq	0(%r13), %rcx
	movq	%rbx, %rsi
	movl	$3, %edx
	orl	$-1, %edi
	addq	$20664, %rsp
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
.L57:
	.cfi_restore_state
	movq	8(%r13), %rdi
	movl	$10, %edx
	xorl	%esi, %esi
	movl	$1, %ebp
	leaq	160(%rsp), %r12
	call	__isoc23_strtol@PLT
	movq	16(%r13), %rdi
	xorl	%esi, %esi
	movq	%rax, 104(%rsp)
	movl	%eax, 116(%rsp)
	call	strtod@PLT
	movq	24(%r13), %rdi
	xorl	%esi, %esi
	movsd	%xmm0, (%rsp)
	call	strtod@PLT
	movq	32(%r13), %rdi
	xorl	%esi, %esi
	movsd	%xmm0, 40(%rsp)
	call	strtod@PLT
	movq	40(%r13), %rdi
	xorl	%esi, %esi
	movsd	%xmm0, 16(%rsp)
	call	strtod@PLT
	movsd	%xmm0, 56(%rsp)
.L59:
	movq	48(%r13), %rcx
	movl	%ebp, %r8d
	movq	%r12, %rdi
	xorl	%eax, %eax
	leaq	.LC16(%rip), %r9
	leaq	.LC17(%rip), %rdx
	leaq	.LC18(%rip), %rsi
	call	sprintf@PLT
	movq	%r12, %rdi
	leaq	.LC19(%rip), %rsi
	addq	$4096, %r12
	call	fopen@PLT
	movq	%rax, -8(%rbx,%rbp,8)
	addq	$1, %rbp
	cmpq	$4, %rbp
	jne	.L59
	cmpl	$0, 104(%rsp)
	jle	.L109
	pxor	%xmm1, %xmm1
	comisd	(%rsp), %xmm1
	ja	.L110
	comisd	56(%rsp), %xmm1
	jnb	.L64
	comisd	40(%rsp), %xmm1
	jnb	.L64
	movq	(%rbx), %rbp
	testq	%rbp, %rbp
	je	.L85
	movq	8(%rbx), %rax
	movq	%rax, 120(%rsp)
	testq	%rax, %rax
	je	.L86
	movq	16(%rbx), %rax
	movq	%rax, 128(%rsp)
	testq	%rax, %rax
	je	.L111
	call	rand@PLT
	movsd	(%rsp), %xmm7
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	mulsd	%xmm7, %xmm7
	movsd	%xmm7, 136(%rsp)
	mulsd	%xmm7, %xmm0
	ucomisd	%xmm0, %xmm1
	ja	.L104
	sqrtsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
.L71:
	call	rand@PLT
	pxor	%xmm1, %xmm1
	cvtsi2sdl	%eax, %xmm1
	divsd	.LC0(%rip), %xmm1
	mulsd	.LC2(%rip), %xmm1
	movsd	%xmm1, 48(%rsp)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	movsd	.LC1(%rip), %xmm2
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	addsd	%xmm0, %xmm0
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	call	acos@PLT
	leaq	144(%rsp), %rsi
	leaq	152(%rsp), %rdi
	movq	%rsi, 96(%rsp)
	movsd	%xmm0, 32(%rsp)
	call	sincos@PLT
	movsd	144(%rsp), %xmm5
	movsd	152(%rsp), %xmm4
	movsd	%xmm5, 24(%rsp)
	movsd	%xmm4, 72(%rsp)
	call	rand@PLT
	pxor	%xmm3, %xmm3
	movsd	32(%rsp), %xmm2
	movq	%rbp, %rdi
	cvtsi2sdl	%eax, %xmm3
	divsd	.LC0(%rip), %xmm3
	mulsd	.LC2(%rip), %xmm3
	movsd	48(%rsp), %xmm1
	movsd	(%rsp), %xmm0
	leaq	.LC23(%rip), %rsi
	movq	%xmm2, %r12
	movsd	%xmm1, 32(%rsp)
	movq	%xmm3, %rax
	movsd	%xmm3, 64(%rsp)
	movq	%rax, %r13
	movl	$4, %eax
	call	fprintf@PLT
	movsd	16(%rsp), %xmm4
	movsd	32(%rsp), %xmm1
	movapd	%xmm4, %xmm5
	movapd	%xmm1, %xmm0
	movsd	%xmm1, 80(%rsp)
	mulsd	%xmm4, %xmm5
	movsd	%xmm5, 48(%rsp)
	call	sin@PLT
	movsd	(%rsp), %xmm7
	movsd	56(%rsp), %xmm6
	movapd	%xmm0, %xmm5
	mulsd	%xmm6, %xmm6
	movapd	%xmm7, %xmm0
	movapd	%xmm7, %xmm2
	addsd	%xmm7, %xmm0
	mulsd	16(%rsp), %xmm0
	mulsd	%xmm7, %xmm2
	addsd	48(%rsp), %xmm2
	movsd	%xmm6, 56(%rsp)
	mulsd	%xmm5, %xmm0
	subsd	%xmm0, %xmm2
	movsd	64(%rsp), %xmm0
	movsd	%xmm2, 32(%rsp)
	call	sin@PLT
	movsd	32(%rsp), %xmm2
	movsd	40(%rsp), %xmm1
	movsd	56(%rsp), %xmm6
	movsd	72(%rsp), %xmm4
	movapd	%xmm2, %xmm3
	movapd	%xmm1, %xmm8
	divsd	%xmm1, %xmm3
	mulsd	%xmm1, %xmm8
	mulsd	%xmm2, %xmm2
	movsd	%xmm8, 88(%rsp)
	addsd	%xmm8, %xmm2
	mulsd	%xmm0, %xmm3
	movapd	%xmm2, %xmm0
	movsd	.LC1(%rip), %xmm2
	movapd	%xmm3, %xmm5
	mulsd	%xmm3, %xmm5
	addsd	%xmm3, %xmm3
	mulsd	%xmm6, %xmm3
	addsd	%xmm5, %xmm2
	mulsd	%xmm2, %xmm0
	movsd	.LC1(%rip), %xmm2
	mulsd	%xmm4, %xmm3
	subsd	%xmm5, %xmm2
	mulsd	24(%rsp), %xmm3
	mulsd	%xmm6, %xmm2
	addsd	%xmm2, %xmm0
	movapd	%xmm4, %xmm2
	mulsd	%xmm4, %xmm2
	mulsd	%xmm2, %xmm0
	pxor	%xmm2, %xmm2
	subsd	%xmm6, %xmm0
	addsd	%xmm3, %xmm0
	comisd	%xmm0, %xmm2
	jb	.L105
	movapd	%xmm1, %xmm4
	movsd	16(%rsp), %xmm5
	movsd	(%rsp), %xmm0
	movq	%r12, %xmm2
	movsd	80(%rsp), %xmm1
	movq	120(%rsp), %rdi
	movq	%r13, %xmm3
	movq	128(%rsp), %rsi
	call	elab_print
	movl	$1, 112(%rsp)
.L72:
	cmpl	$1, 104(%rsp)
	je	.L74
	movl	$1, %r14d
	jmp	.L81
	.p2align 4,,10
	.p2align 3
.L80:
	movsd	16(%rsp), %xmm5
	movsd	40(%rsp), %xmm4
	movapd	%xmm1, %xmm0
	movq	%r12, %xmm2
	movq	128(%rsp), %rsi
	movq	120(%rsp), %rdi
	unpckhpd	%xmm1, %xmm1
	movq	%r13, %xmm3
	call	elab_print
	addl	$1, 112(%rsp)
.L78:
	addl	$1, %r14d
	cmpl	%r14d, 116(%rsp)
	je	.L74
.L81:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm4, %xmm4
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	mulsd	136(%rsp), %xmm0
	ucomisd	%xmm0, %xmm4
	ja	.L106
	sqrtsd	%xmm0, %xmm0
	movsd	%xmm0, (%rsp)
.L77:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	mulsd	.LC2(%rip), %xmm0
	movsd	%xmm0, 32(%rsp)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	movsd	.LC1(%rip), %xmm7
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	addsd	%xmm0, %xmm0
	subsd	%xmm0, %xmm7
	movapd	%xmm7, %xmm0
	call	acos@PLT
	movq	96(%rsp), %rsi
	leaq	152(%rsp), %rdi
	movsd	%xmm0, 24(%rsp)
	call	sincos@PLT
	movsd	24(%rsp), %xmm2
	movsd	152(%rsp), %xmm4
	movsd	144(%rsp), %xmm7
	movq	%xmm2, %rax
	movsd	%xmm4, 80(%rsp)
	movsd	%xmm2, 72(%rsp)
	movq	%rax, %r12
	movsd	%xmm7, 64(%rsp)
	call	rand@PLT
	movsd	.LC2(%rip), %xmm7
	pxor	%xmm0, %xmm0
	movq	%rbp, %rsi
	cvtsi2sdl	%eax, %xmm0
	divsd	.LC0(%rip), %xmm0
	movl	$10, %edi
	mulsd	%xmm0, %xmm7
	movsd	%xmm7, 24(%rsp)
	movq	24(%rsp), %r13
	call	fputc@PLT
	movsd	24(%rsp), %xmm3
	movsd	72(%rsp), %xmm2
	movq	%rbp, %rdi
	movsd	32(%rsp), %xmm1
	movsd	(%rsp), %xmm0
	movl	$4, %eax
	leaq	.LC23(%rip), %rsi
	call	fprintf@PLT
	movsd	32(%rsp), %xmm0
	call	sin@PLT
	movsd	(%rsp), %xmm6
	movapd	%xmm0, %xmm2
	movapd	%xmm6, %xmm0
	movapd	%xmm6, %xmm1
	addsd	%xmm6, %xmm0
	mulsd	16(%rsp), %xmm0
	mulsd	%xmm6, %xmm1
	addsd	48(%rsp), %xmm1
	mulsd	%xmm2, %xmm0
	subsd	%xmm0, %xmm1
	movsd	24(%rsp), %xmm0
	movsd	%xmm1, 72(%rsp)
	call	sin@PLT
	movsd	72(%rsp), %xmm1
	movsd	56(%rsp), %xmm5
	pxor	%xmm7, %xmm7
	movsd	80(%rsp), %xmm4
	movapd	%xmm1, %xmm2
	divsd	40(%rsp), %xmm2
	mulsd	%xmm0, %xmm2
	mulsd	%xmm1, %xmm1
	addsd	88(%rsp), %xmm1
	movapd	%xmm2, %xmm3
	movapd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	mulsd	%xmm2, %xmm3
	addsd	%xmm2, %xmm2
	mulsd	%xmm5, %xmm2
	addsd	%xmm3, %xmm1
	mulsd	%xmm1, %xmm0
	movsd	.LC1(%rip), %xmm1
	mulsd	%xmm4, %xmm2
	subsd	%xmm3, %xmm1
	mulsd	64(%rsp), %xmm2
	mulsd	%xmm5, %xmm1
	addsd	%xmm1, %xmm0
	movapd	%xmm4, %xmm1
	mulsd	%xmm4, %xmm1
	mulsd	%xmm1, %xmm0
	subsd	%xmm5, %xmm0
	addsd	%xmm2, %xmm0
	comisd	%xmm0, %xmm7
	jb	.L78
	movl	112(%rsp), %eax
	movsd	(%rsp), %xmm1
	movhpd	32(%rsp), %xmm1
	testl	%eax, %eax
	je	.L80
	movq	120(%rsp), %rsi
	movl	$10, %edi
	movaps	%xmm1, (%rsp)
	call	fputc@PLT
	movq	128(%rsp), %rsi
	movl	$10, %edi
	call	fputc@PLT
	movapd	(%rsp), %xmm1
	jmp	.L80
.L109:
	leaq	.LC20(%rip), %rcx
	movl	$3, %edx
	movq	%rbx, %rsi
	movl	$1, %edi
	call	myexit
.L61:
	movq	20648(%rsp), %rdx
	subq	%fs:40, %rdx
	jne	.L108
	addq	$20664, %rsp
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
.L105:
	.cfi_restore_state
	xorl	%edx, %edx
	movl	%edx, 112(%rsp)
	jmp	.L72
.L64:
	leaq	.LC22(%rip), %rcx
	movl	$3, %edx
	movq	%rbx, %rsi
	movl	$1, %edi
	call	myexit
	jmp	.L61
.L74:
	movl	104(%rsp), %eax
	movl	112(%rsp), %edx
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	movl	116(%rsp), %ecx
	movq	stdout(%rip), %rdi
	leaq	.LC24(%rip), %rsi
	xorl	%ebp, %ebp
	addl	%eax, %eax
	cvtsi2sdl	%edx, %xmm0
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movl	$1, %eax
	call	fprintf@PLT
.L83:
	movq	(%rbx,%rbp,8), %rdi
	testq	%rdi, %rdi
	je	.L82
	call	fclose@PLT
.L82:
	addq	$1, %rbp
	cmpq	$3, %rbp
	jne	.L83
	movq	%rbx, %rdi
	call	free@PLT
	leaq	4256(%rsp), %rdx
	leaq	.LC25(%rip), %rsi
	xorl	%eax, %eax
	leaq	12448(%rsp), %rdi
	call	sprintf@PLT
	leaq	12448(%rsp), %rdi
	call	system@PLT
	xorl	%eax, %eax
	jmp	.L61
.L110:
	leaq	.LC21(%rip), %rcx
	movl	$3, %edx
	movq	%rbx, %rsi
	movl	$1, %edi
	call	myexit
	jmp	.L61
.L111:
	movl	$2, %eax
.L67:
	salq	$12, %rax
	movl	$3, %edx
	movq	%rbx, %rsi
	movl	$-2, %edi
	leaq	160(%rsp,%rax), %rcx
	call	myexit
	jmp	.L61
.L108:
	call	__stack_chk_fail@PLT
.L85:
	xorl	%eax, %eax
	jmp	.L67
.L86:
	movl	$1, %eax
	jmp	.L67
.L106:
	call	sqrt@PLT
	movsd	%xmm0, (%rsp)
	jmp	.L77
.L104:
	call	sqrt@PLT
	movsd	%xmm0, (%rsp)
	jmp	.L71
	.cfi_endproc
.LFE27:
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
	.ident	"GCC: (GNU) 15.1.1 20250425"
	.section	.note.GNU-stack,"",@progbits
