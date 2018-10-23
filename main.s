	.file	"main.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Hello World!"
	.text
	.p2align 4,,15
	.globl	kmain
	.type	kmain, @function
kmain:
.LFB1:
	.cfi_startproc
	leaq	.LC0(%rip), %rdx
	movl	$753664, %eax
	movl	$72, %ecx
	.p2align 4,,10
	.p2align 3
.L2:
	addq	$1, %rdx
	movb	%cl, (%rax)
	movb	$7, 1(%rax)
	movzbl	(%rdx), %ecx
	addq	$2, %rax
	testb	%cl, %cl
	jne	.L2
.L3:
	jmp	.L3
	.cfi_endproc
.LFE1:
	.size	kmain, .-kmain
	.ident	"GCC: (Ubuntu 7.3.0-16ubuntu3) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
