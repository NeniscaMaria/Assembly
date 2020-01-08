bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fprintf,printf,scanf,fopen,fclose              
import exit msvcrt.dll 
import fprintf msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll  

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "a1.txt", 0
    acces_mode db "w", 0
    desc_file dd -1
    message db "cuv=",0
    format db "%s",0
    cuv db 0
    

; our code starts here
segment code use32 class=code
    start:
        ;Se da un nume de fisier (definit in segmentul de date). Sa se creeze un fisier cu numele dat,
        ;apoi sa se citeasca de la tastatura cuvinte si sa se scrie in fisier cuvintele citite pana cand 
        ;se citeste de la tastatura caracterul '$'.
        
        ; apelam fopen pentru a crea fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(file_name, acces_mode)
        push dword acces_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2                ; eliberam parametrii de pe stiva
        mov [desc_file], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fis
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        repeat:
            ;afisam mesajul pe ecran
            push dword message
            call[printf]
            add esp,4*1
            
            ;citim cuvantul de la tastatura
            push dword cuv 
            push dword format
            call[scanf]
            add esp,4*2
            mov EAX,[cuv]
            cmp EAX,'$'
            je finish
            
            ; scriem cuv in fisierul deschis folosind functia fprintf
            ; fprintf(desc_file, cuv)
            push dword cuv
            push dword [desc_file]
            call [fprintf]
            
            ;here we clear the memory from cuv 
            add esp, 4*2
            mov CL,0
            mov EBX,0
            clear: 
                mov [cuv+EBX],CL
                inc EBX
                mov EAX,[cuv+EBX]
                cmp EAX,0
                jne clear 
            jmp repeat
        finish:    
            ; apelam functia fclose pentru a inchide fisierul
            ; fclose(desc_file)
            push dword [desc_file]
            call [fclose]
            add esp, 4
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
