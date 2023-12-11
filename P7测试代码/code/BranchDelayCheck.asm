# SR
ori $1, 0x1401  # IM: 000101
mtc0 $1, $12

lui $1, 0x7fff
ori $1, $1, 0xffff
sw  $1, 0($0)
lw  $2, 0($0)

jal end
add $ra, $ra, $2  # 301c, Interrupt, In BD

mthi $ra
mflo $ra

jal end
add $3, $2, $ra

ori $2, $0, 10
mult $ra, $2

bne $3, $ra end
mflo $3

end:

.ktext 0x00004180
mfc0  $k0, $12  # Status
mfc0  $k0, $13  # Cause
mfc0  $k0, $14  # EPC

ori  $k1, $0, 0xfffc
and   $k0, $k0, $k1
addi  $k0, $k0, 4
mtc0  $k0, $14

sb $0, 0x7F20($0)
eret
