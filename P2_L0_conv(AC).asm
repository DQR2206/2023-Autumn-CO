 .data
 arr1:    .word    0:101
 arr2:    .word    0:101
 arr3:    .word    0:101
 space:.asciiz " "
 line:    .asciiz "\n"
 
 .macro read (%ans)
 li $v0,5
 syscall
 move %ans,$v0
 .end_macro

 .macro end
 li $v0,10
 syscall
 .end_macro
 .text
    read($t0) # m1
    read($t1) # n1
    read($t2) # m2
    read($t3) # n2
    move   $s0,$zero
    move   $s1,$zero
    move   $s2,$zero   
 read1:
    read($t4)
    mult    $s0,$t1
    mflo    $s2
    add    $s2,$s2,$s1
    sll    $s2,$s2,2
    sw    $t4,arr1($s2)   
    addi    $s1,$s1,1
    bne    $s1,$t1,read1
     
    move   $s1,$zero
    addi   $s0,$s0,1
    bne    $s0,$t0,read1
     
     move    $s0,$0
     move    $s1,$0
     move    $s2,$0
 read2:mult    $s0,$t3
     mflo    $s2
     add    $s2,$s2,$s1
     read($t4)
     sll    $s2,$s2,2
     sw    $t4,arr2($s2)    #t4=b[j][j]
     
     addi    $s1,$s1,1
     bne    $s1,$t3,read2
     
     move    $s1,$0
     addi    $s0,$s0,1
     bne    $s0,$t2,read2
     
     sub    $t4,$t0,$t2
     addi    $t4,$t4,1    #t4=m1-m2+1
     sub    $t5,$t1,$t3
     addi    $t5,$t5,1    #t5=n1-n2+1
     
     move    $s0,$0    #s0=i
 for_begin1:
     beq    $s0,$t4,for_end1
     
     move    $s1,$0    #s1=j
     for_begin2:
         beq    $s1,$t5,for_end2
         move     $s2,$0    #s2=temp
         
         move    $s3,$0    #s3=m
         for_begin3:
             beq    $s3,$t2,for_end3
         
                 move    $s4,$0    #s4=n
                 for_begin4:
                      beq    $s4,$t3,for_end4
                     add    $t6,$s0,$s3    #t6=i+m
                     slt    $s5,$t6,$t0
                     beq    $s5,$0,if_end
                   add    $t7,$s1,$s4    #t7=j+n
                    slt    $s5,$t7,$t1
                     beq    $s5,$0,if_end
                     
                    mult    $t6,$t1
                     mflo    $s5
                    add    $s5,$s5,$t7
                     sll    $s5,$s5,2
                     lw    $s6,arr1($s5)    #s6=a[i+m][j+n]
                     
                      mult    $s3,$t3
                     mflo    $s5
                      add    $s5,$s5,$s4
                    sll    $s5,$s5,2
                     lw    $s7,arr2($s5)    #s7=b[m][n]
                     
                     mult    $s6,$s7
                     mflo    $s5
                     add    $s2,$s2,$s5        
             
                if_end:
                     addi    $s4,$s4,1
                     j    for_begin4
                 for_end4:
                     mult    $s0,$t5
                     mflo    $s5
                     add    $s5,$s5,$s1
                     sll    $s5,$s5,2
                     sw    $s2,arr3($s5)    #c[i][j]=temp
         
             addi    $s3,$s3,1
             j    for_begin3
         for_end3:
             nop
         
         addi    $s1,$s1,1
         j    for_begin2
     for_end2:
         nop
     addi    $s0,$s0,1
     j    for_begin1
 for_end1:
     nop
     
     move    $s0,$0
 for_begin5:
    beq    $s0,$t4,for_end5
     
     move    $s1,$0
     for_begin6:
         beq    $s1,$t5,for_end6
         
         mult    $s0,$t5
         mflo    $s2
         add    $s2,$s2,$s1
         sll    $s2,$s2,2
         lw    $a0,arr3($s2)
         li    $v0,1
         syscall
         la    $a0,space
         li    $v0,4
         syscall    
         
         addi    $s1,$s1,1
         j    for_begin6
     for_end6:
         la    $a0,line
         li    $v0,4
         syscall
         
     addi    $s0,$s0,1
     j    for_begin5
 for_end5:
    end