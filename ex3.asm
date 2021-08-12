	.text
	.globl main
main:
	addu	$t7, $t7, 6
	move	$a0, $t7
	addu	$t6, $t6, 3
	move	$a1, $t6
	
	jal	dynamicallyAllocate
	move	$a0, $v0
	li	$v0, 34		# Syscall call to print HEXA
	syscall
	
	li	$v0, 10		#EXIT
	syscall

dynamicallyAllocate:
	#######################################################
	#### $a0: number of elems
	#### $a1: size of each elems(bytes)
	#### $v0: addr of allocated memory
	#######################################################
	
	addi	$sp, $sp, -4
	sw	$s0, 0($sp)
	
	move	$t0, $a0		# $a0 is number of elems
	
	move	$t1, $a1		# (num) bytes per elem
	mul	$t2, $t0, $t1		# Calculate total allocated memory bytes
	sgt	$t3, $t2, 65536		# t2 > 65536 bits ? t3 = 1 : 0
	beqz	$t3, successCode	# t3 = 0 ? successCode : 
	
	# Error_Code
	li	$v0, -1
	j	end
	
	successCode:
	move	$a0, $t2		#Store number of bytes you need
	li	$v0, 9			# Load system instruction to allocate dynamic memory
					# v0 <-- the addr of the first byte of the dynamically of the block
	syscall				# Allocate memory and return addr into $v0
	
	#la	$s0, arr		# Load addr of arr into $s0
	#move	$s0, $v0
	#sw	$v0, 0($s0)
	
	end:
	lw	$s0, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
