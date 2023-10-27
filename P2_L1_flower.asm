.data
enter : .asciiz "\n"

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

.macro end
li $v0,10
syscall
.end_macro

.macro printstr(%src)
la $a0,%src
li $v0,4
syscall
.end_macro

.text
readinteger($s0)  #m
readinteger($s1)  #n
move $t0,$s0
li $s2,10
li $s3,100
loop:
beq $t0,$s1,loop_end
div $t0,$s3
mflo $t1
div $t0,$s2
mfhi $t2
mflo $t3
div $t3,$s2
mfhi $t3
mul $t4,$t1,$t1
mul $t4,$t4,$t1
mul $t5,$t2,$t2
mul $t5,$t5,$t2
mul $t6,$t3,$t3
mul $t6,$t6,$t3
add $t7,$t4,$t5
add $t7,$t7,$t6
bne $t0,$t7,else
printinteger($t0)
printstr(enter)

else:
addi $t0,$t0,1
j loop

loop_end:
end

# 从这道题我们可以知道MIPS中没有单独的取模的指令
# 乘法 mult 除法div 加法add 除法 sub 与and 或or
# 其中 乘法默认取低32位，因为一般不会超过32位
# 除法中，商存在lo,余数存在hi,做除法之后mfhi就相当于做了取模运算