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
        tickets ticket 'to1','from1','date1',100
                ticket 'to2','from2','date2',110
                ticket 'to3','from3','date3',120
                ticket 'to4','from4','date4',130
                ticket 'to5','from5','date5',140
        string_input db '%s',0
        int_output db '%d',15,0
        n dd 5
        size_of dd 94

        write_file_name db 'in',0
        w_mode db 'w',0
        file_d dd 0

section '.code' code readable writeable executable

start:
        invoke fopen, write_file_name, w_mode
        ; дескриптор файла
        mov [ds:file_d], eax
        mov eax, [ds:n]
        imul [ds:size_of]
        mov ecx, 1
        invoke fwrite, tickets, ecx, eax, [ds:file_d]
        invoke fclose, [ds:file_d]


        invoke getch
        invoke ExitProcess, 0

section '.idata' data import readable
  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf, 'scanf', fopen, 'fopen', fwrite, 'fwrite', fclose, 'fclose'