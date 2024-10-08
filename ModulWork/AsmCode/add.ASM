include 'INCLUDE\win32a.inc'

format MS COFF

public add_32bin_num as '_add_32bin_num@16'

section '.data' data readable writeable

MAX_SIZE_BIN_NUM equ 32
SHIFT_AMOUNT equ 4
NOTATION equ 2

section '.text' code readable executable

; ������� ��� �������� ���� �������� ����� �������������� ����� �������
proc add_32bin_num bn1, bn2, length, r
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
        mov edx, [bn1]
        mov esi, [bn2]
        mov edi, [r]
        ; ����������� ����� �������� �� 1, ����� ������ ����������� ����������� ������ �������� �������
        inc [length]
        ; �������� ������������ ���������
        xor eax, eax ; ������������ ��� ������������� ����������
        xor ecx, ecx ; ������� ��������� ��������
        xor ebx, ebx ; ���������� �������� �������� ����������� � ����������� ��������

addition_loop:
        cmp ecx, MAX_SIZE_BIN_NUM ; ��������� �� �������� ����������� �������� ����� ��������
        je exit
        cmp ecx, [length] ; ��������� ��� �� ��������������� ������� ��������
        je exit
        mov eax, [edx+ecx*SHIFT_AMOUNT] ; ��������� ��������������� ecx �������� ������� ����� �� edx � eax
        add eax, [esi+ecx*SHIFT_AMOUNT] ; ���������� ��������������� ecx �������� ������� ����� �� esi � eax
        add eax, ebx ; ��������� �������� ����������� � ���������� ��������

        cmp eax, NOTATION ; ��������� ���������� �� ������� ������
        jl non_overflow

overflow:
        sub eax, NOTATION ; ���� ������� ������ ����������, �� �������� �� ���� ���� ������� ���������, �.� 2
        mov [edi+ecx*SHIFT_AMOUNT], eax ; ���������� ��������� �� ������������� ecx ������� � edi
        mov ebx, 1 ; ��� ��������� �������� ������������� �������� ����������� ������� ����� 1
        inc ecx ; ����������� ������� ���������� ��������
        jmp addition_loop

non_overflow:
        mov [edi+ecx*SHIFT_AMOUNT], eax ; �.� ������� ������ �� ����������, �� ���������� ��������� �������� �� ������������� ecx ������� � edi
        mov ebx, 0 ; ��� ��������� �������� ������������� �������� ����������� ������� ����� 0
        inc ecx ; ����������� ������� ���������� ��������
        jmp addition_loop
exit:
        mov eax, ebx  ; ���������� �� ������� ���� ������������(������� ��� ��� ��������� ��� ��������)
        ret ; ������� ���������� ���������� �������
endp