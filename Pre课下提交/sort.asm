.data 
array: .space 400 
message_input_n: .asciiz "please input an integer as the length of the sequence\n"
message_input_array: .asciiz "please input an integer followed with a line breaker\n"
message_output_array: .asciiz "the sorted sequence is:\n"
space: .asciiz " "
stack: .space 100

.globl main
.text 

input:
    la $a0,message_input_n
    li $v0,4
    syscall

    li $v0,5
    syscall
    move $t0, $v0 
    li $t1, 0 
    
    for_1_begin:
    slt $t2, $t1, $t0
    beq $t2, $zero, for_1_end
    nop

    la $t2, array
    li $t3, 4
    mult $t3, $t1
    mflo $t3
    addu $t2, $t2, $t3

    la $a0,message_input_array
    li $v0,4
    syscall

    li $v0, 5
    syscall

    sw $v0, 0($t2)

    addi $t1, $t1, 1	
    j for_1_begin
    nop
    for_1_end:
    move $v0, $t0
    jr $ra
    nop


output:
    move $t0, $a0
    li $t1,0
    la $a0,message_output_array
    li $v0,4
    syscall

    for_2_begin:

    slt $t2, $t1, $t0
    beq $t2, $zero, for_2_end
    nop

    la $t2, array
    li $t3, 4
    mult $t3, $t1
    mflo $t3
    addu $t2, $t2, $t3

    lw $a0,0($t2)
    li $v0,1
    syscall

    la $a0,space
    li $v0,4
    syscall


    addi $t1, $t1, 1	
    j for_2_begin
    nop
    for_2_end:
    jr $ra
    nop
    
 # input and output is reliable   
    
sort:
    addiu $sp,$sp,-32
    move $t0,$a0
    
    li $t1,0
    for_4_begin:
    slt $t2, $t1, $t0
    beq $t2, $zero, for_4_end
    nop

    la $t2, array
    li $t3, 4
    mult $t1, $t3
    mflo $t3
    addu $t2, $t2, $t3

    move $a0, $t0
    move $a1, $t1

    sw $t2, 28($sp)
    sw $t1, 24($sp)
    sw $t0, 20($sp)
    sw $ra, 16($sp)

    jal findmin
    nop

    lw $ra, 16($sp)
    lw $t0, 20($sp)
    lw $t1, 24($sp)
    lw $t2, 28($sp)

    lw $t3, 0($v0)
    lw $t4, 0($t2)
    sw $t3, 0($t2)
    sw $t4, 0($v0)

    addi $t1,$t1,1
    j for_4_begin
    nop

    for_4_end:
    addiu $sp,$sp,32
    jr $ra
    nop



findmin:
    la $t0,array
    sll $a0,$a0,2
    subi $a0,$a0,4
    addu $t0,$t0,$a0

    lw $t1, 0($t0)
    move $t2,$t0

    move $t3,$t0
    la $t0,array
    sll $a1,$a1,2
    addu $t0,$t0,$a1

    for_3_begin:
    sge $t4,$t3,$t0
    beq $t4,$zero,for_3_end
    nop

    lw $t5,0($t3)

    slt $t6,$t5,$t1
    beq $t6,$zero,if_1_else
    nop
    move $t1,$t5
    move $t2,$t3
    j if_1_end
    nop

    if_1_else:
    
    if_1_end:
    
    
    subi $t3,$t3,4
    j for_3_begin
    nop

    for_3_end:
    move $v0,$t2
    jr $ra
    nop


main:
    la $sp, stack
    addiu $sp,$sp,100
    addiu $sp,$sp,-20

    jal input
    nop
    move $t0,$v0

    move $a0,$t0
    sw $t0, 16($sp)
    
    jal sort
    nop
    
    lw $t0,16($sp)
    move $a0,$t0
    
    jal output
    nop

    addiu $sp,$sp,20
    
    li $v0,10
    syscall
