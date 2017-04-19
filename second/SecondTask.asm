;Count matrix columns that
;contain only elements with absolute value
;less than given positive number (named "value").
;Matrix is represented as array of lines.

section .bss
    x: resd 1;          <-  this is given positive number
    matrix: resd 1;     <-  lines array base addres
    m_width: resd 1
    m_height: resd 1

section .data
    format_input: dd "%d %d %d/n", 10, 0
    format_input_element: dd "%d", 10, 0
    format_out_result: dd "%d", 10, 0
    format_out_element: dd "%d ", 10, 0

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

    call    allocateMatrixMemory
    call    readMatrix
    call    writeMatrix
    call    findCol
    ret;    RETURN


allocateMatrixMemory:
;Allocate matrix memory using matrix size(m_width, m_height).
;Result(beginning addres) -> matrix (variable, begin addres).
    mov     esi, [m_height]
    shl     esi, 2
    push    esi
    call    dword malloc;   result: lines array addres -> eax
    mov     [matrix], eax
    mov     ebx, eax;       base addres to ebx
    pop     esi;            clearing stack
    shr     esi, 2
    ;matrix height -> esi
    xor     ecx, ecx
    CYCLE:
        push    ebx;    saving array addres to stack
        push    ecx;    saving counter
        push    esi;    saving matrix height

        mov     edi, [m_width]; preparing size
        shl     edi, 2;         ...
        push    edi;            pushing to stack
        call    dword malloc;   calling c function
        add     esp, 4;         clearing stack

        pop     esi;    getting back matrix height
        pop     ecx;    getting back counter
        pop     ebx;    returning matrix base addres

        mov     [ebx + ecx * 4], eax

        inc     ecx
        cmp     ecx, esi
        jb      CYCLE
    EXIT:
    ret;    RETURN


readMatrix:
;Read matrix from standard user input.
;Matrix address in eax.
;(eax <- matrix base addres)
    xor     ecx, ecx;           line index
    xor     edx, edx;           column index

    mov     ebx, [matrix];      lines array base addres
    mov     edi, [m_width];     width storage
    mov     esi, [m_height];    height storage

    CYCLE_LINES_R:
        push    ecx;            saving line index
        push    esi;            saving height
        CYCLE_COLUMNS_R:
            push    edx;        saving column index
            push    ebx;        saving lines array base addres

            mov     eax, [ebx]; getting current line base addres
            shl     edx, 2;     converting index to bytes
            add     eax, edx;   adding index to base addres
            push    eax
            push    format_input_element
            call    scanf
            add     esp, 8

            pop     ebx;        getting back lines array base addres
            pop     edx;        getting back column index
            inc     edx
            cmp     edx, edi
            jb      CYCLE_COLUMNS_R
        pop     esi;            getting back height
        pop     ecx;            getting back line index

        add     ebx, 4;         moving pointer through lines array
        inc     ecx
        cmp     ecx, esi
        jb      CYCLE_LINES_R
    ret;        RETURN


writeMatrix:
    xor     esi, esi;   line index
    xor     edi, edi;   column index
    mov     ebx, [matrix]
    CYCLE_LINES_W:
        mov     eax, [ebx]
        push    esi
        push    ebx
        CYCLE_COLUMNS_W:
            push    edi
            shl     edi, 2
            add     eax, edi

            push    eax
            push    format_out_element
            call    printf
            add     esp, 8

            pop     edi
            inc     edi
            cmp     edi, [m_width]
            jb      CYCLE_COLUMNS_W
        pop     ebx
        pop     esi

        add     ebx, 4
        inc     esi
        cmp     esi, [m_height]
        jb      CYCLE_LINES_W
    ret;        RETURN


findCol:
;Finding index column that contains only
;elements with absolute value less than x.
    
    ret;    RETURN