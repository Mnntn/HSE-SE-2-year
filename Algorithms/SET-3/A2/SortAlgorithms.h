#ifndef SORT_ALGORITHMS_H
#define SORT_ALGORITHMS_H

#include <vector>

// Стандартная сортировка слиянием
void mergeSort(std::vector<int>& arr, int left, int right);
void merge(std::vector<int>& arr, int left, int mid, int right);

// Гибридная сортировка слиянием и сортировкой вставками
void hybridMergeInsertionSort(std::vector<int>& arr, int left, int right);
void insertionSort(std::vector<int>& arr, int left, int right);

#endif

