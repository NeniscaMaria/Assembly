bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,scanf,fopen,fclose,fscanf     
import exit msvcrt.dll   
import printf msvcrt.dll
import scanf msvcrt.dll   
import fopen msvcrt.dll 
import fclose msvcrt.dll    
import fscanf msvcrt.dll            
segment data use32 class=data
    filename dd 'asc.txt',0
    modread dd 'r',0
    readformat dd '%s ',0
    cuv1 times 10 dd 0
    cuv2 times 10 dd 0
    cuv3 times 10 dd 0
    cuv4 times 10 dd 0
    cuv5 times 10 dd 0
    handle1 dd -1
; our code starts here
segment code use32 class=code
    start:
    ; here we open the file for writing/appending
        push dword modread
        push dword filename
        call [fopen]
        add esp,4*2
        mov [handle1],EAX
        cmp EAX,0
        je final
        
        push dword cuv1
        push dword readformat
        push dword [handle1]
        call [fscanf]
        add esp, 4*3
        
        push dword cuv2
        push dword readformat
        push dword [handle1]
        call [fscanf]
        add esp, 4*3
        
        push dword cuv3
        push dword readformat
        push dword [handle1]
        call [fscanf]
        add esp, 4*3
        
        push dword cuv4
        push dword readformat
        push dword [handle1]
        call [fscanf]
        add esp, 4*3
        
        push dword cuv5
        push dword readformat
        push dword [handle1]
        call [fscanf]
        add esp, 4*3
        
        mov ESI,cuv1 ;offset of source string
        mov EDI,cuv1 ;offset of destination string
        mov ECX,10
        repeat1:
            lodsb
            cmp AL,0
            je next1
            sub AL,2
            stosb
            loop repeat1
        next1:
        mov ESI,cuv2 ;offset of source string
        mov EDI,cuv2 ;offset of destination string
        mov ECX,10
        repeat2:
            lodsb
            cmp AL,0
            je next2
            sub AL,2
            stosb
            loop repeat2
        next2:
        mov ESI,cuv3 ;offset of source string
        mov EDI,cuv3 ;offset of destination string
        mov ECX,10
        repeat3:
            lodsb
            cmp AL,0
            je next3
            sub Al,2
            stosb
            loop repeat3
        next3:
        mov ESI,cuv4 ;offset of source string
        mov EDI,cuv4 ;offset of destination string
        mov ECX,10
        repeat4:
            lodsb
            cmp AL,0
            je next4
            sub AL,2
            stosb
            loop repeat4
        next4:
        mov ESI,cuv5 ;offset of source string
        mov EDI,cuv5 ;offset of destination string
        mov ECX,10
        repeat5:
            lodsb
            cmp AL,0
            sub AL,2
            je next5
            stosb
            loop repeat5
        next5:
        push dword cuv1
        push dword readformat
        call [printf]
        add esp, 4*2
        push dword cuv2
        push dword readformat
        call [printf]
        add esp, 4*2
        push dword cuv3
        push dword readformat
        call [printf]
        add esp, 4*2
        push dword cuv4
        push dword readformat
        call [printf]
        add esp, 4*2
        push dword cuv5
        push dword readformat
        call [printf]
        add esp, 4*2
        
    final:
    ;here we close the file
        push dword[handle1]
        call [fclose]
        add esp, 4*1
    
    finish:    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
