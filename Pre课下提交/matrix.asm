.data
array: .space 10000
space: .asciiz " "
enter: .asciiz "\n"

.text
li $v0,5  # n
syscall
move $t0,$v0
addu $a1,$t0,$zero  # a1 is row_counter

li $v0,5 # m
syscall
move $t1,$v0
addu $a2,$t1,$zero # a2 is col_counter

add $a3,$a2,$zero           # calcultate row and col
li $t2,0  # i
mult $t0, $t1
mflo $t3  # m*n

input:
beq $t2, $t3, output

li $v0,5
syscall

sll $t4, $t2, 2
sw $v0, array($t4)
addi $t2, $t2, 1

j input


output:
beq $t3, $zero, output_end
beq $a3,$zero,if_1_else  # equals to 1 col ; row--
sll $t4,$t3,2
subi $t4,$t4,4
lw $t5, array($t4)
beq $t5,$zero,if_2_else

#
add $a0,$a1,$zero
li $v0,1
syscall

la $a0,space
li $v0,4
syscall

add $a0,$a3,$zero
li $v0,1
syscall

la $a0,space
li $v0,4
syscall

add $a0,$t5,$zero
li $v0,1
syscall

la $a0,enter
li $v0,4
syscall
#

subi $a3,$a3,1
subi $t3,$t3,1
j output


if_1_else:    # row--  col_reset
subi $a1,$a1,1
add $a3,$zero,$a2
j output


if_2_else:
subi $a3,$a3,1
subi $t3,$t3,1
j output



output_end:
li $v0,10
syscall





