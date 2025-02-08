.data 
n:          .word 0
array_A:    .space 40
array_B:    .space 40

prompt_start: .asciz "\nEnter your choice:\nEnter '0': input your array.\nEnter other number: launch autotests.\n\nYour choice: "
prompt_next: .asciz "If you want to finish program, enter '0' or press any other number to restart: "
sep:        .asciz " "
newline:    .asciz "\n"

.include "macros.asm"
.include "solution.asm"
.include "user.asm"
.include "tests.asm"

.text
.global main
main:
    li   a7, 4
    la   a0, prompt_start
    ecall
    li   a7, 5
    ecall
    beqz a0, your_array
    j    to_tests
your_array:
    call user_array
    call work
    li   a7, 4
    la   a0, prompt_next
    ecall
    li   a7, 5
    ecall
    beqz a0, end
    j    your_array
to_tests:
    call autotests
end:
    li   a7, 10
    ecall


