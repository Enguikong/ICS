    .ORIG   x3000
        LDI R0, P           ; R0=P
        LDI R1, Q           ; R1=Q
        LDI R2, N           ; R2=N
        ADD R0, R0, #-1     ; now R & R0 = R mod P
        ADD R3, R3, #1      ; R3 is the result  F(N)
        AND R4, R4, #0      ; R4 is F(N-1)
        NOT R7, R1          
        ADD R7, R7, #1      ; now R + R7 = R - Q
    ; Initial
        
AGAIN   ADD R2, R2, #-1     ;
        BRn END             ; now the program end
        ADD R5, R4, #0      ; R5 = R4  F(N-2)
        ADD R6, R3, #0      ; R4 = R3  F(N-1)
        AND R5, R5, R0      ; R5 = F(N-2) % P
BE      ADD R6, R6, R7      ; R6 = R6 - Q
        BRzp BE             ; Re
        ADD R6, R6, R1      ; R6 = F(N-1) % Q
        ADD R4, R3, #0      ; R4 = F(N-1)
        ADD R3, R5, R6      ; R3 = R4 + R5  F(N)
        BRnzp AGAIN         ; jump to AGAIN
END     STI R3, S           ; store result
        HALT
P       .FILL x3100
Q       .FILL x3101
N       .FILL x3102
S       .FILL x3103
    .END