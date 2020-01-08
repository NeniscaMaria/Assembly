bits 32 
global concatenare   

segment code use32 class=code
    concatenare:
        ; the stack will look like this:
        ;  ESP->-----------------
        ;        return adress
        ;ESP+4->-----------------
        ;        s1
        ;ESP+8->-----------------
        ;        s2
        ;ESP+12->----------------
        ;        s3
        ;ESP+16->----------------
        ;        s4
        ;ESP+20->----------------
        ;       lens4
        ;ESP+24->----------------
        ;       lens3
        ;ESP+28->----------------
        ;       lens2
        ;ESP+32->----------------
        ;       lens1
        
        ;first we copy s1 in s4
        cld
        mov ESI,[ESP] ;the offset of the source string(s1)
        mov EDI,[ESP+12] ;the offset of the destination string(s4)
        mov ECX,10 
        repeat1:
            lodsb
            cmp AL,0
            je next1
            stosb
            loop repeat1
        next1:
        ;then copy s2 at the end of s4
        cld
        mov ESI,[ESP+4]
                        ;EDI already contains the offset of the destination string
        mov ECX,10
        repeat2:
            lodsb
            cmp AL,0
            je next2
            stosb
            loop repeat2
        next2:
        ;now copy s3 at the end of s4
        cld
        mov ESI,[ESP+8]
                        ;EDI already contains the offset of the destination string
        mov ECX,10
        repeat3:
            lodsb
            cmp AL,0
            je next3
            stosb
            loop repeat3
        next3:
        ret
