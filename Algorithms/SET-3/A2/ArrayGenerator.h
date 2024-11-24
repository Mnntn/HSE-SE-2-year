#ifndef ARRAY_GENERATOR_H
#define ARRAY_GENERATOR_H

#include <vector>

class ArrayGenerator {
public:
    static std::vector<int> generateRandomArray(int size, int minValue, int maxValue);
    static std::vector<int> generateReverseSortedArray(int size);
    static std::vector<int> generateNearlySortedArray(int size);
};

#endif


