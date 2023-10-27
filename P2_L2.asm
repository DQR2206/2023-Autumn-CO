.data
matrix1 : .space  256
matrix2 : .space  256
enter : .asciiz "\n"
space : .asciiz " "
str : .asciiz "The result is:"

.macro end
li $v0,10
syscall
.end_macro

.macro readinteger(%des)
li $v0,5
syscall
move %des,$v0
.end_macro

.macro printinteger(%src)
li $v0,1
move $a0,%src
syscall
.end_macro

.macro printstr(%src)
li $v0,4
la $a0,%src
syscall
.end_macro

.macro getMatrixIndex(%des,%i,%j)
multu %i,$s1
mflo %des
add %des,%des,%j
sll %des,%des,2
.end_macro

.text
readinteger($s0) # n
readinteger($s1) # m
move $t0,$zero
move $t1,$zero
loop_1:
beq $t0,$s0,loop_1_end
move $t1,$zero
loop_1_2:
beq $t1,$s1,loop_1_2_end
readinteger($t2)
getMatrixIndex($t3,$t0,$t1)
sw $t2,matrix1($t3)
addi $t1,$t1,1
j loop_1_2

loop_1_2_end:
addi $t0,$t0,1
j loop_1

loop_1_end:
move $t0,$zero
loop_2:
beq $t0,$s0,calculate
move $t1,$zero
loop_2_2:
beq $t1,$s1,loop_2_2_end
readinteger($t2)
getMatrixIndex($t3,$t0,$t1)
sw $t2,matrix2($t3)
addi $t1,$t1,1
j loop_2_2

loop_2_2_end:
addi $t0,$t0,1
j loop_2


calculate:
printstr(str)
printstr(enter)
move $t0,$zero
cal_loop:
beq $t0,$s1,program_end
move $t1,$zero
cal_loop_2:
beq $t1,$s0,cal_loop_2_end
getMatrixIndex($t2,$t1,$t0)
lw $t3,matrix1($t2)
lw $t4,matrix2($t2)
add $t5,$t3,$t4
printinteger($t5)
printstr(space)
addi $t1,$t1,1
j cal_loop_2

cal_loop_2_end:
printstr(enter)
addi $t0,$t0,1
j cal_loop

program_end:
end