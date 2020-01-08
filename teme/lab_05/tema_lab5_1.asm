bits 32
global start
extern exit
import exit from msvcrt.dll
segment data use32 class=data:
    s1 db '1357'
    lens1 equ $-s1
    s2 db '2694'
    ;the length of s2 is equal to the length of s1
    d times lens1*2 db 0
    
segment code use 32 class=code:
start:
;Se dau doua siruri de octeti S1 si S2 de aceeasi lungime. Sa se obtina sirul D prin intercalarea elementelor celor doua siruri. 
;Exemplu:
;S1: 1, 3, 5, 7
;S2: 2, 6, 9, 4
;D: 1, 2, 3, 6, 5, 9, 7, 4
    mov ESI,0
    ;we solve this problem by considerring ESI the index from where we take
    ;the values. It will increase after we have put the value from s1 in d and we have taken the value from s2(before we put it in d)
    
    mov EDI,d ;in EDI we consider offset of the current byte from d
    ;we do a loop with lens1*2(=6 in pur caase)iterations. At each iteration
    ;we move the byte from s1 from the position ESI (i.e. the offset [s1+ESI]
    ;and move it into the offset EDI. Then we increase the offset EDi and then
    ;we move the byte from s2 from position ESI(i.e. the offset[s2+ESI] into
    ;the current offset EDI and then increase it as well. And then we increase ESI. In order for the jump 
    ;to happen, ESI<lens1*2
    ;So, in this loop ESI will have the values:{0,1,2,3} and
    ;EDI:{[s2+0],[s2+1],[s2+2],[s2+3],[s2+4],[s2+5],[s2+6],[s2+7]}
    cld
    repeat:
        mov AL,[s1+ESI] ;AL<-the byte from offset s1+ESI
        stosb ;<=> mov EDI,AL(i.e. AL->the byte from the offset s1+ESI)
               ; inc EDI
        mov AL,[s2+ESI] ;AL<-the byte from offset s2+ESI
        stosb 
        inc ESI
        cmp ESI,lens1*2
        jb repeat ;if(ESI<lens1*2) jump to repeat
                  ;otherwise continue below
    push dword 0
    call[exit]
    