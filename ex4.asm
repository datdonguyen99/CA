.text
Cal_Product_Matrix:
##########################################################
### $a1: Address of matric A
### $a2: Address of matric B
### $a3: Address of matric Result
### Return: $v0: Multiply success(0), fail(-1)
##########################################################
move	$s4, $a1		# matric A
move	$s5, $a2		# matric B
move	$s6, $a3		# matric RESULT

bne	$s1, $s2, Not_Multiply
Multiply:	
xor	$t1, $t1, $t1		# Loop 1 variable(i)
	L1:
	slt	$t0, $t1, $s0
	beq	$t0, $zero, end_L1
	xor	$t2, $t2, $t2		# Loop 2 variable(k)
		L2:
		slt	$t0, $t2, $s3
		beq	$t0, $zero, end_L2
			
		# ADDR OF RESULTANT[I][K]
		mul	$t4, $t1, $s3		# cols_resul*i
		addu	$t4, $t4, $t2		# cols_resul*i + k
		sll	$t4 , $t4, 2		# (cols_resul*i + k)*DATA_SIZE
		addu	$t4, $t4, $s6		# matric result in $s6
			
		xor	$t3, $t3, $t3		# Loop 3 variable(j)
			L3:
			slt	$t0, $t3, $s1
			beq	$t0, $zero, end_L3
				
			# ADDR OF MATRIC_A[I][J]
			mul	$t5, $t1, $s1		# cols_A*i
			addu	$t5, $t5, $t3		# cols_A*i + j
			sll	$t5, $t5, 2		# (cols_A*i + j)*DATA_SIZE
			addu	$t5, $t5, $s4		# matric_A in $s4
				
			# ADDR OF MATRIC_B[J][K]
			mul	$t6, $t3, $s3		# cols_B*j
			addu	$t6, $t6, $t2		# cols_B*j + k
			sll	$t6, $t6, 2		# (cols_B*j + k)*DATA_SIZE
			addu	$t6, $t6, $s5		# matric_B in $s5
				
			lw	$t7, 0($t5)		# Loading matric_A[I][J]
			lw	$t8, 0($t6)		# Loading matric_B[J][K]
				
			mul	$t9, $t7, $t8		# Multiply matric_A[I][J]*matric_B[J][K]
				
			lw	$t8, 0($t4)
			addu	$t9, $t9, $t8		# Matric_resultant +=  matric_A[I][J]*matric_B[J][K]
			sw	$t9, 0($t4)	
		addiu	$t3, $t3, 1		# j++
		j L3	
		end_L3:		
	addiu	$t2, $t2, 1		# k++
	j	L2
	end_L2:			
addiu	$t1, $t1, 1		# i++	
j	L1
	
end_L1:
li	$v0, 0
jr	$ra

Not_Multiply:
li	$v0, -1
jr	$ra
