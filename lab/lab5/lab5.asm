    .ORIG x800
    ; (1) Initialize interrupt vector table.
    LD R0, VEC
    LD R1, ISR
    STR R1, R0, #0

    ; (2) Set bit 14 of KBSR.
    LDI R0, KBSR
    LD R1, MASK
    NOT R1, R1
    AND R0, R0, R1
    NOT R1, R1
    ADD R0, R0, R1
    STI R0, KBSR

    ; (3) Set up system stack to enter user space.
    LD R0, PSR
    ADD R6, R6, #-1
    STR R0, R6, #0
    LD R0, PC
    ADD R6, R6, #-1
    STR R0, R6, #0
    ; Enter user space.
    RTI
VEC     .FILL   x0180
ISR     .FILL   x1000
KBSR    .FILL   xFE00
MASK    .FILL   x4000
PSR     .FILL   x8002
PC      .FILL   x3000
    .END

    .ORIG x3000
    ; *** Begin user program code here ***
LOOP    LEA R0, ID      ; 打印学号
        PUTS
        AND R0, R0, #0
        LD  R0, COUNT
REP     ADD R0, R0, #-1
        BRp REP         ; 每两次打印之间进行延迟
        BRnzp LOOP
COUNT   .FILL #25000        
ID      .STRINGZ "PB20000113 "        
    ; *** End user program code here ***
    .END

    .ORIG x3FFF
    ; *** Begin honoi data here ***
HONOI_N .FILL xFFFF
    ; *** End honoi data here ***
    .END

    .ORIG x1000
    ; *** Begin interrupt service routine code here ***
        LD  R6, STACK       ; 压栈
        LD  R0, NEWLINE     
        OUT                 ; 输出"\n",换行
        GETC                ;从键盘读入n (ASCII码)
        OUT
        ADD R5, R0, #0
        LD  R3, ASCIIZ
        ADD R0, R0, R3      ; n-'0'
        ADD R4, R0, #0      
        BRn ERROR           ; 非法输入
        LD  R3, ASCIIN     
        ADD R0, R5, R3      ; n-'9'
        BRp ERROR
        LEA R0, OUTPUT2 
        PUTS                ; 输入合法，输出反馈
        LD R0, NEWLINE
        OUT                 ; 输出"\n",换行
        ADD R0, R4, #0
        BR MAIN
ERROR   LEA R0, OUTPUT1
        PUTS                ; 非0-9，输出反馈
FINISH  LD  R0, NEWLINE
        OUT
        RTI
   
MAIN    ADD R6, R6, #-1
        STR R0, R6, #0
        JSR HANOI
        LEA R0, OUTPUT3
        PUTS
        LD  R0, ZERO
        LD  R2, NHUN
LOOPH   ADD R1, R2, R1
        BRn ENDH
        ADD R0, R0, #1
        BRnzp LOOPH
ENDH    OUT                         ; 百位
        LD R3, PHUN
        ADD R1, R1, R3
        LD R0, ZERO
        LD R2, NTEN
LOOPS   ADD R1, R2, R1
        BRn ENDS
        ADD R0, R0, #1
        BRnzp LOOPS
ENDS    OUT                         ; 十位
        ADD R1, R1, #10
        LD R0, ZERO
        ADD R0, R0, R1
        OUT                         ; 个位
        LEA R0, OUTPUT4
        PUTS
        HALT

HANOI   ADD R6, R6, #-1
        STR R7, R6, #0              ; R7入栈
        ADD R6, R6, #-1
        STR R0, R6, #0              ; R0入栈 (n)
        ADD R6, R6, #-1
        STR R2, R6, #0              ; R2入栈
        ADD R2, R0, #-1
        BRzp REC                    ; R0 = 0 时，R1 = 0 (递归出口)    
        ADD R1, R0, #0              ; R1 = 0 is the answer
        BRnzp DONE

REC     ADD R0, R0, #-1             ; R0 = n-1
        JSR HANOI                   ; R1 = H(n-1)
        ADD R1, R1, R1              ; R1 = 2H(n-1)
        ADD R1, R1, #1              ; R1 = 2H(n-1) + 1
DONE    LDR R2, R6, #0
        ADD R6, R6, #1
        LDR R0, R6, #0
        ADD R6, R6, #1
        LDR R7, R6, #0
        ADD R6, R6, #1
        RET
ASCIIZ  .FILL   xFFD0               ; ASCII码0补码
ASCIIN  .FILL   xFFC7               ; ASCII码9补码
ZERO    .FILL   x0030               
STACK   .FILL   x6000               ; 栈底
NEWLINE .FILL   x000A               ; 换行转义符
OUTPUT1 .STRINGZ " is not a decimal digit."     ; 输入非0-9时反馈
OUTPUT2 .STRINGZ " is a decimal digit."         ; 输入0-9时反馈
OUTPUT3 .STRINGZ "TOWER OF HANOI needs "
OUTPUT4 .STRINGZ " moves."
NHUN    .FILL   xFF9C               ; -100
PHUN    .FILL   x0064               ; +100
NTEN    .FILL   xFFF6               ; -10
    ; *** End interrupt service routine code here ***
    .END