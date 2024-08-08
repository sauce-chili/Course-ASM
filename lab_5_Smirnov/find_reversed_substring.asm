format MS COFF

include '_include/macro/proc32.inc'

section '.text' code readable executable

public find_reversed_substring as '_find_reversed_substring'


proc find_reversed_substring c src: DWORD, len: DWORD, substr: DWORD, sublen: DWORD
start:
        ; сохраняем используемые регистры по соглашению  cdecl
        push ebp
        mov ebp, esp
        push ebx
        push esi
        push edi

        xor esi, esi
        xor ecx, ecx
        mov esi, [substr]
        mov ecx, [sublen]


        ; выделение места под развернутую строку
        sub esp, ecx
        xor edi, edi
        mov edi, esp

        ; сохраняем указатель на развернутую строку
        xor edx, edx
        mov edx, edi

        ; делим длину строку на 2 так как нам нужно идти до середины слова
        shr ecx, 1
        jz preparation_search

        ; разворачиваем строку
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
        mov ebx, [src]

        ; зачищаем регистры для будущей работы
        xor eax, eax
        xor esi, esi
        xor edi, edi
        xor ecx, ecx


search_loop:
        ; заполняем регистры для поэлментного сравнения строк
        mov esi, ebx  ; устанавливаем элемент с к-го будет начинаться итерация
        mov edi, edx  ; восстанвливаем подстроку с прошлрй итерации
        mov ecx, [sublen] ; устанавливаем кол-во итерация

         ; ; итерируемся по строке пока не встретим разных элементов на соответственных позициях или не пройдем все слово
        repe cmpsb
        je equls_substr  ; проверяем ZF флаг, если он 1, значит найдено вхождение подстроки
        jnz not_equls_substr

not_equls_substr:
        inc ebx  ; увеличиваем адрес с которого будем начинать поиск на следующей итерации
        ; проверяем кол-во пройденных символов
        xor eax, eax
        mov eax, ebx
        sub eax, [src] ; получаем кол-во пройденных эл-ов
        inc eax  ; +1 тк требуются все элменты отрезка(вся длина)
        cmp eax, [len]
        jae substr_not_found ; если прошли все эл-ты строки или больше, возращаем -1
        jmp search_loop ; если прошли < lеn эл-ов, то возвращаемся в основной цикл 

equls_substr:
        sub ebx, [src] ; вычисялем индекс первого символа подстроки внутри строки
        xor eax, eax
        mov eax, ebx ; перемещаем разницу в аккумулятор для возврата из фнукции
        jmp exit ; пеерехим к метке восстановления регистров

substr_not_found:
        xor eax, eax
        mov eax, -1 ; возвращаем код ошибки, что подстрока не найдена
        jmp exit ; пеерехим к метке восстановления регистров

exit:
        ; Восстановление использованных регистров
        pop edi
        pop esi
        pop ebx
        mov esp, ebp
        pop ebp
        
        ; передача управления вызывающей стороне
        leave
        ret
endp





