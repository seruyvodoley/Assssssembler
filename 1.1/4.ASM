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
       ; Z dd ?


section '.code' code readable writeable executable

start:

        push inputX                       ;Insert x
        call [printf]

        push X
        push formatNum
        call [scanf]

        push inputY                        ;Insert y
        call [printf]

        push Y
        push formatNum
        call [scanf]


        mov eax, [X]                     ;��������� �������� ���������� X �� ������ � ������� EAX. ������ EAX �������� �������� X.

        sub eax, [Y]                     ;�������� �� eax y
        mov ecx, eax                     ;�������� eax � ecx



        mov ebx, [X]                     ;x � ebx

        imul ebx, [Y]                    ;y �� ebx

        add eax, ebx                     ;ebx + eax = (X - Y + X * Y)
        mov ecx, eax
        mov eax, [X]


        cdq
        idiv ecx                         ;����� eax �� ecx /(x-y)

        push eax                         ;����� z
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