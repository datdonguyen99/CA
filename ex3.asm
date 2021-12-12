.text
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