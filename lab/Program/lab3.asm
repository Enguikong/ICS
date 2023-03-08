    .ORIG x3000
        LDI     R0, NUM
        LD      R1, DATA        ; R1 is the pointer of the string
        LDR     R2, R1, #0      ; R2 is S[i]
        LDR     R3, R1, #1      ; R3 is S[i+1]
        ADD     R4, R4, #1      ; R4 <= 1   (now)
        ADD     R7, R7, #1      ; R7 <= 1   (max)
Zero    ADD     R6, R0, R0      ; judge if R0 == 0 
        BRnp    Loop  
        AND     R7, R7, #0      ; R7 <= 0
        BRnzp   End
Loop    ADD     R6, R0, #-1     ; judge if R0 == 1
        BRz     Store
        NOT     R2, R2
        ADD     R2, R2, #1
        ADD     R6, R2, R3      
        BRnp    Neq
        ADD     R4, R4, #1
        BRnzp   Nor
Neq     ADD     R6, R4, #0
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R4, R7
        BRzp    Nor
        ADD     R7, R6, #0
        AND     R4, R4, #0
        ADD     R4, R4, #1      ; R4 <= 1
Nor     ADD     R1, R1, #1
        LDR     R2, R1, #0      ; R2 is S[i]
        LDR     R3, R1, #1      ; R3 is S[i+1]
        ADD     R0, R0, #-1
        BRnzp   Loop
Store   ADD     R6, R4, #0
        NOT     R4, R4
        ADD     R4, R4, #1
        ADD     R4, R4, R7
        BRzp    End
        ADD     R7, R6, #0
End     STI     R7, RESULT
        HALT
RESULT  .FILL   x3050
NUM     .FILL   x3100
DATA    .FILL   x3101
    .END