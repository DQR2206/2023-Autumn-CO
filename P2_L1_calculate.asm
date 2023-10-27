.data
space : .asciiz " "
enter : .asciiz "\n"
str : .space 128
cnt : .space 128

.macro end
li $v0,10
syscall
.end_macro

.macro readchar(%des)
li $v0,12
syscall
move %des,$v0
.end_macro


.macro printchar(%src)
li $v0,11
move $a0,%src
syscall
.end_macro

.macro readinteger(%des)
li $v0,5
syscall
move %des,$v0
.end_macro

.macro printinteger(%src)
move $a0,%src
li $v0,1
syscall
.end_macro

.macro printstr(%src)
li $v0,4
la $a0,%src
syscall
.end_macro

.text
readinteger($s0) # n is $s0  pos is $s1
move $s1,$zero
move $t0,$zero
loop:
beq $t0,$s0,loop_end
readchar($t2)
move $t1,$zero
loop_2:
beq $t1,$s1,loop_2_end
lb $t3,str($t1)
beq $t3,$t2,addcnt
addi $t1,$t1,1
j loop_2

loop_2_end:
sll $t3,$t1,2
sb $t2,str($t1)
li $s3,1
sw $s3,cnt($t3)
addi $s1,$s1,1
addi $t0,$t0,1
j loop

addcnt:
sll $t3,$t1,2
lw $s2,cnt($t3)
addi $s2,$s2,1
sw $s2,cnt($t3)
addi $t0,$t0,1
j loop

loop_end:
move $t0,$zero
print_loop:
beq $t0,$s1,program_end
sll $t1,$t0,2
lb $t2,str($t0)
printchar($t2)
printstr(space)
lw $t3,cnt($t1)
printinteger($t3)
printstr(enter)
addi $t0,$t0,1
j print_loop

program_end:
end