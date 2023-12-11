
# $1 => INT_MAX
lui $1, 0x7fff
ori $1, $1, 0xffff

# $2 => INT_MIN
lui $2, 0x8000

# $3 => -1
lui $3, 0xffff
ori $3, $3, 0xffff

# $5 => 1
ori $5, $0, 1

add $4, $3, $1  # Ok!
add $4, $2, $3  # Exception!
addi $4, $1, 1  # Exception!
sub $4, $2, $3  # Ok!
sub $4, $1, $3  # Exception!
sub $4, $2, $5  # Exception!

# Exception in branch delay
# According to the handler, may except twice

beq $3, $3, label1
add $4, $2, $2  # Exception!
label1:

beq $4, $2, label2
add $4, $2, $3  # Exception!
label2:

beq $4, $3, label3
sub $4, $3, $1
label3:

# Exception in load / store

sw  $4, 1($1)  # Exception!
sb  $4, 2($3)  # Ok!
lw  $4, -1($2) # Exception!

ori $4, $4, 0xad81

.ktext 0x4180
mfc0  $k0, $12  # Status
mfc0  $k0, $13  # Cause
mfc0  $k0, $14  # EPC

addi  $k0, $k0, 4
mtc0  $k0, $14
eret
