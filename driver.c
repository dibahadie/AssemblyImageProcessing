#include "commandHandler.c"
#include "validation.c"
void normal_multiplication_nonparallel();
void normal_multiplication_parallel();
void call_convolution();

int main() {
  int program_type = choose_program();
  print_intro(program_type);
  switch (program_type) {
    case 1:
      normal_multiplication_nonparallel();
      break;
    case 2:
      system("python3 pythonMultiplier.py");
      break;
    case 3:
      normal_multiplication_parallel();
      break;
    case 4:
      call_convolution();
      break;
    case 5:
      system("python3 pythonConvolution.py");
      break;
  }
  return 0;
}

