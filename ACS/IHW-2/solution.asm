.data
    epsilon: .float 0.00005 

.text
# function to compute sin(x)
# input: fa0 = x
# output: fa0 = sin(x)
sin:
    fmv.s fa1, fa0          # fa1 = x
    fmul.s ft0, fa1, fa1    # ft0 = x^2 (saving x² for multiplication)
    fmv.s fa3, fa1          # fa3 = sum (starting with x)
    fmv.s fa2, fa1          # fa2 = current term of the series (x)
    li t0, 1                # t0 = n (iteration number, starting from 1)
    li t1, -1               # t1 = sign of the next term (-1)

sin_loop:
    # computing the denominator (2n)(2n + 1)
    li t2, 2
    mul t3, t0, t2          # t3 = 2n
    addi t4, t3, 1          # t4 = 2n + 1
    mul t5, t3, t4          # t5 = (2n)(2n + 1)
    # converting the denominator to float
    fcvt.s.w ft1, t5        # ft1 = (2n)(2n + 1)
    # updating the current term: term = term * (-x²) / ((2n)(2n + 1))
    fmul.s fa2, fa2, ft0    # multiplying by x²
    fdiv.s fa2, fa2, ft1    # dividing by (2n)(2n + 1)
    fcvt.s.w ft2, t1        # ft2 = sign (-1 or 1)
    fmul.s fa2, fa2, ft2    # multiplying by sign
    # adding to the sum
    fadd.s fa3, fa3, fa2
    # preparing for the next iteration
    addi t0, t0, 1          # increasing n
    # precision check
    fabs.s ft3, fa2         # |current term|
    la t6, epsilon
    flw ft4, 0(t6)          # loading epsilon
    flt.s t6, ft3, ft4      # |current term| < epsilon?
    beqz t6, sin_loop       # if not, continue loop
    fmv.s fa0, fa3          # returning sum
    ret

# function to compute cos(x)
# input: fa0 = x
# output: fa0 = cos(x)
cos:
    #fmv.s fa1, fa0          # fa1 = x
    li t0, 1                # t0 = n (iteration number, starting from 1)
    li t1, -1               # t1 = sign of the next term (-1)
    fmul.s ft0, fa1, fa1    # ft0 = x^2 (saving x² for multiplication)
    fcvt.s.w fa3, t0        # fa3 = sum (starting with x)
    fcvt.s.w fa2, t0        # fa2 = current term of the series (x)
    
cos_loop:
    # computing the denominator (2n)(2n - 1)
    li t2, 2
    mul t3, t0, t2          # t3 = 2n
    addi t4, t3, -1         # t4 = 2n - 1
    mul t5, t3, t4          # t5 = (2n)(2n - 1)
    # converting the denominator to float
    fcvt.s.w ft1, t5        # ft1 = (2n)(2n - 1)
    # updating the current term: term = term * (-x²) / ((2n)(2n - 1))
    fmul.s fa2, fa2, ft0    # multiplying by x²
    fdiv.s fa2, fa2, ft1    # dividing by (2n)(2n - 1)
    fcvt.s.w ft2, t1        # ft2 = sign (-1 or 1)
    fmul.s fa2, fa2, ft2    # multiplying by sign
    # adding to the sum
    fadd.s fa3, fa3, fa2
    # preparing for the next iteration
    addi t0, t0, 1          # increasing n
    # precision check
    fabs.s ft3, fa2         # |current term|
    la t6, epsilon
    flw ft4, 0(t6)          # loading epsilon
    flt.s t6, ft3, ft4      # |current term| < epsilon?
    beqz t6, cos_loop       # if not, continue loop
    fmv.s fa0, fa3          # returning sum
    ret

# function to compute tan(x)
# input: fa0 = x
# output: fa0 = tan(x)
tan:
    addi sp, sp, -8         # allocating space in stack
    sw ra, 0(sp)            # saving ra
    call sin                # fa0 = sin(x)
    fmv.s fa4, fa0          # fa1 = sin(x)
    call cos                # fa0 = cos(x)
    fdiv.s fa0, fa4, fa0    # fa0 = sin(x) / cos(x)
    lw ra, 0(sp)            # restoring ra
    addi sp, sp, 8          # freeing stack
    ret

