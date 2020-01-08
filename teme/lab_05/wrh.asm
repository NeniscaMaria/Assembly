bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 db '12345678'
    lens1 equ $-s1
    s2 times lens1 db 0

; our code starts here
segment code use32 class=code
    start:
; Se da un sir de octeti S. Sa se construiasca sirul D astfel:
;sa se puna mai intai elementele de pe pozitiile pare din S iar
;apoi elementele de pe pozitiile impare din S. 
;Exemplu:
;S: 1, 2, 3, 4, 5, 6, 7, 8
;D: 1, 3, 5, 7, 2, 4, 6, 8
    
        mov ESI, s1;initialize ESI with offset of s1
        mov EDI, s2;initialize EDI with the offset of s2
        mov ECX,lens1
        mov BL,1 ;1=odd, 0=even
        cld
        odd:
            cmp BL,1
            jl skipeven ;jump short if the step is even
            mov AL,[ESI];;AL<-the byte from offset s1+ESI
            stosb ;<=> mov EDI,AL(i.e. AL->the byte from the offset s1+ESI)
                  ; inc EDI
            add ESI,1
            mov BL,0
            loop odd
        skipeven:
            add ESI,1
            mov BL,1
            loop odd
        
        mov ESI,s1
        mov ECX,lens1
        mov BL,1
        even:
            cmp BL,0
            jg skipodd  ;jump short if step is odd
            mov AL,[ESI];;AL<-the byte from offset s1+ESI
            stosb ;<=> mov EDI,AL(i.e. AL->the byte from the offset s1+ESI)
                  ; inc EDI
            add ESI,1
            mov BL,1
            loop even
        skipodd:
            add ESI,1 
            mov BL,0
            loop even
                
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
