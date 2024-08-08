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

arr dw 1, -2, 3, 5, -9, 5, -2, 2, 1, -4


MESSAGE_POS_SUM db "Sum positive numbers: %hd. ", 0
MESSAGE_NEG_SUM db "Sum negative numbers: %hd. ", 0

sum_pos dw 0
sum_neg dw 0

section '.code' code readable executable
main:
        ; �������� ���������
        xor esi, esi
        xor eax, eax
        xor cx,cx

        ; ����� ������� ��-�� �������
        mov esi, arr
        mov ch, 0
        jmp next

        positive:
                add [sum_pos], ax
                jmp next

        negative:
                add [sum_neg], ax
                jmp next
        next:
                cmp ch, 10
                je exit

                mov ax, [esi]

                inc ch
                add esi, 2

                cmp ax, 0
                jg positive
                jl negative
        exit:
                 ; �������� ��������, � ������� ����� ���������� ����� �����
                 xor ebx, ebx
                 xor edx, edx

                 ; ������� ����� ������������� �����
                 mov dx, [sum_pos]
                 push edx
                 push MESSAGE_POS_SUM
                 call [printf]

                 ; ������� ����� ������������� �����
                 mov bx, [sum_neg]
                 push ebx
                 push MESSAGE_NEG_SUM
                 call [printf]

                 ; ���������� �������
                 call [getchar]
                 stdcall [ExitProcess],0
