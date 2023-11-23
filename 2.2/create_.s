.globl __start

.data
  output_file: .asciiz "output.txt"
  array: 
    .word 1, 2, 3, 4  # 4x4 matrix
    .word 9, 5, 4, 5
    .word 8, 1, 9, 9
    .word 5, 5, 7, 3
  array_rows: .word 4  # Количество строк в массиве
  array_cols: .word 4  # Количество столбцов в массиве
  O_WRONLY: .word 0b0000010
.text
__start:
  # Открываем файл "output.txt" для записи
  li a0, 13          # Ecall Code для открытия файла
  la a1, output_file # Адрес строки с именем файла
  lw a2, O_WRONLY       # Открываем файл для записи 
  ecall

  # Записываем двумерный массив в файл
  la t2, array       # Адрес начала массива
  lw t3, array_rows  # Количество строк в массиве
  lw t4, array_cols  # Количество столбцов в массиве
  li t5, 4           # Размер элемента массива (4 байта)
  li t6, 0           # Счетчик записанных элементов
  mul s3, t3, t4     # Всего элементов

loop:
  mul s2, t6, t5
  add s2, s2, t2

  # Записываем элемент в файл
  li a0, 15          # Ecall Code для записи в файл
  li a1, 3           # Передаем дескриптор файла в a1
  mv a2, s2          # Адрес текущего элемента
  li a3, 4           # Длина элемента
  ecall


  addi t6, t6, 1
  bge t6, s3, done
  j loop

done:
  # Закрываем файл
  li a0, 16          # Ecall Code для закрытия файла
  li a1, 3           # Передаем дескриптор файла в a1
  ecall

exit:
  # Завершаем программу
  li a0, 10          # Ecall Code для завершения программы
  ecall
