format PE console                            ; 32-��������� ���������� ��������� WINDOWS EXE
entry start                                  ; ����� �����

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

ONE dw 250                                   ; ������ �����
TWO dw 150                                   ; ������ �����
MESSAGE db "Sum of two number: %d",0                  ; ����� ���������

section '.code' code readable executable     ; ������ ����

start:                                       ; ����� ����� � ���������
        xor eax, eax                             ; ��������� �������� EAX
        mov ax, [ONE]                            ; ��������� ����� �� ���������� ONE � ������� AX
        add ax, [TWO]                            ; ������� ���������� �������� AX � ���������� TWO
        
        ccall [printf], MESSAGE, eax
        ccall [getchar]
        stdcall [ExitProcess],0
