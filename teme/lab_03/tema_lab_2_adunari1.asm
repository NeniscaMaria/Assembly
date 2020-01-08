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
    b dw 1
    c dd 1
    d dq 1

; our code starts here
segment code use32 class=code
;(d+d-b)+(c-a)+d unsigned
    start:
        mov EAX, DWORD[d] 
        mov EDX, DWORD[d+4]
        ;EDX:EAX:=d=1
        add EAX,EAX
        adc EDX,EDX
        ;EDX:EAX:=EDX:EAX+EDX:EAX=d+d=2
        mov BX, [b]
        ;convertim word la double word
        mov CX, 0    
        push CX
        push BX
        pop EBX   ; acum b e dword, EBX:=b
        sub EAX, EBX 
        sbb EDX,0
        ;EDX:EAX:=EDX:EAX-EBX=d+d-b=2-1=1
        mov EBX, DWORD[c] ;EBX:=c
        mov CL, [a] ;CL:=a
        ;convertim byte la word
        mov CH, 0
        ;convertm word la dword
        mov DX, 0
        push DX
        push CX
        pop ECX ;ECX:=a
        sub EBX, ECX ;EBX:=EBX-ECX=c-a=1-1=0
        add EAX,EBX
        adc EDX,0
        ;EDX:EAX=EDX:EAX+EBX=(d+d-b)+(c-a)=1+0=1
        mov EBX,DWORD[d]
        mov ECX,DWORD[d+4]
        ;ECX:EBX:=d
        add EAX,EBX
        adc EDX,ECX
        ;EDX:EAX:=EDX:EAX+ECX:EBX=(d+d-b)+(c-a)+d=1+1=2
       
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
