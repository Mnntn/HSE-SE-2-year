.include "macros.asm"
.include "solution.asm"
.include "tests.asm"

.data
    prompt: .asciz "Enter 1 to run tests, 2 to enter your own value: "
    input_prompt: .asciz "Enter a value for x: "
    prompt_next: .asciz "If you want to finish program, enter '0' or press any other number to restart: "
    result_msg: .asciz "tan(x) = "

.text
.globl main
main:
    print_str(prompt)
    li a7, 5
    ecall
    li t0, 1
    beq a0, t0, run_tests
    li t0, 2
    beq a0, t0, user_input
    j main

user_input:
    print_str(input_prompt)
    input_float()
    call tan
    print_str(result_msg)
    print_float(fa0)
    print_newline()
    li   a7, 4
    la   a0, prompt_next
    ecall
    li   a7, 5
    ecall
    beqz a0, end
    j main
    
to_tests:
    call run_tests
end:
    li   a7, 10
    ecall
