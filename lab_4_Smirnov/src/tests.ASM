format PE console                            ; 32-????????? ?????????? ????????? WINDOWS EXE
entry main                                  ; ????? ?????

include 'include\win32a.inc'

section '.idata' import data readable        ; ?????? ????????????? ???????

library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  msvcrt,\
        printf,'printf',\
        getchar,'_fgetchar',\
        strrev,'_strrev',\
        strlen,'strlen'

section '.data' data readable writeable

MSG_TEMPLATE db "Start index word: %d.", 0

string db "Hello, Alex and Mark", 0
len dd ?
substr db "dna", 0
sublen dd ?

section '.code' code readable executable
main:
        push edi
        push esi
        push ebx

        ; ��������� ����� ������������ ������
        xor eax, eax ; ������� ����������� �� ������
        push string ; ������ ������ � ���� ��� ���������� ���������
        call [strlen] ; �������� ��-���� �������, ������� �������� ������ �� ����� � ��������� � ����� � eax
        mov [len], eax ; �������� ��������� ������ �������

        ; ��������� ����� ��������� (�������� ��������� ���, ��� ����)
        xor eax, eax
        push substr
        call [strlen]
        mov[sublen], eax

        xor esi, esi
        xor ecx, ecx
        mov esi, substr
        mov ecx, sublen

        sub esp, ecx
        xor edi, edi
        mov edi, esp

        xor edx, edx
        mov edx, edi

        shr ecx, 1
        js preparation_search

        reverse_loop:
                mov al, [esi]
                mov ah, [edi]
                mov [esi], ah
                mov [edi], al
                inc esi
                inc edi
                loop reverse_loop



preparation_search:
        cld
        xor ebx, ebx
        mov ebx, string

        xor eax, eax
        xor esi, esi
        xor edi, edi
        xor ecx, ecx


search_loop:
        ; ��������� �������� ��� ������������� ��������� �����
        mov esi, ebx  ; ������������� ������� � ������� ����� ��������
        mov edi, substr ; ������������� ���������
        mov ecx, [sublen] ; ������������� ���-�� ��������

         ; ����������� �� ������ ���� �� �������� ������ ��������� �� �������������� �������� ��� �� ������� ��� �����
        repe cmpsb
        je equls_substr  ; �������� ZF ����, ���� �� 1, ������ ������� ��������� ���������
        jnz not_equls_substr

not_equls_substr:
        inc ebx ; ����������� ����� � �������� ����� �������� ����� �� ��������� ��������
        ; ��������� ���-�� ���������� ��������
        xor eax,eax
        mov eax, ebx
        sub eax, string ; ��������� ���-�� ���������� ��-��
        inc eax  ; +1 �� �������� ��� �������� �������(��� �����)
        cmp eax, [len] ; ����������
        jae substr_not_found ; ���� ������ ��� ��-�� ������ ��� ������, �� ���������� -1
        jmp search_loop ; ���� ������ < len ��-�� �� ���������� � �������� ����

equls_substr:
        sub ebx,string ; ��������� ������ ������� ������� ��������� ������ ������
        xor eax,eax
        mov eax, ebx ; ���������� ������� � ����������� ��� ����������� ������
        jmp exit ; ��������� � ��������� ���������� ���������

substr_not_found:
        xor eax,eax
        mov eax, -1 ; ����� � ����������� ��� ������
        jmp exit ; ��������� � ��������� ���������� ���������

exit:
        push eax ; ������ � ���� �������� ������������
        push MSG_TEMPLATE ; ������ � ���� ��������������� ������ ���������
        call [printf] ; ������� ���������� �����
        call [getchar] ; ���������� ������ �� ������������
        stdcall [ExitProcess],0 ; ��������� ������ ��������� � ����� 0