.data
dimension: .asciiz "Enter dimension of the matrix: "
enter_first: .asciiz "Enter first matrix:\n"
enter_second: .asciiz "Enter second matrix:\n"
show_first: .asciiz "First matrix:\n"
show_second: .asciiz "Second matrix:\n"
menu: .asciiz "\n1.Addition\n2.Subtraction\n3.Multiplication\n\nThe Following operations are for the first matrix\n4.Transpose\n5.Determinant\n6.Scaling\n7.Exit"
choice: .asciiz "\nEnter your choice :"
num_scale:.asciiz "\nEnter a number for scaling:"
wrongchoice: .asciiz "\nInvalid Choice!"
exiting: .asciiz "\n\tExiting."
show_result: .asciiz "Result:\n"
space: .asciiz " "
newline: .asciiz "\n"
.text
.globl main
main:
# Prompt and take dimension input
li $v0, 4
la $a0, dimension
syscall
li $v0, 5
syscall
addu $s0, $zero, $v0 # $s0 == N
# Size of the 2d array stored in $a0 for next three steps
mul $a0, $s0, $s0
mul $a0, $a0, 4
# Declaring matrix A in $s1
li $v0, 9
syscall
addu $s1, $zero, $v0
# Declaring matrix B in $s2
li $v0, 9
syscall
addu $s2, $zero, $v0
# Declaring resultant matrix in $s3
li $v0, 9
syscall
addu $s3, $zero, $v0
# $s4 = N^2
mul $s4, $s0, $s0
# Take input in matrix A
li $v0, 4
la $a0, enter_first
syscall
xor $t1, $t1, $t1 # loop variable
move $t2, $s1 # pointer
loop1:
slt $t0, $t1, $s4
beq $t0, $zero, exit1
li $v0, 5
syscall
sw $v0, 0($t2)
addiu $t1, $t1, 1
addiu $t2, $t2, 4
j loop1
exit1:
# Take input in matrix B
li $v0, 4
la $a0, enter_second
syscall
xor $t1, $t1, $t1 # loop variable
move $t2, $s2 # pointer
loop2:
slt $t0, $t1, $s4
beq $t0, $zero, exit2
li $v0, 5
syscall
sw $v0, 0($t2)
addiu $t1, $t1, 1
addiu $t2, $t2, 4
j loop2
exit2:
 # Print matrix A
li $v0, 4
la $a0, show_first
syscall
move $a1, $s1
jal printMatrix
# Print matrix B
li $v0, 4
la $a0, show_second
syscall
move $a1, $s2
jal printMatrix
li $v0,4
la $a0, menu
syscall
INPUT:
 li $v0,4
la $a0, choice
syscall
li $v0,5
syscall
move $t0, $v0
li $t1, 1
li $t2, 2
li $t3, 3
li $t4, 4
li $t5, 5
li $t6, 6
li $t7, 7
 move $a0,$s0
 move $a1,$s1
 move $a2,$s2
 move $a3,$s3
blez $t0, Label0
bgt $t0, $t7, Label0
beq $t0, $t1, Label1
beq $t0, $t2, Label2
beq $t0, $t3, Label3
beq $t0, $t4, Label4
beq $t0, $t5, Label5
beq $t0, $t6, Label6
beq $t0, $t7, Label7
Label0:
 li $v0,4
 la $a0,wrongchoice
syscall
 j INPUT
 Label1:
jal addition
 j INPUT
 Label2:
jal subtraction
 j INPUT
 Label3:
jal multiplication
j INPUT
 Label4:
jal transpose
 j INPUT
 Label5:
jal determinant
 j INPUT
 Label6:
jal scaling
 j INPUT
 Label7:
 li $v0,4
 la $a0,exiting
syscall
 li $v0,10
syscall
.end main .globl addition
.ent addition
addition:
 move $s0,$a0
 move $s1,$a1
 move $s2,$a2
xor $t1, $t1, $t1
 L1:
slt $t0, $t1, $s0
beq $t0, $zero, endL1
xor $t2, $t2, $t2
 L2:
slt $t0, $t2, $s0
beq $t0, $zero, endL2
mul $t4, $t1, $s0
addu $t4, $t4, $t2
sll $t4, $t4, 2
addu $t4, $t4, $s1
mul $t5, $t1, $s0
addu $t5, $t5, $t2
sll $t5, $t5, 2
addu $t5, $t5, $s2
lw $t6, 0($t4)
lw $t7, 0($t5)
 add $t8, $t6, $t7
 li $v0,1
 move $a0, $t8
syscall
 li $v0,4
 la $a0,space
syscall
addiu $t2, $t2, 1
 j L2
 endL2:
addiu $t1, $t1, 1
 li $v0,4
 la $a0, newline
syscall
 j L1
endL1:
jr $ra
.end addition
.globl subtraction
.ent subtraction
subtraction:
 move $s0,$a0
 move $s1,$a1
 move $s2,$a2
xor $t1, $t1, $t1
 L3:
slt $t0, $t1, $s0
beq $t0, $zero, endL3
xor $t2, $t2, $t2
 L4:
slt $t0, $t2, $s0
beq $t0, $zero, endL4
mul $t4, $t1, $s0
addu $t4, $t4, $t2
sll $t4, $t4, 2
addu $t4, $t4, $s1
mul $t5, $t1, $s0
addu $t5, $t5, $t2
sll $t5, $t5, 2
addu $t5, $t5, $s2
lw $t6, 0($t4)
lw $t7, 0($t5)
 sub $t8, $t6, $t7
 li $v0,1
 move $a0,$t8
syscall
 li $v0,4
 la $a0,space
syscall
addiu $t2, $t2, 1
 j L4
 endL4:
 li $v0,4
 la $a0,newline
syscall
addiu $t1, $t1, 1
 j L3
endL3:
jr $ra
.end subtraction
.globl multiplication
.ent multiplication
multiplication:
 move $s0,$a0
 move $s1,$a1
 move $s2,$a2
 move $s3,$a3
xor $t1, $t1, $t1 # loop 1 variable
 L5:
slt $t0, $t1, $s0
beq $t0, $zero, endL5
xor $t2, $t2, $t2 # loop 2 variable
 L6:
slt $t0, $t2, $s0
beq $t0, $zero, endL6
mul $t4, $t1, $s0 # address of resultant[i][j]
addu $t4, $t4, $t2
sll $t4, $t4, 2
addu $t4, $t4, $s3
xor $t3, $t3, $t3 # loop 3 variable
 L7:
slt $t0, $t3, $s0
beq $t0, $zero, endL7
mul $t5, $t1, $s0 # address of matA[i][k]
addu $t5, $t5, $t3
sll $t5, $t5, 2
addu $t5, $t5, $s1
mul $t6, $t3, $s0 # address of matB[k][j]
addu $t6, $t6, $t2
sll $t6, $t6, 2
addu $t6, $t6, $s2
lw $t7, 0($t5) # loading matA[i][k]
lw $t8, 0($t6) # loading matB[k][j]
mul $t9, $t7, $t8 # matA[i][k] * matB[k][j]
lw $t8, 0($t4)
addu $t9, $t9, $t8 # resultant += matA[i][k] * matB[k][j]
sw $t9,0($t4)
addiu $t3, $t3, 1
 j L7
endL7:
 li $v0,1
 move $a0,$t9
syscall
 li $v0,4
 la $a0,space
syscall
addiu $t2, $t2, 1
 j L6
endL6:
 li $v0,4
 la $a0,newline
syscall
addiu $t1, $t1, 1
 j L5
endL5:
jr $ra
.end multiplication
.globl transpose
.ent transpose
transpose:
 move $s0,$a0
 move $s1,$a1
xor $t1, $t1, $t1
L8:
slt $t0, $t1, $s0
beq $t0, $zero, endL8
xor $t2, $t2, $t2
L9:
slt $t0, $t2, $s0
beq $t0, $zero, endL9
mul $t4, $t2, $s0
addu $t4, $t4, $t1
sll $t4, $t4, 2
addu $t4, $t4, $s1
lw $t5, 0($t4)
li $v0,1
move $a0,$t5
syscall
li $v0,4
la $a0,space
syscall
addiu $t2, $t2, 1
j L9
 endL9:
 li $v0,4
 la $a0,newline
syscall
addiu $t1, $t1, 1
 j L8
 endL8:
jr $ra
.end transpose
.globl determinant
.ent determinant
determinant:
 move $s0,$a0
 move $s1,$a1
 li $t0,0
li $t1,1
li $t2,2
mul $t3,$t0,$s0
addu $t3,$t3,$t0
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t4,0($t3) # A[0][0]
mul $t3,$t1,$s0
addu $t3,$t3,$t1
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t5,0($t3) # A[1][1]
mul $t3,$t2,$s0
addu $t3,$t3,$t2
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t6,0($t3) # A[2][2]
mul $t5,$t5,$t6 #A[1][1]*A[2][2]
mul $t3,$t2,$s0
addu $t3,$t3,$t1
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t6,0($t3) # A[2][1]
mul $t3,$t1,$s0
addu $t3,$t3,$t2
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t7,0($t3) # A[1][2]
mul $t6,$t6,$t7 #A[2][1]*A[1][2]
sub $t5,$t5,$t6
mul $s7,$t4,$t5
mul $t3,$t0,$s0
addu $t3,$t3,$t1
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t4,0($t3) # A[0][1]
mul $t3,$t1,$s0
addu $t3,$t3,$t0
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t5,0($t3) # A[1][0]
mul $t3,$t2,$s0
addu $t3,$t3,$t2
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t6,0($t3) # A[2][2]
mul $t5,$t5,$t6 #A[1][0]*A[2][2]
mul $t3,$t2,$s0
addu $t3,$t3,$t0
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t6,0($t3) # A[2][0]
mul $t3,$t1,$s0
addu $t3,$t3,$t2
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t7,0($t3) # A[1][2]
mul $t6,$t6,$t7 #A[2][0]*A[1][2]
sub $t5,$t5,$t6
mul $s6,$t4,$t5
 sub $s7,$s7,$s6
mul $t3,$t0,$s0
addu $t3,$t3,$t2
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t4,0($t3) # A[0][2]
mul $t3,$t1,$s0
addu $t3,$t3,$t0
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t5,0($t3) # A[1][0]
mul $t3,$t2,$s0
addu $t3,$t3,$t1
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t6,0($t3) # A[2][1]
mul $t5,$t5,$t6 #A[1][0]*A[2][1]
mul $t3,$t2,$s0
addu $t3,$t3,$t0
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t6,0($t3) # A[2][0]
mul $t3,$t1,$s0
addu $t3,$t3,$t1
sll $t3,$t3,2
addu $t3,$t3,$s1
lw $t7,0($t3) # A[1][1]
mul $t6,$t6,$t7 #A[2][0]*A[1][1]
sub $t5,$t5,$t6
mul $s6,$t4,$t5
 add $s7,$s7,$s6
 li $v0, 4
la $a0, show_result
syscall
 li $v0,1
move $a0, $s7
syscall
jr $ra
.end determinant
.globl scaling
.ent scaling
scaling:
 move $s0,$a0
 move $s1,$a1
 li $v0,4
 la $a0,num_scale
syscall
 li $v0,5
syscall
 move $s7,$v0
xor $t1, $t1, $t1
L11:
slt $t0, $t1, $s0
beq $t0, $zero, endL11
xor $t2, $t2, $t2
 L12:
slt $t0, $t2, $s0
beq $t0, $zero, endL12
mul $t4, $t1, $s0
addu $t4, $t4, $t2
sll $t4, $t4, 2
addu $t4, $t4, $s1
lw $t5,0($t4)
mul $t5,$t5,$s7
 li $v0,1
 move $a0,$t5
syscall
 li $v0,4
 la $a0,space
syscall
addiu $t2, $t2, 1
 j L12
 endL12:
 li $v0,4
 la $a0,newline
syscall
addiu $t1, $t1, 1
 j L11
endL11:
jr $ra
.end scaling
.globlprintMatrix
.entprintMatrix
printMatrix:
xor $t1, $t1, $t1 # loop 1 variable
print1:
slt $t0, $t1, $s0
beq $t0, $zero, end_print1
addiu $t1, $t1, 1
xor $t2, $t2, $t2 # loop 2 variable
print2:
slt $t0, $t2, $s0
beq $t0, $zero, end_print2
addiu $t2, $t2, 1
li $v0, 1
lw $a0, 0($a1)
syscall
addiu $a1, $a1, 4 # increment pointer
li $v0, 4
la $a0, space
syscall
j print2
 end_print2:
 li $v0, 4
 la $a0, newline
syscall
 j print1
 end_print1:
jr $ra
.endprintMatrix
