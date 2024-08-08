format PE console                            ; 32-разрядная консольная программа WINDOWS EXE
entry main                                  ; точка входа

include 'include\win32a.inc'

section '.idata' import data readable        ; секция импортируемых функций

library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'

import  kernel,\
        ExitProcess,'ExitProcess'

import  msvcrt,\
        printf,'printf',\
        getchar,'_fgetchar'

section '.data' data readable writeable      ; секция данных

a dw 250                                   ; первое число
b dw -50                                    ; второе число
c dw 23                                    ; третье  число

MESSAGE db "Result: %d",0                 ; текст сообщения

section '.code' code readable executable     ; секция кода

main:                                       ; точка входа в программу
        ; зачистка регистров
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        ; записываем данные из переменных a,b,c
        mov ax, [a]
        mov bx, [b]
        mov cx, [c]

        ; расширяем ax до dx:ax для хранения знака числа,результата  деления
        cwd
        idiv bx ; (a/b)
        div bx,
        mov dx, ax ; сохраняем результат деления в dx

        ; вычисляем (a + b + c) результат записываем в ax
        add bx, cx
        add bx, [a]
        mov ax, bx

        ; вычисляем (a / b)*(a + b + c)
        imul dx

        ; выводим результат в консоль
        ccall [printf], MESSAGE, eax
        ; очищаем память
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        ccall [getchar]
        stdcall [ExitProcess],0
