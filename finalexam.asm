%macro  print   2
        mov     rax, 1                  ;SYS_write
        mov     rdi, 1                  ;standard output device
        mov     rsi, %1                 ;output string address
        mov     rdx, %2                 ;number of character
        syscall                     ;calling system services
%endmacro


%macro  scan    2
        mov     rax, 0                  ;SYS_read
        mov     rdi, 0                  ;standard input device
        mov     rsi, %1                 ;input buffer address
        mov     rdx, %2                 ;number of character
        syscall                     ;calling system services
%endmacro

section .bss
buffer  resb    4
ascii   resb    3
num1 resb 1
num2 resb 1
num3 resb 1
product resb 1


section .data
msg1    db  "Input 1st number (0~9): "
msg2    db  "Input 2nd number (0~9): "
msg3    db  "Input 3rd number (0~9): "
msg4    db  "product = "
section .text
        global _start


_start:
         print   msg1, 24                ;cout << msg1
             scan    buffer, 2               ;cin >> buffer
             mov rbx, buffer             ;rbx = address of buffer
           mov al, byte[buffer]                  ;al = 35h
             and al, 0fh                     ;al = al and 0fh = 05h
             mov byte[num1], al
             print   msg2, 24                ;cout << msg1
             scan    buffer, 2               ;cin >> buffer
             mov rbx, buffer  
         mov bl, byte[buffer]                  ;bl = 37h
             and bl, 0fh                     ;bl = bl and 0fh = 07h
             mov byte[num2], bl
             print   msg3, 24                ;cout << msg1
             scan    buffer, 2               ;cin >> buffer
             mov rbx, buffer  
         mov cl, byte[buffer]                  ;bl = 37h
          and cl, 0fh                     ;bl = bl and 0fh = 07h
          mov byte[num3], cl
         
          call    calculate               ;call calculate
          call    toString               ;call calculate
      
         print   msg4, 10                ;cout << str1
         print   ascii, 4                ;cout << ascii
         mov rax, 60
         mov rdi, 0
         syscall




calculate:
   mov dl, 0
   mov al, byte[num2]          ;al = num1 = 64h
   add al, byte[num3]          ;al = al + num2 = 2Ch
   adc dl, 0               ;ah = ah + 0 + CF = 01h
   mul byte[num1]
   mov byte[product+0], al         ;sum = al = 9ch
   ret
















toString:
         mov eax, dword[product]
         mov rcx, 0
         mov ebx, 10
         divideLoop:
         mov edx, 0
         div ebx
         push rdx
         inc rcx
         cmp eax, 0
         jne divideLoop
         mov rbx, ascii
         mov rdi, 0
         popLoop:
         pop rax
         add al, "0"
         mov byte [rbx+rdi], al
         inc rdi
         loop popLoop
         mov byte [rbx+rdi], 10
         ret
         