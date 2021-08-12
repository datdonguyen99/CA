	.text
	.globl main
main:
	li	$a0, 1
	jal	readWriteFile

	li	$v0, 10		# EXIT
	syscall
	
readWriteFile:
	##################################################
	### $a0: mode read or write
	##################################################
	
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	move	$t0, $a0
	beqz	$t0, readFile # MODE 1: Write to file, 0: Read file.
	j	writeFile
	
	
	writeFile:
	# Open a file
	li	$v0, 13       # open file
	la	$a0, msgWFile # output filename
	li	$a1, 1        # open writing(flag 0: read, 1: write)
	li	$a2, 0        # mode is ignored(a2: number of character to write)
	syscall
	     
	move	$s0, $v0      # save the file to descriptor
	    
	# Write to file
  	li	$v0, 15       # write to file
  	move	$a0, $s0      # file descriptor
  	la	$a1, arrWrite # addr buffer write to
  	li	$a2, 100     # (hard) code buffer length
  	syscall
  	
  	j	Exit
  
  
  
	readFile:
 	# Open file for read
	li	$v0, 13
	la	$a0, msgRFile # File name to read
	li	$a1, 0        # reading file
	li	$a2, 0
	syscall
	
	move	$s0, $v0
	
 	# Open read file mode
	li	$v0, 14     # syscall to read file
	la	$a1, arrRead
	li	$a2, 100     # (hard) code number character read
	move	$a0, $s0
	syscall
	
	la	$a0, arrRead # print arr read
	li	$v0, 4
	syscall
	
	Exit:
	# Close the file 
  	li	$v0, 16      # close file
  	move	$a0, $s0     # file descriptor to close
  	syscall
  	
  	lw	$ra, 0($sp)
  	addi	$sp, $sp, 4
  	jr	$ra
  	
	.data
arrWrite: .asciiz "assignment computer architecture is coming. \nNewline for new  future"
arrRead: .space 50
msgWFile: .asciiz "writeFile.txt"
msgRFile: .asciiz "readFile.txt"
