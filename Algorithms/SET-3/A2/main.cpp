#include <iostream>
#include <vector>
#include <chrono>
#include "ArrayGenerator.h"
#include "SortAlgorithms.h"

void testMergeSort() {
    ArrayGenerator generator;
    int sizes[] = {500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500,
                   1600, 1700, 1800, 1900, 2000, 2500, 3000, 3500, 4000, 4500,
                   5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000};

    for (int size : sizes) {
        std::vector<int> arr = generator.generateRandomArray(size, 0, 6000);

        auto start = std::chrono::high_resolution_clock::now();
        mergeSort(arr, 0, size - 1);
        auto elapsed = std::chrono::high_resolution_clock::now() - start;
        long long msec = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();

        std::cout << "Merge Sort - Размер: " << size << " Время: " << msec << " мс\n";
    }
}

void testHybridMergeInsertionSort() {
    ArrayGenerator generator;
    int sizes[] = {500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500,
                   1600, 1700, 1800, 1900, 2000, 2500, 3000, 3500, 4000, 4500,
                   5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000};

    for (int size : sizes) {
        std::vector<int> arr = generator.generateRandomArray(size, 0, 6000);

        auto start = std::chrono::high_resolution_clock::now();
        hybridMergeInsertionSort(arr, 0, size - 1);
        auto elapsed = std::chrono::high_resolution_clock::now() - start;
        long long msec = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();

        std::cout << "Гибридная сортировка - Размер: " << size << " Время: " << msec << " мс\n";
    }
}

int main() {
    std::cout << "Тестирование стандартной сортировки Merge Sort:\n";
    testMergeSort();

    std::cout << "\nТестирование гибридной сортировки Merge + Insertion Sort:\n";
    testHybridMergeInsertionSort();

    return 0;
}


