# SR
ori $1, 0x1401  # IM: 000101
mtc0 $1, $12

sw $1, 0($0)

lw $2, 0($0)
beq $2, $2, label  # pc: 3010, interruption!
add $2, $2, $2

label:

.ktext 0x4180
mfc0  $k0, $12  # Status
mfc0  $k0, $13  # Cause
mfc0  $k0, $14  # EPC

ori  $k1, $0, 0xfffc
and   $k0, $k0, $k1
addi  $k0, $k0, 4
mtc0  $k0, $14

sb $0, 0x7F20($0)
eret
