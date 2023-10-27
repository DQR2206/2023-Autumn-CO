.data
space : .asciiz " "
enter : .asciiz "\n"
matrix1 : .space 256
matrix2 : .space 256
result : .space 256

.text
li $v0,5 #read n
syscall
move $t0,$v0

move $s0,$zero # i
move $s1,$zero # j
move $s2,$zero

loop_1:
beq $s0,$t0,loop_1_end
move $s1,$zero # int j = 0;

loop_2:
beq $s1,$t0,loop_2_end
li $v0, 5 #read an integer
syscall
mult $s0,$t0
mflo $s2
add $s2,$s2,$s1 
sll $s2,$s2,2 
sw $v0,matrix1($s2)
addi $s1,$s1,1
j loop_2 

loop_2_end:
addi $s0,$s0,1
j loop_1

loop_1_end:
move $s0,$zero
move $s1,$zero
move $s2,$zero

loop_11:
beq $s0,$t0,calculate
move $s1,$zero 
loop_22:
beq $s1,$t0,loop_22_end
li $v0, 5 
syscall
mult $s0,$t0
mflo $s2 
add $s2,$s2,$s1 
sll $s2,$s2,2 
sw $v0,matrix2($s2)
addi $s1,$s1,1
j loop_22

loop_22_end:
addi $s0,$s0,1
j loop_11


calculate:
move $s0,$zero #i
move $s1,$zero #j
move $s2,$zero #k
cal_1:
beq $s0,$t0, end
move $s1,$zero
cal_2:
beq $s1,$t0,cal_2_end
move $s2,$zero
move $s3,$zero
move $s4,$zero
move $s5,$zero # sum
cal_3:
beq $s2,$t0,cal_3_end
#matrix1[i*n+k]
mult $s0,$t0
mflo $s3
add $s3,$s3,$s2
sll $s3,$s3,2
lw $a1,matrix1($s3)
#matrix2[k*n+j]
mult $s2,$t0
mflo $s4
add $s4,$s4,$s1
sll $s4,$s4,2
lw $a2,matrix2($s4)

mult $a1,$a2
mflo  $a0
add $s5,$s5,$a0
addi $s2,$s2,1 # k = k + 1
j cal_3

cal_2_end:
la $a0,enter
li $v0,4
syscall
addi $s0,$s0,1
j cal_1

cal_3_end:
move $a0,$s5
li $v0,1
syscall
la $a0,space
li $v0,4
syscall
addi $s1,$s1,1
j cal_2


end:
li $v0,10
syscall
