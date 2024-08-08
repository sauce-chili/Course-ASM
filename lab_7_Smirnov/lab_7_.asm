format PE console                            ; 32-��������� ���������� ��������� WINDOWS EXE
entry main                                  ; ����� �����

include 'include\win32a.inc'

section '.idata' import data readable        ; ������ ������������� �������

library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  msvcrt,\
        printf,'printf',\
        getchar,'_fgetchar'

section '.data' data readable writeable      ; ������ ������

; 8-byte float
a dq 1.6
b dq 2.14
c dq 3.54
tmp dq ?
result dq ?

_MSG db "(a / b)*(a + b + c) = %f",0                 ; ����� ���������

section '.code' code readable executable     ; ������ ����

main:                                       ; ����� ����� � ���������
        finit                                ; init coprocessor
        fld [a]                              ; load variable a in stack
        fadd [b]                             ; add val b to top stack
        fadd[c]                              ; add val c to top stack
        fst [tmp]                            ; load top stack to tmp var

        fld [a]                              ; load a variable in stack
        fdiv [b]                             ; div top stack by val b
        fmul [tmp]                           ; (a/b) * (a+b+c)
        fst [result]                         ; load value from stack to var result
        
        ccall [printf],_MSG, dword [result], dword [result+4]
        ccall [getchar]
        stdcall [ExitProcess],0
