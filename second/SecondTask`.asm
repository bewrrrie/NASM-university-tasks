;Count matrix columns that
;contain only elements with absolute value
;less than given positive number (named "x").
;Matrix is represented as array of lines.

section .bss
    x: resd 1;          <-  this is given positive number
    matrix: resd 1;     <-  lines array base addres
    m_width: resd 1
    m_height: resd 1

section .data
    format_input: dd "%d %d %d/n", 10, 0
    format_input_element: dd "%d", 10, 0
    format_output_result: dd "result:%d", 10, 0
    format_output_element: dd "%d ", 10, 0

section .text
extern scanf
extern printf
extern malloc
global main

main:
    mov ebp, esp;   for correct debugging

;Read matrix size & given value
    push    x
    push    m_height
    push    m_width
    push    format_input
    call    scanf
    add     esp, 16

    mov     dword eax, [m_width];   eax <- width.
    cmp     eax, 0;                 if matrix has zero width
    je      END;                    then finish.

    mov     dword eax, [m_height];  eax <- height.
    cmp     eax, 0;                 if matrix has zero height
    je      END;                    then finish.

    call    allocateMatrixMemory
    call    readMatrix
    call    countColsWithAbsValueLessThanX
    
    push    eax
    push    format_output_result
    call    printf
    add     esp, 8
    END:
    ret;    RETURN



allocateMatrixMemory:
;Allocate matrix memory using matrix size(m_width, m_height).
;Result(beginning addres) -> matrix (variable, begin addres).

    mov     dword eax, [m_height];  eax <- height.
    shl     eax, 2;                 eax to bytes
    push    eax
    call    dword malloc;           allocating memory for lines array
    mov     dword [matrix], eax;    'matrix' <- lines array beginnig addres
    add     esp, 4;                 clear stack

    mov     dword edi, [m_width]
    shl     edi, 2;                 edi <- line size in bytes.
    mov     dword edx, [m_height];  edx <- lines quantity.
    mov     dword ebx, [matrix];    ebx <- lines array base addres.
    xor     ecx, ecx;               ecx <- zero, index container.
    ALLOC_CYCLE:
        push    ecx;                    SAVING EVERYTHING
        push    edx;                    TO STACK
        push    ebx
        push    edi
        call    dword malloc
        pop     edi
        pop     ebx;                    RETURNING EVERYTHING
        pop     edx;                    FROM STACK
        pop     ecx
        mov     dword [ebx + ecx * 4], eax;     writing line addres to lines array
        inc     ecx
        cmp     ecx, edx
    jb      ALLOC_CYCLE
    ret



readMatrix:
;Read matrix elements from standard user input.

    mov     ebx, [matrix];  ebx <- lines array base addres
    xor     esi, esi;       esi <- line index
    READ_CYCLE_LINES:
        push    ebx
        push    esi
    
        mov     edx, [ebx + esi * 4];   edx <- current line base addres
        xor     edi, edi;               edi <- column index
        READ_CYCLE_COLUMNS:
            lea     edx, [edx + edi * 4]

            push    edi;                saving col.index to stack
            push    edx
            push    format_input_element
            call    scanf
            add     esp, 4
            pop     edx
            pop     edi;                returning col.index from stack

            inc     edi
            cmp     edi, [m_width]
            jb      READ_CYCLE_COLUMNS
        pop     esi
        pop     ebx

        inc     esi
        cmp     esi, [m_height]
        jb      READ_CYCLE_LINES
    ret



countColsWithAbsValueLessThanX:
;Count matrix columns that contain only elements
;with absolute value less than x.

    xor     eax, eax;       eax <- columns quantity
    mov     ebx, [matrix];  ebx <- lines array base addres
    xor     edi, edi;       esi <- column index
    COUNT_CYCLE_COLUMNS:
        xor     esi, esi;   esi <- line index
        COUNT_CYCLE_LINES:
            mov     edx, [ebx + esi * 4]
            mov     edx, [edx + edi * 4];   edx <- current element

;           abs(x) = (x xor y) - y
;           where y = x >> 31
            mov     ecx, edx
            sar     ecx, 0x1f
            xor     edx, ecx
            sub     edx, ecx;   edx <- cur.element absolute value

            cmp     edx, [x]
            jae     ITER_END

            inc     esi
            cmp     esi, [m_height]
            jb      COUNT_CYCLE_LINES
        inc     eax;    increasing columns quantity
        ITER_END:
        inc     edi
        cmp     edi, [m_width]
        jb      COUNT_CYCLE_COLUMNS
    ret