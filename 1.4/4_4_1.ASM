format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        struct ticket
            destiny db 30 dup(0)
            starting db 30 dup(0)
            date db 30 dup(0)
            cost dd 0
        ends
        tickets ticket ?,?,?,?
                ticket ?,?,?,?
                ticket ?,?,?,?
                ticket ?,?,?,?
                ticket ?,?,?,?
        string_input db '%s',0
        int_output db '%d',10,0
        struct_output db '%s, %s, %s, %d',10,0
        n dd 5
        size_of dd 94
        i dd 0

        read_file_name db 'in',0
        write_file_name db 'out',0
        w_mode db 'w',0
        r_mode db 'r',0
        read_file_d dd 0
        write_file_d dd 0
        size dd 0

section '.code' code readable writeable executable

start:
        invoke fopen, read_file_name, r_mode

        ; сохранение дескриптора файла
        mov [ds:read_file_d], eax

        ; вывчислить количество имеющихся байт
        mov eax, [ds:n]
        imul [ds:size_of]
        ; хотим выбрать 1 элемент
        mov ecx, 1

        invoke fread, tickets, ecx, eax, [ds:read_file_d]

        invoke fclose, [ds:read_file_d]

        invoke fopen, write_file_name, w_mode

        mov [ds:write_file_d], eax


        mov [ds:i], 0
        looop2:
                ; Расчет смещения к началу структуры
                mov eax, [ds:i]
                imul [ds:size_of]

                ; расчет поля cost
                mov edx, eax
                add edx, tickets.cost

                ; изменение cost
                push eax
                mov eax, 99
                add eax, [edx]
                mov [edx], eax
                pop eax

                inc [ds:i]
                mov edx, [ds:i]
                cmp edx, 5
                jne looop2

        ; расчет количества байт для записи в файл
        mov eax, [ds:n]
        imul [ds:size_of]
        mov ecx, 1
        mov [ds:i], 0

                looop:
                ; расчет смещения к началу структуры
                mov eax, [ds:i]
                imul [ds:size_of]
                mov [ds:size], eax

                ; расчет полей
                mov ebx, [ds:size]
                add ebx, tickets.destiny


                mov ecx, [ds:size]
                add ecx, tickets.starting


                add eax, tickets.date


                mov edx, [ds:size]
                add edx, tickets.cost


                invoke printf, struct_output, ebx, ecx, eax, [edx]

                inc [ds:i]
                mov edx, [ds:i]
                cmp edx, 5
                jne looop


        ; запись в файл и закрытие
        invoke fwrite, tickets, ecx, [ds:size], [ds:write_file_d]
        invoke fclose, [ds:write_file_d]




        invoke getch
        invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf, 'scanf', fopen, 'fopen', fwrite, 'fwrite', fclose, 'fclose', fread, 'fread'