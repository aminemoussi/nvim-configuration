#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>
// #include <bits/stdc++.h>
using namespace std;

// #define CLAMP_VAL(var, max, min)                                               \
//   if (var > max) {                                                             \
//     var = max;                                                                 \
//   } else if (var < min) {                                                      \
//     var = min;                                                                 \
//   }
//
// #define DOUBLE_DIG(var) \
//   if (var.size() == 1) { \
//     var = "0" + var; \
//   }

// std::string word_found(std::string word) {
//   std::string new_w = "";
//   // new_w = word.substr(1, -1);
//   new_w = word.substr(1, word.size() - 1);
//   new_w += word.front();
//   new_w += "ay";
//   // std::cout << "new word: " << new_w << std::endl;
//   return new_w;
// }

int solution(int number) {

  int result = 0;

  if (number <= 0) {
    return result;
  } else {

    for (int i = 0; i < number; i++) {
      if (((i % 3) == 0) or ((i % 5) == 0)) {
        std::cout << "Number found: " << i << std::endl;
        result += i;
      }
    }
    return result;
  }
}

int main() {

  std::cout << solution(10) << std::endl;

  // std::cout << (15 % 3) << std::endl;

  return 0;
}
