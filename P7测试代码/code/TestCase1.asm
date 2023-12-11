ori $s7, $0, 10
ori $s5, $0, 0x3060
# SR
ori $1, 0x1401  # IM: 000101
mtc0 $1, $12

# Timer 1
ori $1, $0, 7
sw  $1, 0x7F04($0)
ori $1, $0, 11     # Mode 1
sw  $1, 0x7F00($0)

# Timer 2 (Rejected by SR)
ori $1, $0, 2
sw  $1, 0x7F14($0)
ori $1, $0, 11     # Mode 1
sw  $1, 0x7F10($0)

lui $s2, 0x3344
lui $s3, 0x1344

# Loop
ori $1, $0, 50
loop: 
slt $2, $0, $1

ori $5, $0, 10
sw  $5, 0x7F00($0)

add $s1, $s1, $s2

ori $5, $0, 11
sw  $5, 0x7F00($0)

sub $1, $1, $2
bne $2, $0, loop
add $s1, $s1, $s3

_e:
beq $0, $0, _e
nop

.ktext 0x4180
mfc0  $k0, $12  # Status
mfc0  $k0, $13  # Cause
mfc0  $k0, $14  # EPC

ori  $k1, $0, 0xfffc
and   $k0, $k0, $k1
addi  $k0, $k0, 4
mtc0  $k0, $14
ori   $s0, $0, 0x00c1

addi  $s6, $s6, 1
slt   $k1, $s5, $k0
bne   $k1, $0, quit
nop
beq   $s6, $s7, quit
nop

eret

quit:
add $k0, $0, $s5
mtc0  $k0, $14
eret
