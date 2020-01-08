bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s DD 12345678h, 1A2B3C4Dh, 2398DC76h
    lens EQU $-s
    d times lens db 0
    trei db 3;used when checking if a number is a multiple of 3
    

; our code starts here
segment code use32 class=code
    start:
    ; Se da un sir de dublucuvinte. Sa se obtina sirul format din octetii superiori ai 
    ;cuvitelor superioare din elementele sirului de dublucuvinte care sunt divizibili cu 3.
    ;Exemplu:
    ;Se da sirul de dublucuvinte:
    ;s DD 12345678h, 1A2B3C4Dh, FE98DC76h
    ;Sa se obtina sirul
    ;d DB 12h.
        mov esi,s
        mov edi,d
        mov ecx,lens/4
        cld
        repeat:    
            lodsw;mov AX,[esi] and inc esi// in AX we have the low word of the current doubleword
            lodsw;mov AX,[esi] and inc esi// in AX we have the high word of the current doubleword 
            shr AX,8; we want to obtain only the high bytes of AX (only the first 2 bytes)
            mov AH,0 ; we are interesting only in the least significant part from AX (in AL we have the high bytes from the 
                      ;current double word from s
            div BYTE[trei]; we check if it is a multiple of 3
            cmp AH,0; if the remainder is 0, we will continue the cicle
            jnz next
            mul BYTE[trei]
            stosb ;mov[edi],al +inc edi
            loop repeat
        next:
            loop repeat
            
            
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
