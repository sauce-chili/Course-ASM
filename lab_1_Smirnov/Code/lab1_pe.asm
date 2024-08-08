format PE console                            ; 32-разрядная консольная программа WINDOWS EXE
entry start                                  ; точка входа

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

ONE dw 250                                   ; первое число
TWO dw 150                                   ; второе число
MESSAGE db "Sum of two number: %d",0                  ; текст сообщения

section '.code' code readable executable     ; секция кода

start:                                       ; точка входа в программу
        xor eax, eax                             ; обнуление регистра EAX
        mov ax, [ONE]                            ; переслать слово из переменной ONE в регистр AX
        add ax, [TWO]                            ; сложить содержимое регистра AX с переменной TWO
        
        ccall [printf], MESSAGE, eax
        ccall [getchar]
        stdcall [ExitProcess],0
