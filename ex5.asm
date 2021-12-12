.eqv DATA_SIZE 4 #(CONST)
.data	
msgRowA: .asciiz "Input number ROWs of matrix A: "
msgColA: .asciiz "Input number COLUMs of matrix A: "
msgRowB: .asciiz "Input number ROWs of matrix B: "
msgColB: .asciiz "Input number COLUMs of matrix B: "
pMtxA: .word 0	#Pointer of matric A
pMtxB: .word 0	#Pointer of matric B
pMtxRel: .word 0 #Pointer of matric Result
space: .asciiz " "
newline: .asciiz "\n"
print_mtrA: .asciiz "\nMatric A: \n"
print_mtrB: .asciiz "\nMatric B: \n"
print_mtrRel: .asciiz "\nMatric result: \n"
Atxt: .asciiz "A.txt"
Btxt: .asciiz "B.txt"
RELtxt: .asciiz "result.txt"
buffer: .space 2048 #buffer to store data write to | read from
errDynamicAlloca: .asciiz "Size too large for dynamic allocation. Plz check again!"
errSizeMul: .asciiz "Sizes of two matrices can't mul. Plz check again!"

.text
main:
################################################################
##### $s0: rowA, $s1: colA
##### $s2: rowB, $s3: colB
#################################################################
	
# TAKE DIMENSIONS INPUT
li	$v0, 4
la	$a0, msgRowA
syscall
li	$v0, 5
syscall
move	$s0, $v0
	
li	$v0, 4
la	$a0, msgColA
syscall
li	$v0, 5
syscall
move	$s1, $v0
	
li	$v0, 4
la	$a0, msgRowB
syscall
li	$v0, 5
syscall
move	$s2, $v0
	
li	$v0, 4
la	$a0, msgColB
syscall
li	$v0, 5
syscall
move	$s3, $v0

# DYNAMIC ALLOCATE MATRIC A
mult	$s0, $s1
mflo	$a0
li	$a1, 4
jal	Dynamic_Allocate
beq	$v0, $zero, successAllocMtxA
# Print err
li	$v0, 4
la	$a0, errDynamicAlloca
syscall
break
successAllocMtxA:
la	$t0, pMtxA
sw	$v1, 0($t0)	#Store matric A in $t0

# DYNAMIC ALLOCATE MATRIC B
mult	$s2, $s3
mflo	$a0
li	$a1, 4
jal	Dynamic_Allocate
beq	$v0, $zero, successAllocMtxB
# Print err
li	$v0, 4
la	$a0, errDynamicAlloca
syscall
break
successAllocMtxB:
la	$t1, pMtxB
sw	$v1, 0($t1)	#Store matric B in $t1

# DYNAMIC ALLOCATE MATRIC PRODUCT
mult	$s0, $s3
mflo	$a0
li	$a1, 4
jal	Dynamic_Allocate
beq	$v0, $zero, successAllocMtxResult
# Print err
li	$v0, 4
la	$a0, errDynamicAlloca
syscall
break
successAllocMtxResult:
la	$t2, pMtxRel
sw	$v1, 0($t2)	#Store matric Result in $t2

# GENERATE RANDOMLY INTEGER FOR MATRIC A
move	$a1, $s0
move	$a2, $s1
la	$a3, pMtxA
lw	$a3, 0($a3)
jal	Generate_Value

# GENERATE RANDOMLY INTEGER FOR MATRIC B
move	$a1, $s2
move	$a2, $s3
la	$a3, pMtxB
lw	$a3, 0($a3)
jal	Generate_Value

# PRINT MATRIC A
li	$v0, 4
la	$a0, print_mtrA
syscall
move	$a1, $s0
move	$a2, $s1
la	$a3, pMtxA
lw	$a3, 0($a3)
jal	printMatric

# PRINT MATRIC B
li	$v0, 4
la	$a0, print_mtrB
syscall
move	$a1, $s2
move	$a2, $s3
la	$a3, pMtxB
lw	$a3, 0($a3)
jal	printMatric

# CALCULATE PRODUCT MATRIC
la	$a1, pMtxA
lw	$a1, 0($a1)
la	$a2, pMtxB
lw	$a2, 0($a2)
la	$a3, pMtxRel
lw	$a3, 0($a3)
jal	Cal_Product_Matrix
beq	$v0, $zero, successCalculate
# Print err
li	$v0, 4
la	$a0, errSizeMul
syscall
break
successCalculate:

# PRINT MATRIC RESULT
li	$v0, 4
la	$a0, print_mtrRel
syscall
move	$a1, $s0
move	$a2, $s3
la	$a3, pMtxRel
lw	$a3, 0($a3)
jal	printMatric

#STORE MATRIC A INTO .TXT FILE
la	$a1, buffer
move	$a0, $s0
move	$a2, $s1
la	$a3, pMtxA
lw	$a3, 0($a3)
jal 	Mtx_2_Ascii
la	$a1, Atxt
li	$a2, 1
la	$a3, buffer
jal	Read_Write_File

#STORE MATRIC B INTO .TXT FILE
la	$a1, buffer
move	$a0, $s2
move	$a2, $s3
la	$a3, pMtxB
lw	$a3, 0($a3)
jal 	Mtx_2_Ascii
la	$a1, Btxt
li	$a2, 1
la	$a3, buffer
jal	Read_Write_File

#STORE MATRIC RESULT INTO .TXT FILE
la	$a1, buffer
move	$a0, $s0
move	$a2, $s3
la	$a3, pMtxRel
lw	$a3, 0($a3)
jal 	Mtx_2_Ascii
la	$a1, RELtxt
li	$a2, 1
la	$a3, buffer
jal	Read_Write_File

li	$v0, 10		#Systemcall end program
syscall



##########################################################
##########################################################
#########              MIPS PROCEDUURE           #########
##########################################################
##########################################################



Dynamic_Allocate:
##########################################################
### $a0: Number of elements
### $a1: Size of element(in bytes)
### Return:
### $v0: success(0), fail(-1)
### $v1: First address arr
##########################################################
#Note data need to be saved:
mult	$a0, $a1	#Cal total size
mflo	$a0
li	$a1, 65536
bgt	$a0, $a1, fail
#allocate size of matrix
success:
li	$v0, 9		#Syscall allocated dynamic memory
syscall
move	$v1, $v0
li	$v0, 0
jr	$ra
#Size out of bound
fail:
li	$v0, -1
li	$v1, 0
jr	$ra



Generate_Value:
##########################################################
### $a1: Number of rows
### $a2: Number of cols
### $a3: address of first element of matrix
##########################################################
move	$t0, $a1
move	$t1, $a2
mult	$t0, $t1
mflo	$t1		# Number elements of matrix
li	$t0, 0		# Counter num of elems
li	$a0, 0		# Set lowerbound = 0
li	$a1, 100	# Set upperbound = 100
Generate_Loop:
	beq	$t0, $t1, End_Generate_Loop
	li	$v0, 42		# Generates the random Integer number (returns in $a0).
	syscall
	sw	$a0, 0($a3)
	addi	$t0, $t0, 1	# Increase counter
	addi	$a3, $a3, 4
	j	Generate_Loop
End_Generate_Loop:
jr	$ra



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



printMatric:
##########################################################
### $a1: Number of rows
### $a2: Number of cols
### $a3: address of first element of matrix
##########################################################
xor	$t1, $t1, $t1		# Loop variable
print1A:
	slt	$t0, $t1, $a1
	beq	$t0, $zero, end_print1A
	addiu	$t1, $t1, 1
			
	xor	$t2, $t2, $t2		# Loop variable
	print2A:
		slt	$t0, $t2, $a2
		beq	$t0, $zero, end_print2A
		addiu	$t2, $t2, 1
				
		li	$v0, 1
		lw	$a0, 0($a3)
		syscall
				
		addiu	$a3, $a3, 4	# Increase pointer
				
		li	$v0, 4
		la	$a0, space
		syscall
				
		j print2A
	end_print2A:
	li	$v0, 4
	la	$a0, newline
	syscall
j print1A
end_print1A:
jr	$ra



Read_Write_File:
##########################################################
### $a1: File name will be read from/write to
### $a2: Mode for Read from(0), Write to(1)
### $a3: First address arr store data
##########################################################
		
#Open file
li	$v0, 13  	# system call for open file
move	$a0, $a1 	# output file name
move	$a1, $a2 	# Flag
li	$a2, 0	 	# mode is ignored
syscall 	 	# open a file (file descriptor returned in $v0)
move	$s6, $v0 	# save the file descriptor
	
beqz	$a1, Read
Write:
move	$t0, $a3
Count_Array_Length:
	lb	$t1, 0($t0)
	beq	$t1, $zero, End_Count_Length
	addi	$a2, $a2, 1	#count length
	addi	$t0, $t0, 1
	j	Count_Array_Length
End_Count_Length:
	
li	$v0, 15		# write to file
move	$a0, $s6	# file descriptor
move	$a1, $a3	# addr buffer write to
syscall
j	Close
	
Read:
li	$v0, 14		# system call for reading from file
move	$a0, $s6	# file descriptor
move	$a1, $a3	# address of buffer from which to read
li	$a2, 2048	# hardcoded buffer length
syscall			# read from file

# Printing File Content
li	$v0, 4          # system Call for PRINT STRING
move	$a0, $a1
syscall

Close:
# Close the file
li	$v0, 16
move	$a0, $s6
syscall
jr	$ra



Mtx_2_Ascii:
##########################################################
### $a1: Address of array stored matrix
### $a0: Number of rows
### $a2: Number of cols
### $a3: First Element Address of Matrix
##########################################################
# Save: s4:space, s5:newline, ra
addi	$sp, $sp, -12
sw	$ra, 0($sp)
sw	$s4, 4($sp)
sw	$s5, 8($sp)
	
move	$t7, $a0	#Num Rows
move	$t8, $a2	#Num Cols
li	$s4, 32		#Space Ascii
li	$s5, 10		#Endl Ascii
	
move	$a0, $t7	#Num Rows
jal	Write_Int
sb	$s4, 0($a1)	#Store num rows to txt
addi	$a1, $a1, 1

move	$a0, $t8	#Num Cols
jal	Write_Int
sb	$s5, 0($a1)	#Store num cols to txt
addi	$a1, $a1, 1

li	$t4, 0		#Row Counter
Save_Row_Txt:
	beq	$t4, $t7, End_Row_Txt
	li	$t3, 0		#Col Counter
	Save_Col_Txt:
		beq	$t3, $t8, End_Col_Txt
		lw	$a0, 0($a3)
		jal	Write_Int	#Store elems to txt
		sb	$s4, 0($a1)	#Store space to txt
		
		addi	$a1, $a1, 1
		addi	$a3, $a3, 4
		addi	$t3, $t3, 1	#Increase Col Counter
		j	Save_Col_Txt
	End_Col_Txt:
	sb	$s5, 0($a1)	#Store newline
	addi	$a1, $a1, 1
	addi	$t4, $t4, 1	#Row Counter
	j	Save_Row_Txt
End_Row_Txt:
sb	$zero, 0($a1)
lw	$s5, 8($sp)
lw	$s4, 4($sp)
lw	$ra, 0($sp)
jr	$ra



Write_Int:
##########################################################
### $a0: Integer will be write
### $a1: Reference of pointer to buffer
##########################################################
li	$t1, 10
li	$t2, 0
move	$t0, $a0
Count_Num_Digit:
addi	$t2, $t2, 1	# Num digits
div	$t0, $t1	# /10
mflo	$t0
bnez	$t0, Count_Num_Digit

add	$a1, $a1, $t2
Write_Row:
addi	$a1, $a1, -1
div	$a0, $t1	# /10
mflo	$a0		# Quotient
mfhi	$t0		# Remainder
addi	$t0, $t0, 48	# Int to String(ascii)
sb	$t0, 0($a1)
bnez	$a0, Write_Row

add	$a1, $a1, $t2
jr	$ra
