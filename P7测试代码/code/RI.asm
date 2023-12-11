ori  $2, $0, 0xfa12
ori  $1, $0, 0xaaca

# Assume that these instructions are not implemented
slti  $3, $2, 0
nor   $3, $1, $2

beq $1, $1, end
nor   $1, $1, $1

slti  $3, $1, 0
beq $1, $1, end
slti  $3, $1, 0
end:

and $1, $2, 0xf77f

.ktext 0x00004180
mfc0  $k0, $12  # Status
mfc0  $k0, $13  # Cause
mfc0  $k0, $14  # EPC

ori  $k1, $0, 0xfffc
and   $k0, $k0, $k1
addi  $k0, $k0, 4
mtc0  $k0, $14
eret
