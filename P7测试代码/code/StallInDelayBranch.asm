# SR
ori $1, 0x1401  # IM: 000101
mtc0 $1, $12

ori  $1, $0, 0x0a12
ori  $2, $1, 0x00aa
div $1, $2

beq $1, $1, label1
mfhi $3  # PC: 3018, Interrupt!

label1:

ori $30, $0, 0xaffc

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
