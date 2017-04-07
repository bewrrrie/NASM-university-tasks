;Count matrix columns that
;contain only elements with absolute value
;less than given positive number (named "value").
;Matrix is represented as array of lines.


section .bss
    x: resd 1;      <-  this is given positive number
    matrix: resd 1
    m_width: resd 1
    m_height: resd 1
    
section .data
    format_input: dd "%d %d %d", 10, 0
    format_input_element: dd "%d", 10, 0
    format_out_result: dd "%d", 10, 0

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
    call    findCol
    ret;    RETURN


allocateMatrixMemory:
;Allocate matrix memory using matrix size(m_width, m_height).
;Result(beginning addres) -> eax.
    mov     esi, [m_height]
    shl     esi, 2
    push    esi
    call    dword malloc;   result: lines array addres -> eax
    pop     esi;            clearing stack
    shr     esi, 2
    push    eax;            saving array addres to stack
    ;matrix height -> esi
    xor     ecx, ecx
    CYCLE:
            cmp     ecx, esi
            jae     EXIT

            push    ecx;    saving counter
            push    esi;    saving matrix height

            mov     edi, [m_width]; preparing size
            shl     edi, 2;         ...
            push    edi;            pushing to stack
            call    dword malloc;   calling c function
            add     esp, 4;         clearing stack
            
            pop     esi;    getting back matrix height
            pop     ecx;    getting back counter

            inc     ecx
    jmp CYCLE
    EXIT:
    pop     eax;    Matrix base addres -> eax.
    ret;    RETURN


readMatrix:
;Read matrix from standard user input.
;Matrix address in eax.
;(eax <- matrix base addres)
    xor     esi, esi;                   making line index zero
    CYCLE_LINES:
        xor     edi, edi;               making column index zero
        mov     ebx, [eax + esi * 4];   getting current line addres
        push    eax;                    saving lines array addres
        CYCLE_COLUMNS:
            ;saving indexes...
            push    edi
            push    esi

            ;writing to [ebx + edi * 4] from user input...
            lea     eax, [ebx + edi * 4]
            push    eax
            push    format_input_element
            call    scanf
            add     esp, 8

            ;getting everything back...
            pop     esi
            pop     edi

            inc     edi
            cmp     edi, [m_width]
            jb      CYCLE_COLUMNS
        pop     eax;    getting back lines array addres
        inc     esi
        cmp     esi, [m_height]
        jb      CYCLE_LINES
    ret;        RETURN


findCol:
;Finding index column that contains only element
;with absolute value less than x.
    xor     eax, eax
    ret;    RETURN