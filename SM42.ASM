INS
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; EQUATES
;
; BOOLEAN EQUATES
;
FALSE EQU $00
TRUE  EQU $80
;
; HARWARE EQUATES
;
PTT      EQU $8000           
ATOD2    EQU $9000           
ATOD7    EQU $9001           
TALK     EQU $A000           
TREADY   EQU $B000           
KYBD     EQU $C000           
KSTB     EQU $D000           
PSTB     EQU $D000           
COS      EQU $E000           
;
; ZERO PAGE EQUATES
;
; MEMORY POINTERS 00-0F
;
VECTL    EPZ $00             
VECTH    EPZ $01             
MONVECTL EPZ $02             
MONVECTH EPZ $03             
;
; INTERNAL FLAGS 10-1F
;
SMPLFLAG EPZ $10             
ADDEDFLG EPZ $11             
AUTOLOCK EPZ $12             
SLZFLAG  EPZ $13             
TMLCKFLG EPZ $14             
PWRFAIL  EPZ $15             
OPENFLAG EPZ $16             
KEYEDFLG EPZ $17             
;
; SETABLE FLAGS 20-2F 
;
FLAGBLK  EPZ $20             
;
SMENABLE EPZ $20             
TLIDENBL EPZ $21             
SPENFLAG EPZ $22             
SBENFLAG EPZ $23             
PTENFLAG EPZ $24             
BOENFLAG EPZ $25             
TCENFLAG EPZ $26             
SMENFLAG EPZ $27             
SCENFLAG EPZ $28             
LKENFLAG EPZ $29             
ULENFLAG EPZ $2A             
;
; INTERNAL PARAMETERS 30-3F
;
CODEGRP  EPZ $30             
;
; SETTABLE PARAMETERS 40-4F
; 
PARMBLK  EPZ $40             
;
QSBLEVEL EPZ $40             
USETIME  EPZ $41             
ABUSELVL EPZ $42             
SBLIMIT  EPZ $43             
PTLIMIT  EPZ $44             
BOTHRESH EPZ $45             
CORRECTL EPZ $46             
CORRECTH EPZ $47             
SCTIMEON EPZ $48             
SCTIMEOF EPZ $49             
SCMAX    EPZ $4A             
SKIPCHAR EPZ $4B             
FLUSHCHR EPZ $4C             
ACCESS   EPZ $4D             
;
; GENERAL USE 50-8F
;
SAVY     EPZ $50             
SAVA     EPZ $51             
BYTE     EPZ $52             
B1       EPZ $53             
B2       EPZ $54             
B3       EPZ $55             
PTR      EPZ $56             
SCOUNTL  EPZ $57             
SCOUNTH  EPZ $58             
SIGNALL  EPZ $59             
SIGNAL   EPZ $5A             
SAVSIG   EPZ $5B             
LOW      EPZ $5C             
HIGH     EPZ $5D             
DIFF     EPZ $5E             
BYTCOUNT EPZ $5F             
NEXT.IN  EPZ $60             
NEXT.OUT EPZ $61             
COMMAND  EPZ $62             
LASTACS  EPZ $63             
CODECHK  EPZ $64             
AMPM     EPZ $65             
TB1      EPZ $66             
TB2      EPZ $67             
TB3      EPZ $68             
TB4      EPZ $69             
DECH     EPZ $6A             
DECL     EPZ $6B             
ABUSENUM EPZ $6C             
ABUSENM2 EPZ $6D             
TALKCNT  EPZ $6E             
TCORRL   EPZ $6F             
TCORRH   EPZ $70             
BOMIN1   EPZ $71             
BOMIN2   EPZ $72             
BOMIND   EPZ $73             
BOSEC1   EPZ $74             
BOSEC2   EPZ $75             
BOSECD   EPZ $76             
PNTR     EPZ $77             
PARM     EPZ $78             
TOSEC    EPZ $79             
TOMIN    EPZ $7A             
TOHRS    EPZ $7B             
TODAY    EPZ $7C             
;
; ACCESS CODE MEMORY
;
CODES    EPZ $C0             
CODE41   EPZ $C9             
CODE42   EPZ $CA
CODE43   EPZ $CB
;
; REGISTERS FOR SAVING ABUSE INFORMATION
;
SAVEWEEK EPZ $D0             
SAVEDAY  EPZ $D1             
SAVEHOUR EPZ $D2             
SAVEMIN  EPZ $D3             
SAVESEC  EPZ $D4             
SAVESIG  EPZ $D5             
SAVETYPE EPZ $D6             
SAVESCEN EPZ $D7             
;
; MISC. SAVED TIME REGISTERS
;
TEMPHOUR EPZ $E0             
TEMPMIN  EPZ $E1             
;
;
; TIME IRQ REGISTERS F0-FF
;
WEEK     EPZ $F0             
DAY      EPZ $F1             
HOUR     EPZ $F2             
MINUTE   EPZ $F3             
SECOND   EPZ $F4             
TICK     EPZ $F5             
USESECS  EPZ $F6             
USEMINS  EPZ $F7             
;
; STORAGE BUFFERS
;
KBUFFER  EQU $0200           
ABUFFER  EQU $0300           
PBUFFER  EQU $0400           
;
; OTHER
;
TRNSLATE EQU $FE00           
;
;
;
;
         ORG $F000           
         OBJ $1000           
;
;
;
;
* BEGINNING OF CODE *
;
; SET UP AFTER RESET
;
COLDSTRT:
;
         CLD                 
         CLI                 
;
         LDA ATOD2           
;
         LDA #$43            
         STA TALK            
;
         LDA #$00            
         STA PWRFAIL
; 
         LDA #$00            
         STA WEEK
         STA DAY
         STA HOUR
         STA MINUTE
         STA SECOND
         STA TICK
         STA TCORRL
         STA TCORRH
         STA TOSEC
         STA TOMIN
         STA TOHRS
         STA TODAY
;
         JSR ON              
;
         LDA #$1A            
         JSR SAYMSG
;
         JSR MEMTEST         
;
; SET UP DEFAULTS
;
INIT:
;
         LDA #$00 
         STA PTR             
         STA ACCESS
         STA NEXT.IN
         STA NEXT.OUT
         STA BYTCOUNT
         STA LASTACS
         STA USESECS
         STA USEMINS
         STA ABUSENUM
         STA ABUSENM2
         STA SAVEHOUR
         STA SAVEMIN
         STA SAVETYPE
         STA SAVESIG
;
         LDA #TRUE
         STA SMENABLE        
         STA SBENFLAG        
         STA PTENFLAG        
         STA TLIDENBL        
         STA SPENFLAG        
         STA TCENFLAG        
         STA SCENFLAG        
         STA SAVESCEN        
         STA BOENFLAG        
         STA LKENFLAG        
         STA SMENFLAG        
         STA ULENFLAG        
;
         LDA #FALSE
         STA SMPLFLAG        
         STA ADDEDFLG 
         STA AUTOLOCK 
         STA SLZFLAG  
         STA TMLCKFLG 
         STA OPENFLAG 
         STA KEYEDFLG 
;
         LDA #$10            
         STA QSBLEVEL
;
         LDA #$1E            
         STA USETIME
;
         LDA #$0C            
         STA SKIPCHAR
;
         LDA #$0C            
         STA FLUSHCHR
;
         LDA #$05            
         STA ABUSELVL
;
         LDA #$04            
         STA SCMAX
;
         LDA #$01            
         STA CODEGRP
;
         JSR SETCODES
;
         LDA #$14            
         STA SBLIMIT
;
         LDA #$10            
         STA PTLIMIT
;
         LDA #$03            
         STA BOTHRESH
;
         LDA #$18
         STA SCTIMEOF        
;
         LDA #$08
         STA SCTIMEON        
;
         LDA #$B0            
         STA CORRECTL
         LDA #$13
         STA CORRECTH
;
         LDA #$03            
         STA ONDELAY
;
; CLEAR PHRASE BUFFER
;
         LDA #$FF
         LDX #$00
;
^1       STA PBUFFER,X
         INX
         BNE <1
;
; COME HERE UPON NMI
;
WARMSTRT:
;
* MAIN EXECUTION LOOP *
;
; PROCESS COMMANDS
;
MAIN:
;
         JSR GETNIB          
         JSR TRANS           
         STA COMMAND         
;
         LDA ACCESS          
         CMP #$05            
         BNE >1              
;
         LDA #$04            
         STA ACCESS
;
^1       LDA ACCESS
         BEQ MAIN            
;
         LDA SMENABLE        
         BNE >1              
;
         LDA ACCESS          
         CMP #$04
         BNE MAIN            
;
^1       LDX ACCESS          
         LDA LVLSKIP,X
         TAX        
;
COMLOOP  LDA COMINDEX,X      
         CMP #$FF            
         BEQ NOCOM
;
         CMP COMMAND
         BEQ EXECUTE
;
         INX
         JMP COMLOOP
;
NOCOM    JMP MAIN
;
EXECUTE:
;
         TXA
         ASL                 
         TAX
         LDA COMMANDS,X      
         STA VECTL
         INX
         LDA COMMANDS,X      
         STA VECTH
         JMP (VECTL)         
;
; COMMAND INDEX AND ADDRESSES
;
LVLSKIP  HEX 000B060200      
;
COMINDEX HEX 000E0A0B0C0D0103040607020508090EFF 
;
COMMANDS ADR TXTIME          
         ADR SYSTEM          
;
         ADR SETPHS          
         ADR DONE            
         ADR DONE            
         ADR SETTIME         
;
         ADR GETDW           
         ADR SAYPHS          
         ADR SETBEAM         
         ADR DETAIL          
         ADR SMCOUR          
;
         ADR SAYTIME         
         ADR PADTEST         
         ADR SMREAD          
         ADR LOCK            
         ADR ID              
;
;
* COMMAND FUNCTIONS *
;
; GIVE MSG IN "*" BUFFER
;
ID:
;
         LDA #$0B
         JMP SAYPHS2
;
; GIVE S METER READING OF BUFFER DATA
;
SMREAD:
;
         JSR ON
;
         JSR READSIG         
         JSR SMREAD2
         JMP DONE
;
SMREAD2:
;
         LDX #$00
         LDA SIGNAL
         CMP #$FF
         BNE >1
;
         LDA #$1C            
         JSR SAYMSG
         JMP SMRQUIT
;
^1       LDA SIGNAL
;
^1       CMP SIGTABLE,X      
         BLT >1
;
         INX
         JMP <1
;
^1       TXA
         CLC
         ADC #$04
         JSR SAYMSG          
;
         LDA QSBLEVEL
         BEQ SMRQUIT         
;
         LDA DIFF
         CMP QSBLEVEL        
         BLT SMRQUIT         
;  
         LDA #$17            
         JSR SAYMSG
;
SMRQUIT:
;
         RTS
;
SIGTABLE HEX 0012294058697E92A5B8CCDFF4FF
;
;
;
; PERFORM COURTESY S METER READING
;
SMCOUR:
;
         LDA SMENFLAG        
         BNE SMCOUR1         
;
         JMP DONE            
;
SMCOUR1  LDA ABUSELVL        
         BEQ SMCOUR2         
;
         INC ABUSENM2        
         LDA ABUSENM2
         CMP ABUSELVL        
         BNE SMCOUR2
;
; CLOSE ACCESS UPON DETECTION OF ABUSE
;
         LDA #$00 
         STA ACCESS          
         STA ABUSENM2        
         LDA #FALSE
         STA OPENFLAG        
         STA SMENABLE        
         JSR SAVETIME        
         JSR READSIG         
         LDA SIGNAL          
         STA SAVESIG         
         LDA #$02            
         STA SAVETYPE
         LDA SCENFLAG        
         STA SAVESCEN
         JMP DONE            
;
SMCOUR2:                     
;
         LDY #$00            
         STY SCOUNTL
         STY SCOUNTH
         LDA #FALSE
         STA SMPLFLAG
;
SMCWAIT  BIT COS             
         BPL SMCWAIT         
;
SMCLOOP  LDA SCOUNTH
         CMP SCMAX
         BEQ SMCCHECK
;
         LDA SCOUNTL         
         CLC
         ADC #$01
         STA SCOUNTL
         LDA SCOUNTH
         ADC #$00
         STA SCOUNTH
         JMP SMCCONT
;
SMCCHECK LDA SMPLFLAG        
         BNE SMCCONT
;
         LDA ATOD2
         STA ABUFFER,Y
         INY 
         BNE SMCCONT
;
         LDA #TRUE           
         STA SMPLFLAG
;
SMCCONT  BIT COS             
         BMI SMCLOOP
;
         LDA SMPLFLAG        
         BEQ SMCOUR2
;
         JMP SMREAD          
;
; SET BEAM FUNCTION
;
SETBEAM:
;
         LDA SBENFLAG
         BEQ SBQUIT          
;
         LDA #$00
         STA TALKCNT         
;
SBWAIT   BIT COS             
         BPL SBWAIT
;
         JSR ON
;
SBLOOP   LDX ATOD2           
         LDA TRNSLATE,X
         JSR SAYDEC          
;
         LDA SBLIMIT         
         BEQ >1
;
         INC TALKCNT
         LDA TALKCNT
         CMP SBLIMIT         
         BLT >1              
         JMP SBQUIT          
;
^1       BIT KYBD            
         BPL SBCONT          
;
         BIT KSTB            
         LDA KYBD
         AND #$0F
         CMP FLUSHCHR        
         BNE SBCONT          
;
         JSR CLEAR           
         JMP SBQUIT          
;
SBCONT   BIT COS             
         BMI SBLOOP          
;
SBQUIT   JMP DONE
;
; SAY THE TIME
;
SAYTIME:
;
         JSR ON
         JSR SAYTIME2
         JMP DONE
;
; SAY TIME SUBROUTINE
;
SAYTIME2:
;
         LDA HOUR            
         STA TEMPHOUR
         LDA MINUTE
         STA TEMPMIN
;
SAYTIME3:
;
         LDA TEMPHOUR        
         CMP #$0C            
         BGE PM              
;
AM       LDA #$20            
         STA AMPM
         JMP >1
;
PM       LDA #$2F            
         STA AMPM
;
^1       LDA TEMPHOUR        
         BNE >1              
;
         LDA #$18            
;
^1       CMP #$0D            
         BLT >1              
;
         SEC                 
         SBC #$0C
;
^1       JSR SAYDEC          
;
         LDA #$45            
         JSR SAY
;
         LDA TEMPMIN
         BEQ >1              
;
         STA SAVA
         LDA #TRUE
         STA SLZFLAG         
         LDA SAVA
         JSR SAYDEC          
         LDA #FALSE
         STA SLZFLAG         
^1       LDA #$46            
         JSR SAY
         LDA AMPM            
         JSR SAY
         LDA #$2C            
         JSR SAY
;
^1       RTS
;
; SAY DAY AND WEEK
;
GETDW:
;
         JSR ON
;
         LDA #$23            
         JSR SAY
         LDA #$45            
         JSR SAY
         LDA DAY
         JSR SAYDEC
         LDA #$47            
         JSR SAY
         LDA #$36            
         JSR SAY
         LDA WEEK
         JSR SAYDEC
;
         JMP DONE
;
; SET THE TIME
;
SETTIME:
;
         LDA BYTCOUNT
         CMP #$01
         BNE >1
         JMP SETDAY          
;
^1       CMP #$02
         BNE >1
         JMP SETWEEK         
;
^1       CMP #$04
         BGE >2
         JMP ENTERR          
;
^2       JSR GETBUF          
         JSR TRANS           
         STA TB1
;
         JSR GETBUF          
         JSR TRANS
         STA TB2
;
         JSR GETBUF          
         JSR TRANS
         STA TB3
;
         JSR GETBUF          
         JSR TRANS
         STA TB4
;
         LDA TB1             
         STA DECH
         LDA TB2
         STA DECL
;
         JSR DEC2HEX         
;
         LDA BYTE            
         CMP #$18
         BLT >1
         JMP TERROR
;
^1       STA TB1             
;
         LDA TB3             
         STA DECH
         LDA TB4
         STA DECL
;
         JSR DEC2HEX         
;
         LDA BYTE            
         CMP #$3C
         BLT >1
;
         JMP TERROR
;
^1       STA TB2             
;
         LDA #$00            
         STA SECOND
         STA TICK
;
         LDA TB1             
         STA HOUR
         LDA TB2
         STA MINUTE
;
         LDA #$D5            
         STA PWRFAIL
;
         JSR ON
;
         LDA #$8B            
         JSR SAY
         LDA #$83            
         JSR SAY
         LDA #$46            
         JSR SAY
;
         JSR SAYTIME2        
;
         JMP DONE
;
; SET THE DAY NUMBER
;
SETDAY:
;
         JSR GETBUF          
         JSR TRANS           
         CMP #$07
         BLT >1
         JMP TERROR          
;
^1       STA DAY
;
         JSR ON 
;
         LDA #$23            
         JSR SAY
         LDA #$20            
         JSR SAY
         LDA #$38            
         JSR SAY
         LDA #$45            
         JSR SAY
         LDA #$83            
         JSR SAY
         LDA #$46            
         JSR SAY
         LDA DAY
         JSR SAYDEC
;
         JMP DONE
;
; SET WEEK NUMBER
;
SETWEEK:
;
         LDA BYTCOUNT
         BNE >1
;
         JMP ENTERR
;
^1       JSR GETBYTE
         STA WEEK
;
         JSR ON 
;
         LDA #$36            
         JSR SAY
         LDA #$24            
         JSR SAY
         LDA #$24            
         JSR SAY
         LDA #$2A            
         JSR SAY
         LDA #$45            
         JSR SAY
         LDA #$83            
         JSR SAY
         LDA #$46            
         JSR SAY
         LDA WEEK
         JSR SAYDEC
;
         JMP DONE
;
; GIVE DETAIL OF S METER READING
;
DETAIL:
;
         JSR ON
;
         LDA #$70            
         JSR SAY
         LDA #$44            
         JSR SAY
         LDA SAVSIG          
         JSR SAYDEC          
         LDA #$46            
         JSR SAY
         LDA #$67            
         JSR SAY
         LDA #$44            
         JSR SAY
         LDA LOW             
         JSR SAYDEC
         LDA #$46            
         JSR SAY
         LDA #$5B            
         JSR SAY
         LDA #$44            
         JSR SAY
         LDA HIGH
         JSR SAYDEC          
;
         JMP DONE
;
; PERFORM PAD TEST
;
PADTEST:
;
         LDA PTENFLAG
         BEQ PTQUIT          
;
         LDA BYTCOUNT        
         BNE >1
         JMP PTQUIT
;
^1       LDA #$00            
         STA TALKCNT
;
         JSR ON
;
PTLOOP   LDA BYTCOUNT        
         BNE >1
;
         JMP PTQUIT
;
^1       JSR GETBUF          
         TAY 
         LDA KEYS,Y          
         JSR SAY             
;
         LDA PTLIMIT         
         BEQ >1
;
         INC TALKCNT         
         LDA TALKCNT
         CMP PTLIMIT
         BLT >1
;
         JSR CLEAR           
         JMP PTQUIT
;
^1       BIT KYBD            
         BPL PTCONT          
;
         BIT KSTB            
         LDA KYBD
         AND #$0F
         CMP FLUSHCHR        
         BNE PTCONT          
;
         JSR CLEAR           
         JMP PTQUIT          
;
PTCONT   JMP PTLOOP          
;
PTQUIT   JMP DONE
;
KEYS     HEX 230102030405060708091F867B202122
;
; STORE MESSAGE INTO MESSAGE BUFFER
;
SETPHS:
;
         LDA BYTCOUNT        
         BNE >2
         JMP ENTERR          
;
^2       LDA /PBUFFER        
         STA VECTH
;
         JSR GETBUF          
         JSR TRANS
         ASL 
         ASL                 
         ASL 
         ASL 
         STA VECTL           
         LDY #$00
;
^1       LDA BYTCOUNT
         CMP #$02            
         BLT >3              
;
         STY SAVY            
         JSR GETBYTE         
         LDY SAVY 
         STA (VECTL),Y       
;
         INY                 
         CPY #$10            
         BEQ >2              
;
         CMP #$FF            
         BNE <1              
;
^3       LDA #$FF            
         STA (VECTL),Y
;
^2       JMP DONE
;
; SAY MESSAGE IN MESSAGE BUFFER
;
SAYPHS:
;
         LDA SPENFLAG        
         BEQ SPQUIT
;
         LDA BYTCOUNT        
         BEQ SPQUIT
;
^1       LDA /PBUFFER        
         STA VECTH
;
         JSR GETBUF
         JSR TRANS
;
; 
;
SAYPHS2:
;
         ASL 
         ASL 
         ASL 
         ASL 
         STA VECTL
;
         LDY #$00
;
         JSR ON
;
SPLOOP   LDA (VECTL),Y       
         CMP #$FF            
         BEQ SPQUIT          
         JSR SAY             
;
         INY 
         CPY #$10            
         BEQ SPQUIT
;
         BIT KYBD            
         BPL >2              
;
         BIT KSTB            
         LDA KYBD
         AND #$0F
         CMP FLUSHCHR        
         BNE >2              
;
         JSR CLEAR           
         JMP SPQUIT          
;
^2       JMP SPLOOP          
;
SPQUIT   JMP DONE
;
; READ BACK TOTAL TX TIME
;
TXTIME:
;
        LDA TODAY
        BEQ >1               
        JSR SAYDEC           
        LDA #$23
        JSR SAY              
        LDA #$81
        JSR SAY              
        LDA #$46
        JSR SAY              
;
^1      LDA TOHRS
        BEQ >1               
        JSR SAYDEC           
        LDA #$5D
        JSR SAY              
        LDA #$81
        JSR SAY              
        LDA #$46
        JSR SAY              
;
^1      LDA TOMIN
        BEQ >1               
        JSR SAYDEC           
        LDA #$6E
        JSR SAY              
        LDA #$81
        JSR SAY              
        LDA #$46
        JSR SAY              
;
^1      LDA TOSEC
        BEQ >1               
        JSR SAYDEC           
        LDA #$82
        JSR SAY              
        LDA #$81
        JSR SAY              
;
^1      RTS
;
;
; PROCESS SYSTEM COMMAND
;
SYSTEM:
;
         BIT KYBD            
         BPL >1              
;
         BIT KSTB            
         LDA KYBD
         AND #$0F
         CMP FLUSHCHR        
         BNE >1              
;
         JSR CLEAR           
;
^1       LDA BYTCOUNT
         BNE >1
;
         JMP DONE            
;
^1       JSR GETBUF          
         JSR TRANS
;
         ASL                 
         TAX
;
         LDA SYSCOM,X
         STA VECTL
         INX
         LDA SYSCOM,X
         STA VECTH
;
         JMP (VECTL)         
;
; ADDRESS OF SYSTEM COMMANDS
;
SYSCOM   ADR ABSTIME         
;
         ADR SETON           
         ADR SETFLAG         
         ADR SETPARM         
;
         ADR SETOFF          
         ADR READFLAG        
         ADR READPARM        
;
         ADR INIT            
         ADR SELFTEST        
         ADR SELCODE         
;
         ADR ADDRESS         
         ADR RUN             
         ADR PEEK            
         ADR POKE            
;
         ADR ENDSYS          
         ADR SEQCODE         
;
; READ TIME OF ABUSE LOCK-UP
;
ABSTIME:
;
         LDA SAVEHOUR        
         STA TEMPHOUR
         LDA SAVEMIN
         STA TEMPMIN
;
         JSR ON
;
         JSR SAYTIME3        
;
         LDA #$46            
         JSR SAY
;
         LDA SAVESIG         
         STA SIGNAL
         JSR SMREAD2
;
         LDA #$46            
         JSR SAY
;
         LDA SAVETYPE        
         JSR SAYDEC
;
         JMP SYSDONE
;
; SET SMETER ON
;
SETON:
;
        LDA #TRUE
        STA SMENABLE         
        LDA SAVESCEN         
        STA SCENFLAG
        JMP SYSDONE
;
; SET SMETER OFF
;
SETOFF:
;
        LDA #FALSE
        STA SMENABLE         
        STA SCENFLAG         
        JMP SYSDONE
;
; SET POINTED-TO PARAMETER IN HEX
;
SETPARM:
;
         LDA BYTCOUNT        
         CMP #$03  
         BGE >1              
;
         JMP ENTERR          
;
^1       JSR GETBUF          
         JSR TRANS           
         STA PNTR            
         TAX
;
         JSR GETBYTE         
         STA PARM            
         STA PARMBLK,X       
;
         JMP READPRM2        
;
; READ POINTED-TO PARAMETER BACK
;
READPARM:
;
         LDA BYTCOUNT        
         BNE >1              
;
         JMP ENTERR          
;
^1       JSR GETBUF          
         JSR TRANS           
         STA PNTR
         TAX
;
         LDA PARMBLK,X       
         STA PARM
;
READPRM2:
;
         JSR ON              
;
         LDA PNTR            
         JSR SAYDEC
         LDA #$45            
         JSR SAY
         LDA PARM            
         JSR SAYHEX
;
         JMP SYSDONE
;
; SET POINTED-TO FLAG TO ON/OFF
;
SETFLAG:
;
         LDA BYTCOUNT        
         CMP #$02  
         BGE >1              
;
         JMP ENTERR          
;
^1       JSR GETBUF          
         JSR TRANS           
         STA PNTR            
         TAX
;
         JSR GETBUF          
         AND #$01            
         BEQ >1              
;
         LDA #TRUE           
         JMP >2
;
^1       LDA #FALSE          
;
^2       STA PARM            
         STA FLAGBLK,X       
;
         JMP READFLG2        
;
; READ POINTED-TO FLAG BACK
;
READFLAG:
;
         LDA BYTCOUNT        
         BNE >1              
;
         JMP ENTERR          
;
^1       JSR GETBUF          
         JSR TRANS           
         STA PNTR
         TAX
;
         LDA FLAGBLK,X       
         STA PARM
;
READFLG2:
;
         JSR ON              
;
         LDA PNTR            
         JSR SAYDEC
         LDA #$45            
         JSR SAY
;
         LDA PARM            
         BEQ >1
;
         LDA #$01            
         JMP >2
;
^1       LDA #$1F            
;
^2       JSR SAY
;
         JMP SYSDONE
;
; PERFORM SELFTEST
;
SELFTEST JSR MEMTEST
         JMP SYSDONE
;
; SELECT ACCESS CODE GROUP
;
SELCODE:
;
         LDA BYTCOUNT
         BEQ >2              
;
         JSR GETBUF
         BNE >1
;
         JMP ENTERR          
;
^1       CMP #$05
         BLT >1
;
         JMP ENTERR          
;
^1       STA CODEGRP
         JSR SETCODES
;
^2       JSR ON
         LDA #$70            
         JSR SAY
         LDA #$45            
         JSR SAY
         LDA CODEGRP
         JSR SAYDEC
;
         JMP SYSDONE
;
SETCODES:
;
         LDX #$00
;
         LDA CODEGRP
         SEC
         SBC #$01
         ASL
         ASL
         ASL 
         ASL
         TAY
;
^1       LDA ACSCODES,Y
         STA CODES,X
         INX
         INY
         CPX #$10
         BNE <1
;       
         RTS
;
ACSCODES HEX 02090A0603050705010401080A0B0CFF 
         HEX 06070A0406050306080601020A0B0CFF 
         HEX 04030A070305060804040A070A0B0CFF 
         HEX 06050A020705090702070A090A0B0CFF 
;
; PERFORM SCRAMBLE ALGORHYTHM ON LEVEL 4 CODE
;
SEQCODE:
;
         LDA CODE41
         CLC
         ADC CODE42
         AND #$0F
         STA B1
;
         LDA CODE42
         CLC
         ADC CODE43
         AND #$0F
         STA B2
;
         LDA CODE43
         CLC
         ADC CODE41
         ADC #$01
         AND #$0F
         STA B3
;
         LDA B1
         STA CODE41
         LDA B2 
         STA CODE42
         LDA B3
         STA CODE43
;
         LDA CODE41
         CMP SKIPCHAR
         BEQ SEQCODE
;
         JMP SYSDONE
;
;
; SET MONITOR PEEK/POKE ADDRESS
;
ADDRESS:
;
         LDA BYTCOUNT
         CMP #$04
         BGE >1
;
         JMP ENTERR
;
^1       JSR GETBYTE
         STA MONVECTH
         JSR GETBYTE
         STA MONVECTL
;
         JSR ON
;
         LDA #$20            
         JSR SAY
         LDA MONVECTH
         JSR SAYHEX
         LDA MONVECTL
         JSR SAYHEX
;
         JMP SYSDONE
;
; JUMP TO PROGRAM
;
RUN:
;
         JMP (MONVECTL)      
;
RET      BIT KYBD            
         BMI >1
;
         RTS
;
^1       PLA                 
         PLA
         JMP SYSDONE
;
; READ MEMORY LOCATION
;
PEEK:
;
         LDA BYTCOUNT
         BEQ PEEK1           
;
         LDA BYTCOUNT
         CMP #$02 
         BGE >1
;
         JMP ENTERR          
;
^1       JSR ON
;
         JSR GETBYTE         
         TAX
;
PEEKLOOP LDY #$00
         LDA (MONVECTL),Y    
         JSR SAYHEX          
         LDA #$46            
         JSR SAY
;
         JSR INCMONVC        
;
         DEX
         BNE PEEKLOOP
;
         JMP SYSDONE
;
PEEK1:
;
         JSR ON
;
         LDY #$00
         LDA (MONVECTL),Y
         JSR SAYHEX
;       
         JSR SYSDONE
;
;
; POKE MEMORY LOCATION
;
POKE:
;
         LDA BYTCOUNT
         CMP #$02
         BGE >1              
;
         JMP ENTERR
;
^1       JSR ON
;
POKELOOP JSR GETBYTE
         LDY #$00
         STA (MONVECTL),Y
;
         JSR SAYHEX
         LDA #$46            
         JSR SAY
;
         JSR INCMONVC        
;
         LDA BYTCOUNT        
         CMP #$02
         BGE POKELOOP
;
         JMP SYSDONE
;
; PROCESSING OF SYSTEM COMMANDS COMPLETE
;
SYSDONE:
;
         JMP SYSTEM          
;
ENDSYS:
;
         JMP DONE            
;
;
; INCREMENT MONITOR VECTOR
;
INCMONVC:
;
         LDA MONVECTL
         CLC
         ADC #$01
         STA MONVECTL
         LDA MONVECTH
         ADC #$00
         STA MONVECTH
;
         RTS
;
; LOCK TO LEVEL 0
;
LOCK:
;
         LDA LKENFLAG        
         BEQ LOCKQUIT
;
         LDA #$00            
         STA ACCESS
         LDA #FALSE
         STA OPENFLAG        
;
LOCKQUIT JMP MAIN            
;
; FINISH UP AFTER PROCESSING COMMANDS
;
DONE:
;
         BIT KYBD            
         BPL >1              
;
         BIT KSTB            
         LDA KYBD
         AND #$0F
         CMP FLUSHCHR        
         BNE >1              
;
         JSR CLEAR           
;
^1       LDA BYTCOUNT        
         BNE >3              
;
; PROCESS AFTER COMPLETING COMMANDS:
;
         BIT AUTOLOCK        
         BPL >1              
;
         LDA LASTACS         
         STA ACCESS
         LDA #FALSE          
         STA AUTOLOCK
;
^1       LDA #FALSE          
         STA ABUSENM2
;
         LDA PWRFAIL         
         CMP #$D5
         BEQ >2
;
         LDA #$10            
         JSR SAYMSG
;
^2       JSR OFF
;
^3       JMP MAIN
;
;
;
* END OF COMMAND FUNCTIONS * 
;
* MEDIUM LEVEL SUBROUTINES * 
;
; GET TOUCH TONES INTO BUFFER
;
GETNIB:
;
         LDA #$00            
         STA SCOUNTL
         STA SCOUNTH
         STA PTR
         LDA #FALSE
         STA ADDEDFLG
         STA KEYEDFLG
;
         LDA BYTCOUNT        
         CMP #$01
         BLT GN.LOOP         
;
         JMP GETBUF          
;
; (THIS IS MAIN WAIT LOOP WHILE IDLING)
;
GN.LOOP  BIT COS             
         BMI STORE           
;
         LDA #$00            
         STA SCOUNTL
         STA SCOUNTH
         STA PTR
         LDA #FALSE
         STA SMPLFLAG
;
         LDA TMLCKFLG        
         BEQ >1
         JSR DOTMDLCK
;
^1       LDA KEYEDFLG        
         BNE >1              
;
         JMP GN.LOOP         
;
^1       JSR BOCHECK         
;
         LDA ADDEDFLG        
         BNE >1
;
         LDA #$00            
         STA ABUSENUM        
         LDA #FALSE
         STA KEYEDFLG        
;
         JMP GN.LOOP         
;
^1       LDA ABUSELVL        
         BEQ >1              
;
         INC ABUSENUM        
         LDA ABUSENUM
         CMP ABUSELVL        
         BNE >1
;
         JSR DOABSLCK        
;
^1       JMP UL.CHECK        
;
STORE    LDA KEYEDFLG        
         BNE >1              
;
         LDA MINUTE          
         STA BOMIN1          
         LDA SECOND
         STA BOSEC1
;
         LDA #TRUE           
         STA KEYEDFLG
;
^1       LDA SCOUNTH
         CMP SCMAX           
         BEQ >1              
;
         LDA SCOUNTL         
         CLC
         ADC #$01
         STA SCOUNTL
         LDA SCOUNTH
         ADC #$00
         STA SCOUNTH
;
         JMP >2
;
^1       LDA SMPLFLAG        
         BNE >2
;
         LDA ATOD2           
         LDY PTR 
         STA ABUFFER,Y       
;
         INC PTR             
         LDA PTR             
         BNE >2
;
         LDA #TRUE           
         STA SMPLFLAG
;
^2       BIT KYBD            
         BMI >1
;
         JMP GN.LOOP         
;
^1       BIT KSTB            
         LDA KYBD            
         AND #$0F            
;
         LDY NEXT.IN
         STA KBUFFER,Y       
         INC NEXT.IN         
         INC BYTCOUNT        
         LDA #TRUE           
         STA ADDEDFLG
         JMP GN.LOOP         
;
; GET BUFFER CHARACTER ONLY
;
GETBUF:
;
         LDY NEXT.OUT 
         LDA KBUFFER,Y       
         INC NEXT.OUT        
         DEC BYTCOUNT        
         BEQ CLEAR           
         RTS 
;
; CLEAR KEYBOARD BUFFER
;
CLEAR:
;
         STA SAVA            
         LDA #$00            
         STA NEXT.IN
         STA NEXT.OUT
         STA BYTCOUNT
         LDA #FALSE
         STA ADDEDFLG
         LDA SAVA            
         RTS 
;
; SEE IF FIRST 3 BYTES ARE AN ACCESS CODE 
;
UL.CHECK:
;
         LDA KBUFFER         
         CMP SKIPCHAR        
         BNE >1              
;
         JSR CLEAR           
         JMP GETNIB
;
^1       LDA BYTCOUNT
         CMP #$03
         BLT GETBUF          
;
         LDX #$00            
         LDY #$00
         STY CODECHK
         LDA ACCESS
         STA LASTACS
         LDA #$01
         STA ACCESS
;
UL.LOOP  LDA KBUFFER,X       
         CMP CODES,Y
         BNE UL.NEXT
;
         INX 
         INY 
;
         CPX #$03            
         BNE UL.LOOP         
;
; (CODE VALIDATED)
;
         LDA BYTCOUNT        
         CMP #$04
         BGE >3              
;
         JSR CLEAR           
;
         LDA ULENFLAG        
         BEQ >2
;
         LDA #$00            
         STA USESECS
         STA USEMINS
         LDA #FALSE
         STA TMLCKFLG
         LDA #TRUE
         STA OPENFLAG
;
^2       JMP GETNIB          
;
^3       LDA BYTCOUNT        
         SEC 
         SBC #$03
         STA BYTCOUNT
         LDA NEXT.OUT
         CLC 
         ADC #$03
         STA NEXT.OUT
         LDA #TRUE
         STA AUTOLOCK        
         JMP GETBUF          
;
UL.NEXT  LDA CODECHK         
         CLC 
         ADC #$03
         STA CODECHK
         CMP #$0F            
         BEQ UL.EXIT         
         TAY 
         LDX #$00
         INC ACCESS
         JMP UL.LOOP         
;
UL.EXIT  LDA LASTACS         
         STA ACCESS
         JMP GETBUF          
;
; CLOSE ACCESS UPON TIMED LOCKUP
;
DOTMDLCK:
;
         LDA #$00 
         STA ACCESS          
         LDA #FALSE
         STA OPENFLAG        
         STA TMLCKFLG        
;
         LDA TLIDENBL
         BEQ >1
;
         JSR ON              
;
         LDA #$1B            
         JSR SAYMSG
;
         JSR OFF             
;
^1       RTS
;
; CLOSE ACCESS UPON DETECTION OF ABUSE
;
DOABSLCK:
;
         LDA #$00 
         STA ACCESS          
         STA ABUSENUM        
         LDA #FALSE
         STA OPENFLAG        
         STA SMENABLE        
         STA KEYEDFLG        
         JSR SAVETIME        
         JSR READSIG         
         LDA SIGNAL
         STA SAVESIG         
         LDA #$01            
         STA SAVETYPE
         LDA SCENFLAG        
         STA SAVESCEN
;
         RTS       
;
; SAVE TIME OF ABUSE LOCK
;
SAVETIME:
;
        LDA WEEK
        STA SAVEWEEK
        LDA DAY
        STA SAVEDAY
        LDA HOUR
        STA SAVEHOUR
        LDA MINUTE
        STA SAVEMIN
        LDA SECOND
        STA SAVESEC
        RTS
;
; BABBLEOMETER FUNCTION
;
BOCHECK:
;
         LDA MINUTE          
         STA BOMIN2
         LDA SECOND
         STA BOSEC2
;
         LDA BOMIN2          
         SEC
         SBC BOMIN1
         STA BOMIND
         BPL >1              
;
         CLC                 
         ADC #$3C
         STA BOMIND
;
^1       LDA BOSEC2          
         SEC
         SBC BOSEC1
         STA BOSECD
         BPL >1              
;
         CLC                 
         ADC #$3C
         STA BOSECD
         DEC BOMIND          
;
         JSR ADDTIME         
;
^1       LDA BOMIND          
         CMP BOTHRESH
         BGE >1              
;
         RTS                 
;
^1       LDA BOENFLAG        
         BNE >1              
;
         RTS                 
;
^1       JSR ON              ; TURN TRANSMITTER ON
;
         LDA BOMIND          ; SKIP IF MINUTES ARE ZERO
         BEQ SAYSEC
;
         JSR SAYDEC          
         LDA #$6E            
         JSR SAY
;
         LDA BOMIND          
         CMP #$02
         BLT SAYSEC
;
         LDA #$81            
         JSR SAY
;
SAYSEC   LDA BOSECD          
         BEQ >1
;
         LDA #$45
         JSR SAY             
;
         LDA BOSECD          
         JSR SAYDEC
         LDA #$82            
         JSR SAY
;
         LDA BOSECD          
         CMP #$02
         BLT >1
;
         LDA #$81            
         JSR SAY
;
^1       JSR OFF             
         RTS
;
; ROUTINE TO COUNT TX TIME
;
ADDTIME:
;
        LDA TOSEC
        CLC
        ADC BOSECD
        STA TOSEC
        CMP #$3C
        BLT >1
;
        INC TOMIN
        LDA #$00
        STA TOSEC
;
^1      LDA TOMIN
        CLC
        ADC BOMIND
        STA TOMIN
        CMP #$3C
        BLT >1
;
        LDA #$00
        STA TOMIN
;
        INC TOHRS
        LDA TOHRS
        CMP #$18
        BLT >1
;
        INC TODAY
        LDA #$00
        STA TOHRS
;
^1      RTS
;
;
; OUTPUT HEX BYTE AS DECIMAL SPEECH
;
SAYDEC:
;
         STA SAVA            
;
         LDA #$00            
         STA B1
         STA B2
         STA B3
;
         LDA SAVA
;
D1       CMP #$64 
         BLT D2              
;
         SEC                 
         SBC #$64            
         INC B1              
         JMP D1
;
D2       CMP #$0A
         BLT D3              
;
         SEC                 
         SBC #$0A            
         INC B2              
         JMP D2
;
D3       STA B3              
;
; CORRECT FOR PROPER NUMERIC PRONUNCIATION
;
         LDA B1
         BEQ SD1             
;
         JSR SAY             
         JMP SD2
;
SD1:
         BIT SLZFLAG         
         BMI SD2             
;
         LDA B2
         BEQ SD4             
;
SD2:
;
         LDA B2
         CMP #$01
         BEQ SD3             
;
         CMP #$00 
         BNE >1              
;
         BIT SLZFLAG         
         BPL >2              
;
         LDA #$2E            
         JMP >3
;
^2       LDA #$1F            
^3       JSR SAY
         JMP SD4
;
^1       CLC                 
         ADC #$12            
         JSR SAY
         JMP SD35            
;
SD3:
;
         LDA #$0A            
         CLC                 
         ADC B3              
         JSR SAY
         JMP SD5
;
SD35:
;
         LDA B3              
         BEQ SD5
SD4:
;
         LDA B3
         BNE >1              
;
         LDA #$1F            
         JSR SAY
         JMP SD5
;
^1       JSR SAY             
;
SD5:
;
         RTS 
;
; AVERAGE UP SAMPLE IN SIGNAL BUFFER 
;
READSIG:
;
         LDA #$00            
         STA SIGNALL
         STA SIGNAL
         STA HIGH
         LDA #$FF
         STA LOW
;
         LDY #$00
;
RL       LDX ABUFFER,Y       
         LDA TRNSLATE,X      
         STA BYTE
;
         CMP HIGH
         BLT >1              
;
         STA HIGH            
;
^1       CMP LOW
         BGE >1              
;
         STA LOW             
;
^1       JSR ADD             
         INY 
         BNE RL              
;
         LDA HIGH
         SEC 
         SBC LOW
         STA DIFF            
;
         LDA SIGNAL
         STA SAVSIG
         RTS 
;
; SAY BYTE AS HEXIDECIMAL
;
SAYHEX:
;
         STA SAVA 
;
         LSR                 
         LSR
         LSR
         LSR
         STA B1
;
         LDA SAVA
;
         AND #$0F            
         STA B2
;
         LDY B1
         LDA TRANSHEX,Y
         JSR SAY
;        
         LDY B2
         LDA TRANSHEX,Y
         JSR SAY
;
         RTS
;
; TABLE CONVERTING HEX TO SPEECH
;
TRANSHEX HEX 1F010203040506070809202122232425
;
;
; SAY INTERNAL MESSAGE
;
SAYMSG:
;
         ASL                 
         TAX 
         LDA INDEX,X
         STA VECTL
         INX 
         LDA INDEX,X
         STA VECTH
;
         LDY #$00
;
MSGLOOP:
;
         LDA (VECTL),Y       
         CMP #$FF
         BEQ DONEMSG         
;
         JSR SAY             
         INY 
         JMP MSGLOOP
;
DONEMSG  RTS 
;
; INDEX TO MESSAGES
;
INDEX:
;
         ADR S0              
         ADR S1              
         ADR S2              
         ADR S3              
         ADR S4              
         ADR S5              
         ADR S6              
         ADR S7              
         ADR S8              
         ADR S9              
         ADR S95             
         ADR S910            
         ADR S915            
         ADR S920            
         ADR S925            
         ADR S930            
         ADR S935            
         ADR S940            
         ADR S945            
         ADR S950            
         ADR S955            
         ADR S960            
;
         ADR PF              
         ADR QSB             
         ADR RAMERR          
         ADR ROMERR          
         ADR VERSION         
         ADR TLIDMSG         
         ADR S1M             
;
; TEXT OF MESSAGES
;
S0       HEX 321FFF
S1       HEX 3201FF
S2       HEX 3202FF
S3       HEX 3203FF
S4       HEX 3204FF
S5       HEX 3205FF
S6       HEX 3206FF
S7       HEX 3207FF
S8       HEX 3208FF
S9       HEX 3209FF
S95      HEX 05753209FF
S910     HEX 0A753209FF
S915     HEX 0F753209FF
S920     HEX 14753209FF
S925     HEX 1405753209FF
S930     HEX 15753209FF
S935     HEX 1505753209FF
S940     HEX 16753209FF
S945     HEX 1605753209FF
S950     HEX 17753209FF
S955     HEX 1705753209FF
S960     HEX 18753209FF
;
PF       HEX 2F25FF
QSB      HEX 46303221FF
RAMERR   HEX 31202C51FF
ROMERR   HEX 312E2C51FF
VERSION  HEX 2D0622222C8145326A473544047A02FF
TLIDMSG  HEX 36210635282645326AFF
S1M      HEX 32011EFF
;
; PERFORM RAM AND ROM TEST
;
MEMTEST:
;
         LDA #$00
         STA $00
         LDA $00
         CMP #$00
         BNE MEMERR
;
         LDA #$FF
         STA $00
         LDA $00
         CMP #$FF
         BNE MEMERR
;
         LDA #$55
         STA $00
         LDA $00
         CMP #$55
         BNE MEMERR
;
         LDA #$AA
         STA $00
         LDA $00
         CMP #$AA
         BNE MEMERR
;
         LDA #$00
         STA $01
         LDA $01
         CMP #$00
         BNE MEMERR
;
         LDA #$FF
         STA $01
         LDA $01
         CMP #$FF
         BNE MEMERR
;
         LDA #$55
         STA $01
         LDA $01
         CMP #$55
         BNE MEMERR
;
         LDA #$AA
         STA $01
         LDA $01
         CMP #$AA
         BNE MEMERR
;
         LDY #$02
         LDA #$00
         STA $00
         STA $01
;
         JMP MTLOOP
;
MEMERR   JMP MEMERR1
;
MTLOOP:
;
         LDA ($00),Y
         TAX 
;
         LDA #$00
         STA ($00),Y
         LDA ($00),Y
         CMP #$00
         BNE MEMERR
;
         LDA #$FF
         STA ($00),Y
         LDA ($00),Y
         CMP #$FF
         BNE MEMERR
;
         LDA #$55
         STA ($00),Y
         LDA ($00),Y
         CMP #$55
         BNE MEMERR
;
         LDA #$AA
         STA ($00),Y
         LDA ($00),Y
         CMP #$AA
         BNE MEMERR
;
         TXA 
         STA ($00),Y
;
         INY 
         BNE MTLOOP
;
         INC $01
         LDA $01
         CMP #$08
         BLT MTLOOP
;
         LDA #FALSE
         STA $05             
         JMP ROMTEST
;
MEMERR1:
;
         JSR ON
         LDA #$18            
         JSR SAYMSG
         LDA #TRUE
         STA $05             
;
ROMTEST:
;
         LDA #$00
         STA $00
         STA $01
;
         LDA #$00
         STA $02
         LDA #$F0
         STA $03
;
         LDY #$00
;
RTLOOP:
;
         CPY #$F8
         BNE >1
;
         LDA $03
         CMP #$FF
         BNE >1
;
         JMP RTCHECK
;
^1       LDA ($02),Y
;
         CLC 
         ADC $00
         STA $00
;
         BCC RTCONT
;
         INC $01
;
RTCONT   INY 
         BNE RTLOOP
;
         INC $03
         JMP RTLOOP
;
RTCHECK:
;
;
         LDA $00
         CMP $FFF8
         BNE MEMERR2
;
         LDA $01
         CMP $FFF9
         BNE MEMERR2
;
         LDA $05
         BNE >1              
;
         JSR ON              
         LDA #$2E            
         JSR SAY
         LDA #$2A            
         JSR SAY
         JSR OFF             
^1       RTS
;
MEMERR2:
;
         JSR ON
         LDA #$19            
         JSR SAYMSG
         JSR OFF
         RTS
;
;
;
* LOW LEVEL SUBROUTINES * 
;
; TURN TRANSMITTER ON
;
ON:
;
         BIT PTT
         LDA #$47            
;
^1       LDX ONDELAY         
         JSR SAY
         DEX
         BNE <1
;
         RTS 
;
; TURN TRANSMITTER OFF
;
OFF:
;
         BIT PSTB            
         RTS 
;
; SAY WORD IN "A" REGISTER FOLLOWED BY DELAY
;
SAY:
;
         STA SAVA            
         JSR SAY2            
         LDA #$43            
         JSR SAY2 
         LDA SAVA            
         RTS 
;
; STORE WORD BYTE TO DIGITALKER WHEN READY
;
SAY2:
;
         BIT TREADY          
         BPL SAY2 
         STA TALK            
         RTS 
;
; GET TWO KEYSTROKES AND CONVERT TO 8 BIT BYTE
;
GETBYTE:
;
         JSR GETNIB          
         JSR TRANS           
         ASL                 
         ASL 
         ASL 
         ASL 
         STA BYTE            
         JSR GETNIB          
         JSR TRANS           
         CLC 
         ADC BYTE
         STA BYTE            
         RTS 
;
; TRANSLATE KEYSTROKE TO HEX
;
TRANS:
;
         TAY 
;
         LDA TRAN,Y
         RTS 
;
TRAN     HEX 0D010203040506070809000E0F0A0B0C
;
; CONVERT DEC TO HEX (0 0 - 9 9 TO 00h - 63h)
;
DEC2HEX:
;
         LDX #$00
         LDA #$00
;
^1       CPX DECH            
         BEQ >1
         CLC 
         ADC #$0A
         INX 
         JMP <1
;
^1       CLC 
         ADC DECL
         STA BYTE
;
         RTS
;
; GIVE ERROR MESSAGE IN CASE TIME ENTERED WRONG
;
TERROR:
;
         JSR ON
         LDA #$51            
         JSR SAY
         JMP DONE
;
; ACCUMULATE 16 BIT NUMBER
;
ADD:
;
         LDA SIGNALL
         CLC 
         ADC BYTE
         STA SIGNALL
;
         LDA SIGNAL
         ADC #$00
         STA SIGNAL
;
         RTS 
;
; GIVE ERROR MESSAGE AND CLEAR BUFFER IN CASE DATA ENTERED WRONG
;
ENTERR:
;
         JSR CLEAR
         JSR ON
         LDA #$51            
         JSR SAY
         JMP DONE
;
;
* END OF SUBROUTINES * 
;
;
        ORG $FF00
        OBJ $1F00
;
; REAL TIME CLOCK INTERUPT HANDLING ROUTINE
;
IRQ:
;
         PHA                 
         TYA 
         PHA 
         TXA 
         PHA 
;
         LDA TCENFLAG        
         BEQ >2
;
         INC TCORRL          
         BNE >1              
;
         INC TCORRH          
;
^1       LDA TCORRH          
         CMP CORRECTH
         BNE >2              
;
         LDA TCORRL          
         CMP CORRECTL
         BNE >2              
;
         LDA #$00            
         STA TCORRH
         STA TCORRL
         JMP IRQRET          
;
; START OF MAIN TIME ROUTINE
;
^2       INC TICK            
         LDA TICK
         CMP #$3C
         BNE IRQRET          
;
         LDA #$00
         STA TICK
;
         JSR INCUSESC        
;
         INC SECOND          
         LDA SECOND
         CMP #$3C
         BNE IRQRET          
;
         LDA #$00
         STA SECOND
;
         INC MINUTE          
         LDA MINUTE
         CMP #$3C
         BNE IRQRET          
;
         LDA #$00
         STA MINUTE
;
         INC HOUR            
;
         JSR CHKSCHED        
;
         LDA HOUR
         CMP #$18
         BNE IRQRET          
;
         LDA #$00
         STA HOUR
;
         INC DAY             
         LDA DAY
         CMP #$07
         BNE IRQRET
;
         LDA #$00
         STA DAY
;      
         INC WEEK
;
IRQRET   PLA                 
         TAX 
         PLA 
         TAY 
         PLA 
         RTI 
;
INCUSESC:
;
         LDA OPENFLAG
         BEQ >1              
;
         LDA USETIME
         BEQ >1              
;
         INC USESECS         
         LDA USESECS
         CMP #$3C
         BLT >1
;
         LDA #$00
         STA USESECS
;
         INC USEMINS         
         LDA USEMINS
;
         CMP USETIME
         BLT >1              
;
         LDA #TRUE           
         STA TMLCKFLG
;
^1       RTS 
;
CHKSCHED:
;
         LDA SCENFLAG        
         BEQ >2
;
         LDA SCTIMEON        
         CMP HOUR
         BNE >1              
;
         LDA #TRUE
         STA SMENABLE        
         JMP >2
;
^1       LDA SCTIMEOF        
         CMP HOUR
         BNE >2              
;
         LDA #FALSE
         STA SMENABLE        
;
^2       RTS
;
;
; TRANSLATION TABLE FOR ADC SAMPLES
;
         ORG $FE00
         OBJ $1E00
;
         HEX 0001020303040405
         HEX 060708090A0B0B0C
         HEX 0C0D0E0F10111212
         HEX 1313141516161718
         HEX 1A1A1B1C1D1E1F20
         HEX 2222232425252627
         HEX 292A2B2C2D2D2E2F
         HEX 3131323335353637
         HEX 39393A3B3D3E3F40
         HEX 4142434446474848
         HEX 494A4B4C4E4F5050
         HEX 5152535354545556
         HEX 585859595A5B5C5D
         HEX 5E5F606061616263
         HEX 6465666667676869
         HEX 6B6B6C6D6E6F7071
         HEX 7273747475767778
         HEX 797A7B7B7C7D7E7F
         HEX 8182838384858687
         HEX 89898A8C8E8F9192
         HEX 949596989A9B9C9D
         HEX 9FA0A2A4A6A7A8A9
         HEX AAABADAEB0B1B2B4
         HEX B6B8BABBBCBEC0C1
         HEX C3C4C6C7C8C8C9CA
         HEX CBCBCCCDCFD0D1D2
         HEX D3D3D4D5D7D8D9DA
         HEX DBDBDCDDDEDFE0E0
         HEX E1E2E3E3E4E5E6E7
         HEX E8E9EAEBECEDEEEF
         HEX F0F1F2F3F4F5F6F7
         HEX F8F9FAFBFCFDFEFF
;
; MICROPROCESSOR RESET VECTORS
;
         ORG $FFFA
         OBJ $1FFA
;
         ADR WARMSTRT        
         ADR COLDSTRT        
         ADR IRQ             
;
* END OF CODE * 
;
         END 
