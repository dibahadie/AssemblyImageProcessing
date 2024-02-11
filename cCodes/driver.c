#include "commandHandler.c"
#include "validation.c"
#include "timeCalculation.c"
#include "imageProcessing.c"

void normal_multiplication_nonparallel();
void normal_multiplication_parallel();
void normal_convolution();
void parallel_convolution();

int main() {
  int run_program = 1;
  while(run_program) {
    int program_type = choose_program(8);
    print_intro(program_type);
    switch (program_type) {
      case 1:
        normal_multiplication_nonparallel();
        break;
      case 2:
        system("python3 pythonCodes/pythonMultiplier.py");
        break;
      case 3:
        normal_multiplication_parallel();
        break;
      case 4:
        normal_convolution();
        break;
      case 5:
        parallel_convolution();
        break;
      case 6:
        system("python3 pythonCodes/pythonConvolution.py");
        break;
      case 7:
        run_image_processing_menu();
        break;
      case 8:
        run_program = 0;
        break;
    }
  }
  return 0;
}

