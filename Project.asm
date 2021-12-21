;Prepared By:
;Mohammad Wahaj Tariq (FA19-BCS-084)
;Muhammad Umair (SP19-BCS-139)
;Saad Goraya (FA18-BCS-043)
;Muhammad Tayyab (SP19-BCS-108)

.MODEL SMALL
.STACK 100H
.DATA      

BTOP DB " -------- "     ; PRINT BUTTON RANDOMLY
BR1 DB " |BUTTON| " 
BR2 DB " -------- " 

SB1 DB " -------- "      ; PRINT START BUTTON 
SB2 DB " |START!| " 
SB3 DB " -------- "        

STRING DB "----------REACTION TESTER GAME----------$" 
CSTRING DB 0AH, 0DH, "COUNTER: $"  
TSTRING DB 0AH, 0DH, "TIMER: $"

COLUMN DB ?       ; VARIABLE TO STORE COLUMN THAT IS RANDOMLY GENERATED
ROW DB ?          ; VARIABLE TO STORE ROW THAT IS RANDOMLY GENERATED
X DW ?            ; X COORDINATE OF MOUSE. 
Y DW ?            ; y COORDINATE OF MOUSE.
COUNT DB 0        ; COUNTER TO STORE NUMBER OF CLICK.

TIME_PASSED DB 0

CURRENT_TIME DB ? ; SECONDS PART OF THE CURRENT TIME OF THE SYSTEM

.CODE
  
  PRINT_START_BUTTON PROC 
        
        CALL SET_COLUMN
        CALL SET_ROW
        
        MOV AL, 1  ; PRINT STRING WITH ATTRIBUTES.
        MOV BH, 0  ; PAGE NUMBER
        MOV BL, 1110_0010B ; SETS COLOR. 1110 FOR BACKGROUND, 0010 FOR TEXT. 
        
        MOV CX, 0AH ; SETS STRING SIZE.
        MOV DL, 15  ; SET COLUMN
        MOV DH, 15  ; SET ROW
        PUSH DS
        POP ES
        
        MOV BP, OFFSET SB1  ;USES BP:ES TO PRINT STRING.
        MOV AH, 13H
        INT 10H     
        
        MOV AL, 1
        MOV BH, 0
        MOV BL, 1110_0010B     ; SETS COLOR. 1110 FOR BACKGROUND, 0010 FOR TEXT.
        
        MOV CX, 0AH ; SETS STRING SIZE.
        MOV DL, 15  ; SET COLUMN 
        MOV DH, 16  ; SET ROW
        PUSH DS
        POP ES
        MOV BP, OFFSET SB2
        MOV AH, 13H
        INT 10H      
        
        MOV AL, 1
        MOV BH, 0
        MOV BL, 1110_0010B     ; SETS COLOR. 1110 FOR BACKGROUND, 0010 FOR TEXT.
        
        MOV CX, 0AH ; SETS STRING SIZE.
        MOV DL, 15  ; SET COLUMN 
        MOV DH, 17  ; SET ROW
        PUSH DS
        POP ES
        MOV BP, OFFSET SB3
        MOV AH, 13H  ; STRING WRITE IN GRAPHICS MODE
        INT 10H
    RET
  PRINT_START_BUTTON ENDP
  
  SET_COLUMN PROC  
    
    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

    MOV AX, DX
    XOR DX, DX   ; CLEAR DX
    MOV CX, 29    
    DIV CX       ; here dx contains the remainder of the division - from 0 to 29
    MOV  COLUMN, DL
      
    RET      
    
  SET_COLUMN ENDP    
  
  SET_ROW PROC  
    
    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

    MOV AX, DX
    XOR DX, DX
    MOV  CX, 5    
    DIV CX      ; here dx contains the remainder of the division - from 0 to 5
    MOV  ROW, DL
    ADD ROW, 10
      
    RET      
    
  SET_ROW ENDP
  
  PRINT_BUTTON PROC 
        
        CALL SET_COLUMN
        CALL SET_ROW
        
        MOV AL, 1
        MOV BH, 0
        MOV BL, 1110_0010B ; SETS COLOR. 1110 FOR BACKGROUND, 0010 FOR TEXT. 
        
        MOV CX, 0AH ; SETS STRING SIZE.
        MOV DL, COLUMN  ; SET COLUMN
        MOV DH, ROW  ; SET ROW
        PUSH DS
        POP ES
        
        MOV BP, OFFSET BTOP
        MOV AH, 13H
        INT 10H     
        
        MOV AL, 1
        MOV BH, 0
        MOV BL, 1110_0010B     ; SETS COLOR. 1110 FOR BACKGROUND, 0010 FOR TEXT.
        
        MOV CX, 0AH ; SETS STRING SIZE.
        MOV DL, COLUMN  ; SET COLUMN  
        INC ROW
        MOV DH, ROW  ; SET ROW
        PUSH DS
        POP ES
        MOV BP, OFFSET BR1
        MOV AH, 13H
        INT 10H      
        
        MOV AL, 1
        MOV BH, 0
        MOV BL, 1110_0010B     ; SETS COLOR. 1110 FOR BACKGROUND, 0010 FOR TEXT.
        
        MOV CX, 0AH ; SETS STRING SIZE.
        MOV DL, COLUMN  ; SET COLUMN 
        INC ROW
        MOV DH, ROW  ; SET ROW
        PUSH DS
        POP ES
        MOV BP, OFFSET BR2
        MOV AH, 13H
        INT 10H
        
        DEC ROW
        DEC ROW
    RET
  PRINT_BUTTON ENDP      
  
  GET_MOUSE_LOCATION PROC  
    
    MOV AX, 3  ; CATCH MOUSE LOCATION AND STATUS
    INT 33H
    
    RET
  GET_MOUSE_LOCATION ENDP    
  
  TIMER PROC   
       MOV AH, 2CH
       INT 21H 
       SUB DH, CURRENT_TIME 
       MOV TIME_PASSED, DH
   RET
  TIMER ENDP
  
  
  
    
  MAIN PROC
    
         MOV AX , @data
         MOV DS, AX   
         
         MOV AL, 13H       ;graphical mode. 40x25. 256 colors. 320x200 pixels. 1 page.
         MOV AH, 0         ;set video mode.
    	 INT 10H
         
         MOV AH, 9
         MOV DX, OFFSET STRING
         INT 21H  
         
         CALL PRINT_START_BUTTON   
         
         CLICK1:
         CALL GET_MOUSE_LOCATION 
           
         CMP BX, 1
         JE START_BUTTON_PRESSED
         JMP CLICK1 
             
         START_BUTTON_PRESSED: 
         
             MOV X, CX
             MOV Y, DX
             
             XOR BX, BX
             
             MOV AX, X
             MOV BL,15
             DIV BL
             
             MOV BX, AX  ; store quotient in bx
             MOV AL, 15
             MUL BL
              
             MOV CX, X
             CMP CX, AX  
             JGE SB_CHECK_END_COLUMN_RANGE
             JMP CLICK1
             
             SB_CHECK_END_COLUMN_RANGE: 
             
             ADD AX, 10
             CMP CX, AX
             JLE SB_CHECK_ROW_RANGE
             JMP CLICK1
             
             SB_CHECK_ROW_RANGE:
             
             XOR BX, BX
             MOV AX, Y
             MOV BL,15
             DIV BL
             
             MOV BX, AX
             MOV AL, 15
             MUL BL
             
             MOV DX, Y
             CMP DX, AX  
             JGE SB_CHECK_END_ROW_RANGE
             JMP CLICK1       
             
             SB_CHECK_END_ROW_RANGE:
             ADD AX, 3
             CMP DX, AX
             JLE SUCCESS1
             JMP CLICK
             
             SUCCESS1: 
             
         
         
             
         MOV AL, 13H      ;CLEAR SCREEN
         MOV AH, 0
    	 INT 10H
         
         MOV AH, 9
         MOV DX, OFFSET STRING
         INT 21H 
         
         MOV AH, 9
         MOV DX, OFFSET CSTRING
         INT 21H  
         
         MOV AH, 2
         XOR DX,DX
         MOV DL, COUNT
         OR DL, 30H  
         INT 21H
         
         MOV AH, 9
         MOV DX, OFFSET TSTRING
         INT 21H  
         
         MOV AH, 2
         MOV DL, TIME_PASSED
         OR DL, 30H
         INT 21H 
         
         MOV AH, 2CH
         INT 21H
         MOV CURRENT_TIME, DH
         
         
         WHILE:  
             CALL TIMER
             CMP TIME_PASSED, 10
             JGE END_WHILE
             
             CALL PRINT_BUTTON  
             
             CLICK:
             CALL GET_MOUSE_LOCATION 
             
             CMP BX, 1
             JE BUTTON_PRESSED
             JMP CLICK 
                    
             CALL TIMER
             CMP TIME_PASSED, BH
             JE END_WHILE  
             
             BUTTON_PRESSED: 
             MOV X, CX
             MOV Y, DX
             
             XOR BX, BX
             
             MOV AX, X
             MOV BL,COLUMN
             DIV BL
             
             MOV BX, AX
             MOV AL, COLUMN
             MUL BL
              
             MOV CX, X
             CMP CX, AX  
             JGE CHECK_END_COLUMN_RANGE
             JMP CLICK
             
             CHECK_END_COLUMN_RANGE: 
             
             ADD AX, 10
             CMP CX, AX
             JLE CHECK_ROW_RANGE
             JMP CLICK
             
             CHECK_ROW_RANGE:
             
             XOR BX, BX
             MOV AX, Y
             MOV BL,ROW
             DIV BL
             
             MOV BX, AX
             MOV AL, ROW
             MUL BL
             
             MOV DX, Y
             CMP DX, AX  
             JGE CHECK_END_ROW_RANGE
             JMP CLICK       
             
             CHECK_END_ROW_RANGE:
             ADD AX, 3
             CMP DX, AX
             JLE SUCCESS
             JMP CLICK
             
             SUCCESS: 
             
             INC COUNT
             
             CALL TIMER
             CMP TIME_PASSED, 10
             JGE END_WHILE
             
             CLEAR_SCREEN: 
             MOV AL, 13H
             MOV AH, 0
             INT 10H 
             
             MOV AH, 9
             MOV DX, OFFSET STRING
             INT 21H
             MOV DX, OFFSET CSTRING
             INT 21H    
             
             MOV AH, 2  
             XOR DX,DX
             MOV DL, COUNT
             OR DL, 30H
             INT 21H
                
             MOV AH, 9
             MOV DX, OFFSET TSTRING
             INT 21H
             MOV AH, 2
             MOV DL, TIME_PASSED
             OR DL, 30H
             INT 21H 
             
         JMP WHILE  
         END_WHILE: 
         
             MOV AL, 13H   ; CLEAR SCREEN
             MOV AH, 0
             INT 10H 
             
             MOV AH, 9
             MOV DX, OFFSET STRING
             INT 21H
             MOV DX, OFFSET CSTRING
             INT 21H    
             
             MOV AH, 2  
             XOR DX,DX
             MOV DL, COUNT
             OR DL, 30H
             INT 21H
                
             MOV AH, 9
             MOV DX, OFFSET TSTRING
             INT 21H 
             
             MOV AH, 2
             MOV DL, TIME_PASSED
             OR DL, 30H
             INT 21H
         
         
         MOV AH, 4CH
         INT 21H
  MAIN ENDP

END MAIN