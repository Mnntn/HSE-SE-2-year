.macro get_size(%x)
    # Message for input array size
    li   a7, 4
    la   a0, prompt_size
    ecall
    # Read number
    li   a7, 5
    ecall
    # Set number to register %x
    mv   %x, a0
.end_macro

.macro check_size(%x)
    # Boundary values of array size
    li   t0, 1
    li   t1, 10
    # Checking
    blt  a0, t0, error
    bgt  a0, t1, error
    # Set 1 (true), if size is correct
    li   %x, 1
    j    end_check
error:
    # Message that the array size is incorrect
    li   a7, 4
    la   a0, prompt_er_size
    ecall
    # Set 0 (false), if size is incorrect
    li   %x, 0
end_check:
.end_macro

.macro add_element(%x)
    # Message for enter of element
    li   a7, 4
    la   a0, prompt_element
    ecall
    # Read element
    li   a7, 5
    ecall
    # Set element to register %x
    mv   %x, a0
.end_macro

.macro print_element(%x)
    # Print element
    li   a7, 1
    lw   a0, (%x)
    ecall
    # Print space after element
    li   a7, 4
    la   a0, sep
    ecall
.end_macro

.macro print_array(%array, %size)
    # Set a beginning of array and array size to register t0 and t3
    la   t0, %array
    li   t2, 0    # Counter of elements
    lw   t3, %size
print_el:
    beq  t2, t3, end
    # Print element
    print_element(t0)
    # Go to the next element
    addi t0, t0, 4
    addi t2, t2, 1
    j    print_el
end:
    # Print new line after array
    li   a7, 4
    la   a0, newline
    ecall
.end_macro
