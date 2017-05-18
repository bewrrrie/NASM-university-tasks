;Rectangle method (definite integral).
;As an example integrate functions cos(x), x, exp(x).

section .bss
    a: resq 1;      |definite integral with
    b: resq 1;      |integration borders - [a,b].
    tmp: resq 1;    - temporary real number storage.

    n: resd 1;  segments quantity.

section .data
    format_input: dd "%lf %lf %d ", 10, 0
    format_output: dd "%lf ", 10, 0

section .text
extern scanf
extern scanf_s
extern printf
global main


;USER INPUT:
;   left integration border;
;   right integration border;
;   segments quantity (segmentation of integration area).

main:
    mov     ebp, esp;   for correct debugging

    push    n
    push    b
    push    a
    push    format_input
    call    scanf
    add     esp, 16

    call    integrateFunction
    call    printCoProcessorsStackTop

    ret


Function:
;Function that is gonna be integrated.
;(When called it is supposed that argument is in the top of coprocessor stack)
    fcos
    
    ;fstp    st0
    ;fld1
    ; - CONST. function, f(x) = 1;
    ret


integrateFunction:
    finit
;                           STACK STATES CHANGING:
;                          st0:     |st1:       |st2:           |st3:
;                                   |           |               |
    fldz;                  summ = 0 |           |               |
    fld     qword [b];      b       | summ = 0  |               |
    fld     qword [a];      a       | b         | summ = 0      |

    fcom    st1
    fstsw   ax
    sahf
    jc      OK
    jz      EQUALS; Return zero if a=b.

;   This block is executed when a>b:
    fxch    st1

    OK:
;                          st0:     |st1:       |st2:           |st3:
    fsubp   st1, st0;       (b-a)   | summ      |               |
    fild    qword [n];      n       | (b-a)     | summ          |
    fdivp   st1, st0;       (b-a)/n | summ      |               |
    fld     qword [a];      a       | (b-a)/n   | summ          |
;                                   |           |               |
    fldz;                   i = 0   | a         |step:=(b-a)/n  | summ
    mov     ecx, [n]
    SUMM_CYCLE:;            st0:    |st1:   |st2:   |st3:       |st4:
;                            i      | a     | step  | summ      |
        fld     st0;         i      | i     | a     | step      | summ
        fmul    st0, st3;    i*step | i     | a     | step      | summ
        fadd    st0, st2;  i*step+a | i     | a     | step      | summ

;                               st0:     |st1:   |st2:   |st3:       |
        fadd    st0, st0;   2*(i*step+a) | i     | a     | step      | summ
        fadd    st0, st3; (2i+1)*step+2*a| i     | a     | step      | summ
        
        fld1;                   1   |i*step+a| i      | a       | step  | summ
        fld1;                   1   |   1    |i*step+a| i       | a     | step   | summ
        faddp   st1, st0;        2  |i*st.+a| i     | a         | step  | summ

        fdivp   st1, st0;    (..)/2 | i     | a     | step      | summ

        call    Function;    F(..)  | i     | a     | step      | summ
        fmul    st0, st3; F(..)*step| i     | a     | step      | summ
;                                   |       |       |
        faddp   st4, st0;    i      | a     | step  | summ + F(..)
;                                   |       |       |
        fld1;                1      | i     | a     | step      | summ + F(..)
        faddp   st1, st0;    i + 1  | a     | step  | summ+F(..)|
    loop    SUMM_CYCLE
    fstp    st0;              a     | step  | RESULT
    EQUALS:
    fstp    st0
    fstp    st0

;    mov     eax, [esp]
;    cmp     eax, 0
;    je      END
;    fchs
;    END:
    ret


printCoProcessorsStackTop:
    sub     esp, 8
    fst     qword [esp]
    lea     eax, [format_output]
    push    eax
    call    printf
    add     esp, 12

    ret
