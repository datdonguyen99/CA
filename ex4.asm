	.text
	.globl main
main:
	################################################################
	##### $a0: matrix A
	##### $a1: matrix B
	#################################################################
	
	la	$s0, matrixA
	la	$s1, matrixB
	la	$s2, sizeA
	nop
	
	lw	$s3, 4($s2)
	nop
	
	lw	$s2, 0($s2)
	la	$s4, sizeB
	nop
	
	lw	$s5, 4($s4)
	nop
	
	lw	$s4, 0($s4)
	la	$s6, result
	
	add	$s7, $s5, $zero		# col result matrix
	add	$t0, $zero, $zero	# i=0
	add	$t1, $zero, $zero	# j=0
	add	$t2, $zero, $zero	# k=0
	li	$t3, 0
	
i_loop:
	beq	$t0, $s2, i_end
	nop
j_loop:
	beq	$t1, $s5, j_end
	nop
k_loop:
	beq	$t2, $s4, k_end
	nop
	
	li	$t4, 0
	li	$t5, 0
	li	$t6, 0
	
	mul	$t4, $t0, $s3
	add	$t4, $t4, $t2
	addi	$t4, $t4, -1
	sll	$t4, $t4, 2
	addu	$t4, $t4, $s0
	lw	$t4, 0($t4)
	
	mul	$t5, $t2, $s5
	add	$t5, $t5, $t1
	addi	$t5, $t5, -1
	sll	$t5, $t5, 2
	addu	$t5, $t5, $s1
	lw	$t5, 0($t5)
	
	mul	$t6, $t0, $s7
	add	$t6, $t6, $t1
	addi	$t6, $t6, -1
	sll	$t6, $t6, 2
	addu	$t6, $t6, $s6
	lw	$t8, 0($t6)
	
	mul	$t7, $t4, $t5
	add	$t9, $t8, $t7
	sw	$t9, 0($t6)
	
	addi	$t2, $t2, 1	# k++
	j	k_loop
	
k_end:
	addi	$t1, $t1, 1	# j++
	li	$t2, 0
	j	j_loop
j_end:
	addi	$t0, $t0, 1	# i++
	li	$t1, 0
	j	i_loop
i_end:


	li	$t0, 0
	#li	$t2, 0
	la	$a1, result
	#li	$v0, 0
loop_print:
	bge	$t0, 9, exit_print
	lw	$t2, 0($a1)
	addi	$a1, $a1, 4
	
	li	$v0, 1
	move	$a0, $t2
	syscall
	
	li      $a0, 32
	li      $v0, 11  
	syscall
	
	addi	$t0, $t0, 1
	j	loop_print
	
exit_print:
	li	$v0, 10
	syscall
	
	.data
matrixA: .word 1, 2
	 .word 3, 4
	 .word 5, 6
	 
matrixB: .word 7, 8, 9, 10, 11, 12
	
sizeA: .word 3, 2
sizeB: .word 2, 3
result: .word 0:9

.eqv DATA_SIZE 4  # CONST(eqv)

	#RESULT:
	###################
	### 27 30 33    ###
	### 61 68 75    ###
	### 95 106 117  ###
	###################
	
