format MZ                                    ; 16-��������� ��������� DOS EXE
entry code_segment:start                     ; ����� �����
stack 200h                                   ; ������ �����

DECIMAL_SIZE EQU 5

segment data_segment                         ; ������� ������

ONE dw 250                                   ; ������ �����
TWO dw 125                                   ; ������ �����
MESSAGE	db "Result is $"                     ; ����� ���������
RESULT db DECIMAL_SIZE DUP('0')              ; ����� ��� �������� ����� � ������
 
segment code_segment                         ; ������� ����

start:                                       ; ����� ����� � ���������
	mov ax, data_segment
	mov ds, ax                               ; ������������� �������� DS
	
	mov ax, [ONE]                            ; ��������� ����� �� ���������� ONE � ������� AX
	add ax, [TWO]                            ; ������� ���������� �������� AX � ���������� TWO
	
	mov cx, 10                               ; ��������� ���������� �������
	mov bx, RESULT
	add bx, DECIMAL_SIZE
	mov byte [bx], '$'                       ; ������ ������� ����� ������ � ����� ������

next:
	dec bx                                   ; ������� �� ���������� ������ ������
	xor dx, dx
	div cx                                   ; ������� ������� �� 10
	add dl, '0'                              ; ���������� � ���������� ascii-���� ���� ��� ��������� ���������������� ����� �������
	mov [bx], dl                             ; ��������� ����������� ������� � �����
	cmp bx, RESULT                           ; �������� ����� �� �� ������ ������
	jne next                                 ; ���� ��� - ��������� ��� ���������� �������

	mov ah, 09h
	mov dx, MESSAGE
	int 21h                                  ; ����� �� ����� ������ ���������
	mov ah, 09h
	mov dx, RESULT
	int 21h                                  ; ����� �� ����� ����������� ������
	
	mov ax, 4C00h                            ; ���������� ���������� ���������
	int 21h
