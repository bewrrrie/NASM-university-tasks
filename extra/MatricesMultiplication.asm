section .bss
    m1: resd 1; <- first matrix lines array
    m1_width: resd 1
    m1_height: resd 1

    m2: resd 1; <- second matrix lines array
    m2_width: resd 1
    m2_height: resd 1

    result_matrix: resd 1; <- mutiplication result matrix lines array

section .data
    size_format: dd "%d %d %d %d/n", 10, 0
    element_format: dd "%d", 10, 0
    
    size_notification: dd "Matrices does not fit for multiplication because of their sizes!", 10, 0
    size_less_or_equal_to_zero: dd "Matrix size must be positive integer!", 10, 0


section .text
extern scanf
extern printf
extern malloc
global main

main:
    mov ebp, esp; for correct debugging

;Reading matrices size
    push    m2_height
    push    m2_width
    push    m1_height
    push    m1_width
    push    size_format
    call    scanf
    add     esp, 20
    
;Proccessing special case
    mov     eax, [m1_width]
    cmp     eax, 0
    jle     ERROR_LESS_OR_EQUAL_TO_ZERO

    mov     eax, [m1_height]
    cmp     eax, 0
    jle     ERROR_LESS_OR_EQUAL_TO_ZERO

    mov     eax, [m2_width]
    cmp     eax, 0
    jle     ERROR_LESS_OR_EQUAL_TO_ZERO

    mov     eax, [m2_height]
    cmp     eax, 0
    jle     ERROR_LESS_OR_EQUAL_TO_ZERO

    mov     eax, [m1_width]
    cmp     eax, [m2_height]
    jne     ERROR_SIZE_NOT_EQUAL
    
;Allocating first matrix
    mov     dword ebx, m1
    mov     dword edi, [m1_height]
    mov     dword esi, [m1_width]
    call    allocateMatrixMemory
;Allocating second matrix
    mov     dword ebx, m2
    mov     dword edi, [m2_height]
    mov     dword esi, [m2_width]
    call    allocateMatrixMemory
;Allocating result matrix
    mov     dword ebx, result_matrix
    mov     dword edi, [m1_height]
    mov     dword esi, [m2_width]
    call    allocateMatrixMemory

    
;Reading first matrix
    mov     dword ebx, [m1]
    mov     dword edi, [m1_height]
    mov     dword esi, [m1_width]
    call    readMatrix
;Reading second matrix
    mov     dword ebx, [m2]
    mov     dword edi, [m2_height]
    mov     dword esi, [m2_width]
    call    readMatrix


;Mutiplying m1 & m2
    ;call    multiplyMatrices


    jmp     END_MAIN
;ERRORS PROCESSING
ERROR_SIZE_NOT_EQUAL:
    push    size_notification
    call    printf
    add     esp, 4
    jmp     END_MAIN
    
ERROR_LESS_OR_EQUAL_TO_ZERO:
    push    size_less_or_equal_to_zero
    call    printf
    add     esp, 4
    jmp     END_MAIN


END_MAIN:
    xor eax, eax
    ret



allocateMatrixMemory:
;Allocate matrix memory using matrix size(m_width, m_height).
;Supposed that: ebx <- matrix lines array base addres
;               esi <- matrix width
;               edi <- matrix height

    mov     eax, edi
    shl     eax, 2
    push    eax
    call    malloc
    mov     [ebx], eax
    add     esp, 4

    push    
    xor     ecx, ecx
    ALLOC_CYLCE:
        
    inc     ecx
    jb      ecx, 
    ret


readMatrix:
;Read matrix elements from standard user input.
;Supposed that: ebx <- matrix lines array base addres
;               esi <- matrix width
;               edi <- matrix height
    ret

