	.data
dimA:	.word 0,0
dimB:	.word 0,0
dimRes:	.word 0,0

	.text
Matrix_Mul:
	#Parameter: $a0: first address of matrix A
		  # $a1: first address of matrix B
		  # $a2: first address of matrix Result
					
	#Return: $v0: Multiply success (0), Multiply fail (-1)
	
	
	la	$t0, dimA 
	la	$t1, dimB 
	lw	$t2, 4($t0)
	lw	$t3, 0($t1)
	bne	$t2, $t3, Unsatisfy
	Satisfy:
	# Note data need to be saved:
	la	$t2, dimRes
	lw	$t3, 0($t2)
	lw	$t4, 4($t2)
	mult	$t3, $t4
	mflo	$t2  # total element of result matrix.
	lw	$t0, 4($t0) # Get number of column of matrix A again to use
	lw	$t1, 4($t1)
	li	$t3, 0	#Counter loop1
	assign_each_resElemt:
	beq	$t3, $t2, return
	li	$t4, 0 #Registor save the result at index $t3
	li	$t5, 0 #Counte loop2
		loop_assign:
		beq	$t5, $t0, end_loop_assign
		### GET INDEX OF MATRIX A ###
		div	$t3, $t1
		mflo	$t6
		mult	$t6, $t0
		mflo	$t6
		add	$t6, $t6, $t5
		sll	$t6, $t6, 2
		### END GET INDEX ###
		
		### GET INDEX OF MATRIX B ###
		mult 	$t5, $t1
		mflo	$t7
		div	$t3, $t1
		mfhi	$t8
		add	$t7, $t7, $t8
		sll	$t7, $t7, 2
		### END GET INDEX ###
		
		### GET VALUE AT INDEX $t6 OF MATRIX A ###
		add	$t6, $a0, $t6
		lw	$t6, 0($t6)
		
		### GET VALUE AT INDEX $t7 OF MATRIX B ###
		add	$t7, $a1, $t7
		lw	$t7, 0($t7)
		
		### COMPUTE VALUE AT INDEX $t3 OF MATRIX RESULT ###
		mult 	$t6, $t7
		mflo	$t6
		add	$t4, $t4, $t6
		
		addi	$t5, $t5, 1
		j	loop_assign
		end_loop_assign:
	sw	$t4, 0($a2)
	addi	$a2, $a2, 4
	addi	$t3, $t3, 1
	j	assign_each_resElemt
	return:
	li	$v0, 0
	jr	$ra
	Unsatisfy:
	li	$v0, -1
	jr	$ra
##############################################################################
		