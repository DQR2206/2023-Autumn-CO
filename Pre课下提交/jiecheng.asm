.macro end
    li      $v0, 10
    syscall
.end_macro

.macro getInt(%des)
    li      $v0, 5
    syscall
    move    %des, $v0
.end_macro

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro

.macro push(%src)
    sw      %src, 0($sp)
    subi    $sp, $sp, 4
.end_macro

.macro pop(%des)
    addi    $sp, $sp, 4
    lw      %des, 0($sp) 
.end_macro

.text
main:
    getInt($s0)
    
    move $a0, $s0
    jal  factorial
    move $s1, $v0

    printInt($s1)
    end

factorial:
    bne  $a0, 1, else
    li  $v0, 1
    j   exit  
    else:
    push($ra)
    push($a0)
    subi $a0,$a0,1
    jal  factorial
    pop($a0)
    pop($ra)
    mul  $v0,$a0,$v0
    exit:
    jr  $ra
