bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 1
    b db 2
    c db 3
    d dw 4
    x dw 0
; our code starts here
;-a*a+2*(b-1)-d
segment code use32 class=code
    start:
        mov AL, [a]
        mul BYTE [a] ;AX:=AL*a=a*a
        mov BX, 0
        sub BX, AX   ; BX:=BX-AX=0-a*a=-a*a
        mov AL, [b]
        sub AL, 1  ; AL:=b-1
        mov CL, 2
        mul CL; AX=2*(b-1)
        add BX,AX ; BX=-a*a+2(b-1)
        sub BX, [d]  ; BX:= -a*a+2(b-1)-d
        mov [x], BX
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
