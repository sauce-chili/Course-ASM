include 'INCLUDE\win32a.inc'

format MS COFF

public sub_32bin_num as '_sub_32bin_num@16'

section '.data' data readable writeable
; ���� ��������
MAX_SIZE_BIN_NUM equ 32 ; ������������ ���-�� �������� �����
SHIFT_AMOUNT equ 4 ; ���-�� ���� ����������� ��� ������ � ���������� ��-��
NOTATION equ 2 ; ���� ������� ���������

section '.text' code readable executable

; ������� ��� ��������� ���� �������� ����� �������������� ����� �������
proc sub_32bin_num bn1, bn2, length, r
;    bn1 - ��������� �� ������ �����
;    bn2 - ��������� �� ������ �����
;    length - ���������� ���-�� �������� �� ���� ��������� �����
;    r - ��������� �� �������������� �����
init:
        ; �������� ������������ ���������
        xor esi,esi
        xor edi, edi
        xor edx, edx
        ; ������������� �������� �������� ����������
        mov esi, [bn1]
        mov edi, [bn2]
        mov edx, [r]
        ; �������� ������������ ���������
        xor eax, eax ; ���������� ��� ������������� ����������
        xor ecx, ecx ; ������� ��������� ��������
        xor ebx, ebx ; ���������� ��� �������� �������� ������� �� ���������� ��������

subtraction_loop:
        cmp ecx, [length] ; ��������� ��� �� ��������������� ������� �������� ����� ��������
        je exit

        mov eax, [esi+ecx*SHIFT_AMOUNT] ; ��������� � eax �������������� ����� �� esi
        sub eax, ebx  ; �������� �� eax ���������� ���� � ���������� ��������
        cmp eax, [edi+ecx*SHIFT_AMOUNT] ; ��������� �������� ��������� ��������� ��� ���� � ��������� �������

        jl subtraction_with_borrowing
default_subtraction:
        sub eax, [edi+ecx*SHIFT_AMOUNT] ; �������� �� eax �������������� ������ �� edi
        mov [edx+ecx*SHIFT_AMOUNT], eax  ; ���������� ��������� ��������� �� ������������� ������� � edx

        mov ebx, 0 ; ��� ��������� �������� ������������� ������� ���� 0
        inc ecx ; ����������� ������� ��������� ��������
        jmp subtraction_loop
subtraction_with_borrowing:
        mov eax, NOTATION ; ��������� ��� �������� � ���������� �������
        sub eax, ebx  ; �������� �� eax ���������� ���� � ���������� ��������
        sub eax, [edi+ecx*SHIFT_AMOUNT] ; �������� �� eax �������������� ������ �� edi
        mov [edx+ecx*SHIFT_AMOUNT], eax ; ���������� ��������� ��������� �� ������������� ������� � edx

        mov ebx, 1 ; ��� ��������� �������� ������������� ������� ���� 2
        inc ecx ; ����������� ������� ��������� ��������
        jmp subtraction_loop
exit:
        mov eax, ebx ; ���������� �� ������� ���� ������������(������� ��� ��� ��������� ��� ���������)
        ret ; ������� ���������� ���������� �������
endp