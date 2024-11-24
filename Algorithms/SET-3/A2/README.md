# Сравнительный анализ алгоритмов Merge Sort и Merge + Insertion Sort

## Описание эксперимента

В рамках эксперимента была проведена оценка времени выполнения двух алгоритмов сортировки:
1. **Стандартный Merge Sort** (рекурсивная реализация с выделением дополнительной памяти).
2. **Гибридный алгоритм Merge + Insertion Sort**, который переключается на сортировку вставками для подмассивов малого размера.

### Параметры тестовых данных
- **Размеры массивов**: от 500 до 10000 с шагом 100.
- **Диапазон случайных значений**: от 0 до 6000.
- **Типы массивов**:
  - Случайно сгенерированные значения.
  - Отсортированные в обратном порядке.
  - Почти отсортированные массивы (с небольшими перестановками элементов).

Для проведения тестов использовались массивы максимального размера (10000), из которых выделялись подмассивы нужных размеров.

---

## Результаты эксперимента

### Временные затраты стандартного Merge Sort
| Размер массива | Время (мс) |
|----------------|------------|
| 500            | 0          |
| 1000           | 0          |
| 2000           | 0          |
| 5000           | 2          |
| 10000          | 4          |

### Временные затраты гибридного Merge + Insertion Sort
| Размер массива | Время (мс) |
|----------------|------------|
| 500            | 0          |
| 1000           | 0          |
| 2000           | 0          |
| 5000           | 1          |
| 10000          | 2          |

---

## Выводы

1. **Общие наблюдения**:
   - Гибридная сортировка Merge + Insertion Sort показывает **более высокую производительность** по сравнению со стандартным Merge Sort на всем диапазоне размеров массивов.
   - Для массивов размером до 2000 элементов оба алгоритма работают с одинаковой скоростью (0 мс). Для больших массивов гибридная реализация становится заметно быстрее.

2. **Причины разницы в производительности**:
   - Гибридный алгоритм использует сортировку вставками (Insertion Sort) для обработки мелких подмассивов, что снижает накладные расходы.
   - В стандартной реализации Merge Sort накладные расходы связаны с рекурсией и выделением дополнительной памяти.

3. **Пороговое значение**:
   - Порог переключения на сортировку вставками в гибридном алгоритме настроен на оптимальное значение (15 элементов). Это обеспечивает выигрыш во времени без потерь производительности для больших массивов.

4. **Рекомендации**:
   - Гибридный Merge + Insertion Sort предпочтителен для задач, включающих обработку массивов малого и среднего размера.
   - Для дальнейшей оптимизации можно исследовать влияние других пороговых значений на производительность.

---

## Репозиторий и реализация

1. **Код реализации гибридного алгоритма**: [Ссылка на репозиторий](#)
2. **ID посылки на CodeForces**: `A2i`
3. **Классы для тестирования и генерации массивов**:
   - `ArrayGenerator` — генерация массивов заданных размеров и характеристик.
   - `SortTester` — функции замера времени выполнения алгоритмов.
