.globl __start

.data
  input_file: .asciiz "output.txt"  # Имя файла с матрицей
  output_file: .asciiz "output2.txt"  # Имя файла с матрицей
  matrix: .zero 16        # Буфер для считывания матрицы (максимум 4 строки x 4 столбца)
  O_RDONLY: .word 0b0000001       
  O_WRONLY: .word 0b0000010

.text

__start:
  # Открываем файл "input.txt" для чтения
  li a0, 13             # Ecall Code для открытия файла
  la a1, input_file     # Адрес строки с именем файла
  lw a2, O_RDONLY          # Открываем файл для чтения (O_RDONLY)
  ecall

  # Считываем матрицу из файла
  li a0, 14             # Ecall Code для чтения из файла
  li a1, 3              # Передаем дескриптор файла в a1
  la a2, matrix         # Адрес буфера для чтения
  li a3, 64
  ecall

  # Закрываем файл
  li a0, 16             # Ecall Code для закрытия файла
  li a1, 3              # Передаем дескриптор файла в a1
  ecall
  
  la t1, matrix              # Текущий индекс

  # Инициализация переменных i и j
  li a0, 0  # i
  li a1, 0  # j



  
# Открываем файл "output.txt" для записи
li a0, 13             # Ecall Code для открытия файла
la a1, output_file    # Адрес строки с именем файла
lw a2, O_WRONLY       # Открываем файл для записи (O_WRONLY)
ecall

# Записываем новую матрицу в файл
li a0, 15             # Ecall Code для записи в файл
li a1, 3              # Передаем дескриптор файла в a1
la a2, matrix         # Адрес буфера с новой матрицей
li a3, 64             # Размер новой матрицы
ecall

# Закрываем файл
li a0, 16             # Ecall Code для закрытия файла
li a1, 3              # Передаем дескриптор файла в a1
ecall


