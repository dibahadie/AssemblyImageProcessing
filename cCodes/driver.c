#include "commandHandler.c"
#include "validation.c"
// Diba Hadi
// Pr Jahangir
// Main driver code
#include "timeCalculation.c"
#include "imageProcessing.c"

void normal_multiplication_nonparallel();
void normal_multiplication_parallel();
void normal_convolution();
void parallel_convolution();

int main() {
  int run_program = 1;
  // run program until exit command is entered
  // each time get a command and run it
  while(run_program) {
    // print the instructions and program list and get the program number from user
    // function implemented in commandHadler.c
    int program_type = choose_program(8);
    // print the discription of the program that is about to be executed
    // implemented in commandHandler.c
    print_intro(program_type);
    switch (program_type) {
      case 1:
      // multiplication normal assembly
        normal_multiplication_nonparallel();
        break;
      case 2:
      // multiplication python
        system("python3 pythonCodes/pythonMultiplier.py");
        break;
      case 3:
      // parallel multiplication
        normal_multiplication_parallel();
        break;
      case 4:
      // normal convolution
        normal_convolution();
        break;
      case 5:
      // parallel convolution
        parallel_convolution();
        break;
      case 6:
      // convolution by python
        system("python3 pythonCodes/pythonConvolution.py");
        break;
      case 7:
      // process image
        run_image_processing_menu();
        break;
      case 8:
      // exit
        run_program = 0;
        break;
    }
  }
  return 0;
}

