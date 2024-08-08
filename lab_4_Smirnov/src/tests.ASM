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

        ; вычисляем длину оригинальной строки
        xor eax, eax ; очищаем аккумулятор от мусора
        push string ; кладем строку в стек для дельнейшей обработки
        call [strlen] ; вызываем си-шную функцию, которая забирает строку из стака и возразает её длину в eax
        mov [len], eax ; забираем результат работы функции

        ; вычисляем длину подстроки (действия анлогичны тем, что выше)
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
        ; заполняем регистры для поэлементного сравнения строк
        mov esi, ebx  ; устанавливаем элемент с котрого будет итерация
        mov edi, substr ; восставливаем подстроку
        mov ecx, [sublen] ; устанавливаем кол-во итераций

         ; итерируемся по строке пока не встретим разных элементов на соответсвенных позициях или не пройдем все слово
        repe cmpsb
        je equls_substr  ; проверям ZF флаг, если он 1, значит найдено вхождение подстроки
        jnz not_equls_substr

not_equls_substr:
        inc ebx ; увеличиваем адрес с которого будем начинать поиск на следующей итерации
        ; проверяем кол-во пройденных символов
        xor eax,eax
        mov eax, ebx
        sub eax, string ; вычисляем кол-во пройденных эл-ов
        inc eax  ; +1 тк требется все элементы отрезка(вся длина)
        cmp eax, [len] ; сравниваем
        jae substr_not_found ; если прошли все эл-ты строки или больше, то возвращаем -1
        jmp search_loop ; если прошли < len эл-ов то возвраемся в основной цикл

equls_substr:
        sub ebx,string ; вычисляем индекс первого символа подстроки внутри строки
        xor eax,eax
        mov eax, ebx ; перемещаем разницу в аккумулятор для дальнейшего вывода
        jmp exit ; переходим к состоянию завершения программы

substr_not_found:
        xor eax,eax
        mov eax, -1 ; кладём в аккумулятор код ошибки
        jmp exit ; переходим к состоянию завершения программы

exit:
        push eax ; кладем в стек значение аккумулятора
        push MSG_TEMPLATE ; кладем в стек форматированный шаблон сообщения
        call [printf] ; выводим содержимое стека
        call [getchar] ; дожилаемся ответа от пользователя
        stdcall [ExitProcess],0 ; завершаем работу программы с кодом 0