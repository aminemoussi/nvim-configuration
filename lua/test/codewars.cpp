#include <iostream>
#include <ostream>
#include <string>
#include <string_view>
#include <vector>

std::string result;
std::string curr_number = "";
int max, min, current;
bool first;

void next_number() {

  int current = std::stoi(curr_number);

  std::cout << "number made: " << current << std::endl;

  if (first) {
    max = current;
    min = current;
    first = false;
  } else if (current > max) {
    max = current;
  } else if (current < min) {
    min = current;
  }
  curr_number = "";
}

std::string highAndLow(const std::string &numbers) {
  result = "";
  first = true;
  const int size = numbers.size();

  for (int i = 0; i <= size; i++) {
    // std::cout << numbers[i] << std::endl;
    if (i == size) {
      next_number();
    } else if (numbers[i] != ' ') {
      curr_number += numbers[i];
    } else if (curr_number != "") {
      next_number();
    }
  }

  result = std::to_string(max) + " " + std::to_string(min);

  // std::cout << curr_number;
  return result; // Do your magic!
}

int main() {

  std::string tst = "8 3 -5 42 -1 0 0 -9 4 7 4 -4";

  std::string rs = highAndLow(tst);
  std::cout << rs << std::endl;

  tst = "1 2 3";

  rs = highAndLow(tst);
  std::cout << rs << std::endl;

  return 0;
}
