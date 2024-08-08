include 'INCLUDE\win32a.inc'

format MS COFF

public add_32bin_num as '_add_32bin_num@16'

section '.data' data readable writeable

MAX_SIZE_BIN_NUM equ 32
SHIFT_AMOUNT equ 4
NOTATION equ 2

section '.text' code readable executable

; Функция для сложения двух двоичных чисел представленных ввиде массива
proc add_32bin_num bn1, bn2, length, r
;    bn1 - указатель на первое число
;    bn2 - указатель на второе число
;    length - наибольшее кол-во разрядов из двух введенных чисел
;    r - указатель на резудьтирующие число
init:
        ; зачистка используемых регистров
        xor esi,esi
        xor edi, edi
        xor edx, edx
        ; инциалицируем регистры адресами указателей
        mov edx, [bn1]
        mov esi, [bn2]
        mov edi, [r]
        ; увеличиваем лимит итераций на 1, чтобы учесть возможность переполения самого старшего разряда
        inc [length]
        ; зачистка используемых регистров
        xor eax, eax ; используется для промежуточных вычислений
        xor ecx, ecx ; счетчик проёденных разрядов
        xor ebx, ebx ; переменная хранящая величину переполения с передыдущей итерации

addition_loop:
        cmp ecx, MAX_SIZE_BIN_NUM ; проверяем не пройдено максимально возможно число разрядов
        je exit
        cmp ecx, [length] ; проверяем все ли задействованные разряды пройдены
        je exit
        mov eax, [edx+ecx*SHIFT_AMOUNT] ; загружаем соостветсвенное ecx значение разряда числа из edx в eax
        add eax, [esi+ecx*SHIFT_AMOUNT] ; складываем соостветсвенное ecx значение разряда числа из esi с eax
        add eax, ebx ; добавляем величину переполения с предыдущей итерации

        cmp eax, NOTATION ; проверяем переполнен ли текущей разряд
        jl non_overflow

overflow:
        sub eax, NOTATION ; если текущей разряд переполнен, то вычитаем из него базу системы счисления, т.е 2
        mov [edi+ecx*SHIFT_AMOUNT], eax ; записываем результат на соответвенную ecx позицию в edi
        mov ebx, 1 ; для следующей итерации устанавливаем значение переполения разряда равно 1
        inc ecx ; увеличиваем счетчик пройденных разрядов
        jmp addition_loop

non_overflow:
        mov [edi+ecx*SHIFT_AMOUNT], eax ; т.к текущий разряд не переполнен, то записываем результат сложения на соответвенную ecx позицию в edi
        mov ebx, 0 ; для следующей итерации устанавливаем значение переполения разряда равно 0
        inc ecx ; увеличиваем счетчик пройденных разрядов
        jmp addition_loop
exit:
        mov eax, ebx  ; возвращаем из функции флаг переполнения(хватило или нет регистров для сложения)
        ret ; возврат управления вызывающей стороне
endp