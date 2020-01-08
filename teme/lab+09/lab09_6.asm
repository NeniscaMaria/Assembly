bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf              ; tell nasm that exit exists even if we won't be defining it
extern concatenare
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db '%s',0
    message db 'Insert a word:',0
    message2 db 'The result is: %s',0
    s1 times 10 db 0
    lens1 dd 10
    s2 times 10 db 0
    lens2 dd 10
    s3 times 10 db 0
    lens3 dd 10
    s4 times 30 db 0
    lens4 dd 30
    
    
; our code starts here
segment code use32 class=code
    start:
        ; Se citesc trei siruri de caractere. Sa se determine si sa se afiseze rezultatul concatenarii lor.
        ; we suppose that a word is not longer than 10 characters
        push dword message 
        call [printf]
        add ESP,4
            
        push dword s1
        push dword format
        call [scanf] 
        add ESP,4*2  

        push dword message 
        call [printf]
        add ESP,4
            
        push dword s2
        push dword format
        call [scanf] 
        add ESP,4*2 
        
        push dword message 
        call [printf]
        add ESP,4
            
        push dword s3
        push dword format
        call [scanf] 
        add ESP,4*2         
            
        push dword lens1
        push dword lens2
        push dword lens3
        push dword lens4
        push dword s4
        push dword s3
        push dword s2
        push dword s1
        call concatenare
        add ESP,4*4
            
        push dword s4
        push dword message2
        call [printf]
        add ESP,4*2        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
