bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db -1
    b db 1
    c dd -2
    d dq -1

; our code starts here
segment code use32 class=code
;a-d+b+b+c signed
    start:
        mov AL, [a]; AL:=a
        CBW ; convertim byte la word => AL->AX=a
        CWDE ; AX->EAX=a
        CDQ ;EAX->EDX:EAX=a
        mov EBX,[d]
        mov ECX,[d+4]
        ;ECX:EBX=d
        sub EAX,EBX
        sbb EDX,ECX
        ;EDX:EAX:=EDX:EAX-ECX:EBX=a-d=0
        mov EBX,EAX
        mov ECX,EDX
        ;ECX:EBX:=EDX:EAX=0
        mov AL, [b]; AX:=b
        CBW; convertim byte la word => AL-> AX=b
        CWDE ; AX->EAX:=b
        CDQ ; EAX->EDX:EAX:=b
        add EBX,EAX
        adc ECX,EDX
        ;ECX:EBX:=ECX:EBX+EDX:EAX=a-d+b=0+1=1
        add EBX,EAX
        adc ECX,EDX
        ;ECX:EBX:=ECX:EBX+EDX:EAX=a-d+b+b=1+1=2
        mov EAX, [c]; EAX:=c
        CDQ ;EAX->EDX:EAX=c
        add EBX, EAX
        adc ECX,EDX
        ;ECX:EBX:=ECX:EBX+EDX:EAX=a-d+b+b+c=2-2=0
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
