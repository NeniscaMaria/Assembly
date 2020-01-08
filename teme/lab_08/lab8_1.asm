bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf   
import exit msvcrt.dll   
import printf msvcrt.dll
import scanf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0
    result dd 0
    zece dw 10
    message db "n=",0
    format db "%x",0
    format2 db "Numarul in baza 10 este %d.",0

; our code starts here
segment code use32 class=code
    start:
        ; Sa se citeasca de la tastatura un numar in baza 16 si sa se afiseze valoarea acelui numar in baza 10.
        ;Exemplu: Se citeste: 1D; se afiseaza: 29
        ;citim numarul in hexadecimal, folosind %x
        S
	push dword message
        call[printf]
        add esp,4*1
        
        push dword n 
        push dword format
        call[scanf]
        add esp,4*2
        
        ;afisam numarul in decimal, folosind %d  
        push dword [n] 
        push dword format2
        call[printf]
        add esp, 4*2
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
