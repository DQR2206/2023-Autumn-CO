.data
str:.space 1024
rev_str : .space 1024

.text
li $v0,5
syscall
move $t0,$v0
move $t1,$zero  # i

loop:
beq $t1,$t0,loop_end
li $v0,12
syscall
sb $v0,str($t1)
addi $t1,$t1,1
j loop

loop_end:
move $t1,$zero

loop_2:
beq $t1,$t0,compare
lb $a0,str($t1)
sub $t2,$t0,$t1
addi $t2,$t2,-1
sb $a0,rev_str($t2)
addi $t1,$t1,1
j loop_2

compare:
move $t1,$zero
loop_3:
beq $t1,$t0,success
lb $t2,str($t1)
lb $t3,rev_str($t1)
beq $t2,$t3,normal
j failed

normal:
addi $t1,$t1,1
j loop_3

failed:
li $v0,1
li $a0,0
syscall
li $v0,10
syscall

success:
li $v0,1
li $a0,1
syscall
li $v0,10
syscall


