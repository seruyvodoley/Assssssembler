format PE console

entry start

include 'win32ax.inc'

section '.data' data readable writeable
matrix db 5, 0, 1, 5
       db 3, 4, 2, 4
       db 5, 8, 6, 0
       db 1, 2, 1, 0

matrix_rows equ 4
matrix_cols equ 4
n dd 3
m dd 3

section '.text' code readable executable
start:
row:
mov esi, 0 ; индекс в строке
mov edi, 0 ; индекс в столбце
mov ebp, 1 ; счетчик цикла
mov edx, 0 ; счетчик совпадений

loop_i_row:
        mov eax, esi
        imul eax, matrix_cols ; вычислим смещение
        add eax, edi ; eax теперь содержит смещение matrix[i][j]
        movzx ebx, byte [matrix + eax]

loop_j_row:
        mov eax, esi
        imul eax, matrix_cols
        add eax, ebp
        movzx ecx, byte [matrix + eax]
        cmp ebx, ecx
        jne unequal_row
        inc edx
        jmp next_row

unequal_row:
        cmp ebp, [m]
        jae equals_row
        inc ebp
        jmp loop_j_row

equals_row:
        mov eax, [m]
        cmp edi, eax
        jae next_row
        inc edi
        cmp edi, eax
        jae next_row
        mov ebp, edi
        inc ebp
        jmp loop_i_row

next_row:
        mov eax, [n]
        cmp esi, eax
        jae print_count_row
        inc esi
        mov edi, 0
        mov ebp, 1
        jmp loop_i_row

print_count_row:
        mov eax, [n]
        sub eax, edx
        inc eax
        cinvoke printf, "%d row ", eax

col:
        mov esi, 0
        mov edi, 0
        mov ebp, 1
        mov edx, 0

loop_i_col:
        mov eax, esi
        imul eax, matrix_cols
        add eax, edi
        movzx ebx, byte [matrix + eax]

loop_j_col:
        mov eax, ebp
        imul eax, matrix_cols
        add eax, edi
        movzx ecx, byte [matrix + eax]
        cmp ebx, ecx
        jne unequal_col
        inc edx
        jmp next_col

unequal_col:
        cmp ebp, [n]
        jae equals_col
        inc ebp
        jmp loop_j_col

equals_col:
        mov eax, [n]
        cmp esi, eax
        jae next_col
        inc esi
        cmp esi, eax
        jae next_col
        mov ebp, esi
        inc ebp
        jmp loop_i_col

next_col:
        mov eax, [m]
        cmp edi, eax
        jae print_count_col
        inc edi
        mov esi, 0
        mov ebp, 1
        jmp loop_i_col

print_count_col:
        mov eax, [m]
        sub eax, edx
        inc eax
        cinvoke printf, "%d col", eax

invoke getch
invoke ExitProcess, 0


section '.idata' import readable writable
library kernel32, 'KERNEL32.DLL',\
user32, 'USER32.DLL',\
msvcrt, 'msvcrt.dll'

include 'api\kernel32.inc'
include 'api\user32.inc'
import msvcrt, printf, 'printf', \
scanf, 'scanf', getch, '_getch'