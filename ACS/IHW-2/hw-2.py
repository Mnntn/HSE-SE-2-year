import math

def compute_sin(x, epsilon=0.0005):
    term = x
    sin_x = term
    n = 1
    while abs(term) > epsilon:
        term *= -x * x / ((2 * n) * (2 * n + 1))
        sin_x += term
        n += 1
    return sin_x

def compute_cos(x, epsilon=0.0005):
    term = 1
    cos_x = term
    n = 1
    while abs(term) > epsilon:
        term *= -x * x / ((2 * n - 1) * (2 * n))
        cos_x += term
        n += 1
    return cos_x

def compute_tan(x, epsilon=0.0005):
    sin_x = compute_sin(x, epsilon)
    cos_x = compute_cos(x, epsilon)
    if abs(cos_x) < epsilon:
        raise ValueError("cos(x) is too close to zero, tan(x) is undefined")
    return sin_x / cos_x

# Заданные значения x
test_values = [0, math.pi/12, math.pi/6, math.pi/4, math.pi/3]

# Ожидаемые значения tan(x) (вычисленные с помощью math.tan)
expected_tan_values = [math.tan(x) for x in test_values]

# Вычисление и вывод результатов
for x, expected_tan in zip(test_values, expected_tan_values):
    try:
        computed_tan = compute_tan(x)
        if expected_tan == 0:
            delta_percent = abs(computed_tan - expected_tan) * 100  # Избегаем деления на 0
        else:
            delta_percent = abs(computed_tan - expected_tan) / expected_tan * 100
        print(f"tan({x:.6f}) = {computed_tan:.8f} expected tan(x) = {expected_tan:.8f} delta = {delta_percent:.8E}%")
    except ValueError as e:
        print(f"tan({x:.6f}) is undefined: {e}")
