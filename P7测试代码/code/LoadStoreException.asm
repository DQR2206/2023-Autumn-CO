# Aligned Exception

ori  $1, $0, 3
lw   $1, -2($1)  # Exception
lh   $1, 2($1)   # Exception
sw   $1, 0($1)   # Exception
sh   $1, 4($1)   # Exception

# Range Exception

sw  $1, -7($1)   # Exception
sw  $1, 0x3000($0) # Code Modify, Exception
sb  $1, 0x2ffc($1) # Ok

sw  $1, 0x7F04($0)  # Ok
lh  $1, 0x7F04($0)  # Exception

sw  $0, 0x7F20($0)  # Int, Ok


# Exception in branch delay

jal end
lh  $1, 3($0)  # Exception

jal end
lw  $1, -1($0) # Exception

jal end
sw  $1, 0x7F18($1) # Exception

end:

ori $5, $0, 0xa119

.ktext 0x00004180
mfc0  $k0, $12  # Status
mfc0  $k0, $13  # Cause
mfc0  $k0, $14  # EPC

addi  $k0, $k0, 4
mtc0  $k0, $14
eret
