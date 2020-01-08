bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s dw 0000000010010001b, 1111111111101010b, 1111111111010000b, 0000000001111111b
    lens equ $-s 
    d times lens db 0
    max equ 16
    unu equ 1
    
; our code starts here
segment code use32 class=code
    start:
    ;A word string s is given. Build the byte string d such that each element d[i] contains:
    ;- the count of zeros in the word s[i], if s[i] is a negative number
    ;- the count of ones in the word s[i], if s[i] is a positive number
    ;Example:
    ;s:145,-22, -48, 127
    ;in binary:
    ;10010001, 1111111111101010, 1111111111010000, 1111111
    ;d: 3, 3, 5, 7
        
        mov ESI,s
        mov EDI,d
        mov ECX,0
        cld
        repeat:
            lodsw ; mov AX,[esi] and inc esi
            cmp AX,0
            mov BL,0
            mov DL,0
            stc
            jl negative
            jg positive
        negative:
            rcr AX,unu
            jnc add1
            inc DL
            cmp DL,max
            jb negative 
            je continue
        add1:
            inc BL
            inc DL
            cmp DL,max
            jb negative
        add2:
            inc BL
            inc DL
            cmp DL,max
            jb positive
        positive:
            rcr AX,unu
            jc add2
            inc DL
            cmp DL,max
            jb positive 
            je continue
        continue:
            mov AL,BL
            stosb ; mov[edi],al and inc edi
            inc ECX
            cmp ECX,lens/2
            jb repeat
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
