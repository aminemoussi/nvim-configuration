#include <bits/stdc++.h>
#include <cassert>
#include <cctype>
#include <iostream>
#include <ostream>
#include <stdio.h>
#include <string>
#include <string_view>
#include <vector>

// std::string result;
// std::string curr_number = "";
// int max, min, current;
// bool first;

// void next_number() {
//
//   int current = std::stoi(curr_number);
//
//   std::cout << "number made: " << current << std::endl;
//
//   if (first) {
//     max = current;
//     min = current;
//     first = false;
//   } else if (current > max) {
//     max = current;
//   } else if (current < min) {
//     min = current;
//   }
//   curr_number = "";
// }

// std::string highAndLow(const std::string &numbers) {
//   result = "";
//   first = true;
//   const int size = numbers.size();
//
//   for (int i = 0; i <= size; i++) {
//     // std::cout << numbers[i] << std::endl;
//     if (i == size) {
//       next_number();
//     } else if (numbers[i] != ' ') {
//       curr_number += numbers[i];
//     } else if (curr_number != "") {
//       next_number();
//     }
//   }
//
//   result = std::to_string(max) + " " + std::to_string(min);
//
//   // std::cout << curr_number;
//   return result; // Do your magic!
// }

std::string duplicate_encoder(const std::string &word) {
  std::string result = "";
  int size = word.size();

  for (int i = 0; i < size; i++) {
    char x = (char)tolower(word[i]);
    int position = word.find(word[i]);
    // std::string w = tolower(word[i]);
    std::cout << word[i] << " lowered: " << x << " at " << position
              << std::endl;

    std::string left = word.substr(0, i);
    std::string right = word.substr(i + 1, size - i);

    std::transform(left.begin(), left.end(), left.begin(),
                   [](unsigned char c) { return std::tolower(c); });
    std::transform(right.begin(), right.end(), right.begin(),
                   [](unsigned char c) { return std::tolower(c); });
    // std::cout << "left: " << left << ", right:" << right << std::endl;

    if ((left.find(x) == -1) && (right.find(x) == -1)) {
      result += "(";
      std::cout << x << " found once" << std::endl;
    } else {
      result += ")";
      std::cout << x << " found twice" << std::endl;
    }
  }

  return result;
}

int main() {

  std::string tst = "Recede";

  std::string rs = duplicate_encoder(tst);
  std::cout << rs << std::endl;

  assert(duplicate_encoder("Success") == ")())())");

  return 0;
}
