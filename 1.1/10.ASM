format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable
    inputX db 'Enter X: ', 0
    inputY db 'Enter Y: ', 0
    formatNum db '%lf', 0
    result db "Result is %.2lf", 0


    X dq 0.0
    Y dq 0.0
    Z dq 0.0
    One dq 1.0   ; ????????? 1.0

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

    fld qword [X]
    fmul qword [Y]  ; ???????? X ?? Y
    fld qword [One]  ; ????????? 1.0

    fxch
    fstp qword [Z]


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






