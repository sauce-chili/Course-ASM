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

arr dw 1, -2, 3, 5, -9, 5, -2, 2, 1, -4


MESSAGE_POS_SUM db "Sum positive numbers: %hd. ", 0
MESSAGE_NEG_SUM db "Sum negative numbers: %hd. ", 0

sum_pos dw 0
sum_neg dw 0

section '.code' code readable executable
main:
        ; зачистка регистров
        xor esi, esi
        xor eax, eax
        xor cx,cx

        ; адрес первого эл-та массива
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
                 ; зачищаем регистры, в который будем копировать суммы чисел
                 xor ebx, ebx
                 xor edx, edx

                 ; выводим сумму положительных чисел
                 mov dx, [sum_pos]
                 push edx
                 push MESSAGE_POS_SUM
                 call [printf]

                 ; выводим сумму отрицательных чисел
                 mov bx, [sum_neg]
                 push ebx
                 push MESSAGE_NEG_SUM
                 call [printf]

                 ; удерживаем консоль
                 call [getchar]
                 stdcall [ExitProcess],0
