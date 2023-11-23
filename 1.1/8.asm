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

        mov eax, [X]
        mov ecx, [Y]
        mov edx, 0                       ;обнуляю для получения остатка

        mul ecx                          ;xy
        dec eax                          ;xy-1
        add ecx, [X]                     ;x+y
        cdq
        idiv ecx                         ;(xy-1)/(x+y)


        push eax                        ;вывод z
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
  
