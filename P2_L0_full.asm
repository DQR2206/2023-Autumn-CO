.data
array : .space 1024
symbol : .space 1024
space : .asciiz " "
enter : .asciiz "\n"

.macro end
li $v0,10
syscall
.end_macro

.macro readinteger(%ans)
li $v0,5
syscall
move %ans,$v0
.end_macro

.macro printinteger(%ans)
li $v0,1
move $a0,%ans
syscall
.end_macro

.macro printspace
li $v0,4
la $a0,space
syscall
.end_macro

.macro printenter
li $v0,4
la $a0,enter
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
readinteger($s0)  # n
move $a0,$zero
jal FullArray
end


FullArray:     
bge	$a0, $s0, print_init
move $t0,$zero
loop:
beq $t0,$s0,end_loop
sll $t1,$t0,2
lw $t2,symbol($t1)
bne $t2,$zero,else
addi $t3,$t0,1
sll $s2,$a0,2
sw $t3,array($s2)
li $t4,1
sw $t4,symbol($t1)

push($ra)
push($t0)   
push($a0) 

addi $a0,$a0,1  
jal FullArray

pop($a0)
pop($t0)
pop($ra)

sll $t1,$t0,2
sw $zero,symbol($t1)

else:
addi $t0,$t0,1
j loop

end_loop:
jr $ra


print_init:
move $t0,$zero
print_loop:
beq $t0,$s0,print_loop_end
sll $t1,$t0,2
lw $t2,array($t1)
printinteger($t2)
printspace
addi $t0,$t0,1
j print_loop

print_loop_end:
printenter
jr $ra


