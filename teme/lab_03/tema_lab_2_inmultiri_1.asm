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
    b db 1
    c dw 0
    e dd 1
    x dq 1
    var dd 0
; our code starts here
segment code use32 class=code
;(a-b+c*128)/(a+b)+e-x unsigned
    start:
        mov BL, [a]; Bl:=a
        sub Bl, [b]; BL:=a-b
        ;convertim byte la word
        mov BH, 0; BX:=a-b
        ;convertim word la dword
        mov CX,0
        push CX
        push BX
        pop EBX
        ;EBX=a-b
        mov dword[var],EBX
        ;var=EBX=a-b
        mov AX, [c]; AX:=c
        mov CX, 128; CX:=128
        mul CX; DX:AX:=AX*CX=c*128
        mov CX, [var+2]
        mov BX,[var]
        ;CX:BX=var=a-b
        add AX,BX
        adc DX,CX
        ;DX:AX=DX:AX+CX:BX=a-b+c*128
        mov BL, [a]; BL:=a
        add BL, [b]; BL:=a+b
        ;convertim byte la word
        mov BH, 0; BX:=a+b
        div BX; AX:=DX:AX/BX=(a-b+c*128)/(a+b)
               ; DX:=DX:AX%BX
        ;convertim word la double word
        mov DX, 0
        push DX
        push AX
        pop EAX; EAX:=(a-b+c*128)/(a+b)
        add EAX, [e]; EAX:=EAX+e=(a-b+c*128)/(a+b)+e
        ;convertim dword la qword  EAX->EDX:EAX=(a-b+c*128)/(a+b)+e
        mov EDX,0
        sub EAX, [x]
        sbb EDX, [x+4]
        ; EDX:EAX:=EDX:EAX-x=(a-b+c*128)/(a+b)+e-x
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
