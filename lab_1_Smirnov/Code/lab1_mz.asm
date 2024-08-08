format MZ                                    ; 16-разрядная программа DOS EXE
entry code_segment:start                     ; точка входа
stack 200h                                   ; размер стека

DECIMAL_SIZE EQU 5

segment data_segment                         ; сегмент данных

ONE dw 250                                   ; первое число
TWO dw 125                                   ; второе число
MESSAGE	db "Result is $"                     ; текст сообщения
RESULT db DECIMAL_SIZE DUP('0')              ; буфер для перевода числа в строку
 
segment code_segment                         ; сегмент кода

start:                                       ; точка входа в программу
	mov ax, data_segment
	mov ds, ax                               ; инициализация регистра DS
	
	mov ax, [ONE]                            ; переслать слово из переменной ONE в регистр AX
	add ax, [TWO]                            ; сложить содержимое регистра AX с переменной TWO
	
	mov cx, 10                               ; основание десятичной системы
	mov bx, RESULT
	add bx, DECIMAL_SIZE
	mov byte [bx], '$'                       ; запись символа конца строки в конец буфера

next:
	dec bx                                   ; переход на предыдущий символ буфера
	xor dx, dx
	div cx                                   ; деление остатка на 10
	add dl, '0'                              ; добавление к результату ascii-кода нуля для получения соответствующего цифре символа
	mov [bx], dl                             ; пересылка полученного символа в буфер
	cmp bx, RESULT                           ; проверка дошли ли до начала буфера
	jne next                                 ; если нет - повторяем для следующего разряда

	mov ah, 09h
	mov dx, MESSAGE
	int 21h                                  ; вывод на экран текста сообщения
	mov ah, 09h
	mov dx, RESULT
	int 21h                                  ; вывод на экран содержимого буфера
	
	mov ax, 4C00h                            ; корректное завершение программы
	int 21h
