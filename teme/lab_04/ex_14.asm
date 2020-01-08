bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 01110111010101111011111111101110b; 7757BFEEh
    b dd 0
    d dd 0
    c db 0
    x dd 0; aici va fi numarul intreg reprezentat pe bitii 14-17 ai lui A
; our code starts here
segment code use32 class=code
    start:
        ;Se da dublucuvantul A. Sa se obtina numarul intreg n reprezentat de bitii 14-17 ai lui A. Sa se obtina apoi in B dublucuvantul rezultat prin rotirea spre stanga a lui A cu n pozitii. Sa se obtina apoi octet C astfel:
            ;bitii 0-5 ai lui C coincid cu bitii 1-6 ai lui B
            ;bitii 6-7 ai lui C coincid cu bitii 17-18 ai lui B
    mov EAX,[a]; izolam bitii 14-17
    and EAX, 00000000000000111100000000000000b
    mov Cl,14
    ror EAX, CL; deplasam la dreapta cu 14 pozitii
    mov DWORD[x],EAX; mutam rezultatul in variabila
    mov EAX,[a]; vom roti spre stanga cuvantul cu n pozitii(n=numarul intreg reprezentat in x)
    mov CL, [x]
    rol EAX,CL
    mov DWORD[b],EAX; punem rezultatul in variabila b
    mov EBX,0; aici vom calcula rezultatul de la ultima operatie
    mov EAX,[b]; izolam bitii 1-6 din b
    and EAX, 00000000000000000000000001111110b
    mov CL,1
    ror EAX,CL; deplasam la stanga cu 1 pozitie
    or EBX,EAX; punem bitii in rezultat
    mov EAX,[b]; vom izola bitii 17-18 din b
    and EAX, 00000000000001100000000000000000b
    mov CL, 11
    ror EAX,CL; deplasam cu 11 pozitii bitii
    or EBX,EAX;punem bitii in rezultat
    mov DWORD[d],EBX; vom lua daor ultimii 8 biti din acest rezultat
    mov BL,[d]
    mov BYTE[c],BL; punem rezultatul in variabila
    
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
