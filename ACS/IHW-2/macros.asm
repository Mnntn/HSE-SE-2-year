.data
    pass_msg: .asciz "All tests passed!\n"
    fail_msg: .asciz "Test failed!\n"
    newline: .asciz "\n"
    tan_msg: .asciz "tan(x) = "
    expected_msg: .asciz " expected tan(x) = "
    delta_msg: .asciz " delta = "
    percent_msg: .asciz "%\n"

.text
# Macro for printing a string
.macro print_str(%str)
    li a7, 4
    la a0, %str
    ecall
.end_macro

# Macro for reading a floating-point number
.macro input_float()
    li a7, 6
    ecall
.end_macro

# Macro for printing a floating-point number
.macro print_float(%reg)
    fmv.s fa0, %reg
    li a7, 2
    ecall
.end_macro

# Macro for printing a success message
.macro print_pass_msg()
    li a7, 4
    la a0, pass_msg
    ecall
.end_macro

# Macro for printing a failure message
.macro print_fail_msg()
    li a7, 4
    la a0, fail_msg
    ecall
.end_macro

# Macro for printing a newline
.macro print_newline()
    li a7, 4
    la a0, newline
    ecall
.end_macro

# Macro for printing the test result
# Input: %tan_result = computed tan(x), %expected = expected value
.macro print_test_result(%tan_result, %expected)
    # Save registers
    addi sp, sp, -16
    fsw fs0, 0(sp)
    fsw fs1, 4(sp)
    fsw fs2, 8(sp)
    sw ra, 12(sp)

    # Load values
    fmv.s fs0, %tan_result  # fs0 = tan(x)
    fmv.s fs1, %expected    # fs1 = expected tan(x)

    # Compute delta = |tan(x) - expected| / expected * 100
    fsub.s ft0, fs0, fs1    # ft0 = tan(x) - expected
    fabs.s ft0, ft0         # ft0 = |tan(x) - expected|
    fdiv.s ft0, ft0, fs1    # ft0 = |tan(x) - expected| / expected
    li t0, 100
    fcvt.s.w ft1, t0        # ft1 = 100.0
    fmul.s ft0, ft0, ft1    # ft0 = delta (in percentage)

    # Print result
    print_str(tan_msg)
    print_float(fs0)
    print_str(expected_msg)
    print_float(fs1)
    print_str(delta_msg)
    print_float(ft0)
    print_str(percent_msg)

    # Restore registers
    flw fs0, 0(sp)
    flw fs1, 4(sp)
    flw fs2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
.end_macro

