# Assembly Image Processing

A compact coursework-style project that implements **image processing routines in x86 assembly**, with helper C and Python utilities for data prep and testing. The repo demonstrates how to build and run NASM-based code and visualize results.

---

## 🛠️ Requirements

- **Linux** (x86_64 host ok; we build 32‑bit)
- **NASM** `>= 2.14`
- **GCC** with 32‑bit support (`gcc -m32`)  
  On Debian/Ubuntu:
  ```bash
  sudo apt update
  sudo apt install nasm gcc-multilib
  ```
- (Optional) **Python 3.9+** with `numpy`, `matplotlib` for visualization

---

## 🚀 Quick start

### 1) Clone
```bash
git clone https://github.com/dibahadie/AssemblyImageProcessing.git
cd AssemblyImageProcessing
```

### 2) One‑shot run
If your system supports `bash` and has NASM/GCC installed:
```bash
chmod +x run.sh
./run.sh
```

### 3) Manual build (if you prefer)
Below is a typical flow; adjust filenames if you modify sources:

```bash
# Assemble core program
nasm -f elf32 -g -F dwarf ans.asm -o ans.o

# Link with provided support objects (non-PIE 32-bit)
gcc -m32 -no-pie -o ans ans.o asm_io.o driver.o

# Run (may read from inputSample/ or write into ImageProcessing/)
./ans
```

If you see linker errors about 32‑bit libs, install multilib (see Requirements).

---

## 📋 Command Guide (Inside Program)

| Command / Routine                  | Description |
|------------------------------------|-------------|
| **normal_multiplication_nonparallel** | Performs standard (serial) matrix multiplication of two input matrices. |
| **normal_multiplication_parallel**   | Performs matrix multiplication using SIMD parallelism for speedup. |
| **normal_convolution**               | Computes convolution of the two input matrices using the standard nested-loop approach. |
| **parallel_convolution**             | Computes convolution using SIMD vectorization and loop unrolling for parallel performance. |
| **get_first_matrix / get_second_matrix** | Prompts user to input the first and second matrices (size and values). |
| **print_matrix**                     | Prints the resulting matrix to stdout. |
| **read_int / read_float / read_char** | Reads an integer, float, or character input from the user. |
| **print_int / print_float / print_string** | Outputs values or strings to the screen. |

---

## 🧪 Inputs & Outputs

- **Inputs:** put test images (e.g., PGM/RAW) under `inputSample/` or wherever your driver expects.
- **Outputs:** the program prints/exports results via `asm_io` helpers or to files in `ImageProcessing/`.
- **Python viz:** drop quick plots like histograms or filtered images with scripts in `pythonCodes/`.

---

## 🧰 Common tasks

- **Switch kernel / operation:** edit `ans.asm` to include the desired routine or dispatch by a CLI arg.
- **Tune performance:** unroll inner loops; leverage `rep movsb/stosd`, use registers wisely, avoid unnecessary memory traffic.
- **Debugging tips:**
  - Add checkpoints with `print_*` routines from `asm_io`.
  - Use `gdb` (with `set disassembly-flavor intel`) on the linked executable.
  - Keep symbols (`-g -F dwarf`) when assembling.

---

## 📄 License

No license file was found. If you intend to reuse the code, please clarify licensing with the maintainer or open an issue.

---
