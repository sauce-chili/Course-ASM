; ASM код на FASM для разворачивания строки

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writeable
    message db 'Hello, World!', 0
    msglen equ $-message

section '.code' code readable executable
start:
    mov esi, message
    mov edi, message
    add edi, msglen - 1

reverse_loop:
    mov al, [esi]
    mov ah, [edi]
    xchg al, ah
    mov [esi], al
    mov [edi], ah

    inc esi
    dec edi
    cmp esi, edi
    jge done

    jmp reverse_loop

done:
    ; Вывод строки
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, msglen
    int 0x80

    ; Завершение программы
    xor eax, eax
    inc eax
    xor ebx, ebx
    int 0x80

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', \
            msvcrt, 'msvcrt.dll'

    import kernel32, \
           ExitProcess, 'ExitProcess'

    import msvcrt, \
           printf, 'printf'