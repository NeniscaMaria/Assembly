bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0111011101010111b
    b dw 1001101110111110b
    c dd 0

; our code starts here
segment code use32 class=code
    start:
        ; Se dau cuvintele A si B. Sa se obtina dublucuvantul C:
            ;bitii 0-4 ai lui C coincid cu bitii 11-15 ai lui A
            ;bitii 5-11 ai lui C au valoarea 1
            ;bitii 12-15 ai lui C coincid cu bitii 8-11 ai lui B
            ;bitii 16-31 ai lui C coincid cu bitii lui A
    mov EBX,0 ; in EBX vom calcula rezultatul
    mov AX, [a]; vom izola bitii 11-15 ai lui a
    and AX, 1111100000000000b
    mov CL, 11
    ror AX,CL; rotim la dreapta cu 11 pozitii
    CWDE ; AX->EAX=0000000000011111
    or EBX,EAX; punem bitii in rezultat
    or EBX, 00000000000000000000111111100000b ; facem bitii 5-11 din rezultat 1
    mov AX,[b] ;vom izola bitii 8-11 din b
    and AX, 0000111100000000b
    CWDE; AX->EAX:=00000000000000000000111100000000b
    mov CL,4
    rol EAX,CL; rotim spre stanga cu 5 pozitii
    or EBX,EAX; punem bitii in rezultat
    mov AX,[a] ; bitii 16-31 din c(EBX) vor coincide cu toti bitii din ai
    CWDE; AX->EAX:=00000000000000000111011101010111b
    mov CL,16
    rol EAX,CL; deplasam bitii cu 16 poozitii la stanga
    or EBX,EAX; punem bitii in rezultat
    mov DWORD[c],EBX
    
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
