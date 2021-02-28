;
; **** ZP ABSOLUTE ADRESSES **** 
;
a00 = $00
a01 = $01
a02 = $02
a03 = $03
a04 = $04
a05 = $05
a06 = $06
a07 = $07
a08 = $08
a09 = $09
a0A = $0A
a0B = $0B
a0C = $0C
a0D = $0D
a0E = $0E
a10 = $10
a11 = $11
a12 = $12
a13 = $13
a14 = $14
a15 = $15
a16 = $16
a17 = $17
a18 = $18
a19 = $19
a1A = $1A
a1B = $1B
a1C = $1C
a1D = $1D
a1E = $1E
a22 = $22
a23 = $23
a24 = $24
a25 = $25
a26 = $26
a27 = $27
a28 = $28
a29 = $29
a2A = $2A
a2B = $2B
a2C = $2C
a2D = $2D
a2E = $2E
a2F = $2F
a30 = $30
a31 = $31
a32 = $32
a33 = $33
a34 = $34
a35 = $35
a36 = $36
a37 = $37
a38 = $38
a39 = $39
a3A = $3A
a3B = $3B
a3C = $3C
a3D = $3D
a3E = $3E
a3F = $3F
mysteryBonusEarned = $40
bonusBits = $41
aC5 = $C5
;
; **** ZP POINTERS **** 
;
p00 = $00
p06 = $06
;
; **** FIELDS **** 
;
f0340 = $0340
f0360 = $0360
f0FFF = $0FFF
SCREEN_RAM = $1000
f93FF = $93FF
f9400 = $9400
f9442 = $9442
f9500 = $9500
mysteryBonusPerformance = $1D00
;
; **** ABSOLUTE ADRESSES **** 
;
a028D = $028D
a0291 = $0291
a1015 = $1015
a1133 = $1133
;
; **** POINTERS **** 
;
p03 = $0003
p0106 = $0106
p0108 = $0108
p0109 = $0109
p0113 = $0113
p0170 = $0170
p0171 = $0171
p0200 = $0200
p0301 = $0301
p0313 = $0313
p0317 = $0317
p033C = $033C
p0405 = $0405
p0507 = $0507
p070E = $070E
p070F = $070F
p075E = $075E
p0A07 = $0A07
p0C05 = $0C05
p0F00 = $0F00
p1000 = $1000
p1002 = $1002
p1042 = $1042
p1080 = $1080
p10F0 = $10F0
;
; **** PREDEFINED LABELS **** 
;
VICCR0 = $9000
VICCR1 = $9001
VICCR4 = $9004
VICCR5 = $9005
VICCRA = $900A
VICCRB = $900B
VICCRC = $900C
VICCRD = $900D
VICCRE = $900E
VICCRF = $900F
VIA1IER = $911E
VIA1PA2 = $911F
VIA2PB = $9120
VIA2DDRB = $9122

* = $1201
;-----------------------------------------------------------------------------------------------------
; SYS 8192 (PrepareGame)
; This launches the program from address $2000, i.e. PrepareGame.
;-----------------------------------------------------------------------------------------------------
; $9E = SYS
        .BYTE $0B,$08,$0A,$00,$9E,$38,$31,$39,$32,$00

.include "padding-vic20.asm"

;-------------------------------------------------------------------------
; s2000
;-------------------------------------------------------------------------
s2000
        JMP j3BA0

;-------------------------------------------------------------------------
; s2003
;-------------------------------------------------------------------------
s2003   LDA #>p1000
        STA a01
        LDA #<p1000
        STA a00
p200B   LDX #$00
b200D   LDA a00
        STA f0340,X
        LDA a01
        STA f0360,X
        LDA a00
        CLC 
        ADC #$16
        STA a00
        LDA a01
;-------------------------------------------------------------------------
; s2020
;-------------------------------------------------------------------------
s2020   ADC #$00
        STA a01
        INX 
        CPX #$18
        BNE b200D
        RTS 

;-------------------------------------------------------------------------
; s202A
;-------------------------------------------------------------------------
s202A   LDX a03
        LDY a02
        LDA f0340,X
        STA a00
        LDA f0360,X
        STA a01
        RTS 

;-------------------------------------------------------------------------
; s2039
;-------------------------------------------------------------------------
s2039   JSR s202A
        LDA (p00),Y
        RTS 

;-------------------------------------------------------------------------
; s203F
;-------------------------------------------------------------------------
s203F   JSR s202A
        LDA a04
        STA (p00),Y
        LDA a01
        CLC 
        ADC #$84
        STA a01
        LDA a05
        STA (p00),Y
        RTS 

;-------------------------------------------------------------------------
; s2052
;-------------------------------------------------------------------------
s2052   LDX #$00
b2054   LDA #$20
        STA p1000,X
        STA SCREEN_RAM + $0100,X
        LDA #$01
        STA f9400,X
        STA f9500,X
        DEX 
        BNE b2054
        RTS 

j2068   LDA #$80
        STA a0291
        LDA #$02
        STA VIA1IER  ;$911E - interrupt enable register (IER)
        LDA #$30
        LDX #$07
b2076   STA f14F0,X
        DEX 
        BNE b2076
        LDA #$00
        STA VICCRE   ;$900E - sound volume
        LDA #$08
        STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDA #$CD
        STA VICCR5   ;$9005 - screen map & character map address
        JSR s2052
        JSR s2003
        JMP j20A6

;-------------------------------------------------------------------------
; s2094
;-------------------------------------------------------------------------
s2094   LDX #$28
b2096   LDA f20AE,X
        STA f0FFF,X
        LDA f20DA,X
        STA f93FF,X
        DEX 
        BNE b2096
        RTS 

j20A6   JSR s2094
        JSR s37A6
f20AE   =*+$02
        JMP j216E

        .BYTE $23,$24,$22,$25,$26,$27,$20,$19
        .BYTE $1A,$20,$30,$30,$30,$30,$30,$30
        .BYTE $30,$20,$20,$07,$20,$35,$21,$21
        .BYTE $21,$21,$21,$21,$20,$20,$20,$20
        .BYTE $20,$20,$20,$20,$20,$20,$20,$20
        .BYTE $20,$20,$20
f20DA   .BYTE $20,$43,$43,$43,$43,$43,$43,$40
        .BYTE $44,$44,$40,$47,$47,$47,$47,$47
        .BYTE $47,$47,$40,$40,$45,$40,$43,$44
        .BYTE $44,$44,$44,$44,$44,$40,$40,$40
        .BYTE $40,$40,$40,$40,$40,$40,$40,$40
        .BYTE $40,$40,$40,$40
f2106   .BYTE $40
        .BYTE $06,$02,$04,$05,$03,$07,$01
;-------------------------------------------------------------------------
; s210E
;-------------------------------------------------------------------------
s210E   LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        RTS 

;-------------------------------------------------------------------------
; s2122
;-------------------------------------------------------------------------
s2122   LDX a02
b2124   LDY a03
b2126   DEY 
        BNE b2126
        DEX 
        BNE b2124
        RTS 

;-------------------------------------------------------------------------
; s212D
;-------------------------------------------------------------------------
s212D   LDA #>p1042
        STA a01
        LDA #<p1042
        STA a00
b2135   LDA #$00
        LDY #$14
b2139   STA (p00),Y
        DEY 
        BNE b2139
        LDA a01
        PHA 
        CLC 
        ADC #$84
        STA a01
        LDX a06
        LDA f2106,X
        LDY #$14
b214D   STA (p00),Y
        DEY 
        BNE b214D
        LDA a00
        ADC #$16
        STA a00
        PLA 
        ADC #$00
        STA a01
        INC a06
        LDA a06
        CMP #$08
        BNE b2169
        LDA #$01
        STA a06
b2169   DEC a07
        BNE b2135
        RTS 

j216E   LDA #$C6
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        LDA #$8B
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$00
        LDX #$08
b217C   STA SCREEN_RAM + $03FF,X
        DEX 
        BNE b217C
        LDA #<p0113
        STA a08
        LDA #>p0113
        STA a09
b218A   LDA a09
        STA a06
        LDA #$14
        SEC 
        SBC a08
        STA a07
        INC VICCRE   ;$900E - sound volume
        LDA VICCRE   ;$900E - sound volume
        CMP #$10
        BNE b21A2
        DEC VICCRE   ;$900E - sound volume
b21A2   JSR s212D
        LDX #$00
b21A7   LDA #$FF
        STA f1400,X
        TXA 
        PHA 
        LDA #<p1080
        STA a02
        LDA #>p1080
        STA a03
        JSR s2122
        PLA 
        TAX 
b21BB   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b21BB
        LDA #$00
        STA f1400,X
        INX 
        CPX #$08
        BNE b21A7
        DEC a09
        BNE b21D4
        LDA #$07
        STA a09
b21D4   DEC a08
        BNE b218A
        LDX #$08
b21DA   LDA #$FF
        STA SCREEN_RAM + $03FF,X
        TXA 
        PHA 
        LDA #<p10F0
        STA a02
        LDA #>p10F0
        STA a03
        JSR s2122
        PLA 
        TAX 
        DEX 
        BNE b21DA
        LDA #$02
        LDX #$00
b21F5   STA f9442,X
        STA f9500,X
        INX 
        BNE b21F5
        LDA #<p03
        STA a06
        LDA #>p03
        STA a07
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
b2209   LDX #$80
b220B   STX VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDY #$00
b2210   DEY 
        BNE b2210
        INX 
        BNE b220B
        LDY #$08
b2218   LDX a07
        LDA f16D8,X
        STA SCREEN_RAM + $03FF,Y
        INC a07
        DEY 
        BNE b2218
        LDA VICCRE   ;$900E - sound volume
        SBC #$05
        STA VICCRE   ;$900E - sound volume
        DEC a06
        BNE b2209
j2231   JSR s327F
        LDA #$00
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        JSR s3301
        LDA #$A0
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #>p150A
        STA a0B
        LDA #<p150A
        STA a0A
        LDA #$09
        STA a06
b2253   LDA #$0F
        SEC 
        SBC a06
        STA VICCRE   ;$900E - sound volume
        LDA a0A
        SEC 
        SBC a06
        STA a02
        LDA a0B
        SBC a06
        SEC 
        STA a03
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        JSR s203F
        LDA a0A
        CLC 
        ADC a06
        STA a02
        JSR s203F
        DEC a06
        DEC a02
        INC a03
        LDA #<p0317
        STA a04
        LDA #>p0317
        STA a05
        JSR s203F
        LDA a0A
        SEC 
        SBC a06
        STA a02
        DEC a04
        JSR s203F
        LDA a06
        CLC 
        ADC #$01
        ASL 
        ASL 
        ASL 
        STA a02
        LDA #$00
        STA a03
        JSR s2122
        LDA a06
        CMP #$00
        BNE b2253
        LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #$03
        STA a06
b22BB   LDA #$01
        CLC 
        ADC a06
        LDX #$00
b22C2   STA f9442,X
        STA f9500,X
        DEX 
        BNE b22C2
        LDA a0A
        STA a02
        LDA a0B
        STA a03
        LDA #<p0507
        STA a04
        LDA #>p0507
        STA a05
        JSR s203F
        LDA #$FF
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b22E3   LDY #$00
b22E5   DEY 
        BNE b22E5
        DEC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        CMP #$7F
        BNE b22E3
        LDA VICCRE   ;$900E - sound volume
        SBC #$05
        STA VICCRE   ;$900E - sound volume
        DEC a06
        BNE b22BB
        JSR s210E
        LDA #$00
        LDX #$20
b2305   STA SCREEN_RAM + $0320,X
        DEX 
        BNE b2305
        STA a10
        STA a17
        STA a39
        STA a1E
        STA a28
        STA a31
        STA a36
        STA a3D
        STA mysteryBonusEarned
        LDA #>p0301
        STA a15
        LDA #<p0301
        STA a14
        STA a16
        LDA #$02
        STA a35
        LDA #$20
        STA a26
        STA a27
        STA a2D
        STA a2E
        LDA #$13
        STA a29
        LDA #$40
        STA a2B
        STA a2C
        LDA #$04
        STA bonusBits
j2343   JSR s23A4
        JSR s24E4
        JSR s256C
        JSR s263D
        JSR s28C6
        JSR s3067
        JSR s24B4
        JMP j2343

;-------------------------------------------------------------------------
; s235B
;-------------------------------------------------------------------------
s235B   SEI 
        LDX #$7F
        STX VIA2DDRB ;$9122 - data direction register for port b
b2361   LDY VIA2PB   ;$9120 - port b I/O register
        CPY VIA2PB   ;$9120 - port b I/O register
        BNE b2361
        LDX #$FF
        STX VIA2DDRB ;$9122 - data direction register for port b
        LDX #$F7
        STX VIA2PB   ;$9120 - port b I/O register
        CLI 
b2374   LDA VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        CMP VIA1PA2  ;$911F - mirror of VIA1PA1 (CA1 & CA2 unaffected)
        BNE b2374
        PHA 
        AND #$1C
        LSR 
        CPY #$80
        BCC b2386
        ORA #$10
b2386   TAY 
        PLA 
        AND #$20
        CMP #$20
        TYA 
        ROR 
        EOR #$8F
f2391   =*+$01
        STA a0D
f2392   RTS 

f2393   .BYTE $0C,$0D,$0E,$0F,$10,$11,$12,$0A
a239B   .BYTE $08,$03,$04,$05,$06,$0A,$13,$14
        .BYTE $15
;-------------------------------------------------------------------------
; s23A4
;-------------------------------------------------------------------------
s23A4   DEC a0E
        BEQ b23B2
        LDA a0E
        CMP #$80
        BEQ b23AF
        RTS 

b23AF   JMP j2492

b23B2   JSR s235B
        JSR s341A
        LDA a0A
        STA a02
        CMP #$03
        BEQ b23C4
        CMP #$12
        BNE b23CA
b23C4   LDA bonusBits
        AND #$FB
        STA bonusBits
b23CA   LDA a0B
        STA a03
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        JSR s203F
        LDA a0D
        AND #$01
        BEQ b23E9
        DEC a03
        LDA a03
        CMP #$06
        BNE b23E9
        INC a03
b23E9   LDA a0D
        AND #$02
        BEQ b23F9
        INC a03
        LDA a03
        CMP #$16
        BNE b23F9
        DEC a03
b23F9   LDA #$00
        STA a0C
        LDA a0D
        AND #$04
        BEQ b2411
        LDA #$01
        STA a0C
        DEC a02
        BNE b2411
        INC a02
        LDA #$00
        STA a0C
b2411   LDA a0D
        AND #$08
        BEQ b2429
        LDA #$02
        STA a0C
        INC a02
        LDA a02
        CMP #$15
        BNE b2429
        DEC a02
        LDA #$00
        STA a0C
b2429   JSR s27D5
        LDA a0D
        AND #$80
        BEQ b2449
        LDA a10
        BNE b2449
        LDA a0A
        STA a11
        LDA a0B
        STA a12
        DEC a12
        LDA #$01
        STA a10
        LDA #$DE
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b2449   LDA a0C
        BNE b2460
;-------------------------------------------------------------------------
; s244D
;-------------------------------------------------------------------------
s244D   LDA a0A
        STA a02
        LDA a0B
        STA a03
        LDA #<p0507
        STA a04
        LDA #>p0507
        STA a05
        JMP s203F

b2460   LDA a0B
        STA a03
        LDA #$05
        STA a05
        LDA a0C
        CMP #$02
        BEQ b2480
        LDA #$0B
        STA a04
        LDA a0A
        STA a02
        JSR s203F
        INC a04
        INC a02
        JMP s203F

b2480   LDA #$0C
        STA a04
        LDA a0A
        STA a02
        JSR s203F
        DEC a04
        DEC a02
        JMP s203F

j2492   JSR s273B
        LDA a0C
        BNE b249A
        RTS 

b249A   JSR s244D
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        INC a02
        LDA a0C
        CMP #$02
        BNE b24B1
        DEC a02
        DEC a02
b24B1   JMP s203F

;-------------------------------------------------------------------------
; s24B4
;-------------------------------------------------------------------------
s24B4   LDA #<p0106
        STA a02
        LDA #>p0106
        STA a03
        LDA aC5
        CMP #$40
        BNE b24C5
b24C2   JMP s2122

b24C5   LDA a028D
        AND #$07
        CMP #$07
        BEQ b24E1
        CMP #$04
        BNE b24C2
b24D2   LDA aC5
        CMP #$40
        BNE b24D2
b24D8   LDA aC5
        CMP #$40
        BEQ b24D8
        JMP s2122

b24E1   JMP j342A

;-------------------------------------------------------------------------
; s24E4
;-------------------------------------------------------------------------
s24E4   DEC a13
        BEQ b24E9
b24E8   RTS 

b24E9   LDA #$30
        STA a13
        LDA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        AND #$80
        BEQ b24F7
        DEC VICCRD   ;$900D - frequency of sound osc.4 (noise)
b24F7   LDA a10
        BEQ b24E8
        AND #$F0
        BEQ b2514
        CMP #$10
        BNE b2506
        JMP j2F92

b2506   CMP #$20
        BNE b250D
        JMP j3026

b250D   CMP #$30
        BNE b2514
        JMP j2FE1

b2514   LDA a10
        AND #$02
        BNE b2536
        LDA #$01
        STA a05
        LDA a11
        STA a02
        LDA a12
        STA a03
        JSR s27FD
        LDA #$09
        STA a04
        LDA a10
        EOR #$02
        STA a10
        JMP s203F

b2536   LDA a11
        STA a02
        LDA a12
        STA a03
        LDA #>p0200
        STA a05
        LDA #<p0200
        STA a04
        JSR s203F
        DEC a12
        DEC a03
        LDA a03
        CMP #$02
        BNE b2558
        LDA #$00
        STA a10
        RTS 

b2558   LDA #>p0108
        STA a05
        LDA #<p0108
        STA a04
        LDA a10
        EOR #$02
        STA a10
        JSR s27FD
        JMP s203F

;-------------------------------------------------------------------------
; s256C
;-------------------------------------------------------------------------
s256C   LDA a0E
        CMP #$30
        BEQ b2573
b2572   RTS 

b2573   DEC a16
        BNE b2572
        JSR s2855
        LDA #$02
        STA a16
        JSR s3376
        LDA a17
        BNE b25B9
        LDA #<p033C
        STA a04
        LDA #>p033C
        STA a05
        LDA #$00
        STA a02
        LDA a15
        STA a03
        JSR s203F
        INC a04
        INC a03
        JSR s203F
        LDA #<p3A16
        STA a03
        LDA #>p3A16
        STA a04
        LDA a14
        STA a02
        JSR s203F
        INC a02
        INC a04
        LDA #$01
        STA a17
        JMP s203F

b25B9   LDA #$20
        STA a04
        LDA #$00
        STA a02
        LDA a15
        STA a03
        JSR s203F
        INC a03
        JSR s203F
        LDA #$16
        STA a03
        LDA a14
        STA a02
        JSR s203F
        INC a02
        JSR s203F
        INC a14
        LDA a14
        CMP #$15
        BNE b25E9
        LDA #$01
        STA a14
b25E9   INC a15
        LDA a15
        CMP #$16
        BNE b25F5
        LDA #$03
        STA a15
b25F5   LDA #$00
        STA a17
        LDA #$03
        STA a05
        LDA a14
        STA a02
        LDA #$02
        STA a04
        JSR s203F
        LDA #$00
        STA a02
        LDA a15
        STA a03
        LDA #$01
        STA a04
        JSR s203F
        LDA a36
        AND #$80
        BEQ b2627
        LDA a14
        CMP a0A
        BNE b2627
        LDA #$01
        STA a18
b2627   DEC a18
        BNE b2643
        LDA a14
        STA a1B
        LDA a15
        STA a1C
        LDA #$01
        STA a1A
        LDA #$90
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        RTS 

;-------------------------------------------------------------------------
; s263D
;-------------------------------------------------------------------------
s263D   LDA a13
        CMP #$02
        BEQ b2644
b2643   RTS 

b2644   JSR s285F
        JSR s2C60
        LDA a18
        BNE b2643
        LDA a1A
        CMP a1B
        BEQ b2683
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        LDA a1A
        STA a02
        LDA a1C
        STA a03
        JSR s203F
        INC a1A
        INC a02
        JMP j2671

b266E   JMP j3447

j2671   LDA #$01
        STA a05
        INC a1D
        LDA a1D
        AND #$01
        CLC 
        ADC #$03
        STA a04
        JSR s203F
b2683   LDA #$15
        STA a03
        LDA a1B
        STA a02
        LDA a1D
        AND #$01
        CLC 
        ADC #$05
        STA a04
b2694   JSR s203F
        DEC a03
        LDA a03
        CMP #$02
        BNE b2694
        LDA a1B
        CMP a0A
        BEQ b266E
        LDA a1A
        CMP a1B
        BEQ b26AC
        RTS 

b26AC   LDA #$15
        STA a03
        LDA #>p0200
        STA a05
        LDA #<p0200
        STA a04
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        LDA a1B
        STA a02
b26BF   JSR s203F
        DEC a03
        LDA a03
        CMP #$02
        BNE b26BF
        LDA a1C
        STA a03
        LDA #>p070F
        STA a05
        LDA #<p070F
        STA a04
        JSR s203F
        LDA a19
        STA a18
        LDA #<p1042
        STA a06
        LDA #>p1042
        STA a07
        LDA bonusBits
        ORA #$08
        STA bonusBits
        LDY #$00
b26ED   LDA (p06),Y
        BEQ b26F4
        JSR s2701
b26F4   INC a06
        BNE b26ED
        INC a07
        LDA a07
        CMP #$12
        BNE b26ED
        RTS 

;-------------------------------------------------------------------------
; s2701
;-------------------------------------------------------------------------
s2701   CMP #$20
        BNE b2706
        RTS 

b2706   LDX #$07
b2708   CMP f2392,X
        BEQ b2711
        DEX 
        BNE b2708
        RTS 

b2711   LDA f2393,X
        STA (p06),Y
        LDA bonusBits
        AND #$F7
        STA bonusBits
        CPX #$07
        BEQ b2721
        RTS 

b2721   LDX #$20
b2723   LDA SCREEN_RAM + $0320,X
        BEQ b2730
        DEX 
        BNE b2723
        LDA #$0D
        STA (p06),Y
        RTS 

b2730   LDA a06
        STA SCREEN_RAM + $0300,X
        LDA a07
        STA SCREEN_RAM + $0320,X
        RTS 

;-------------------------------------------------------------------------
; s273B
;-------------------------------------------------------------------------
s273B   LDX #$20
b273D   LDA SCREEN_RAM + $0320,X
        BEQ b2745
        JSR s2751
b2745   DEX 
        BNE b273D
f2748   RTS 

        .BYTE $07,$0B,$0C
f274C   .BYTE $0C,$20,$02,$3A,$3B
;-------------------------------------------------------------------------
; s2751
;-------------------------------------------------------------------------
s2751   STX a08
        LDA SCREEN_RAM + $0300,X
        STA a06
        LDA SCREEN_RAM + $0320,X
        STA a07
        LDY #$00
        TYA 
        STA (p06),Y
        LDA a07
        PHA 
        CLC 
        ADC #$84
        STA a07
        LDA #$02
        STA (p06),Y
        PLA 
        STA a07
        LDA a06
        CLC 
        ADC #$16
        STA a06
        LDA a07
        ADC #$00
        STA a07
        LDA (p06),Y
        LDX #$04
b2782   CMP f2748,X
        BNE b278A
        JMP b266E

b278A   CMP f274C,X
        BEQ b27AE
        DEX 
        BNE b2782
        LDA #$0A
        STA (p06),Y
        LDA a07
        PHA 
        CLC 
        ADC #$84
        STA a07
        LDA #$01
        STA (p06),Y
        LDX a08
        LDA a06
        STA SCREEN_RAM + $0300,X
        PLA 
        STA SCREEN_RAM + $0320,X
        RTS 

b27AE   LDX a08
        LDA #$00
        STA SCREEN_RAM + $0320,X
        RTS 

b27B6   JSR s2039
        BEQ b27CC
        LDX a239B
b27BE   CMP a239B,X
        BEQ b27C9
        DEX 
        BNE b27BE
        STX a0C
        RTS 

b27C9   JMP b266E

b27CC   LDA a02
        STA a0A
        LDA a03
        STA a0B
        RTS 

;-------------------------------------------------------------------------
; s27D5
;-------------------------------------------------------------------------
s27D5   LDA a02
        CMP a0A
        BEQ b27B6
        LDA a03
        CMP a0B
        BEQ b27B6
        LDA a02
        PHA 
        LDA a0A
        STA a02
        JSR s2039
        BNE b27F3
        PLA 
        STA a02
        JMP b27B6

b27F3   LDA a0B
        STA a03
        PLA 
        STA a02
        JMP b27B6

;-------------------------------------------------------------------------
; s27FD
;-------------------------------------------------------------------------
s27FD   JSR s2039
        CMP #$08
        BEQ b283A
        LDX #$07
b2806   CMP f2392,X
        BEQ b2811
        DEX 
        BNE b2806
        JMP j2B09

b2811   LDA f2391,X
        STA a04
        LDA #$07
        STA a05
        CPX #$02
        BNE b2831
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        LDX #$06
        LDY #$01
        JSR s283B
        LDA #$04
        STA a1E
b2831   JSR s203F
        LDA #$00
        STA a10
        PLA 
        PLA 
b283A   RTS 

;-------------------------------------------------------------------------
; s283B
;-------------------------------------------------------------------------
s283B   TXA 
        PHA 
b283D   INC SCREEN_RAM + $0009,X
        LDA SCREEN_RAM + $0009,X
        CMP #$3A
        BNE b284F
        LDA #$30
        STA SCREEN_RAM + $0009,X
        DEX 
        BNE b283D
b284F   PLA 
        TAX 
        DEY 
        BNE s283B
        RTS 

;-------------------------------------------------------------------------
; s2855
;-------------------------------------------------------------------------
s2855   LDA a1509
        ROL 
        ADC #$00
        STA a1509
        RTS 

;-------------------------------------------------------------------------
; s285F
;-------------------------------------------------------------------------
s285F   JSR s288E
        LDA a1E
        BNE b2867
        RTS 

b2867   LDA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        AND #$80
        BNE b287E
        LDA a1E
        ASL 
        ASL 
        CLC 
        ADC a1E
        STA VICCRE   ;$900E - sound volume
        LDA #$F6
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        RTS 

b287E   INC VICCRB   ;$900B - frequency of sound osc.2 (alto)
        BEQ b2884
b2883   RTS 

b2884   DEC a1E
        BNE b2883
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        RTS 

;-------------------------------------------------------------------------
; s288E
;-------------------------------------------------------------------------
s288E   LDA a3D
        BNE b28B2
        LDA a39
        BNE b2897
        RTS 

b2897   LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        CMP #$D0
        BEQ b28A2
        DEC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        RTS 

b28A2   DEC a39
        BEQ b28AC
        LDA #$D8
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        RTS 

b28AC   LDA #$00
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b28B1   RTS 

b28B2   DEC a3D
        LDA a3D
        STA VICCRE   ;$900E - sound volume
        BNE b28B1
        LDA #$00
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        RTS 

;-------------------------------------------------------------------------
; s28C6
;-------------------------------------------------------------------------
s28C6   DEC a22
        LDA a22
        CMP #$01
        BEQ b28CF
b28CE   RTS 

b28CF   LDA #$00
        STA a22
        JSR s2EBF
        LDA a25
        BNE b28DD
        JMP j2954

b28DD   LDA a26
        BEQ b28CE
        CMP #$01
        BEQ b28EA
        DEC a26
        JMP j2954

b28EA   LDA a24
        CMP a23
        BNE b292B
        INC a28
        LDX a28
        LDA #$03
        STA f1980,X
        LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        AND #$01
        BEQ b290D
        LDA #$0A
        STA f1900,X
        LDA #$81
        STA f1A00,X
        JMP j2917

b290D   LDA #$0C
        STA f1900,X
        LDA #$80
        STA f1A00,X
j2917   LDA a3F
        AND #$80
        BEQ b292B
        LDA a25
        AND #$01
        BEQ b292B
        LDA f1A00,X
        ORA #$04
        STA f1A00,X
b292B   INC a28
        LDX a28
        LDA #$0B
        STA f1900,X
        LDA #$03
        STA f1980,X
        LDA #$00
        STA f1A00,X
        DEC a24
        BEQ b2945
        JMP j2954

b2945   LDA #$40
        STA f1A00,X
        LDA a27
        STA a26
        LDA a23
        STA a24
        DEC a25
j2954   INC a29
        LDA a29
        CMP #$15
        BNE b2960
        LDA #$13
        STA a29
b2960   LDX a28
        LDA a28
        BNE b2967
        RTS 

b2967   LDA f1A00,X
        AND #$80
        BNE b2971
        JMP j2A1A

b2971   JSR s2BF8
        LDA f1A00,X
        AND #$04
        BEQ b297E
        JMP j2A6A

b297E   LDA f1900,X
        STA a02
        LDA f1980,X
        STA a03
        LDA f1A00,X
        AND #$40
        BEQ b299E
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        STX a07
        JSR s203F
        LDX a07
b299E   LDA f1A00,X
        AND #$01
        BEQ b29A9
        DEC a02
        DEC a02
b29A9   INC a02
        LDA a02
        BEQ b29B6
        CMP #$15
        BEQ b29B6
        JMP j29B9

b29B6   JMP j29F6

j29B9   STX a07
        JSR s2039
        LDX a07
        CMP #$00
        BEQ b29D6
        CMP #$07
        BEQ b29D3
        CMP #$0B
        BEQ b29D3
        CMP #$0C
        BEQ b29D3
        JMP j29F6

b29D3   JMP b266E

b29D6   LDA a02
        STA f1900,X
        LDA a03
        STA f1980,X
        LDA #$03
        STA a05
        LDA a29
        STA a04
        STX a07
        JSR s203F
        LDX a07
j29EF   DEX 
        BEQ b29F5
        JMP b2967

b29F5   RTS 

j29F6   INC a03
        LDA f1900,X
        STA a02
        LDA f1A00,X
        EOR #$01
        STA f1A00,X
        LDA a03
        CMP #$15
        BNE b29D6
        DEC a03
        LDA f1A00,X
        EOR #$01
        ORA #$06
        STA f1A00,X
        JMP b29D6

j2A1A   LDA f1900,X
        STA a02
        LDA f1980,X
        STA a03
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        LDA f1A00,X
        AND #$40
        BEQ b2A3A
        STX a07
        JSR s203F
        LDX a07
b2A3A   LDA f18FF,X
        STA f1900,X
        STA a02
        LDA f197F,X
        STA f1980,X
        STA a03
        STX a07
        JSR s2039
        LDX a07
        CMP #$07
        BNE b2A58
        JMP b266E

b2A58   LDA #>p0313
        STA a05
        LDA #<p0313
        STA a04
        STX a07
        JSR s203F
        LDX a07
        JMP j29EF

j2A6A   LDA f1900,X
        STA a02
        LDA f1980,X
        STA a03
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        LDA f1A00,X
        AND #$40
        BEQ b2A8A
        STX a07
        JSR s203F
        LDX a07
b2A8A   LDA f1A00,X
        STA a08
        AND #$01
        BEQ b2A97
        DEC a02
        DEC a02
b2A97   INC a02
        LDA a08
        AND #$02
        BEQ b2AA3
        DEC a03
        DEC a03
b2AA3   INC a03
        STX a07
        JSR s2039
        LDX a07
        CMP #$07
        BEQ b2ABF
        CMP #$0B
        BEQ b2ABF
        CMP #$0C
        BNE b2AC2
        CMP #$00
        BEQ b2AC2
        JMP j2AE2

b2ABF   JMP b266E

b2AC2   LDA #$00
        STA a09
        LDA a02
        BEQ j2AE2
        CMP #$15
        BEQ j2AE2
j2ACE   LDA a03
        CMP #$02
        BEQ b2AF5
        CMP #$16
        BEQ b2AF5
j2AD8   LDA a09
        BNE b2ADF
        JMP b29D6

b2ADF   JMP b2A8A

j2AE2   LDA a08
        EOR #$01
        STA f1A00,X
        LDA f1980,X
        STA a03
        LDA #$01
        STA a09
        JMP j2ACE

b2AF5   LDA f1A00,X
        EOR #$02
        STA f1A00,X
        LDA f1900,X
        STA a02
        LDA #$01
        STA a09
        JMP j2AD8

j2B09   CMP #$13
        BEQ b2B18
        CMP #$14
        BEQ b2B18
        CMP #$15
        BEQ b2B18
        JMP j2DED

b2B18   PHA 
        LDA a03
        CMP #$03
        BNE b2B29
        LDA a24
        CMP a23
        BEQ b2B29
        PLA 
        JMP j2DED

b2B29   PLA 
        LDX a28
b2B2C   LDA f1900,X
        CMP a02
        BEQ b2B37
b2B33   DEX 
        BNE b2B2C
        RTS 

b2B37   LDA f1980,X
        CMP a03
        BNE b2B33
        LDA a10
        AND #$30
        BEQ b2B4A
        LDA bonusBits
        ORA #$80
        STA bonusBits
b2B4A   LDA #$00
        STA a10
        LDA #$04
        STA a39
        LDA #$D0
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA f1A00,X
        AND #$C0
        CMP #$C0
        BNE b2B67
        LDA #$04
        STA a08
        JMP j2BC8

b2B67   CMP #$40
        BNE b2B7B
        LDA f1A00,X
        ORA f19FF,X
        STA f19FF,X
        LDA #$01
        STA a08
        JMP j2BC8

b2B7B   CMP #$80
        BEQ b2BAF
        STX a07
b2B81   DEX 
        LDA f1A00,X
        AND #$80
        BEQ b2B81
        LDA f1A00,X
        LDX a07
        ORA f1A01,X
        STA f1A01,X
        AND #$04
        BEQ b2BA0
        LDA f1A01,X
        EOR #$01
        STA f1A01,X
b2BA0   LDA #$01
        STA a08
        LDA #$40
        ORA f19FF,X
        STA f19FF,X
        JMP j2BC8

b2BAF   LDA f1A00,X
        ORA f1A01,X
        STA f1A01,X
        AND #$04
        BEQ b2BC4
        LDA f1A01,X
        EOR #$01
        STA f1A01,X
b2BC4   LDA #$04
        STA a08
j2BC8   LDA f1901,X
        STA f1900,X
        LDA f1981,X
        STA f1980,X
        LDA f1A01,X
        STA f1A00,X
        CPX a28
        BEQ b2BE2
        INX 
        JMP j2BC8

b2BE2   DEC a28
        LDX #$05
        LDY a08
        JSR s283B
        LDA #>p070E
        STA a05
        LDA #<p070E
        STA a04
        PLA 
        PLA 
        JMP s203F

;-------------------------------------------------------------------------
; s2BF8
;-------------------------------------------------------------------------
s2BF8   LDA a2A
        CMP #$02
        BPL b2BFF
b2BFE   RTS 

b2BFF   DEC a2B
        BEQ b2C19
        LDA a2A
        CMP a04
        BMI b2BFE
        LDA f1900,X
        CMP a0A
        BNE b2BFE
        DEC a2D
        BEQ b2C15
b2C14   RTS 

b2C15   LDA a2E
        STA a2D
b2C19   LDA a2C
        STA a2B
        LDA a0B
        SEC 
        SBC f1980,X
        BVS b2C14
        CMP #$04
        BMI b2C14
        STX a07
        LDX #$20
b2C2D   LDA SCREEN_RAM + $0320,X
        BEQ b2C36
        DEX 
        BNE b2C2D
        RTS 

b2C36   STX a08
        LDX a07
        LDA f1900,X
        STA a02
        LDA f1980,X
        STA a03
        STX a07
        JSR s202A
        TYA 
        CLC 
        ADC a00
        STA a00
        LDA a01
        ADC #$00
        LDX a08
        STA SCREEN_RAM + $0320,X
        LDA a00
        STA SCREEN_RAM + $0300,X
        LDX a07
        RTS 

;-------------------------------------------------------------------------
; s2C60
;-------------------------------------------------------------------------
s2C60   DEC a2F
        BEQ b2C65
        RTS 

b2C65   LDA a30
        STA a2F
        LDA a23
        BNE b2C70
        JSR ReduceScore
b2C70   LDA a32
        BNE b2C75
        RTS 

b2C75   LDA a34
        BNE b2C7C
        JMP j2CA5

b2C7C   DEC a32
        BEQ b2C83
        JMP j2CA5

b2C83   LDA a33
        STA a32
        INC a31
        LDX a31
        LDA #$03
        STA f1B00,X
        LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        AND #$0F
        CLC 
        ADC #$04
        STA f1A80,X
        LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        AND #$40
        STA f1B80,X
        DEC a34
j2CA5   LDX a31
        CPX #$00
        BNE b2CAC
        RTS 

b2CAC   LDA f1B80,X
        AND #$20
        BEQ b2CB6
        JMP j2E72

b2CB6   LDA f1B80,X
        AND #$01
        BEQ b2CC0
        JMP j2D79

b2CC0   LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        LDA f1A80,X
        STA a02
        LDA f1B00,X
        STA a03
        LDA f1B80,X
        AND #$40
        BEQ b2CDD
        INC a02
        INC a02
b2CDD   DEC a02
        STX a07
        JSR s203F
        LDX a07
j2CE6   LDA f1A80,X
        STA a02
        LDA #>p075E
        STA a05
        LDA #<p075E
        STA a04
        LDA f1B80,X
        AND #$40
        BEQ b2CFE
        LDA #$61
        STA a04
b2CFE   STX a07
        JSR s203F
        LDX a07
        LDA f1B80,X
        AND #$40
        BEQ b2D10
        DEC a02
        DEC a02
b2D10   INC a02
        JSR s2039
        BEQ b2D5E
        LDX a07
        LDA f1A80,X
        STA a02
        INC a03
        LDA f1B80,X
        EOR #$40
        STA f1B80,X
        LDA f1A80,X
        STA a02
        DEC a03
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        JSR s203F
        LDX a07
        INC f1B00,X
        INC a03
        LDA a03
        CMP #$16
        BNE b2D5B
        LDA a28
        BNE b2D55
        LDA a25
        BNE b2D55
        LDA bonusBits
        ORA #$02
        STA bonusBits
b2D55   JSR s2DB8
        JMP j2D6A

b2D5B   JMP j2CE6

b2D5E   LDA a02
        LDX a07
        STA f1A80,X
        LDA a03
        STA f1B00,X
j2D6A   LDA f1B80,X
        EOR #$01
        STA f1B80,X
        DEX 
        BEQ b2D78
        JMP b2CAC

b2D78   RTS 

j2D79   LDA #$07
        STA a05
        LDA f1A80,X
        STA a02
        LDA f1B00,X
        STA a03
        LDA f1B80,X
        AND #$40
        BNE b2DA3
        LDA #$60
        STA a04
        STX a07
        JSR s203F
        DEC a02
        DEC a04
        JSR s203F
        LDX a07
        JMP j2D6A

b2DA3   LDA #$63
        STA a04
        STX a07
        JSR s203F
        INC a02
        DEC a04
        JSR s203F
        LDX a07
        JMP j2D6A

;-------------------------------------------------------------------------
; s2DB8
;-------------------------------------------------------------------------
s2DB8   STX a07
j2DBA   LDA f1A81,X
        STA f1A80,X
        LDA f1B01,X
        STA f1B00,X
        LDA f1B81,X
        STA f1B80,X
        CPX a31
        BEQ b2DD4
        INX 
        JMP j2DBA

b2DD4   LDX a07
        DEC a31
        LDA a23
        BEQ b2DE6
        LDA a34
        BNE b2DE6
        LDA bonusBits
        ORA #$40
        STA bonusBits
b2DE6   RTS 

        .BYTE $5E,$5F,$60,$61,$62,$63
j2DED   LDX #$06
b2DEF   CMP b2DE6,X
        BEQ b2DFA
        DEX 
        BNE b2DEF
        JMP j30BD

b2DFA   CMP #$62
        BNE b2E00
        DEC a02
b2E00   CMP #$5F
        BNE b2E06
        INC a02
b2E06   CMP #$5E
        BNE b2E0C
        INC a02
b2E0C   CMP #$61
        BNE b2E12
        DEC a02
b2E12   LDX a31
        LDA a02
b2E16   CMP f1A80,X
        BEQ b2E1F
b2E1B   DEX 
        BNE b2E16
        RTS 

b2E1F   LDA a03
        CMP f1B00,X
        BNE b2E1B
        LDA #$00
        STA a10
        STX a07
        LDX #$05
        LDY #$01
        JSR s283B
        LDX #$07
        LDY #$06
        JSR s283B
        LDX a07
        LDA #$04
        STA a39
        LDA #$D0
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA f1B80,X
        AND #$40
        BNE b2E59
        LDA f1A80,X
        CMP #$01
        BEQ b2E6A
        DEC f1A80,X
        JMP b2E6A

b2E59   LDA f1A80,X
        CMP #$13
        BEQ b2E6A
        LDA f1B80,X
        AND #$01
        BEQ b2E6A
        INC f1A80,X
b2E6A   LDA #$2F
        STA f1B80,X
        PLA 
        PLA 
        RTS 

j2E72   LDA f1A80,X
        STA a02
        LDA f1B00,X
        STA a03
        LDA f1B80,X
        AND #$0F
        BEQ b2EA9
        AND #$07
        STA a05
        LDA f1B80,X
        SEC 
        SBC #$01
        STA f1B80,X
        LDA #$64
        STA a04
        STX a07
        JSR s203F
        INC a04
        INC a02
        JSR s203F
j2EA0   LDX a07
        DEX 
        BEQ b2EA8
        JMP b2CAC

b2EA8   RTS 

b2EA9   JSR s2DB8
        LDA #>p0200
        STA a05
        LDA #<p0200
        STA a04
        JSR s203F
        INC a02
        JSR s203F
        JMP j2EA0

;-------------------------------------------------------------------------
; s2EBF
;-------------------------------------------------------------------------
s2EBF   LDA a37
        BEQ b2EC7
        DEC a37
        BEQ b2EC8
b2EC7   RTS 

b2EC8   LDA a38
        STA a37
        LDA a36
        EOR #$01
        STA a36
        AND #$80
        BEQ b2ED9
        JMP j2F6C

b2ED9   LDA #$02
        STA a03
        LDA #$01
        STA a05
        LDA a35
        STA a02
        LDA a36
        AND #$40
        BNE b2F11
        LDA #$20
        STA a04
        DEC a02
        JSR s203F
        INC a02
        LDA #$66
        STA a04
        LDA a36
        AND #$01
        BEQ b2F04
        LDA #$68
        STA a04
b2F04   JSR s203F
        INC a02
        INC a04
        JSR s203F
        JMP j2F36

b2F11   LDA #$20
        STA a04
        INC a02
        JSR s203F
        DEC a02
        LDA #$6B
        STA a04
        LDA a36
        AND #$01
        BEQ b2F2A
        LDA #$6D
        STA a04
b2F2A   DEC a02
        JSR s203F
        INC a02
        DEC a04
        JSR s203F
j2F36   LDA a36
        AND #$01
        BEQ b2F49
        LDA a36
        AND #$40
        BNE b2F46
        INC a35
        INC a35
b2F46   DEC a35
        RTS 

b2F49   LDA a35
        CMP a0A
        BNE b2F54
        LDA #$80
        STA a36
b2F53   RTS 

b2F54   BMI b2F61
        LDA a36
        AND #$40
        BNE b2F53
        LDA #$41
        STA a36
b2F60   RTS 

b2F61   LDA a36
        AND #$40
        BEQ b2F60
        LDA #$01
        STA a36
        RTS 

j2F6C   LDA a36
        AND #$01
        CLC 
        ADC #$6E
        STA a04
        LDA #$01
        STA a05
        LDA #$02
        STA a03
        LDA a35
        STA a02
        JSR s203F
        LDA a35
        CMP a0A
        BNE b2F8B
        RTS 

b2F8B   LDA #$00
        STA a36
        JMP b2F49

j2F92   LDA a10
        AND #$02
        BNE b2FB1
        LDA #>p0171
        STA a05
        LDA #<p0171
        STA a04
        LDA a11
        STA a02
        LDA a12
        STA a03
j2FA8   LDA a10
        EOR #$02
        STA a10
        JMP s203F

b2FB1   LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        LDA a11
        STA a02
        LDA a12
        STA a03
        JSR s203F
        INC a02
        LDA a02
        CMP #$15
        BNE b2FD1
        LDA #$00
        STA a10
        RTS 

b2FD1   INC a11
        LDA #>p0170
        STA a05
        LDA #<p0170
        STA a04
        JSR s27FD
        JMP j2FA8

j2FE1   LDA a10
        AND #$02
        BNE b2FFA
        LDA #>p0170
        STA a05
        LDA #<p0170
        STA a04
        LDA a11
        STA a02
        LDA a12
        STA a03
        JMP j2FA8

b2FFA   LDA a11
        STA a02
        LDA a12
        STA a03
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        JSR s203F
        DEC a02
        DEC a11
        BNE b3018
        LDA #$00
        STA a10
        RTS 

b3018   LDA #>p0171
        STA a05
        LDA #<p0171
        STA a04
        JSR s27FD
        JMP j2FA8

j3026   LDA a11
        STA a02
        LDA a12
        STA a03
        LDA a10
        AND #$02
        BNE b303F
        LDA #>p0108
        STA a05
        LDA #<p0108
        STA a04
        JMP j2FA8

b303F   LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        JSR s203F
        INC a03
        LDA a03
        CMP #$16
        BNE b3057
        LDA #$00
        STA a10
        RTS 

b3057   INC a12
        LDA #>p0109
        STA a05
        LDA #<p0109
        STA a04
        JSR s27FD
        JMP j2FA8

;-------------------------------------------------------------------------
; s3067
;-------------------------------------------------------------------------
s3067   DEC a3A
        BEQ b306C
        RTS 

b306C   LDA #$80
        STA a3A
        INC a3C
        LDX a3B
        CPX #$00
        BNE b3079
        RTS 

b3079   LDA #$00
        STA a07
        LDA mysteryBonusPerformance,X
        AND #$30
        TAY 
        LDA #$72
        CPY #$10
        BNE b308B
        LDA #$75
b308B   CPY #$20
        BNE b3091
        LDA #$78
b3091   CLC 
        ADC a07
        STA a04
        LDA a3C
        AND #$07
        STA a05
        LDA f1C00,X
        STA a02
        LDA f1C80,X
        STA a03
        STX a07
        JSR s203F
        LDX a07
        DEX 
        BNE b3079
f30B0   RTS 

        .BYTE $72,$73
f30B3   .BYTE $74,$75,$76
f30B6   .BYTE $77,$78,$79
f30B9   .BYTE $7A,$07,$0B,$0C
j30BD   LDX #$03
b30BF   CMP f30B0,X
        BEQ b30ED
        CMP f30B3,X
        BEQ b3109
        CMP f30B6,X
        BEQ b30DA
        CMP f30B9,X
        BNE b30D6
        JMP b266E

b30D6   DEX 
        BNE b30BF
b30D9   RTS 

b30DA   LDA a10
        AND #$10
        BNE b30D9
        LDA a10
        EOR #$20
        STA a10
        CPX #$01
        BNE b30D9
        JMP j3119

b30ED   LDA a10
        AND #$30
        STA a07
        LDA #$50
        SEC 
        SBC a07
        AND #$30
        STA a07
j30FC   LDA a10
        AND #$8F
        ORA a07
        STA a10
        CPX #$01
        BEQ j3119
        RTS 

b3109   LDA a10
        AND #$30
        STA a07
        LDA #$30
        SEC 
        SBC a07
        STA a07
        JMP j30FC

j3119   LDX a3B
b311B   LDA a02
        CMP f1C00,X
        BEQ b3126
b3122   DEX 
        BNE b311B
        RTS 

b3126   LDA a03
        CMP f1C80,X
        BNE b3122
        LDA mysteryBonusPerformance,X
        JSR s3144
        STA mysteryBonusPerformance,X
        LDA #$0F
        STA a3D
        LDA #$F0
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$00
        STA a39
        RTS 

;-------------------------------------------------------------------------
; s3144
;-------------------------------------------------------------------------
s3144   AND #$30
        CMP #$20
        BEQ b3159
        CMP #$10
        BEQ b3154
        LDA #$1F
        STA mysteryBonusPerformance,X
        RTS 

b3154   LDA #$0F
        STA mysteryBonusPerformance,X
b3159   LDA mysteryBonusPerformance,X
        RTS 

j315D   LDX a3E
        STX a3B
b3161   LDA f3176,X
        STA f1C00,X
        LDA f3192,X
        STA f1C80,X
        LDA f31AE,X
        STA mysteryBonusPerformance,X
        DEX 
        BNE b3161
f3176   RTS 

        .BYTE $0A,$0B,$0A,$0B,$01,$03,$05,$07
        .BYTE $14,$12,$10,$0E,$0A,$0B,$07,$0E
        .BYTE $05,$05,$10,$10,$02,$04,$06,$08
        .BYTE $13,$11,$0F
f3192   .BYTE $0D,$0D,$0D,$0E,$0E,$0A,$0A,$0A
        .BYTE $0A,$0A,$0A,$0A,$0A,$06,$06,$06
        .BYTE $06,$0E,$15,$0E,$15,$08,$08,$08
        .BYTE $08,$08,$08,$08
f31AE   .BYTE $08,$1F,$0F,$0F,$1F,$1F,$0F,$1F
        .BYTE $0F,$0F,$1F,$0F,$1F,$2F,$2F,$2F
        .BYTE $2F,$0F,$1F,$1F,$0F,$2F,$2F,$2F
        .BYTE $2F,$2F,$2F,$2F
f31CA   .BYTE $2F,$01,$02,$03,$00,$02,$02,$02
        .BYTE $02,$00,$03,$03,$03,$02,$03,$03
        .BYTE $00,$03,$03,$03
f31DE   .BYTE $03,$06,$06,$04,$00,$07,$08,$08
        .BYTE $06,$00,$07,$08,$08,$08,$08,$06
        .BYTE $00,$0A,$09,$08
f31F2   .BYTE $07,$00,$00,$00,$14,$00,$08,$09
        .BYTE $00,$19,$0A,$00,$0B,$0C,$00,$0F
        .BYTE $1E,$00,$14,$14
f3206   .BYTE $14,$00,$00,$00,$06,$00,$06,$06
        .BYTE $00,$04,$06,$00,$04,$04,$00,$04
        .BYTE $03,$00,$04,$03
f321A   .BYTE $03,$00,$00,$00,$04,$00,$07,$07
        .BYTE $00,$03,$06,$00,$05,$05,$00,$04
        .BYTE $03,$00,$03,$03
f322E   .BYTE $03,$10,$0F,$0E,$0D,$0D,$0D,$0C
        .BYTE $0C,$0B,$0B,$0A,$09,$09,$08,$09
        .BYTE $08,$07,$07,$06
f3242   .BYTE $06,$00,$00,$04,$04,$03,$03,$03
        .BYTE $03,$02,$02,$02,$02,$02,$02,$02
        .BYTE $02,$02,$02,$02
f3256   .BYTE $02,$00,$00,$00,$00,$04,$00,$00
        .BYTE $0C,$00,$00,$10,$00,$00,$14,$00
        .BYTE $00,$00,$1C,$00
f326A   .BYTE $1C,$00,$00,$00,$01,$01,$00,$82
        .BYTE $01,$01,$00,$01,$82,$00,$01,$82
        .BYTE $82,$00,$01
        .BYTE $82,$82 ;NOP #$82
;-------------------------------------------------------------------------
; s327F
;-------------------------------------------------------------------------
s327F   LDX a2A
        LDA f31CA,X
        STA a25
        LDA f31DE,X
        STA a23
        STA a24
        LDA f31F2,X
        STA a34
        LDA f3206,X
        STA a33
        STA a32
        LDA f321A,X
        STA a30
        STA a2F
        LDA f322E,X
        STA a18
        STA a19
        LDA f3242,X
        STA a37
        STA a38
        LDA f3256,X
        STA a3E
        LDA f326A,X
        STA a3F
        JMP j315D

;-------------------------------------------------------------------------
; s32BB
;-------------------------------------------------------------------------
s32BB   LDA #$02
        STA a03
        JSR s33DD
        LDA #$20
        STA a04
b32C6   LDA #$00
        STA a02
b32CA   JSR s203F
        INC a02
        LDA a02
        CMP #$16
        BNE b32CA
        INC a03
        LDA a03
        CMP #$17
        BNE b32C6
        LDA #>p03
        STA a04
        LDA #<p03
        STA a03
        LDA #$02
        STA a05
b32E9   LDA #$01
        STA a02
b32ED   JSR s203F
        INC a02
        LDA a02
        CMP #$15
        BNE b32ED
        INC a03
        LDA a03
        CMP #$16
        BNE b32E9
        RTS 

;-------------------------------------------------------------------------
; s3301
;-------------------------------------------------------------------------
s3301   JSR s32BB
        LDA #<p200B
        STA a03
        LDA #>p200B
        STA a04
b330C   LDA #$04
        STA a02
b3310   JSR s203F
        INC a02
        LDA a02
        CMP #$13
        BNE b3310
        INC a03
        LDA a03
        CMP #$0E
        BNE b330C
        LDA #<p0C05
        STA a02
        LDA #>p0C05
        STA a03
        JSR s202A
        LDX #$00
        LDA #$01
        STA a05
b3334   LDA f3395,X
        STA a04
        STX a0A
        JSR s203F
        LDX a0A
        INC a02
        INX 
        CPX #$0D
        BNE b3334
        DEC a02
        DEC a02
        JSR s202A
        INY 
        LDX a2A
b3351   LDA (p00),Y
        CLC 
        ADC #$01
        STA (p00),Y
        CMP #$3A
        BNE b3369
        LDA #$30
        STA (p00),Y
        DEY 
        LDA (p00),Y
        CLC 
        ADC #$01
        STA (p00),Y
        INY 
b3369   DEX 
        BNE b3351
        JMP j33A2

b336F   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b336F
;-------------------------------------------------------------------------
; s3376
;-------------------------------------------------------------------------
s3376   LDA a1407
        STA a00
        LDX #$07
b337D   LDA SCREEN_RAM + $03FF,X
        STA f1400,X
        DEX 
        BNE b337D
        LDA a00
        STA f1400
        LDA a3F
        AND #$80
        BEQ b3394
        JMP j340A

b3394   RTS 

f3395   .TEXT "ENTER ZONE 00"
j33A2   LDA #$0F
        STA VICCRE   ;$900E - sound volume
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$F0
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b33AF   LDA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
b33B5   JSR b336F
        INC VICCRA   ;$900A - frequency of sound osc.1 (bass)
        BNE b33B5
        INC VICCRD   ;$900D - frequency of sound osc.4 (noise)
        BNE b33AF
        LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
f33CC   =*+$02
        JMP s32BB

        .BYTE $18,$18,$18,$E7,$E7,$18,$18
f33D4   .BYTE $18,$80,$40,$20,$10,$FF,$04,$02
        .BYTE $01
;-------------------------------------------------------------------------
; s33DD
;-------------------------------------------------------------------------
s33DD   LDA a3F
        BNE b33ED
        LDX #$08
b33E3   LDA f33CC,X
        STA SCREEN_RAM + $03FF,X
        DEX 
        BNE b33E3
        RTS 

b33ED   LDA a3F
        CMP #$01
        BNE b33FE
        LDX #$08
        LDA #$00
b33F7   STA SCREEN_RAM + $03FF,X
        DEX 
        BNE b33F7
        RTS 

b33FE   LDX #$08
b3400   LDA f33D4,X
        STA SCREEN_RAM + $03FF,X
        DEX 
        BNE b3400
        RTS 

j340A   LDX #$08
b340C   CLC 
        LDA SCREEN_RAM + $03FF,X
        ROL 
        ADC #$00
        STA SCREEN_RAM + $03FF,X
        DEX 
        BNE b340C
b3419   RTS 

;-------------------------------------------------------------------------
; s341A
;-------------------------------------------------------------------------
s341A   LDA a25
        BNE b3419
        LDA a28
        BNE b3419
        LDA a34
        BNE b3419
        LDA a31
        BNE b3419
j342A   INC a2A
        LDA a2A
        CMP #$15
        BNE b3434
        DEC a2A
b3434   LDX #$F8
        TXS 
        INC a1015
        LDA a1015
        CMP #$3A
        BNE b3444
        DEC a1015
b3444   JMP CalculateMysteryBonusAndClearZone

j3447   LDA a0B
        STA a03
        LDA #$01
        STA a02
        LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
b3457   JSR s203F
        INC a02
        LDA a02
        CMP #$15
        BNE b3457
        LDA #$00
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$08
        STA VICCRE   ;$900E - sound volume
        LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #$10
        STA a07
b3478   LDA #$E0
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b347D   LDY #$E0
b347F   DEY 
        BNE b347F
        INC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        BNE b347D
b3487   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b3487
        LDA #$08
        LDX VICCRF   ;$900F - screen colors: background, border & inverse
        CPX #$08
        BNE b3499
        LDA #$6E
b3499   STA VICCRF   ;$900F - screen colors: background, border & inverse
        LDA a0A
        STA a02
        LDA a0B
        STA a03
        LDA a07
        AND #$03
        TAX 
        LDA f357F,X
        STA a04
        LDA a07
        AND #$07
        STA a05
        JSR s203F
        DEC a07
        BNE b3478
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA #$80
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
b34C8   LDA #$0F
        SEC 
        SBC VICCRE   ;$900E - sound volume
        STA a08
        LDA #$07
        STA a09
        LDX a08
        INX 
        TXA 
        ASL 
        TAX 
b34DA   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b34DA
        DEX 
        BNE b34DA
b34E4   JSR s3506
        LDA a08
        BEQ b34FE
        DEC a08
        BEQ b34F3
        LDA a09
        BNE b34E4
b34F3   LDA #<p0200
        STA a04
        LDA #>p0200
        STA a05
        JSR s3513
b34FE   DEC VICCRE   ;$900E - sound volume
        BNE b34C8
        JMP j358B

;-------------------------------------------------------------------------
; s3506
;-------------------------------------------------------------------------
s3506   LDX a09
        DEC a09
        LDA f3583,X
        STA a05
        LDA #$40
        STA a04
;-------------------------------------------------------------------------
; s3513
;-------------------------------------------------------------------------
s3513   LDA a0A
        SEC 
        SBC a08
        STA a02
        LDA a0B
        STA a03
        JSR s355B
        LDA a03
        CLC 
        ADC a08
        STA a03
        JSR s355B
        LDA a0B
        SEC 
        SBC a08
        STA a03
        JSR s355B
        LDA a0A
        STA a02
        JSR s355B
        LDA a02
        CLC 
        ADC a08
        STA a02
        JSR s355B
        LDA a0B
        STA a03
        JSR s355B
        LDA a03
        CLC 
        ADC a08
        STA a03
        JSR s355B
        LDA a0A
        STA a02
;-------------------------------------------------------------------------
; s355B
;-------------------------------------------------------------------------
s355B   LDA a02
        AND #$80
        BEQ b3562
b3561   RTS 

b3562   LDA a02
        BEQ b3561
        CMP #$15
        BPL b3561
        LDA a03
        AND #$80
        BNE b3561
        LDA a03
        CMP #$16
        BPL b3561
        LDA a03
        AND #$FC
        BEQ b3561
        JMP s203F

f357F   .BYTE $73,$74,$76,$40
f3583   .BYTE $00,$06,$02,$04,$05,$03,$07,$01
j358B   DEC a1015
        LDA a1015
        CMP #$30
        BEQ b3598
        JMP j35BF

b3598   JMP j39B0

;-------------------------------------------------------------------------
; s359B
;-------------------------------------------------------------------------
s359B   LDA #$20
        LDX #$00
b359F   STA SCREEN_RAM + $002C,X
        STA SCREEN_RAM + $0100,X
        DEX 
        BNE b359F
        LDA #$00
        LDX #$00
b35AC   STA f1800,X
        DEX 
        BNE b35AC
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        RTS 

j35BF   JSR s359B
        LDA #>p0A07
        STA a03
        LDA #<p0A07
        STA a02
        LDA #$03
        STA a05
        LDX #$00
b35D0   LDA f362C,X
        STX a07
        STA a04
        JSR s203F
        LDX a07
        INC a02
        INX 
        CPX #$08
        BNE b35D0
        LDA #$00
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        LDX #$0A
b35F5   LDA #$B0
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b35FA   LDY #$00
b35FC   DEY 
        BNE b35FC
        INC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        BNE b35FA
        DEX 
        BNE b35F5
        LDX #$07
b3609   LDA #$FF
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b360E   LDY #$00
b3610   DEY 
        BNE b3610
        DEC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        LDA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        AND #$80
        BNE b360E
        LDA VICCRE   ;$900E - sound volume
        SEC 
        SBC #$02
        STA VICCRE   ;$900E - sound volume
        DEX 
        BNE b3609
        JMP j2231

f362C   .TEXT "GOT YOUz"
;---------------------------------------------------------------------------------
; DrawZoneClearedInterstitial   
;---------------------------------------------------------------------------------
DrawZoneClearedInterstitial   
        JSR s359B
        LDA #$0F
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        STA VICCRE   ;$900E - sound volume
        STA VICCRD   ;$900D - frequency of sound osc.4 (noise)
        LDA #$00
        STA a07
b3649   LDA #>p0405
        STA a03
b364D   LDA #<p0405
        STA a02
        LDA a07
        AND #$07
        TAX 
        LDA f3583,X
        STA a05
        LDX #$00
b365D   LDA f36B6,X
        STA a04
        STX a08
        JSR s203F
        INC a02
        LDX a08
        INX 
        CPX #$0C
        BNE b365D
        INC a07
        INC a03
        LDA a03
        CMP #$0B
        BNE b364D
        LDA #$80
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
b367F   DEY 
        BNE b367F
        INC VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        CMP #$C0
        BNE b367F
        LDA a07
        AND #$C0
        CMP #$C0
        BNE b3649
        LDX #$07
b3696   LDA #$80
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
b369B   DEY 
        BNE b369B
        INC VICCRB   ;$900B - frequency of sound osc.2 (alto)
        BNE b369B
        LDA VICCRE   ;$900E - sound volume
        SEC 
        SBC #$02
        STA VICCRE   ;$900E - sound volume
        DEX 
        BNE b3696
        LDA mysteryBonusEarned
        BNE b36C2
        JMP j2231

f36B6   .TEXT "ZONE CLEARED"
b36C2   LDA #$0F
        STA VICCRE   ;$900E - sound volume
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        LDX #$08
        LDA #$FF
b36CE   STA SCREEN_RAM + $03FF,X
        DEX 
        BNE b36CE
        LDA #$04
        STA a05
        LDA #>p0F00
        STA a03
b36DC   LDA #<p0F00
        STA a02
        STA a04
b36E2   JSR s203F
        INC a02
        LDA a02
        CMP #$16
        BNE b36E2
        INC a03
        LDA a03
        CMP #$12
        BNE b36DC
        LDA #>p1002
        STA a03
        LDA #<p1002
        STA a02
        LDX #$00
        LDA #$07
        STA a05
b3703   LDA txtMysteryBonus,X
        STA a04
        STX a08
        JSR s203F
        LDX a08
        INC a02
        INX 
        CPX #$12
        BNE b3703
        DEC a02
        DEC a02
        DEC a02
        LDA #$30
        CLC 
        ADC mysteryBonusEarned
        STA a04
        LDA #$03
        STA a05
        JSR s203F
        LDX #$04
        LDY mysteryBonusEarned
        JSR s283B
        LDA #$D0
        STA a07
b3735   LDA a07
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
b373A   DEY 
        BNE b373A
        INC VICCRB   ;$900B - frequency of sound osc.2 (alto)
        BNE b373A
b3742   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b3742
        LDA a07
        AND #$07
        TAX 
        LDA #$FF
        STA f1400,X
        INC a07
        LDA a07
        AND #$07
        TAX 
        LDA #$00
        STA f1400,X
        LDA a07
        BNE b3735
        JMP j2231

txtMysteryBonus   .TEXT " MYSTERY BONUS    "
;---------------------------------------------------------------------------------
; CalculateMysteryBonusAndClearZone   
;---------------------------------------------------------------------------------
CalculateMysteryBonusAndClearZone   
        LDX #$04
b377A   LDA mysteryBonusPerformance,X
        CMP mysteryBonusBenchmarks,X
        BNE b378F
        DEX 
        BNE b377A

        LDA a3B
        BEQ b378F

        LDA bonusBits
        ORA #$20
        STA bonusBits

b378F   LDA #$08
        STA mysteryBonusEarned

b3793   LDA bonusBits
        CLC 
        ROL 
        STA bonusBits
        BCS b379F
        DEC mysteryBonusEarned
        BNE b3793
b379F   JMP DrawZoneClearedInterstitial

mysteryBonusBenchmarks   =*-$01
        .BYTE $0F,$1F,$1F,$0F
;-------------------------------------------------------------------------
; s37A6
;-------------------------------------------------------------------------
s37A6   JSR s359B
        LDA #$03
        STA a05
        LDA #$00
        STA a02
        LDX #$00
b37B3   LDA #$05
        STA a03
        LDA f3829,X
        STA a04
        STX a07
        JSR s203F
        INC a03
        INC a03
        LDA #$07
        STA a05
        LDX a07
        LDA f383F,X
        STA a04
        JSR s203F
        LDA #$01
        STA a05
        INC a03
        INC a03
        LDX a07
        LDA f3855,X
        STA a04
        JSR s203F
        INC a05
        LDX a07
        INC a03
        INC a03
        INC a05
        LDA f386B,X
        STA a04
        JSR s203F
        INC a05
        LDX a07
        INC a03
        INC a03
        LDA f3881,X
        STA a04
        JSR s203F
        LDX a07
        LDA #$01
        STA a05
        INC a03
        INC a03
        LDA f3897,X
        STA a04
        JSR s203F
        LDX a07
        LDA #$03
        STA a05
        INC a02
        INX 
        CPX #$16
        BNE b37B3
        JMP DrawHiScore

f3829   .TEXT "DESIGN AND PROGRAMMING"
f383F   .TEXT "   BY  JEFF  MINTER   "
f3855   .TEXT " ?  1983 BY LLAMASOFT "
f386B   .TEXT " PRESS FIRE FOR START "
f3881   .TEXT "SELECT START LEVEL   1"
f3897   .BYTE $96,$95,$94,$93,$92,$91,$90,$8F
        .BYTE $8E,$8D,$8C,$8B,$8A,$89,$88,$87
        .BYTE $86,$85,$84,$83,$82,$81
b38AD   LDX #$00
        LDA #>f1400
        STA a08
        LDA #<f1400
        STA a07
b38B7   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b38B7
        LDA f3A9B,X
        BEQ b38AD
        AND #$3F
        CMP #$20
        BNE b38CC
        JMP j392F

b38CC   CMP #$2E
        BNE b38D3
        JMP j393E

b38D3   CMP #$2C
        BNE b38DA
        JMP j394E

b38DA   CLC 
        ASL 
        ASL 
        ASL 
        TAY 
        STX a09
        LDX #$00
b38E3   LDA f1600,Y
        STA f1800,X
        INY 
        INX 
        CPX #$08
        BNE b38E3
j38EF   LDX a09
        LDA #$08
        STA a08
b38F5   LDY #$00
b38F7   LDA #$18
        STA a07
        TYA 
        TAX 
        CLC 
j38FE   ROL f1800,X
        PHP 
        TXA 
        CLC 
        ADC #$08
        TAX 
        DEC a07
        BEQ b390F
        PLP 
        JMP j38FE

b390F   PLP 
        INY 
        CPY #$08
        BNE b38F7
        LDX #$0A
b3917   DEY 
        BNE b3917
        DEX 
        BNE b3917
b391D   LDA VICCR4   ;$9004 - raster beam location (bits 7-0)
        CMP #$7F
        BNE b391D
        DEC a08
        BNE b38F5
        LDX a09
        INX 
        JMP j395E

j392F   =*+$01
        BRK #$86
        ORA #$A9
        BRK #$A2
        PHP 
b3935   STA f17FF,X
        DEX 
        BNE b3935
        JMP j38EF

j393E   STX a09
        LDX #$08
b3942   LDA f17B7,X
        STA f17FF,X
        DEX 
        BNE b3942
        JMP j38EF

j394E   STX a09
        LDX #$08
b3952   LDA f17C7,X
        STA f17FF,X
        DEX 
        BNE b3952
        JMP j38EF

j395E   STX a09
        JSR s235B
        LDA a0D
        AND #$02
        BEQ b3974
        INC VICCR1   ;$9001 - vertical picture origin
        LDA VICCR1   ;$9001 - vertical picture origin
        AND #$3F
        STA VICCR1   ;$9001 - vertical picture origin
b3974   LDA a0D
        AND #$08
        BEQ b3985
        INC VICCR0   ;$9000 - left edge of picture & interlace switch
        LDA VICCR0   ;$9000 - left edge of picture & interlace switch
        AND #$1F
        STA VICCR0   ;$9000 - left edge of picture & interlace switch
b3985   LDA aC5
        CMP #$40
        BEQ b399A
        INC a1133
        LDA a1133
        CMP #$37
        BNE b399A
        LDA #$31
        STA a1133
b399A   LDA a0D
        AND #$80
        BNE b39A5
        LDX a09
        JMP b38B7

b39A5   LDA a1133
        SEC 
        SBC #$30
        STA a2A
        JMP s359B

j39B0   JSR s359B
        LDA #$07
        STA a05
        LDX #$00
        LDA #>p0A07
        STA a03
        LDA #<p0A07
        STA a02
b39C1   LDA f3A2F,X
        STA a04
        STX a07
        JSR s203F
        LDX a07
        INC a02
        INX 
        CPX #$09
        BNE b39C1
        LDA #$0F
        STA VICCRE   ;$900E - sound volume
        LDX #$0F
b39DB   LDA #$80
        STA VICCRA   ;$900A - frequency of sound osc.1 (bass)
        STA VICCRB   ;$900B - frequency of sound osc.2 (alto)
        STA VICCRC   ;$900C - frequency of sound osc.3 (soprano)
b39E6   LDY #$00
b39E8   DEY 
        BNE b39E8
        INC VICCRA   ;$900A - frequency of sound osc.1 (bass)
        INC VICCRB   ;$900B - frequency of sound osc.2 (alto)
        INC VICCRC   ;$900C - frequency of sound osc.3 (soprano)
        BNE b39E6
        LDA VICCRE   ;$900E - sound volume
        SEC 
        SBC #$01
        STA VICCRE   ;$900E - sound volume
        DEX 
        BNE b39DB
        LDX #$01
b3A04   LDA SCREEN_RAM + $0009,X
        CMP f14F0,X
        BEQ b3A10
        BMI b3A15
        BPL b3A21
b3A10   INX 
        CPX #$08
        BNE b3A04
p3A16   =*+$01
b3A15   JSR s37A6
        JSR s2094
        LDX #$F8
        TXS 
        JMP j216E

b3A21   LDX #$07
b3A23   LDA SCREEN_RAM + $0009,X
        STA f14F0,X
        DEX 
        BNE b3A23
        JMP b3A15

f3A2F   .TEXT "GAME OVER"
;---------------------------------------------------------------------------------
; DrawHiScore   
;---------------------------------------------------------------------------------
DrawHiScore   
        LDA #$14
        STA a03
        LDX #$00
b3A3E   LDA f3A94,X
        STA a04
        LDA #$04
        STA a05
        TXA 
        CLC 
        ADC #$03
        STA a02
        STX a07
        JSR s203F
        LDX a07
        LDA a02
        CLC 
        ADC #$09
        STA a02
        LDA #$03
        STA a05
        LDA f14F1,X
        STA a04
        JSR s203F
        LDX a07
        INX 
        CPX #$07
        BNE b3A3E
        JMP b38AD

;-------------------------------------------------------------------------
; ReduceScore
;-------------------------------------------------------------------------
ReduceScore
        LDA #$01
        STA a39
        LDX #$06
b3A77   DEC SCREEN_RAM + $0009,X
        LDA SCREEN_RAM + $0009,X
        CMP #$2F
        BNE b3A93
        LDA #$39
        STA SCREEN_RAM + $0009,X
        DEX 
        BNE b3A77
        LDX #$07
        LDA #$30
b3A8D   STA SCREEN_RAM + $0009,X
        DEX 
        BNE b3A8D
b3A93   RTS 

f3A94   .TEXT "HISCORE"
f3A9B   .BYTE $09,$0E,$20,$14,$08,$05,$20,$14
        .BYTE $05,$0E,$20,$19,$05,$01,$12,$13
        .BYTE $20,$01,$06,$14,$05,$12,$20,$14
        .BYTE $08,$05,$20,$07,$12,$09,$04,$20
        .BYTE $17,$01,$12,$13,$2C,$20,$09,$0E
        .BYTE $14,$05,$12,$07,$01,$0C,$01,$03
        .BYTE $14,$09,$03,$20,$14,$05,$0E,$13
        .BYTE $09,$0F,$0E,$20,$09,$0E,$03,$12
        .BYTE $05,$01,$13,$05,$04,$20,$15,$0E
        .BYTE $14,$09,$0C,$20,$14,$08,$05,$20
        .BYTE $06,$05,$01,$12,$13,$20,$0F,$06
        .BYTE $20,$0D,$01,$0E,$0B,$09,$0E,$04
        .BYTE $20,$17,$05,$12,$05,$20,$12,$05
        .BYTE $01,$0C,$09,$13,$05,$04,$20,$01
        .BYTE $0E,$04,$20,$14,$08,$05,$20,$04
        .BYTE $12,$0F,$09,$04,$13,$20,$12,$05
        .BYTE $14,$15,$12,$0E,$05,$04,$20,$17
        .BYTE $09,$14,$08,$20,$13,$15,$10,$05
        .BYTE $12,$09,$0F,$12,$20,$17,$05,$01
        .BYTE $10,$0F,$0E,$12,$19,$20,$14,$0F
        .BYTE $20,$01,$14,$14,$01,$03,$0B,$20
        .BYTE $14,$08,$05,$20,$07,$12,$09,$04
        .BYTE $2E,$2E,$2E,$2E,$20,$03,$01,$0E
        .BYTE $20,$19,$0F,$15,$20,$06,$12,$05
        .BYTE $05,$20,$01,$0C,$0C,$20,$14,$17
        .BYTE $05,$0E,$14,$19,$20,$07,$12,$09
        .BYTE $04,$20,$13,$05,$03,$14,$0F,$12
        .BYTE $13,$20,$0F,$12,$20,$02,$05,$20
        .BYTE $02,$0C,$01,$13,$14,$05,$04,$20
        .BYTE $14,$0F,$20,$01,$0C,$09,$05,$0E
        .BYTE $20,$08,$05,$0C,$0C,$2E,$2E,$2E
        .BYTE $2E,$2E,$2E,$20,$20,$20,$20,$20
        .BYTE $01,$4B,$20,$20,$38
;---------------------------------------------------------------------------------
; j3BA0   
;---------------------------------------------------------------------------------
j3BA0   
        LDX #$00
b3BA2   LDA f3C00,X
        STA f1400,X
        LDA f3D00,X
        STA f1500,X
        LDA f3E00,X
        STA f1600,X
        LDA f3F00,X
        STA f1700,X
        INX 
        BNE b3BA2
        JMP j2068

        .TEXT "8SNITCH.", $BF, "SNITN1/ISNITN2/TSNITND/6SNITP ", $00
        .TEXT "6SNITX ", $00, "5SNLOP 4", $7D, "SNLOP14"
.include "charset-vic20.asm"
