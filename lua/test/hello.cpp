#include <iostream>
#include <string>
#include <vector>

std::vector<std::string> solution(const std::string &s) {
  std::vector<std::string> result;
  std::string portion;
  int size = s.length();

  for (int i = 0; i < size; i += 2) {

    portion = s[i];

    if ((i + 1) < size) {
      portion += s[i + 1];
    } else {
      portion += "_";
    }

    result.push_back(portion);
  }

  return result; // Your code here
}

int main() {
  std::string exmpl = "abcde";
  std::vector<std::string> sol = solution(exmpl);

  for (int i = 0; i < sol.size(); i++) {
    std::cout << sol[i] << " ";
  }
  std::cout << std::endl;

  return 0;
}
