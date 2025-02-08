.data
b_size: .word 0

.text
work:
    addi sp, sp, -24
    sw   ra, 0(sp)
    sw   s0, 4(sp)
    sw   s1, 8(sp)
    sw   s2, 12(sp)
    sw   s3, 16(sp)
    sw   s4, 20(sp)

    # Compute 64-bit sum of A
    la   t0, array_A
    lw   s0, n           # s0 = N
    li   s1, 0           # sum_lo
    li   s2, 0           # sum_hi
    li   t1, 0           # i
sum_loop:
    beq  t1, s0, end_sum
    lw   a0, 0(t0)
    add  s1, s1, a0      # sum_lo += A[i]
    sltu t2, s1, a0      # carry out
    srai a1, a0, 31      # sign extend
    add  s2, s2, a1      # sum_hi += sign
    add  s2, s2, t2      # sum_hi += carry
    addi t0, t0, 4
    addi t1, t1, 1
    j    sum_loop
end_sum:

    # Find m
    la   t0, array_A
    lw   s0, n           # s0 = N
    li   t1, 0           # i = 0
    mv   s3, s0          # m = N initially
loop_find_m:
    bge  t1, s0, end_find_m
    lw   a0, 0(t0)
    mulh a1, a0, s0      # product_hi
    mul  a2, a0, s0      # product_lo
    bgt  a1, s2, found
    blt  a1, s2, next_i
    bgeu a2, s1, found   
next_i:
    addi t0, t0, 4
    addi t1, t1, 1
    j    loop_find_m
found:
    mv   s3, t1
end_find_m:

    # Cap m to N-1 if >= N
    lw   t0, n
    bge  s3, t0, cap_m
    j    no_cap
cap_m:
    addi s3, t0, -1
no_cap:

    # Create B
    la   t0, array_A
    la   t1, array_B
    li   t2, 0           # i = 0
    li   s4, 0           # sum
    mv   s5, s3          # m_val
create_B_loop:
    bgt  t2, s5, end_create_B
    lw   a0, 0(t0)       # A[i]
    add  a1, s4, a0      # new_sum
    # Check overflow
    srai t3, s4, 31      # sum_sign
    srai t4, a0, 31      # a0_sign
    srai t5, a1, 31      # new_sign
    xor  t6, t3, t4
    bnez t6, no_overflow
    xor  t6, t3, t5
    beqz t6, no_overflow
    li   a1, 0           # overflow
    sw   zero, 0(t1)
    j    update_sum
no_overflow:
    sw   a1, 0(t1)
update_sum:
    mv   s4, a1
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, 1
    j    create_B_loop
end_create_B:

    # Print B
    addi t0, s5, 1
    la   t1, b_size
    sw   t0, 0(t1)
    print_array(array_B, b_size)

    lw   ra, 0(sp)
    lw   s0, 4(sp)
    lw   s1, 8(sp)
    lw   s2, 12(sp)
    lw   s3, 16(sp)
    lw   s4, 20(sp)
    addi sp, sp, 24
    ret



