;Diba Hadi
;Pr Jahangir
;multiplication and covolution methods
section .data
    read_float_format: db "%f", 0                       ;format for reading float
    print_float_format: db "%f ", 0                     ;format for printing float
    read_int_format: db "%ld", 0                        ;format for reading int
    print_int_format: db "%ld ", 0                      ;format for printing int
    new_line: db "", 0                                  ;new line string
    zero: dq 0                                          ;zero to be loaded in matrices
    MAX_SIZE: equ 512
    MAX_CAPACITY: equ 262144

;-------------------------------------
    fixed_matrix_size: dq MAX_SIZE                            ;first matrix size
    first_matrix_size: dq MAX_SIZE                            ;fixed matrix size
    first_matrix: dd MAX_CAPACITY DUP(0.0)                    ;first matrix memory reserved
    second_matrix: dd MAX_CAPACITY DUP(0.0)                   ;second matrix memory reserved
    second_matrix_size: dq MAX_SIZE                           ;second matrix size
    normal_multiplication_result: dd MAX_CAPACITY DUP(0.0)    ;result of normal multiplication reserved memory
    parallel_multiplication_result: dd MAX_CAPACITY DUP(0.0)  ;result of parallel multiplication reserved memory 
    convolution_result: dd MAX_CAPACITY DUP(0.0)              ;convolution result reserved memory

;-------------------------------------
    matrix_input_msg: dd "Please enter the matrix:", 0              ;message for reading matrix
;-------------------------------------


segment .text                                           ;defining the functions which are called from outside globally
    global normal_multiplication_nonparallel            ;also defining the functions from outside that are called here by extern  
    global normal_multiplication_parallel 
    global normal_convolution  
    global parallel_convolution
    extern calculate_time_spent                         ;fucntion to calculate time -> timeCalculation.c
    extern start_clock                                  ;function to start clock -> timeCalculation.c
    extern printf                                       
    extern scanf    
    extern puts 
    extern get_input_matrix_size                        ;function to get matrix input -> validation.c
    extern getchar                                 

;   funtion to calculate normal multiplication of first and second matrices
normal_multiplication_nonparallel:
;   these registers are pushed onto the stack before doing the opereation and popped afterwards
;   therefore they remain unchanged after calling the function
	push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix                               ;get first matrix
    call get_second_matrix                              ;get second matrix
    call start_clock                                    ;start the clock for counting time
    call multiply_square_matrices_normal                ;multiply the matrices and store the result
    call calculate_time_spent                           ;stop the clock and log results

    mov rdi, normal_multiplication_result               ;address of matrix to be printed
    mov rax, qword[first_matrix_size]                   ;size of matrix to be printed
    call print_matrix                                   ;print the result matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

;   function to calculate matrix multiplication using simd instructions and parellelism
normal_multiplication_parallel:
;   these registers are pushed onto the stack before doing the opereation and popped afterwards
;   therefore they remain unchanged after calling the function
	push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix                               ;get the first matrix
    call get_second_matrix                              ;get the second matrix

    call start_clock                                    ;mark the start time
    call multiply_square_matrices_parallel              ;calculate the multiplication
    call calculate_time_spent                           ;mark the finish time and log results

    mov rdi, parallel_multiplication_result             ;address of matrix to be printed
    mov rax, qword[first_matrix_size]                   ;size of matrix to be printed
    call print_matrix                                   ;print the result matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

;   function to calculate the convolution
normal_convolution:
;   these registers are pushed onto the stack before doing the opereation and popped afterwards
;   therefore they remain unchanged after calling the function
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix                               ;get the first matrix
    call get_second_matrix                              ;get the second matrix
    call start_clock                                    ;mark the start time
    call convolution_nonparallel                        ;calculate the convolution
    call calculate_time_spent                           ;mark the finish time


    mov rdi, convolution_result                         ;address of matrix to be printed
    mov rax, qword[first_matrix_size]                   
    sub rax, qword[second_matrix_size]                  ;calculate the size from first and second matrix size
    inc rax                                             ;size of matrix to be printed
    call print_matrix                                   ;print the matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

;   function to calculate the convolution
parallel_convolution:
;   these registers are pushed onto the stack before doing the opereation and popped afterwards
;   therefore they remain unchanged after calling the function
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix                               ;get the first matrix
    call get_second_matrix                              ;get the second matrix
    call start_clock                                    ;mark the start time
    call convolution_parallel                           ;calculate convolution
    call calculate_time_spent                           ;mark the finish time and log results

    mov rdi, convolution_result                         ;address of matrix to be printed
    mov rax, qword[first_matrix_size]                   ;calculate matrix size
    sub rax, qword[second_matrix_size]
    inc rax
    call print_matrix                                   ;print the result matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

;----------------------------------------------------------------------------------------
;   these functions are implemented for easier I/O operations

read_float:                         ;read float and put in eax
    sub rsp, 8                      ;reserve stack space
    mov rsi, rsp                    ;save rsp
    mov rdi, read_float_format      ;input format
    mov rax, 1                      ;number of arguments
    call scanf                      
    mov eax, dword[rsp]             ;result is in eax
    add rsp, 8
    ret


print_float:                        ;print the value of xmm0
    sub rsp, 8
    cvtss2sd xmm0, xmm0                                             
    mov rdi, print_float_format     ;output format                                                     
    mov rax, 1                      ;number of arguments                                                                                  
    call printf                                                
    add rsp, 8                      ;clearing local variables from stack
    ret


print_int:                          ;print the value of rdi
    sub rsp, 8
    mov rsi, rdi
    mov rdi, print_int_format
    mov rax, 1                      ;setting rax (al) to number of vector inputs
    call printf
    add rsp, 8                      ;clearing local variables from stack
    ret


print_string:
    sub rsp, 8
    call puts
    add rsp, 8                      ;clearing local variables from stack
    ret


read_int:                           ;reading int and putting in rax
    sub rsp, 8
    mov rsi, rsp
    mov rdi, read_int_format
    mov rax, 1                      ;setting rax (al) to number of vector inputs
    call scanf
    mov rax, [rsp]
    add rsp, 8                      ;clearing local variables from stack
    ret

read_char:
    sub rsp, 8

    call getchar

    add rsp, 8 ; clearing local variables from stack

    ret
;--------------------------------------------------------------------------------------------
read_matrix:                        ;read matrix of size rax and put in [rdi]
;   these registers are pushed onto the stack before doing the opereation and popped afterwards
;   therefore they remain unchanged after calling the function
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    mov r12, rdi                    ;rdi is memory allocated for matrix
    mov r13, rax                    ;save the value of matrix_size
    call fill_with_zero             ;feel the matrices with zero to avoid unrelated results during pareallel calculation

    xor r14, r14                    ;first loop counter set to zero
    get_input_i:
        xor rbx, rbx                ;second loop counter set to zero
        get_input_j:
            call read_float         ;read indice
            movd xmm0, eax          ;move read content to xmm register

            mov rdi, r14
            mov rax, rbx
            call index_at_ij        ;calculate index of array[r14][rbx]
            movss [r12 + 4 * rax], xmm0     ;put the input value in rax'th index

            inc rbx
            cmp rbx, r13
            jl get_input_j                    ;loop for r13 times
        inc r14
        cmp r14, r13
        jl get_input_i                    ;loop for r13 times

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp 
    ret


print_matrix:                       ;print matrix of size rax and in memory location rdi
;   these registers are pushed onto the stack before doing the opereation and popped afterwards
;   therefore they remain unchanged after calling the function
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    mov r12, rdi                    ;rdi is where matrix is saved - save to r12
    mov r13, rax                    ;save the value of matrix_size in r13
    xor r14, r14                    ;used as first loop counter - unchanged when calling printf

    print_row:
        xor r15, r15                    ;used as second loop counter - unchanged when calling printf

        print_indice:
            mov rdi, r14
            mov rax, r15                    ;calculate the index to be printed
            call index_at_ij                ;calculate array[r14][r15]
            movss xmm0, [r12 + 4 * rax]     ;put the output value in xmm0
            call print_float

            inc r15
            cmp r15, r13
            jl print_indice                 ;loop for r13 times
        
        mov rdi, new_line                   ;going to next row - print new line
        call print_string

        inc r14
        cmp r14, r13
        jl print_row                        ;loop for r13 time

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp 
    ret
;-------------------------------------------------------------------------------------------
get_first_matrix:
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8
        call get_input_matrix_size                      ;function in validation.c - get size
        mov qword[first_matrix_size], rax               ;move result to memory

        mov rdi, matrix_input_msg                       ;message to be printed
        call print_string                               ;print input message

        mov rax, qword[first_matrix_size]               ;size of matrix to be printed
        mov rdi, first_matrix                           ;address of matrix to be printed
        call read_matrix

        call read_char                                  ;read the \n char
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp 
    ret


get_second_matrix:
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8
        call get_input_matrix_size                      ;function in validation.c
        mov qword[second_matrix_size], rax              ;move result to memory

        mov rdi, matrix_input_msg                       ;message to be printed
        call print_string                               ;print input message

        mov rax, qword[second_matrix_size]              ;size of matrix to be printed
        mov rdi, second_matrix                          ;address of matrix to be printed
        call read_matrix                                ;read the matrix
        call read_char                                  ;read the \n char
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp
    ret
;----------------------------------------------------------------------------------------
index_at_ij:                        ;row is at rdi
    push rbp                        ;column is at rax                     
    push rbx                                                  
    push r12                                          
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

        mov r12, rax
        mov rax, rdi
        imul qword[fixed_matrix_size]       ;formula for index 4 * (rdi * size + rax)
        add rax, r12                        ;calculate the index to be printed

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp
    ret

fill_with_zero:                             ;fill the first and second matrix with zeros
    push rbp                                         
    push rbx                                         
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    xor r14, r14                            ;first loop counter initialized to zero
    put_zero_i:         
        xor rbx, rbx                        ;second loop counter initialized to zero
        put_zero_j:
            movd xmm0, [zero]               ;load zero into register

            mov rdi, r14                    
            mov rax, rbx
            call index_at_ij                ;calculate index arrat[r14][rbx]
            movss [r12 + 4 * rax], xmm0     ;put the zero value in rax'th index

            inc rbx
            cmp rbx, r13
            jl put_zero_j                    ;loop for matrix_size times
        inc r14
        cmp r14, r13
        jl put_zero_i                    ;loop for matrix_size times


    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp
    ret

multiply_square_matrices_normal:    
    push rbp                                         
    push rbx                                         
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8
    
    xor r12, r12                                            ;first loop counter initialized to zero
    row_i:                                                  ;loop on rows
        xor r13, r13                                        ;second loop counter initialized to zero
        column_j:                                           ;loop on columns
            xor r14, r14                                    ;third loop counter initialized to zero
            xorps xmm1, xmm1
            dot_product:                                    ;loop for calculating dot product of row and col
                mov rdi, r12
                mov rax, r14
                call index_at_ij                            ;calculate array index of array[r12][r14]
                movss xmm0, [first_matrix + 4 * rax]        ;move value to xmm0

                mov rdi, r14
                mov rax, r13
                call index_at_ij                            ;calculate array[r14][r13]
                mulss xmm0, [second_matrix + 4 * rax]       ;do multiplication and add results
                addss xmm1, xmm0

                inc r14
                cmp r14, [first_matrix_size]
                jl dot_product


            mov rdi, r12
            mov rax, r13
            call index_at_ij                                        ;calculate index of array[r12][r13]
            movss [normal_multiplication_result + rax * 4], xmm1    ;move dot product to destination

            inc r13
            cmp r13, [first_matrix_size]
            jl column_j                                             ;loop first_matrix_size times

        inc r12
        cmp r12, [first_matrix_size]
        jl row_i                                                    ;loop first_matrix_size times

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp
    ret

multiply_square_matrices_parallel:    
    push rbp                                         
    push rbx                                         
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8
    
    xor r12, r12                                            ; Initialize r12 to 0
    for_i:                                                  ; Outer loop over i
        xor r13, r13                                        ; Initialize r13 to 0
        for_k:                                              ; Middle loop over k
            xor r14, r14                                    ; Initialize r14 to 0
            for_j:                                          ; Inner loop over j
                mov rax, r12                                ; Move r12 to rax
                shl rax, 9                                  ; Shift rax left by 9 bits
                add rax, r13                                ; calculate array index
                vbroadcastss xmm0, [first_matrix + 4 * rax] ; Load value from first_matrix into xmm0

                mov rax, r13                                ; Move r13 to rax
                shl rax, 9                                  ; Shift rax left by 9 bits
                add rax, r14                                ; Add r14 to rax
                movups xmm1, [second_matrix + 4*rax]        ; Load value from second_matrix into xmm1
                mulps xmm0, xmm1  ; Multiply xmm0 and xmm1

                mov rax, r12                                ; Move r12 to rax
                shl rax, 9                                  ; Shift rax left by 9 bits
                add rax, r14                                ; Add r14 to rax
                movups xmm1, [parallel_multiplication_result + 4 * rax]  ; Load value from parallel_multiplication_result into xmm1
                addps xmm1, xmm0                                         ; Add xmm0 to xmm1
                movups [parallel_multiplication_result + 4 * rax], xmm1  ; Store result back into parallel_multiplication_result

                add r14, 4                                  ; Increment r14 by 4
                cmp r14, [first_matrix_size]                ; Compare r14 with first_matrix_size
                jl for_j                                    ; If r14 < first_matrix_size, jump to for_j


            inc r13                                         ; Increment r13
            cmp r13, [first_matrix_size]                    ; Compare r13 with first_matrix_size
            jl for_k                                        ; If r13 < first_matrix_size, jump to for_k

        inc r12                                             ; Increment r12
        cmp r12, [first_matrix_size]                        ; Compare r12 with first_matrix_size
        jl for_i                                            ; If r12 < first_matrix_size, jump to for_i

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp
    ret


convolution_nonparallel:
    push rbp                                         
    push rbx 
    push r8
    push r9
    push r10
    push r11                                        
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    mov r8, [first_matrix_size]
    sub r8, [second_matrix_size]
    inc r8

    
    xor r12, r12                                                    ;r12 = i, initialize to zero
    first_loop_nonparallel:
        xor r13, r13                                                ;r13 = j, initialize to zero
        second_loop_nonparallel:
            xor r14, r14                                            ;r14 = k, initialize to zero
            third_loop_nonparallel:
                xor r15, r15                                        ;r15 = l, initialize to zero
                forth_loop_nonparallel:

                    mov rdi, r12
                    add rdi, r14
                    mov rax, r13
                    add rax, r15
                    call index_at_ij                               ;calculate index of first_matrix[i + k][j + l]

                    movss xmm1, [first_matrix + 4*rax]              ;xmm1 = first_matrix[i + k][j + l]

                    mov rdi, r14    
                    mov rax, r15
                    call index_at_ij                  ;calculate index of second_matrix[k][l]

                    movss xmm2, [second_matrix + 4*rax]             ;xmm2 = second_matrix[k][l]

                    mulss xmm1, xmm2                                ;xmm1 = first_matrix[i + k][j + l] * second_matrix[k][l]

                    mov rdi, r12
                    mov rax, r13
                    call index_at_ij             ;calculate index of convolution_result[i][j]

                    movss xmm0, [convolution_result + 4*rax]
                    addss xmm0, xmm1
                    movss [convolution_result + 4*rax], xmm0
                    
                    inc r15
                    cmp r15, [second_matrix_size]
                    jl forth_loop_nonparallel
                inc r14
                cmp r14, [second_matrix_size]
                jl third_loop_nonparallel
            inc r13
            cmp r13, r8
            jl second_loop_nonparallel
        inc r12
        cmp r12, r8
        jl first_loop_nonparallel


    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12  
    pop r11
    pop r10
    pop r9
    pop r8                                           
    pop rbx                                             
    pop rbp
    ret

convolution_parallel:
    push rbp                                         
    push rbx 
    push r8
    push r9
    push r10
    push r11                                        
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    mov r8, [first_matrix_size]
    sub r8, [second_matrix_size]
    inc r8

    
    xor r12, r12                                                    ;r12 = i, initialize to zero
    first_loop_parallel:
        xor r13, r13                                                ;r13 = j, initialize to zero
        second_loop_parallel:
            xor r14, r14                                            ;r14 = k, initialize to zero
            third_loop_parallel:
                xor r15, r15                                        ;r15 = l, initialize to zero
                forth_loop_parallel:

                    mov rdi, r12
                    add rdi, r14
                    mov rax, r13
                    add rax, r15
                    call index_at_ij                ;calculate index of first_matrix[i + k][j + l]

                    movups xmm1, [first_matrix + 4*rax]             ;xmm1 = first_matrix[i + k][j + l]

                    mov rdi, r14    
                    mov rax, r15
                    call index_at_ij                  ;calculate index of second_matrix[k][l]

                    movups xmm2, [second_matrix + 4*rax]            ;xmm2 = second_matrix[k][l]

                    mulps xmm1, xmm2                                ;xmm1 = first_matrix[i + k][j + l] * second_matrix[k][l]

                    mov rdi, r12
                    mov rax, r13
                    call index_at_ij             ;calculate index of convolution_result[i][j]

                    movups xmm0, [convolution_result + 4*rax]
                    addps xmm0, xmm1
                    movups [convolution_result + 4*rax], xmm0
                    
                    add r15, 4
                    cmp r15, [second_matrix_size]
                    jl forth_loop_parallel
                inc r14
                cmp r14, [second_matrix_size]
                jl third_loop_parallel
            inc r13
            cmp r13, r8
            jl second_loop_parallel
        inc r12
        cmp r12, r8
        jl first_loop_parallel


    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12  
    pop r11
    pop r10
    pop r9
    pop r8                                           
    pop rbx                                             
    pop rbp
    ret