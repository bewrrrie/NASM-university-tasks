;Метод прямоугольников.
;В качестве примера, реализовать вычисление
;интеграла cos(x), x, exp(x).

section .data
    string: dd "asdasd", 10, 0

section .bss
    string1: resd 1

section .text
extern printf
extern malloc
global main
main:
    mov     dword [string1], 1
    mov     eax, 100
    push    eax
    call    malloc
    add     esp, 4

    ret