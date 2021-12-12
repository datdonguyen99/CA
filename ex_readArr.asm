.data
    a: 
        .word 3, 2, 1, 8, 6, 9, 3, 4, 2, 5
    nline: 
        .asciiz "\n"

    .text
    .globl main
main:
    la      $a1, a
    li      $v0, 0
    
loop1:
    bge     $t0, 10, exit

    # load word from addrs and goes to the next addrs
    lw      $t2, 0($a1)
    addi    $a1, $a1, 4

    # syscall to print value
    li      $v0, 1      
    move    $a0, $t2
    syscall
    # optional - syscall number for printing character (space)
    li      $a0, 32
    li      $v0, 11  
    syscall


    #increment counter
    addi    $t0, $t0, 1
    j      loop1

 exit:
    li      $v0, 10
    syscall
