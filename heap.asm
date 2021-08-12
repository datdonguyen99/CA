.data
.globl memory
memory:
    .asciiz "number of bytes to allocate: "
.text
.globl main
main:
la      $a0, memory 
li      $v0, 4       #command to print string
syscall
li      $v0, 5        #command to read int
syscall
move    $a0, $v0
ori     $v0, $0, 9   #sbrk  
syscall
la      $a0, 0($v0)
ori     $v0, $0, 34      #command to print hex
syscall