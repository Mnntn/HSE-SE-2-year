.data
    test_x1: .float 0.785398  # x = π/4, tan(π/4) = 1
    expected_tan1: .float 1.0
    test_x2: .float 0.523599  # x = π/6, tan(π/6) ≈ 0.57735
    expected_tan2: .float 0.57735
    test_x3: .float 1.0472    # x = π/3, tan(π/3) ≈ 1.73205
    expected_tan3: .float 1.73205
    test_x4: .float 0.0       # x = 0, tan(0) = 0
    expected_tan4: .float 0.0
    test_x5: .float 0.261799  # x = π/12, tan(π/12) ≈ 0.267949
    expected_tan5: .float 0.267949

.text
.globl run_tests
run_tests:
    # Test 1: x = π/4
    la t6, test_x1
    flw fa0, 0(t6)
    call tan
    la t6, expected_tan1
    flw ft0, 0(t6)
    print_test_result(fa0, ft0)
    
     # Test 2: x = π/6
    la t6, test_x2
    flw fa0, 0(t6)
    call tan
    la t6, expected_tan2
    flw ft0, 0(t6)
    print_test_result(fa0, ft0)

    # Test 3: x = π/3
    la t6, test_x3
    flw fa0, 0(t6)
    call tan
    la t6, expected_tan3
    flw ft0, 0(t6)
    print_test_result(fa0, ft0)

    # Test 4: x = 0
    la t6, test_x4
    flw fa0, 0(t6)
    call tan
    la t6, expected_tan5
    flw ft0, 0(t6)
    print_test_result(fa0, ft0)

    # Test 5: x = π/12
    la t6, test_x5
    flw fa0, 0(t6)
    call tan
    la t6, expected_tan5
    flw ft0, 0(t6)
    print_test_result(fa0, ft0)

    # All test passed
    print_pass_msg()
    li   a7, 4
    la   a0, prompt_next
    ecall
    li   a7, 5
    ecall
    beqz a0, end
    j main
