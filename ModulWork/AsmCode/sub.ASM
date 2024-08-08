include 'INCLUDE\win32a.inc'

format MS COFF

public sub_32bin_num as '_sub_32bin_num@16'

section '.data' data readable writeable
; блок констант
MAX_SIZE_BIN_NUM equ 32 ; максимальное кол-во разярдов числа
SHIFT_AMOUNT equ 4 ; кол-во байт необходимое для сдвига к следующему эл-ту
NOTATION equ 2 ; база системы счисления

section '.text' code readable executable

; Функция для вычитания двух двоичных чисел представленных ввиде массива
proc sub_32bin_num bn1, bn2, length, r
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
        mov esi, [bn1]
        mov edi, [bn2]
        mov edx, [r]
        ; зачистка используемых регистров
        xor eax, eax ; переменная для промежуточных вычислений
        xor ecx, ecx ; счетчик проденных разрядов
        xor ebx, ebx ; переменная для хранения выличины разрчда на предыдущей итерации

subtraction_loop:
        cmp ecx, [length] ; проверяем все ли задействованные разряды большего числа пройдены
        je exit

        mov eax, [esi+ecx*SHIFT_AMOUNT] ; загружаем в eax соотвественную цифры из esi
        sub eax, ebx  ; вычитаем из eax выличитину заёма с предыдушей итерации
        cmp eax, [edi+ecx*SHIFT_AMOUNT] ; проверяем возможно выполнить вычитание без заёма у страршего разряда

        jl subtraction_with_borrowing
default_subtraction:
        sub eax, [edi+ecx*SHIFT_AMOUNT] ; вычитаем из eax соответсвенную цифрвы из edi
        mov [edx+ecx*SHIFT_AMOUNT], eax  ; записываем результат вычитания на соответвенную позицию в edx

        mov ebx, 0 ; для слудующей итерации устанавливаем величну заёма 0
        inc ecx ; увеличиваем счетчик проденных разрядов
        jmp subtraction_loop
subtraction_with_borrowing:
        mov eax, NOTATION ; выполняем заём значения у следующего разряда
        sub eax, ebx  ; вычитаем из eax выличитину заёма с предыдушей итерации
        sub eax, [edi+ecx*SHIFT_AMOUNT] ; вычитаем из eax соответсвенную цифрвы из edi
        mov [edx+ecx*SHIFT_AMOUNT], eax ; записываем результат вычитания на соответвенную позицию в edx

        mov ebx, 1 ; для слудующей итерации устанавливаем величну заёма 2
        inc ecx ; увеличиваем счетчик проденных разрядов
        jmp subtraction_loop
exit:
        mov eax, ebx ; возвращаем из функции флаг переполнения(хватило или нет регистров для вычитания)
        ret ; возврат управления вызывающей стороне
endp