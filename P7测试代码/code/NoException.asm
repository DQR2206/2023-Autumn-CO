
jal label1
add $4, $ra, $ra

and $ra, $ra, $4

label1:

lui $1, 0x7fff      # $ 1 0x7fff_0000
ori $2, $1, 0xfffe  # $ 2 0x7fff_fffe
sub $1, $2, $1      # $ 1 0x0000_fffe
add $3, $1, $1      # $ 3 0x0001_????

ori $1, $0, 8
lw  $3, -8($1)
sw  $1, -8($1)
lw  $4, -8($1)
sw  $4, -4($4)

mult  $4, $4
mflo  $4
div   $2, $4
mfhi  $5
mflo  $6

mtc0  $5, $14  # Without any meaning, just write it!
mfc0  $4, $14

mthi  $4
mfhi  $3

beq   $3, $4, label2
mult  $3, $4
label2:

mflo  $5
sb    $5, 1($5)
lh    $4, 0($5)

beq   $4, $5, label1
mtc0  $4, $14

jal   label3
mtc0  $ra, $14

label3:

mfc0  $5, $14

.ktext 0x4180
ori $1, $0, 0xdca2
