.data
G : .space 1024
book : .space 32

.macro readinteger(%des)
li $v0,5
syscall
move %des,$v0
.end_macro

.macro matrixGetIndex(%des,%i,%j)
multu %i,$s1
mflo %des
add %des,%des,%j
sll %des,%des,2
.end_macro

.macro vectorGetIndex(%des,%i)
sll %des,%i,2
.end_macro

.macro printinteger(%src)
li $v0,1
move $a0,%src
syscall
.end_macro

.macro  end
li $v0,10
syscall
.end_macro


.macro push(%src)
sw %src,0($sp)
subi $sp,$sp,4
.end_macro

.macro pop(%des)
addi $sp,$sp,4
lw %des,0($sp)
.end_macro

.text
main:
readinteger($s0) # n
readinteger($s1) # m
move $t0,$zero
loop:
beq $t0,$s1,loop_end
readinteger($t2)  #x
readinteger($t3)  #y
subi $t2,$t2,1
subi $t3,$t3,1
li $t4,1
matrixGetIndex($t5,$t2,$t3)
sw $t4,G($t5)
matrixGetIndex($t5,$t3,$t2)
sw $t4,G($t5)
addi $t0,$t0,1
j loop

loop_end:
move $a0,$zero  
jal dfs
printinteger($v1)
end

# $a0 is x
# $t1 is 1
dfs:
vectorGetIndex($t0,$a0)
li $t1,1
sw $t1,book($t0)
move $t2,$t1 #  $t2 is flag
move $t0,$zero
dfs_loop:
beq $t0,$s0,end_dfs_loop
vectorGetIndex($t3,$t0)
lw $t4,book($t3)
and $t2,$t2,$t4
addi $t0,$t0,1
j dfs_loop

end_dfs_loop:
matrixGetIndex($t3,$a0,$zero)
lw $t4,G($t3)
and $t5,$t2,$t4
beq $t5,$t1,exit
move $t0,$zero
dfs_loop_2:
beq $t0,$s0,dfs_loop_2_end
vectorGetIndex($t2,$t0)
lw $t3,book($t2)
matrixGetIndex($t2,$a0,$t0)
lw $t4,G($t2)
seq $t3,$t3,$zero
and $t5,$t3,$t4
beq $t5,$t1,if_
addi $t0,$t0,1
j dfs_loop_2

dfs_loop_2_end:
sll $t8,$a0,2
sw $zero,book($t8)
jr $ra

if_:
push($a0)
push($ra)
push($t0)
move $a0,$t0
jal dfs
pop($t0)
pop($ra)
pop($a0)
addi $t0,$t0,1
j dfs_loop_2

exit:
li $v1,1
jr $ra