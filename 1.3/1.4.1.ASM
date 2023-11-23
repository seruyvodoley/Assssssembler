format PE console 4.0

entry start

include 'win32a.inc'

define  string_buf  512

section '.data' data readable writable
        char_print         db   '%c', 0
        msg_string         db   'Enter string: ', 10, 0
        input_string       db   string_buf dup(0)
        offset_long_word   dd   0
        len_string         dd   0

section '.code' code readable executable

find_long_word:
    cld ; DL = 0
    mov   ax, ds
    mov   es, ax ; ES = DS (для команд scas инициализация адресом DS)
    lea   edi, [input_string] ; записываем адрес строки в EDI (адрес начала строки)
    mov   al, 0 ; символ конца строки
    mov   ecx, string_buf ; максимальная длина повторений 
    repnz scasb ; повторять, пока символ строки не будет равен AL, или пока ECX != 0 (ZF != 0). читает из EDI   

    ; высчитываем длину строки
    mov   eax, string_buf
    sub   eax, ecx
    mov   [len_string], eax    
    mov   ecx, eax
    mov   ebx, ecx ; текущее начало слова (относительно счётчика ECX)

    mov   edx, 0   ; длина наибольшего слова
    lea   edi, [input_string] ; записываем адрес строки в EDI
    find_word:
      mov   al,  32 ; пробел
      ; повторять, пока символ строки не будет равен AL, или пока ECX != 0
      repnz scasb
      ; сравнить длину слова
      mov   eax, ebx
      sub   eax, ecx
      dec   eax ; убираем учтенный пробел  
      cmp   eax, edx ; в флаг ZF
      ; если текущее слово не больше 
      jle   skip_set_best_len ; переход если SF != OF или ZF = 1 (a <= b) 
      ; если больше
      mov   edx, eax ; новая максимальная длина слова
      ; вычислим величину смещения относительно начала 
      mov   eax, [len_string]
      sub   eax, ebx
      mov   [offset_long_word], eax
      skip_set_best_len:
      mov   ebx, ecx    
      ; проверяем на конец итерации
      cmp   ecx, 0
      jne   find_word ; переход, если не ноль (a != 0)  
    ret  

print_long_word:
    cld
    mov   eax, [offset_long_word]
    mov   eax, [offset_long_word]
    lea   esi, [input_string+eax] ; записываем адрес нужного слова в EDI
    ; длина до конца строки
    mov   eax, [len_string]
    sub   eax, [offset_long_word]
    mov   ecx, eax
    dec   ecx  ; не учитывая конец строки 
    print_each_symb:
      xor eax, eax
      lodsb ; загрузить текущий символ в al
      ; сравнить с пробелом
      cmp al,  32
      je end_print ; если пробел - слово закончилось (a = b)
      push ecx
      cinvoke printf, char_print, eax
      pop ecx
      loop print_each_symb     
    end_print:
    mov   eax, 10
    cinvoke printf, char_print, eax  
    ret
    
start:
    
    cinvoke printf, msg_string
    cinvoke gets, input_string
    call    find_long_word
    call    print_long_word
    invoke getch
    invoke ExitProcess, 0

section '.idata' import data readable
 
        library msvcrt,'MSVCRT.DLL',\
                kernel32,'KERNEL32.DLL'
 
        import kernel32,\
            ExitProcess, 'ExitProcess',\
               sleep,'Sleep'
 
        import msvcrt,\
               gets,'gets',\
               printf,'printf', \
               getch, '_getch'

