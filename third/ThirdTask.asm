;Метод прямоугольников.
;В качестве примера, реализовать вычисление
;интеграла cos(x), x, exp(x).

section .bss

section .text
extern printf
extern malloc
global main
main:
    finit
    
    ret