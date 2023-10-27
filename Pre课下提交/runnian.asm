.data
.text
li $v0, 5
syscall
move $t7,$v0

li $t0, 4
li $t1,100
li $t2 400

div $t7,$t0  # %4
mfhi $t3

div $t7,$t1  # %100
mfhi $t4

div $t7,$t2  # %400
mfhi $t5

bne $t3,$zero,if_1_else
beq $t4,$zero,if_2_else
li $a0,1
li $v0,1
syscall
j if_1_end

if_2_else:
bne $t5,$zero,if_2_2_else
li $a0,1
li $v0,1
syscall
j if_1_end

if_2_2_else:
li $a0,0
li $v0,1
syscall
j if_1_end

if_1_else:
li $a0,0
li $v0,1
syscall

if_1_end:
li $v0,10
syscall