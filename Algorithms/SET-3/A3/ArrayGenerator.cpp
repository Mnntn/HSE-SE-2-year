#include "ArrayGenerator.h"
#include <random>
#include <algorithm>

std::vector<int> ArrayGenerator::generateRandomArray(int size, int minValue, int maxValue) {
    std::vector<int> arr(size);
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(minValue, maxValue);

    for (int i = 0; i < size; ++i) {
        arr[i] = dis(gen);
    }
    return arr;
}

std::vector<int> ArrayGenerator::generateReverseSortedArray(int size) {
    std::vector<int> arr(size);
    for (int i = 0; i < size; ++i) {
        arr[i] = size - i;
    }
    return arr;
}

std::vector<int> ArrayGenerator::generateNearlySortedArray(int size) {
    std::vector<int> arr(size);
    for (int i = 0; i < size; ++i) {
        arr[i] = i + 1;
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, size - 1);

    for (int i = 0; i < 10; ++i) { // Меняем 10 случайных пар элементов
        int a = dis(gen);
        int b = dis(gen);
        std::swap(arr[a], arr[b]);
    }

    return arr;
}

