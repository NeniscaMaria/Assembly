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
    x dd 1
    var dd 0

; our code starts here
segment code use32 class=code
;(a-b+c*128)/(a+b)+e-x signed
    start:
        mov AL, [a]; Al:=a
        sub Al, [b]; AL:=a-b
        ;convertim byte la word
        CBW; AX:=a-b
        CWD; DX:AX=a-b
        mov BX, AX
        mov CX, DX
        ;CX:BX:=DX:AX=a-b
        push CX
        push BX
        pop EBX
        ;EBX:=CX:BX=a-b
        mov dword[var],EBX
        ;var=EBX=a-b
        mov AX, [c]; AX:=c
        mov CX, 128; CX:=128 
        ;punem in word pentru ca valoarea maxima (signed) care incape intr-un byte e 127
        imul CX; DX:AX:=AX*CX=c*128
        mov CX,[var+2]
        mov BX,[var]
        ;CX:BX=var=a-b
        add BX,AX
        adc CX,DX
        ;CX:BX:=CX:BX+DX:AX=a-b+c*128
        push CX
        push BX
        pop EBX; EBX=a-b+c*128
        mov dword[var], EBX; var=a-b+c*128
        mov AL, [a]; AL:=a
        add AL, [b]; AL:=a+b
        ;convertim byte la word
        CBW; AL->AX:=a+b
        mov CX, AX; CX:=AX=a+b
        
        mov DX, [var+2]
        mov AX, [var]
        ;DX:AX:=var=a-b+c*128
        idiv CX; AX:=DX:AX/CX=(a-b+c*128)/(a+b)
               ; DX:=DX:AX%CX
        ;convertim word la double word
        CWD; AX->DX:AX:=(a-b+c*128)/(a+b)
        add AX, [e]
        adc DX, [e+2]
        ;DX:AX:=(a-b+c*128)/(a+b)+e
        push DX
        push AX
        pop EAX ; EAX:=(a-b+c*128)/(a+b)+e
        CDQ; EAX->EDX:EAX=(a-b+c*128)/(a+b)+e
        sub EAX,[x]
        sbb EDX,[x+4]
        ;EDX:EAX=(a-b+c*128)/(a+b)+e-x
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
