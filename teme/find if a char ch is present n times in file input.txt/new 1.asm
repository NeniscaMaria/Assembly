
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf,fopen,fread,fclose,fprintf  
import exit msvcrt.dll   
import printf msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll

 
segment data use32 class=data
    message1 dd 'Please enter a filename:',0
    message2 dd 'Please enter a character:',0
    message3 dd 'Please enter a number:',0
    message4 dd 'Numarul aparitiilor caracterului %s citit nu este egal cu numarul %d citit.',0
    message5 dd 'Numarul aparitiilor caracterului %s citit este egal cu numarul %d citit.',0
    fileOutput dd 'output.txt',0
    modread dd 'r',0
    modwrite dd'w',0
    len equ 100
    handle1 dd -1
    handle2 dd -1
    format1 dd '%s',0
    format2 dd '%s',0
    format3 dd '%d',0
    nrAparitii dd 0
    filename times 3 dd 0
    char dd 0
    n dd 0
    charRead dd 0
; our code starts here
segment code use32 class=code
    start:
        ;we read the filename
        push dword message1
        call [printf]
        add esp,4
        push dword filename
        push dword format1
        call [scanf]
        add esp,4*2
        
        ;we read the character char    
        push dword message2
        call [printf]
        add esp,4
        push dword char
        push dword format2
        call [scanf]
        add esp,4*2
        
        ;we read a number
        push dword message3
        call [printf]
        add esp,4
        push dword n
        push dword format3
        call [scanf]
        add esp,4*2
        
        ;we open the input file
        push dword modread
        push dword filename
        call [fopen]
        add esp,4*2
        mov [handle1],eax
        cmp eax,0
        je finish1
        
        ;we open the output file
        push dword modwrite
        push dword fileOutput
        call [fopen]
        add esp,4*2
        mov [handle2],eax
        cmp eax,0
        je finish
        
        bucla:
            ;here we read from the input file
            push dword [handle1]
            push dword 1
            push dword 1
            push dword charRead
            call [fread]
            add esp,4*4
            cmp eax,0
            je exitloop
            mov eax,[charRead]
            cmp eax,[char]
            je increase
            jmp bucla
        increase:
            mov ebx,[nrAparitii]
            inc ebx
            mov [nrAparitii],ebx
            jmp bucla
        exitloop:
            mov ebx,[nrAparitii]
            cmp ebx,dword [n]
            je done
            push dword [n]
            push dword char
            push dword message4
            push dword [handle2]
            call [fprintf]
            add esp,4*4
            jmp finish
        done:
            push dword [n]
            push dword char
            push dword message5
            push dword [handle2]
            call [fprintf]
            add esp,4*4
        finish1:
            ;we close only the input file because that is were the error occured
            push dword [handle1]
            call [fclose]
            add esp,4
            ;and exit
            push dword 0
            call [exit]
        finish:
            ;we close both the input and the output files
            push dword [handle1]
            call [fclose]
            add esp,4
            push dword [handle2]
            call [fclose]
            add esp,4
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
