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
    mov   es, ax ; ES = DS (��� ������ scas ������������� ������� DS)
    lea   edi, [input_string] ; ���������� ����� ������ � EDI (����� ������ ������)
    mov   al, 0 ; ������ ����� ������
    mov   ecx, string_buf ; ������������ ����� ���������� 
    repnz scasb ; ���������, ���� ������ ������ �� ����� ����� AL, ��� ���� ECX != 0 (ZF != 0). ������ �� EDI   

    ; ����������� ����� ������
    mov   eax, string_buf
    sub   eax, ecx
    mov   [len_string], eax    
    mov   ecx, eax
    mov   ebx, ecx ; ������� ������ ����� (������������ �������� ECX)

    mov   edx, 0   ; ����� ����������� �����
    lea   edi, [input_string] ; ���������� ����� ������ � EDI
    find_word:
      mov   al,  32 ; ������
      ; ���������, ���� ������ ������ �� ����� ����� AL, ��� ���� ECX != 0
      repnz scasb
      ; �������� ����� �����
      mov   eax, ebx
      sub   eax, ecx
      dec   eax ; ������� �������� ������  
      cmp   eax, edx ; � ���� ZF
      ; ���� ������� ����� �� ������ 
      jle   skip_set_best_len ; ������� ���� SF != OF ��� ZF = 1 (a <= b) 
      ; ���� ������
      mov   edx, eax ; ����� ������������ ����� �����
      ; �������� �������� �������� ������������ ������ 
      mov   eax, [len_string]
      sub   eax, ebx
      mov   [offset_long_word], eax
      skip_set_best_len:
      mov   ebx, ecx    
      ; ��������� �� ����� ��������
      cmp   ecx, 0
      jne   find_word ; �������, ���� �� ���� (a != 0)  
    ret  

print_long_word:
    cld
    mov   eax, [offset_long_word]
    mov   eax, [offset_long_word]
    lea   esi, [input_string+eax] ; ���������� ����� ������� ����� � EDI
    ; ����� �� ����� ������
    mov   eax, [len_string]
    sub   eax, [offset_long_word]
    mov   ecx, eax
    dec   ecx  ; �� �������� ����� ������ 
    print_each_symb:
      xor eax, eax
      lodsb ; ��������� ������� ������ � al
      ; �������� � ��������
      cmp al,  32
      je end_print ; ���� ������ - ����� ����������� (a = b)
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

