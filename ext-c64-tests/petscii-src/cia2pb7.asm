;---------------------------------------;CIA2PB7.ASM - THIS FILE IS PART;OF THE �64 �MULATOR �EST �UITE;PUBLIC DOMAIN, NO COPYRIGHT           *= $0801           .BYTE $4C,$14,$08,$00,$97TURBOASS   = 780           .TEXT "780"           .BYTE $2C,$30,$3A,$9E,$32,$30           .BYTE $37,$33,$00,$00,$00           .BLOCK           LDA #1           STA TURBOASS           LDX #0           STX $D3           LDA THISNAMEPRINTTHIS           JSR $FFD2           INX           LDA THISNAME,X           BNE PRINTTHIS           JSR MAIN           LDA #$37           STA 1           LDA #$2F           STA 0           JSR $FD15           JSR $FDA3           JSR PRINT           .TEXT " - OK"           .BYTE 13,0           LDA TURBOASS           BEQ LOADNEXT           JSR WAITKEY           JMP $8000           .BENDLOADNEXT           .BLOCK           LDX #$F8           TXS           LDA NEXTNAME           CMP #"-"           BNE NOTEMPTY           JMP $A474NOTEMPTY           LDX #0PRINTNEXT           JSR $FFD2           INX           LDA NEXTNAME,X           BNE PRINTNEXT           LDA #0           STA $0A           STA $B9           STX $B7           LDA #<NEXTNAME           STA $BB           LDA #>NEXTNAME           STA $BC           JMP $E16F           .BEND;---------------------------------------;PRINT TEXT WHICH IMMEDIATELY FOLLOWS;THE ��� AND RETURN TO ADDRESS AFTER 0PRINT           .BLOCK           PLA           STA NEXT+1           PLA           STA NEXT+2           LDX #1NEXT           LDA $1111,X           BEQ END           JSR $FFD2           INX           BNE NEXTEND           SEC           TXA           ADC NEXT+1           STA RETURN+1           LDA #0           ADC NEXT+2           STA RETURN+2RETURN           JMP $1111           .BEND;---------------------------------------;PRINT HEX BYTEPRINTHB           .BLOCK           PHA           LSR A           LSR A           LSR A           LSR A           JSR PRINTHN           PLA           AND #$0FPRINTHN           ORA #$30           CMP #$3A           BCC NOLETTER           ADC #6NOLETTER           JMP $FFD2           .BEND;---------------------------------------;WAIT UNTIL RASTER LINE IS IN BORDER;TO PREVENT GETTING DISTURBED BY ���SWAITBORDER           .BLOCK           LDA $D011           BMI OKWAIT           LDA $D012           CMP #30           BCS WAITOK           RTS           .BEND;---------------------------------------;WAIT FOR A KEY AND CHECK FOR ����WAITKEY           .BLOCK           JSR $FD15           JSR $FDA3           CLIWAIT           JSR $FFE4           BEQ WAIT           CMP #3           BEQ STOP           RTSSTOP           LDA TURBOASS           BEQ LOAD           JMP $8000LOAD           JSR PRINT           .BYTE 13           .TEXT "BREAK"           .BYTE 13,0           JMP LOADNEXT           .BEND;---------------------------------------THISNAME   .NULL "CIA2PB7"NEXTNAME   .NULL "CIA1TAB"MAIN;---------------------------------------;OLD CRB 0 START;    CRB 1 PB7OUT;    CRB 2 PB7TOGGLE;NEW CRB 0 START;    CRB 1 PB7OUT;    CRB 2 PB7TOGGLE;    CRB 4 FORCE LOAD           .BLOCK           JMP STARTI          .BYTE 0OLD        .BYTE 0NEW        .BYTE 0OR         .BYTE 0RIGHT      .TEXT "----------------"           .TEXT "0000000000000000"           .TEXT "----------------"           .TEXT "1111111111111111"           .TEXT "----------------"           .TEXT "0000000000000000"           .TEXT "----------------"           .TEXT "1111111111111111"START           LDA #0           STA ILOOP           LDA #$80           STA $DD03           LDA #0           STA $DD01           STA $DD0E           STA $DD0F           LDA #127           STA $DD0D           BIT $DD0D           LDA #$FF           STA $DD06           STA $DD07           LDA I           AND #%00000111           STA $DD0F           STA OLD           LDA I           LSR A           LSR A           PHA           AND #%00010000           STA OR           PLA           LSR A           AND #%00000111           ORA OR           STA $DD0F           STA NEW           LDA $DD01           EOR #$80           STA $DD01           CMP $DD01           BEQ MINUS           EOR #$80           ASL A           LDA #"0"/2           ROL A           JMP NOMINUSMINUS           LDA #"-"NOMINUS           LDX I           CMP RIGHT,X           BEQ OK           PHA           JSR PRINT           .BYTE 13           .TEXT "OLD NEW PB7  "           .BYTE 0           LDA OLD           JSR PRINTHB           LDA #32           JSR $FFD2           LDA NEW           JSR PRINTHB           LDA #32           JSR $FFD2           PLA           JSR $FFD2           JSR WAITKEYOK           INC I           BMI END           JMP LOOPEND           .BEND;---------------------------------------;TOGGLE PB7, CRB ONE SHOT, START TIMER;-> PB7 MUST BE HIGH;WAIT UNTIL CRB HAS STOPPED;-> PB7 MUST BE LOW;WRITE CRB, WRITE TA LOW/HIGH, FORCE;LOAD, PB7ON, PB7TOGGLE;-> PB7 MUST REMAIN LOW;START;-> PB7 MUST GO HIGH           .BLOCK           LDA #0           STA $DD0F           LDX #100           STX $DD06           STA $DD07           SEI           JSR WAITBORDER           LDA #$0F           STA $DD0F           LDA #$80           BIT $DD01           BNE OK1           JSR PRINT           .BYTE 13           .NULL "PB7 IS NOT HIGH"           JSR WAITKEYOK1           LDA #$01WAIT           BIT $DD0F           BNE WAIT           LDA #$80           BIT $DD01           BEQ OK2           JSR PRINT           .BYTE 13           .NULL "PB7 IS NOT LOW"           JSR WAITKEYOK2           LDA #$0E           STA $DD0F           LDA #$80           BIT $DD01           BEQ OK3           JSR PRINT           .BYTE 13           .TEXT "WRITING CRB MAY "           .TEXT "NOT SET PB7 HIGH"           .BYTE 0           JSR WAITKEYOK3           LDA #100           STA $DD06           LDA #$80           BIT $DD01           BEQ OK4           JSR PRINT           .BYTE 13           .TEXT "WRITING TA LOW MAY "           .TEXT "NOT SET PB7 HIGH"           .BYTE 0           JSR WAITKEYOK4           LDA #0           STA $DD05           LDA #$80           BIT $DD01           BEQ OK5           JSR PRINT           .BYTE 13           .TEXT "WRITING TA HIGH MAY "           .TEXT "NOT SET PB7 HIGH"           .BYTE 0           JSR WAITKEYOK5           LDA #$1E           STA $DD0F           LDA #$80           BIT $DD01           BEQ OK6           JSR PRINT           .BYTE 13           .TEXT "FORCE LOAD MAY "           .TEXT "NOT SET PB7 HIGH"           .BYTE 0           JSR WAITKEYOK6           LDA #%00001010           STA $DD0F           LDA #%00001110           STA $DD0F           LDA #$80           BIT $DD01           BEQ OK7           JSR PRINT           .BYTE 13           .TEXT "SWITCHING TOGGLE "           .TEXT "MAY NOT SET PB7 HIGH"           .BYTE 0           JSR WAITKEYOK7           LDA #%00001100           STA $DD0F           LDA #%00001110           STA $DD0F           LDA #$80           BIT $DD01           BEQ OK8           JSR PRINT           .BYTE 13           .TEXT "SWITCHING PB7ON "           .TEXT "MAY NOT SET PB7 HIGH"           .BYTE 0           JSR WAITKEYOK8           SEI           JSR WAITBORDER           LDA #%00000111           STA $DD0F           LDA #$80           BIT $DD01           BNE OK9           JSR PRINT           .BYTE 13           .TEXT "START MUST SET "           .TEXT "PB7 HIGH"           .BYTE 0           JSR WAITKEYOK9           LDA #$80           LDX #0WAITLOW0           DEX           BEQ TIMEOUT           BIT $DD01           BNE WAITLOW0WAITHIGH0           DEX           BEQ TIMEOUT           BIT $DD01           BEQ WAITHIGH0WAITLOW1           DEX           BEQ TIMEOUT           BIT $DD01           BNE WAITLOW1WAITHIGH1           DEX           BEQ TIMEOUT           BIT $DD01           BEQ WAITHIGH1           JMP OKTIMEOUT           JSR PRINT           .BYTE 13           .NULL "PB7 TOGGLE TIMED OUT"           JSR WAITKEYOK           .BEND;---------------------------------------;CRB PB7ON/TOGGLE 4 COMBINATIONS;WAIT UNTIL UNDERFLOW;SET BOTH PB7ON AND TOGGLE;-> PB7 MUST BE INDEPENDENT FROM;   PB7ON/TOGGLE STATE AT UNDERFLOW           .BLOCK           JMP STARTI          .BYTE 0START           LDA #3           STA ILOOP           LDA #0           STA $DD0F           LDA #15           STA $DD06           LDA #0           STA $DD07           SEI           JSR WAITBORDER           LDA I           SEC           ROL A           STA $DD0F           LDX #$07           STX $DD0F           LDY $DD01           STA $DD0F           LDX #$07           STX $DD0F           LDA $DD01           AND #$80           BNE ERROR           TYA           AND #$80           BNE OKERROR           JSR PRINT           .BYTE 13           .TEXT "TOGGLE STATE IS NOT "           .NULL "INDEPENDENT "           LDA I           JSR PRINTHB           JSR WAITKEYOK           DEC I           BPL LOOP           .BEND;---------------------------------------;CHECK PB7 TIMING           .BLOCK           JMP STARTSETTAB     .BYTE 7,7,7,7,7,7           .BYTE 3,3,3,3,3,3,3,3LOADTAB    .BYTE 7,6,3,2,1,0           .BYTE 7,6,5,4,3,2,1,0COMPTAB    .BYTE 1,0,0,1,0,0           .BYTE 0,1,0,0,0,0,0,1I          .BYTE 0START           LDA #LOADTAB-SETTAB-1           STA ILOOP           LDA #0           STA $DD0F           LDX I           LDA LOADTAB,X           STA $DD06           LDA #0           STA $DD07           SEI           JSR WAITBORDER           LDX I           LDA SETTAB,X           STA $DD0F           NOP           NOP           LDA $DD01           ASL A           LDA #0           ROL A           CMP COMPTAB,X           BEQ OK           JSR PRINT           .BYTE 13           .NULL "TIMING ERROR INDEX "           LDA I           JSR PRINTHB           JSR WAITKEYOK           DEC I           BPL LOOP           .BEND;---------------------------------------           RTS