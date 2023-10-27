#求前12个fibonacci数
.data
fibs: .space 48 # array of 12 words to contain fib values
size: .word 12  # size of array
space: .asciiz " " # space to insert between numbers
head: .asciiz "The Fibonacci numbers are:\n"

.macro done (%reg, %num) #程序结束宏 在有些条件下是输出宏
  li %reg, %num
  syscall
.end_macroS

# la load address
.text
#在这一段中涉及到寄存器的两个用法，存数字还是存地址
la $t0, fibs  #load address of array 存储地址
la $t5, size  #load address of size variable 存储地址
lw $t5, 0($t5)#从t5存储的地址中读取一个字节
li $t2, 1     #f[0]=f[1]=1
sw $t2, 0($t0)#向t0存储的内存中写入t2存储的数
sw $t2, 4($t0)#这里的0/4都是偏移到了元素的首地址
addi $t1, $t5, -2 #保存需要计算的fibonacci的个数

loop:
lw $t3, 0($t0) # t3=F[n]
lw $t4, 4($t0) # t4=F[n+1]
add $t2, $t3, $t4 # t2=F[n]+F[n+1]
sw $t2, 8($t0)   # F[n+2] = t2
addi $t0, $t0, 4 #base address + 4
addi $t1, $t1, -1 # need to be calculated -1
bgtz $t1,loop # if t1>0 loop
la $a0, fibs
add $a1, $zero, $t5
jal print
done($v0,10) #finish

print:
add $t0, $zero, $a0
add $t1, $zero, $a1
la $a0, head
done($v0,4) #输出 the fibonacci numbers are:
#无跳转时，标签之间是顺序运行 
out:
lw $a0, 0($t0)
done($v0,1)
la $a0,space
done($v0,4)
addi $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, out
jr $ra
