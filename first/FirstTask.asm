;Найти в строке символы с минимальным и максимальным кодом.


section .bss
    text: resb 1

section .data
    max_bytes: dd 100
    msg: db "min_code_index:%d, max_code_index:%d", 10, 0

section .text

extern printf
global main

main:
    ;User input:
    mov     eax, 3;         3 - system read function
    mov     ebx, 0;         0 - for stdin
    mov     ecx, text;      memory location for input
    mov     edx, max_bytes; max number of bytes to read
    int     0x80;           system interrupt


    ;Searching for index of character with max & min code:
    ;(eax - max_code_index, edx - min_code_index)
    xor     edx, edx;   min code index
    xor     eax, eax;   max code index
    mov     ebx, text;  base
    xor     esi, esi;   index
    mov     ch, [ebx];  min char code
    mov     cl, [ebx];  max char code

WHILE:
    cmp     byte [ebx + esi], 0
    je      EXIT

    cmp     byte [ebx + esi], ch;   if current min code less than current element
    jae     NEXT_CHECK
    mov     ch, [ebx + esi];        refresh min char code
    mov     edx, esi;               refresh index

NEXT_CHECK:
    cmp     byte [ebx + esi], cl;   if current max code less than current element
    jbe     CONTINUE
    mov     cl, [ebx + esi];        refresh max char code
    mov     eax, esi;               refresh index

CONTINUE:
    inc     esi;        incrementing current index
    jmp     WHILE
EXIT:


    ;PROGRAM OUTPUT
    ;Preparing stack frames:
    push    eax
    push    edx
    mov     eax, msg
    push    eax

    call    printf;     calling C function
    add     esp, 12;    clearing stack frames