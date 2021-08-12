	.eqv DATA_SIZE 4 #(CONST)
	.text
	.globl main
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
	
	# CALCULATE SIZE OF 2 MATRICS
	mul	$t1, $s0, $s1		# size of matric A
	mul	$t2, $s2, $s3		# size of matric B
	mul	$t3, $s0, $s3		# size of matric result
	
	add	$t1, $t1, $t2
	add	$t1, $t1, $t3
	mul	$a0, $t1, DATA_SIZE	# multiply by 4(INTEGER NUMBER)
	
	# DECLARING MATRIC A IN $S4
	li	$v0, 9
	syscall
	addu	$s4, $zero, $v0
	
	# DECLARING MATRIC B IN $S5
	li	$v0, 9
	syscall
	addu	$s5, $zero, $v0
	
	# DECLARING MATRIC RRSULT IN $S6
	li	$v0, 9
	syscall
	addu	$s6, $zero, $v0
	
	# $t7: TOTAL ELEMS OF MATRIC A
	mul	$t7, $s0, $s1
	
	xor	$t1, $t1, $t1		# Loop variable
	move	$t2, $s4		# Pointer
	
loop1:
	slt	$t0, $t1, $t7
	beq	$t0, $zero, exit_loop1
	
	# TAKE INPUT FROM MATRIC A
	li	$v0, 4
	la	$a0, enter_mtrA
	syscall
	
	li	$v0, 5
	syscall
	sw	$v0, 0($t2)
	
	addiu	$t1, $t1, 1
	addiu	$t2, $t2, 4
	
	j	loop1
	
exit_loop1:
	
	# $s6: TOTAL ELEMS OF MATRIC B
	mul	$t7, $s2, $s3
	
	xor	$t1, $t1, $t1		# Loop variable
	move	$t2, $s5		# Pointer
	
loop2:
	slt	$t0, $t1, $t7
	beq	$t0, $zero, exit_loop2
	
	# TAKE INPUT FROM MATRIC B
	li	$v0, 4
	la	$a0, enter_mtrB
	syscall
	
	li	$v0, 5
	syscall
	sw	$v0, 0($t2)
	
	addiu	$t1, $t1, 1
	addiu	$t2, $t2, 4
	
	j	loop2
	
exit_loop2:

	# PRINT MATRIC A
	li	$v0, 4
	la	$a0, print_mtrA
	syscall
	
	move	$a1, $s4
	jal	printMatricA
	
	# PRINT MATRIC B
	li	$v0, 4
	la	$a0, print_mtrB
	syscall
	
	move	$a1, $s5
	jal	printMatricB
	
	
	# MOVE MATRIC: A, B, RESUL INTO ARGUMENT A1, A2, A3 RESPECTIVELY
	move	$a1, $s4
	move	$a2, $s5
	move	$a3, $s6
	
	jal	multiplication
	
	# PRINT MATRIC RESULT
	li	$v0, 4
	la	$a0, print_mtrRel
	syscall
	
	move	$a1, $s6
	jal	printMatricRel
	
	
	##################################################
	### $a1: mode read or write
	### $a0: file name read from or write to
	### $a2: addr of array
	##################################################
	li	$a1, 1
	la	$a0, Atxt
	#move	$a2, $s4
	
	#addi	$t3, $s4, 48 # CONVERT INTERGER TO ASCII
	jal	intToAscii_mtrA
	
	
	move	$t3, $s4
	
	la	$t0, arrRead
	sw	$t3, ($t0)
	move	$a2, $t0
	
	jal readWriteFile
	
	
	li	$v0, 10
	syscall
	
	
	
	
	
	
	multiplication:
	move	$s4, $a1		# matric A
	move	$s5, $a2		# matric B
	move	$s6, $a3		# matric RESULT
		
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
			#li	$v0, 1
			#move	$a0, $t9
			#syscall
					
			#li	$v0, 4
			#la	$a0, space
			#syscall
				
		addiu	$t2, $t2, 1		# k++
		j	L2
		
		end_L2:
		#li	$v0, 4
		#la	$a0, newline
		#syscall
			
	addiu	$t1, $t1, 1		# i++	
	j	L1
	
	end_L1:
	jr	$ra
	
	
	intToAscii_mtrA:
		xor	$t1, $t1, $t1		# Loop 1 variable(i)
		print1Aci:
			slt	$t0, $t1, $s0
			beq	$t0, $zero, end_print1Aci
			
			xor	$t2, $t2, $t2		# Loop 2 variable(j)
			print2Aci:
				slt	$t0, $t2, $s1
				beq	$t0, $zero, end_print2Aci
				
				mul	$t4, $t1, $s1
				addu	$t4, $t4, $t2
				sll	$t4, $t4, 2
				addu	$t4, $t4, $s4
				
				lw	$t5, 0($t4)
				addiu	$t5, $t5, 48		# CONVERT INTERGER TO ASCII
				
				sw	$t5, 0($t4)
				
				li	$v0, 1
				move	$a0, $t5
				syscall
				
				li	$v0, 4
				la	$a0, space
				syscall
				
				addiu	$t2, $t2, 1		# i++
				
				j print2Aci
			end_print2Aci:
			   li	$v0, 4
			   la	$a0, newline
			   syscall
			   
			   addiu	$t1, $t1, 1		# j++
			j print1Aci
		end_print1Aci:
	jr	$ra			
	
	
	
	
	
	#.globl printMatric
	printMatricA:
		xor	$t1, $t1, $t1		# Loop variable
		print1A:
			slt	$t0, $t1, $s0
			beq	$t0, $zero, end_print1A
			addiu	$t1, $t1, 1
			
			xor	$t2, $t2, $t2		# Loop variable
			print2A:
				slt	$t0, $t2, $s1
				beq	$t0, $zero, end_print2A
				addiu	$t2, $t2, 1
				
				li	$v0, 1
				lw	$a0, 0($a1)
				syscall
				
				addiu	$a1, $a1, 4		# Increase pointer
				
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
		
			
	printMatricB:
		xor	$t1, $t1, $t1		# Loop variable
		print1B:
			slt	$t0, $t1, $s2
			beq	$t0, $zero, end_print1B
			addiu	$t1, $t1, 1
			
			xor	$t2, $t2, $t2		# Loop variable
			print2B:
				slt	$t0, $t2, $s3
				beq	$t0, $zero, end_print2B
				addiu	$t2, $t2, 1
				
				li	$v0, 1
				lw	$a0, 0($a1)
				syscall
				
				addiu	$a1, $a1, 4		# Increase pointer
				
				li	$v0, 4
				la	$a0, space
				syscall
				
				j print2B
			end_print2B:
			   li	$v0, 4
			   la	$a0, newline
			   syscall
			j print1B
		end_print1B:
	jr	$ra			
	
	
	printMatricRel:
		xor	$t1, $t1, $t1		# Loop variable
		print1Rel:
			slt	$t0, $t1, $s0
			beq	$t0, $zero, end_print1Rel
			addiu	$t1, $t1, 1
			
			xor	$t2, $t2, $t2		# Loop variable
			print2Rel:
				slt	$t0, $t2, $s3
				beq	$t0, $zero, end_print2Rel
				addiu	$t2, $t2, 1
				
				li	$v0, 1
				lw	$a0, 0($a1)
				syscall
				
				addiu	$a1, $a1, 4		# Increase pointer
				
				li	$v0, 4
				la	$a0, space
				syscall
				
				j print2Rel
			end_print2Rel:
			   li	$v0, 4
			   la	$a0, newline
			   syscall
			j print1Rel
		end_print1Rel:
	jr	$ra
	
	
	
	readWriteFile:
	##################################################
	### $a1: mode read or write
	### $a0: file name read from or write to
	### $a2: addr of array
	##################################################
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	move	$t1, $a1		# mode
	move	$t0, $a0		# file name
	move	$t2, $a2		# addr of arr
	
	beqz	$t1, readFile		# MODE 1: Write to file, 0: Read file.
	j	writeFile
	
	
	writeFile:
	# Open a file
	li	$v0, 13			# open file
	move	$a0, $t0		# output filename
	move	$a1, $t1		# open writing(flag 0: read, 1: write)
	li	$a2, 0			# mode is ignored(a2: number of character to write)
	syscall
	     
	move	$t7, $v0		# save the file to descriptor
	    
	# Write to file
  	li	$v0, 15			# write to file
  	move	$a0, $t7		# file descriptor
  	#la	$a1, arrWrite		# addr buffer write to
  	move	$a1, $t2
  	li	$a2, 100     		# (hard) code buffer length
  	syscall
  	
  	j	Exit
  
  
  
	readFile:
 	# Open file for read
	li	$v0, 13
	move	$a0, $t0		# File name to read
	move	$a1, $t1		# reading file
	li	$a2, 0
	syscall
	
	move	$t7, $v0
	
 	# Open read file mode
	li	$v0, 14     # syscall to read file
	la	$a1, arrRead
	li	$a2, 100     # (hard) code number character read
	move	$a0, $t7
	syscall
	
	la	$a0, arrRead # print arr read
	li	$v0, 4
	syscall
	
	Exit:
	# Close the file 
  	li	$v0, 16      # close file
  	move	$a0, $t7     # file descriptor to close
  	syscall
  	
  	lw	$ra, 0($sp)
  	addi	$sp, $sp, 4
  	jr	$ra
  	
  	
	.data
	
msgRowA: .asciiz "Input number ROW of matrix A: "
msgColA: .asciiz "Input number COLUM of matrix A: "
msgRowB: .asciiz "Input number ROW of matrix B: "
msgColB: .asciiz "Input number COLUM of matrix B: "
space: .asciiz " "
newline: .asciiz "\n"
enter_mtrA: .asciiz "Enter matric A: "
enter_mtrB: .asciiz "Enter matric B: "
print_mtrA: .asciiz "Matric A: \n"
print_mtrB: .asciiz "Matric B: \n"
print_mtrRel: .asciiz "\nMatric result: \n"
Atxt: .asciiz "A.txt"
Btxt: .asciiz "B.txt"
RELtxt: .asciiz "result.txt"
arrWrite: .asciiz "assignment computer architecture is coming. \nNewline for new  future"
arrRead: .space 100
