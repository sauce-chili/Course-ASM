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

a dw 250                                   ; ������ �����
b dw -50                                    ; ������ �����
c dw 23                                    ; ������  �����

MESSAGE db "Result: %d",0                 ; ����� ���������

section '.code' code readable executable     ; ������ ����

main:                                       ; ����� ����� � ���������
        ; �������� ���������
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        ; ���������� ������ �� ���������� a,b,c
        mov ax, [a]
        mov bx, [b]
        mov cx, [c]

        ; ��������� ax �� dx:ax ��� �������� ����� �����,����������  �������
        cwd
        idiv bx ; (a/b)
        div bx,
        mov dx, ax ; ��������� ��������� ������� � dx

        ; ��������� (a + b + c) ��������� ���������� � ax
        add bx, cx
        add bx, [a]
        mov ax, bx

        ; ��������� (a / b)*(a + b + c)
        imul dx

        ; ������� ��������� � �������
        ccall [printf], MESSAGE, eax
        ; ������� ������
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        ccall [getchar]
        stdcall [ExitProcess],0
