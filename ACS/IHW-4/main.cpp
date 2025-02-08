#include <iostream>
#include <fstream>
#include <thread>
#include <vector>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <string>
#include <cstdlib>
#include <ctime>
#include <climits>
#include <atomic>
#include <sstream>

// Глобальные переменные
int fieldHeight, fieldWidth, people;
std::vector<std::string> island;
std::mutex mtx, coutMtx;
std::condition_variable cv, group_cv;
std::queue<int> tasksQueue;
std::vector<int> tasks;
bool found = false;
int treasureNumber;
std::vector<int> groups;
std::atomic<int> activeGroup{1}; // Указывает, какая группа сейчас должна работать

void outIsland(std::ostream& os) {
    os << "Остров:\n";
    for (int i = 0; i < fieldHeight; i++) {
        for (int j = 0; j < fieldWidth; j++) {
            os << island[i * fieldWidth + j] << " ";
        }
        os << std::endl;
    }
}

void groupFunction(int id, int members, std::ofstream& out) {
    while (true) {
        std::unique_lock<std::mutex> lock(mtx);
        cv.wait(lock, [id] { return tasks[id] != -1 || found; });

        if (found) return;  // Завершаем работу потока, если клад уже найден

        int task = tasks[id];
        tasks[id] = -1;
        lock.unlock();

        {
            std::lock_guard<std::mutex> lock(coutMtx);
            std::cout << "Группа " << id << " начала обследовать ячейку " << task << std::endl;
            out << "Группа " << id << " начала обследовать ячейку " << task << std::endl;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(5000 / members)); // Имитация работы

        if (task == treasureNumber) {
            island[task] = "X";

            {
                std::lock_guard<std::mutex> lock(coutMtx);
                std::cout << "Группа " << id << " нашла клад в ячейке " << task << "!\n";
                out << "Группа " << id << " нашла клад в ячейке " << task << "!\n";
                outIsland(std::cout);
                outIsland(out);
            }

            std::lock_guard<std::mutex> lock(mtx);
            found = true;
            cv.notify_all();
            return;
        }

        island[task] = "O";

        {
            std::lock_guard<std::mutex> lock(coutMtx);
            std::cout << "Группа " << id << " закончила обследование ячейки " << task << std::endl;
            out << "Группа " << id << " закончила обследование ячейки " << task << std::endl;
            outIsland(std::cout);
            outIsland(out);
        }

        std::lock_guard<std::mutex> lock2(mtx);
        tasksQueue.push(id);
        cv.notify_all();
    }
}

bool loadConfig(const std::string& filename) {
    std::ifstream file(filename);
    if (!file) {
        std::cerr << "Ошибка: не удалось открыть файл конфигурации " << filename << "\n";
        return false;
    }

    std::string line;
    if (std::getline(file, line)) {
        std::istringstream iss(line);
        if (!(iss >> fieldHeight >> fieldWidth >> people)) {
            std::cerr << "Ошибка: неверный формат данных в конфигурационном файле.\n";
            return false;
        }
        if (fieldHeight <= 0 || fieldWidth <= 0 || people <= 0) {
            std::cerr << "Ошибка: параметры должны быть положительными числами.\n";
            return false;
        }
    } else {
        std::cerr << "Ошибка: файл конфигурации пуст.\n";
        return false;
    }

    return true;
}

int main(int argc, char* argv[]) {
    setlocale(LC_ALL, "rus");
    std::srand(std::time(0));

    if (argc < 3) {
        std::cerr << "Использование: " << argv[0] << " <выходной_файл> [-f <конфигурационный_файл> | <высота> <ширина> <пираты>]\n";
        return 1;
    }

    std::ofstream out(argv[1]);
    if (!out) {
        std::cerr << "Ошибка открытия выходного файла.\n";
        return 1;
    }

    if (std::string(argv[2]) == "-f") {
        if (argc < 4) {
            std::cerr << "Ошибка: необходимо указать путь к конфигурационному файлу после `-f`.\n";
            return 1;
        }
        if (!loadConfig(argv[3])) {
            return 1;
        }
    } else {
        try {
            fieldHeight = std::stoi(argv[2]);
            fieldWidth = std::stoi(argv[3]);
            people = std::stoi(argv[4]);
            if (fieldHeight <= 0 || fieldWidth <= 0 || people <= 0) {
                std::cerr << "Ошибка: параметры должны быть положительными числами.\n";
                return 1;
            }
        } catch (const std::exception& e) {
            std::cerr << "Ошибка: Невозможно преобразовать аргумент в число.\n";
            return 1;
        }
    }

    groups.push_back(0);
    tasks.push_back(0);
    island.resize(fieldHeight * fieldWidth, "_");
    outIsland(std::cout);
    outIsland(out);

    treasureNumber = std::rand() % (fieldHeight * fieldWidth);

    int freePeople = people;
    for (int i = 1; freePeople > 0; i++) {
        std::cout << "Введите число пиратов в группе " << i << ": ";
        int count;
        while (true) {
            std::cin >> count;
            if (std::cin.fail() || count <= 0 || count > freePeople) {
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                std::cout << "Некорректный ввод. Введите положительное число, не превышающее " << freePeople << ".\n";
            } else {
                break;
            }
        }
        groups.push_back(count);
        freePeople -= count;
    }

    std::vector<std::thread> threads;
    for (size_t i = 1; i < groups.size(); i++) {
        threads.emplace_back(groupFunction, i, groups[i], std::ref(out));
        tasks.push_back(-1);
        tasksQueue.push(i);
    }

    for (int i = 0; i <= fieldHeight * fieldWidth; i++) {
        std::unique_lock<std::mutex> lock(mtx);
        cv.wait(lock, [] { return !tasksQueue.empty() || found; });

        if (found)
            break;

        int threadId = tasksQueue.front();
        tasksQueue.pop();
        tasks[threadId] = i;

        {
            std::lock_guard<std::mutex> coutLock(coutMtx);
            std::cout << "Команде " << threadId << " назначено задание в ячейке " << i << std::endl;
            out << "Команде " << threadId << " назначено задание в ячейке " << i << std::endl;
        }

        cv.notify_all();
        group_cv.notify_all(); // Активируем потоки
    }

    {
        std::lock_guard<std::mutex> lock(mtx);
        found = true;
        cv.notify_all();
    }

    for (auto& t : threads) {
        if (t.joinable()) {
            t.join();
        }
    }

    out.close();
    return 0;
}
