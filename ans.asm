section .data
    read_float_format: db "%f", 0
    print_float_format: db "%f ", 0
    read_int_format: db "%ld", 0
    print_int_format: db "%ld ", 0
    new_line: db "", 0
    zero: db 0.0
    one_vector: dq 1, 1, 1, 1

;-------------------------------------
    fixed_matrix_size: dq 100
    first_matrix: dd 250000 DUP(0.0)
    first_matrix_size: dq 3
    second_matrix: dd 250000 DUP(0.0)
    second_matrix_size: dq 3
    normal_multiplication_result: dd 250000 DUP(0.0)
    parallel_multiplication_result: dd 250000 DUP(0.0)
    convolution_result: dd 10000 DUP(0.0)

;-------------------------------------
    matrix_input_msg: dd "Please enter the matrix:", 0
    matrix_input_msg_size3: dd "Please enter a 3*3 matrix:", 0

;-------------------------------------
    maximum_matrix_size: dd 500

segment .text
    global normal_multiplication_nonparallel  
    global normal_multiplication_parallel 
    global normal_convolution  
    global parallel_convolution
    global first_matrix 
    extern calculate_time_spent
    extern start_clock
    extern printf                                       
    extern scanf    
    extern puts 
    extern get_input_matrix_size  
    extern getchar                                 

normal_multiplication_nonparallel:
	push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix
    call get_second_matrix
    call start_clock
    call multiply_square_matrices_normal
    call calculate_time_spent

    mov rdi, normal_multiplication_result
    mov rax, qword[first_matrix_size]
    call print_matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

normal_multiplication_parallel:
	push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix
    call get_second_matrix
    call start_clock
    call multiply_square_matrices_parallel
    call calculate_time_spent


    mov rdi, parallel_multiplication_result
    mov rax, qword[first_matrix_size]
    call print_matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

normal_convolution:
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix
    call get_second_matrix
    call start_clock
    call convolution_nonparallel
    call calculate_time_spent


    mov rdi, convolution_result
    mov rax, qword[first_matrix_size]
    sub rax, qword[second_matrix_size]
    inc rax
    call print_matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

parallel_convolution:
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8   
    
    call get_first_matrix
    call get_second_matrix
    call start_clock
    call convolution_parallel
    call calculate_time_spent

    mov rdi, convolution_result
    mov rax, qword[first_matrix_size]
    sub rax, qword[second_matrix_size]
    inc rax
    call print_matrix
    
    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp                                             
    ret

;----------------------------------------------------------------------------------------
read_float:
    sub rsp, 8                      ;read float and put in eax
    mov rsi, rsp
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
    add rsp, 8
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
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    mov r12, rdi                    ;rdi is memory allocated for matrix
    mov r13, rax                    ;save the value of matrix_size
    call fill_with_zero

    xor r14, r14
    get_input_i:
        xor rbx, rbx
        get_input_j:
            call read_float
            movd xmm0, eax

            mov rdi, r14
            mov rax, rbx
            call index_at_ij
            movss [r12 + 4 * rax], xmm0     ;put the input value in rax'th index

            inc rbx
            cmp rbx, r13
            jl get_input_j                    ;loop for matrix_size times
        inc r14
        cmp r14, r13
        jl get_input_i                    ;loop for matrix_size times

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp 
    ret


print_matrix:
    push rbp                                            
    push rbx                                            
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    mov r12, rdi                    ;rdi is where matrix is saved
    mov r13, rax                    ;save the value of matrix_size
    xor r14, r14                    ;used as counter - unchanged when calling printf

    print_row:
        xor r15, r15                    ;used as counter - unchanged when calling printf

        print_indice:
            mov rdi, r14
            mov rax, r15                    ;calculate the index to be printed
            call index_at_ij
            movss xmm0, [r12 + 4 * rax]     ;put the output value in xmm0
            call print_float

            inc r15
            cmp r15, r13
            jl print_indice                 ;loop for matrix_size^2 times
        
        mov rdi, new_line                   ;going to next row - print new line
        call print_string

        inc r14
        cmp r14, r13
        jl print_row

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

        call get_input_matrix_size
        mov qword[first_matrix_size], rax

        mov rdi, matrix_input_msg
        call print_string

        mov rax, qword[first_matrix_size]
        mov rdi, first_matrix
        call read_matrix

        call read_char
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
        call get_input_matrix_size
        mov qword[second_matrix_size], rax

        mov rdi, matrix_input_msg
        call print_string

        mov rax, qword[second_matrix_size]
        mov rdi, second_matrix
        call read_matrix
        call read_char
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
        imul qword[fixed_matrix_size]       ;formula for index 4 * (r13 * size + r12)
        add rax, r12                        ;calculate the index to be printed

    add rsp, 8
	pop r15                                             
	pop r14                                             
	pop r13                                             
	pop r12                                             
    pop rbx                                             
    pop rbp
    ret

fill_with_zero:
    push rbp                                         
    push rbx                                         
    push r12                                            
    push r13                                            
    push r14                                            
    push r15                                                 
    sub rsp, 8

    xor r14, r14
    put_zero_i:
        xor rbx, rbx
        put_zero_j:
            movd xmm0, [zero]

            mov rdi, r14
            mov rax, rbx
            call index_at_ij
            movss [r12 + 4 * rax], xmm0     ;put the input value in rax'th index

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
    
    xor r12, r12
    row_i:
        xor r13, r13
        column_j:
            xor r14, r14
            xorps xmm1, xmm1
            dot_product:
                mov rdi, r12
                mov rax, r14
                call index_at_ij
                movss xmm0, [first_matrix + 4 * rax]  

                mov rdi, r14
                mov rax, r13
                call index_at_ij
                mulss xmm0, [second_matrix + 4 * rax]
                addss xmm1, xmm0

                inc r14
                cmp r14, [first_matrix_size]
                jl dot_product


            mov rdi, r12
            mov rax, r13
            call index_at_ij
            movss [normal_multiplication_result + rax * 4], xmm1

            inc r13
            cmp r13, [first_matrix_size]
            jl column_j

        inc r12
        cmp r12, [first_matrix_size]
        jl row_i

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
    
    xor r12, r12
    for_i:
        xor r13, r13
        for_k:
            xor r14, r14
            xorps xmm1, xmm1
            xorps xmm0, xmm0
            for_j:
                mov rdi, r12
                mov rax, r13
                call index_at_ij

                vbroadcastss xmm0, [first_matrix + 4 * rax]

                mov rdi, r13
                mov rax, r14
                call index_at_ij

                movups xmm1, [second_matrix + 4*rax]
                mulps xmm0, xmm1

                mov rdi, r12
                mov rax, r14
                call index_at_ij

                movups xmm1, [parallel_multiplication_result + 4 * rax]
                addps xmm1, xmm0
                movups [parallel_multiplication_result + 4 * rax], xmm1


                add r14, 4
                cmp r14, [first_matrix_size]
                jl for_j


            inc r13
            cmp r13, [first_matrix_size]
            jl for_k

        inc r12
        cmp r12, [first_matrix_size]
        jl for_i

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