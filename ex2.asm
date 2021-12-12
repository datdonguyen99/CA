.text

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
syscall            	# print

Close:
# Close the file
li	$v0, 16
move	$a0, $s6
syscall

jr	$ra