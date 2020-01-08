bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 3
    b db 2
    c db 1
    x db 0

; our code starts here
segment code use32 class=code
;(a-c)*3+b*b
    start:
        mov AL, [a]
        sub AL, [c] ; AL:=a-c
        mov BL, 3
        mul BL ; AX:=AL*BL=AL*3=(a-c)*3
        mov BX, AX  ; BX:=AX=AL*3=(a-c)*3
        mov AL, [b]
        mul BYTE[b]; AX:=b*b
        add BX,AX  ; BX:=(a-c)*3+b*b
        mov [x], BX
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
