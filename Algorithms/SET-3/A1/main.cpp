#include <iostream>
#include <cmath>
#include <cstdint> //For uint64_t
#include <fstream> // Для работы с файлами
#include <iomanip> // Для управления форматированием


// Constants (M_PI is defined in the question as it is not available by default on all platforms)
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

using namespace std;

//Structure for Circle
struct Circle {
    double x, y, r;
};

//is_circle_inside function
bool is_circle_inside(const Circle& c1, const Circle& c2) {
    double distance = sqrt(pow(c1.x - c2.x, 2) + pow(c1.y - c2.y, 2));
    return distance + c1.r <= c2.r;
}

//is_inside_circle function
bool is_inside_circle(double x, double y, const Circle& c) {
    return pow(x - c.x, 2) + pow(y - c.y, 2) <= c.r * c.r;
}

//Manual implementation of min and max for doubles
double min(double a, double b){ return a < b ? a : b;}
double max(double a, double b){ return a > b ? a : b;}
double min(double a, double b, double c){ return min(min(a,b),c);}
double max(double a, double b, double c){ return max(max(a,b),c);}


//Implementation of a simple pseudo random number generator (Mersenne Twister will need a full implementation)
uint64_t seed = 123456789;
double my_rand() {
  seed = seed * 1103515245 + 12345;
  return (double)seed / (double)UINT64_MAX;
}

double monte_carlo_intersection_area(const Circle& c1, const Circle& c2, const Circle& c3, int num_points) {
    if (is_circle_inside(c1, c2) && is_circle_inside(c1, c3)) return M_PI * c1.r * c1.r;
    if (is_circle_inside(c2, c1) && is_circle_inside(c2, c3)) return M_PI * c2.r * c2.r;
    if (is_circle_inside(c3, c1) && is_circle_inside(c3, c2)) return M_PI * c3.r * c3.r;

    double min_x = min(c1.x - c1.r, c2.x - c2.r, c3.x - c3.r);
    double max_x = max(c1.x + c1.r, c2.x + c2.r, c3.x + c3.r);
    double min_y = min(c1.y - c1.r, c2.y - c2.r, c3.y - c3.r);
    double max_y = max(c1.y + c1.r, c2.y + c2.r, c3.y + c3.r);

    int inside_count = 0;
    for (int i = 0; i < num_points; ++i) {
        double x = min_x + (max_x - min_x) * my_rand(); //Manual uniform distribution
        double y = min_y + (max_y - min_y) * my_rand(); //Manual uniform distribution
        if (is_inside_circle(x, y, c1) && is_inside_circle(x, y, c2) && is_inside_circle(x, y, c3)) {
            inside_count++;
        }
    }

    double bounding_box_area = (max_x - min_x) * (max_y - min_y);
    return bounding_box_area * (double)inside_count / num_points;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    Circle c1, c2, c3;
    c1.x = 1;
    c1.y = 1;
    c1.r = 1;
    c2.x = 1.5;
    c2.y = 2;
    c2.r = std::sqrt(5) / 2;
    c3.x = 2;
    c3.y = 1.5;
    c3.r = std::sqrt(5) / 2;

    ofstream output_file("results.csv"); // Создаем файл results.csv для записи

    if (!output_file.is_open()) {
        cerr << "Ошибка: не удалось открыть файл для записи!" << endl;
        return 1;
    }

    // Записываем заголовки в CSV
    output_file << "Число точек,Площадь\n";

    for (int num_points = 100; num_points <= 100000; num_points += 500) {
        double result = monte_carlo_intersection_area(c1, c2, c3, num_points);
        output_file << num_points << "," << fixed << setprecision(10) << result << "\n"; // Записываем в CSV
    }

    // Дополнительная запись для 100000 точек, если нужно
    output_file << 100000 << "," << fixed << setprecision(10)
                << monte_carlo_intersection_area(c1, c2, c3, 100000) << "\n";

    output_file.close(); // Закрываем файл
    cout << "Данные сохранены в файл results.csv" << endl;

    return 0;
}

