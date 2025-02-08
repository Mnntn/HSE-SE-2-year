.text
autotests:
    addi sp, sp, -4
    sw   ra, (sp)

    call store_test_1
    print_array(array_A, n)
    call work

    call store_test_2
    print_array(array_A, n)
    call work

    call store_test_3
    print_array(array_A, n)
    call work

    call store_test_4
    print_array(array_A, n)
    call work

    call store_test_5
    print_array(array_A, n)
    call work

    call store_test_6
    print_array(array_A, n)
    call work

    call store_test_7
    print_array(array_A, n)
    call work

    lw   ra, (sp)
    addi sp, sp, 4
    ret

#test 1 all positive
store_test_1:
    la   t0, array_A
    li   t1, 2
    sw   t1, 0(t0)
    li   t1, 3
    sw   t1, 4(t0)
    li   t1, 7
    sw   t1, 8(t0)
    la   t0, n
    li   t1, 3
    sw   t1, (t0)
    ret
#test 2 all neg
store_test_2:
    la   t0, array_A
    li   t1, -2
    sw   t1, 0(t0)
    li   t1, -3
    sw   t1, 4(t0)
    li   t1, -1
    sw   t1, 8(t0)
    la   t0, n
    li   t1, 3
    sw   t1, (t0)
    ret
#test 3 all zero
store_test_3:
    la   t0, array_A
    sw   zero, 0(t0)
    sw   zero, 4(t0)
    sw   zero, 8(t0)
    la   t0, n
    li   t1, 3
    sw   t1, (t0)
    ret
#test 4 zero,neg,pos
store_test_4:
    la   t0, array_A
    li   t1, -4
    sw   t1, 0(t0)
    li   t1, 5
    sw   t1, 4(t0)
    sw   zero, 8(t0)
    li   t1, -5
    sw   t1, 12(t0)
    li   t1, 52
    sw   t1, 16(t0)
    la   t0, n
    li   t1, 5
    sw   t1, (t0)
    ret
#test 5 pos,neg
store_test_5:
    la   t0, array_A
    sw   zero, 0(t0)
    li   t1, 1
    sw   t1, 4(t0)
    li   t1, 234
    sw   t1, 8(t0)
    sw   zero, 12(t0)
    la   t0, n
    li   t1, 4
    sw   t1, (t0)
    ret
#test 6 zero, pos
store_test_6:
    la   t0, array_A
    sw   zero, 0(t0)
    li   t1, -1
    sw   t1, 4(t0)
    li   t1, -234
    sw   t1, 8(t0)
    sw   zero, 12(t0)
    la   t0, n
    li   t1, 4
    sw   t1, (t0)
    ret
#test 7 zero,neg
store_test_7:
    la   t0, array_A
    li   t1, -123
    sw   t1, 0(t0)
    li   t1, 1
    sw   t1, 4(t0)
    li   t1, 234
    sw   t1, 8(t0)
    li   t1, -5
    sw   t1, 12(t0)
    la   t0, n
    li   t1, 4
    sw   t1, (t0)
    ret
