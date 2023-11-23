format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        inputX db 'Enter X: ', 0
        inputY db 'Enter Y: ', 0
        formatNum db '%d', 0
        result db "Result is %d",0


        NULL = 0

        X dd ?
        Y dd ?








section '.code' code readable writeable executable

start:

        push inputX
        call [printf]

        push X
        push formatNum
        call [scanf]

        push inputY
        call [printf]

        push Y
        push formatNum
        call [scanf]

        mov eax, [Y]
        mov ecx, [X]
        mov edx, 2

        add eax, 1                        ;y+1
        cdq
        idiv ecx                          ;(y+1)/x
        neg eax                           ;-(y+1)/x
        add eax,2                         ;2-(y+1)/x
        mov ecx, [Y]
        imul ecx                          ;y(2-(y+1)/x)



        push eax                         ;вывод z
        push result
        call [printf]


        call [getch]

        push NULL
        call [ExitProcess]


section '.idata' data import readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel, \
               ExitProcess, 'ExitProcess'

        import msvcrt, \
               printf, 'printf', \
               getch, '_getch', \
               scanf, 'scanf'
  
