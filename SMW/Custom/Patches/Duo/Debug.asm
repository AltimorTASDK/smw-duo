!DebugHUD_VRAMOffset = $02

org SMW_GameMode14_InLevel_Debug_SlowMotion
	NOP #2

org SMW_OverworldProcess03_StandingStill_Debug_WalkOnUnrevealedOWPaths
	JMP.w SMW_OverworldProcess03_StandingStill_CODE_0492B2

org SMW_InitializeStatusBarTilemap_BufferStatusCounterRAMLoop
namespace DUO_InitializeStatusBarTilemap
	; Original code
	LDA.w SMW_StatusBarTilemap_SecondRow,y
	STA.w !RAM_SMW_Misc_StatusBarTilemap,x
	DEY
	DEY
	DEX
	BPL.b SMW_InitializeStatusBarTilemap_BufferStatusCounterRAMLoop
	JSL.l Main
	RTS
freecode
Main:
	; Overwritten code
	LDA.b #!Define_SMW_Counter_TimerFrames
	STA.w !RAM_SMW_Counter_TimerFrames

	; Initialize new row
	LDA.b #$80
	STA.w !REGISTER_VRAMAddressIncrementValue
	LDA.b #!VRAM_SMW_Layer3TilemapVRAMLocation+!DebugHUD_VRAMOffset
	STA.w !REGISTER_VRAMAddressLo
	LDA.b #!VRAM_SMW_Layer3TilemapVRAMLocation>>8
	STA.w !REGISTER_VRAMAddressHi
	LDX.b #$06
CopyLoop:
	LDA.l NewRowParams,x
	STA.w DMA[$01].Parameters,x
	DEX
	BPL.b CopyLoop
	LDA.b #$02
	STA.w !REGISTER_DMAEnable

	; Initialize RAM copy of tilemap
	LDX.b #NewRowEnd-NewRow-1
BufferStatusCounterRAMLoop:
	LDA.l NewRow,x
	STA.l DUO_Hi.Misc_StatusBarTilemap,x
	DEX
	BPL.b BufferStatusCounterRAMLoop

	RTL

NewRowParams:
	db $01,!REGISTER_WriteToVRAMPortLo
	dl NewRow
	dw NewRowEnd-NewRow

NewRow:	; Info: "SPEED X   0 Y   0"
.SpeedLabel:
	dw $3C1C,$3C19,$3C0E,$3C0E,$3C0D,$38FC
.XLabel:
	dw $2C21
.XSpeed:
	dw $38FC,$38FC,$3800
.Blank1:
	dw $38FC
.YLabel:
	dw $2C22
.YSpeed:
	dw $38FC,$38FC,$3800
.Blank2:
	dw $38FC,$38FC,$38FC,$38FC
.PMeterLabel:
	dw $3C19
.PMeter:
	dw $392E,$392E,$392E,$392E,$392E,$392E,$392E,$392E
NewRowEnd:
namespace off

org SMW_UploadStatusBarTilemap_CODE_008DD8
namespace DUO_UploadStatusBarTilemap
	; Original code
	LDA.w SMW_UploadStatusBarTilemap_PARAMS_StBr2,x
	STA.w DMA[$01].Parameters,x
	DEX
	BPL.b SMW_UploadStatusBarTilemap_CODE_008DD8
	JSL.l Main
	RTS
freecode
Main:
	; Overwritten code
	LDA.b #$02
	STA.w !REGISTER_DMAEnable

	; Upload new row
	LDA.b #$80
	STA.w !REGISTER_VRAMAddressIncrementValue
	LDA.b #!VRAM_SMW_Layer3TilemapVRAMLocation+!DebugHUD_VRAMOffset
	STA.w !REGISTER_VRAMAddressLo
	LDA.b #!VRAM_SMW_Layer3TilemapVRAMLocation>>8
	STA.w !REGISTER_VRAMAddressHi
	LDX.b #$06
CopyLoop:
	LDA.l PARAMS_StBr3,x
	STA.w DMA[$01].Parameters,x
	DEX
	BPL.b CopyLoop
	LDA.b #$02
	STA.w !REGISTER_DMAEnable

	RTL

PARAMS_StBr3:
	db $01,!REGISTER_WriteToVRAMPortLo
	dl DUO_Hi.Misc_StatusBarTilemap
	dw DUO_Hi.Misc_StatusBarTilemapEnd-DUO_Hi.Misc_StatusBarTilemap
namespace off

org SMW_UpdateStatusBarCounters_Main
namespace DUO_UpdateStatusBarCounters
	JSL.l Main
	NOP
freecode
Main:
	; Write X
	LDX.b !RAM_SMW_Player_XSpeed
	BPL.b PositiveX

	; Write minus
	LDA.b #$27
	STA.l DUO_Hi.Misc_StatusBarTilemap_XSpeed
	TAY
	TXA
	EOR.b #$FF
	LDX.b !RAM_SMW_Player_SubXSpeed
	BNE.b +
	INC
+:
	BRA.b WriteDigitsX

PositiveX:
	; Write space
	LDA.b #$FC
	STA.l DUO_Hi.Misc_StatusBarTilemap_XSpeed
	TAY
	TXA

WriteDigitsX:
	JSL.l DUO_HexToDec
	STA.l DUO_Hi.Misc_StatusBarTilemap_XSpeed+4
	TXA
	CMP.b #0
	BNE.b WriteTensX
	; Copy space/minus over
	LDA.b #$FC
	STA.l DUO_Hi.Misc_StatusBarTilemap_XSpeed
	TYA
WriteTensX:
	STA.l DUO_Hi.Misc_StatusBarTilemap_XSpeed+2

	; Write Y
	LDX.b !RAM_SMW_Player_YSpeed
	BPL.b PositiveY

	; Write minus
	LDA.b #$27
	STA.l DUO_Hi.Misc_StatusBarTilemap_YSpeed
	TAY
	TXA
	EOR.b #$FF
	LDX.b !RAM_SMW_Player_SubYSpeed
	BNE.b +
	INC
+:
	BRA.b WriteDigitsY

PositiveY:
	; Write space
	LDA.b #$FC
	STA.l DUO_Hi.Misc_StatusBarTilemap_YSpeed
	TAY
	TXA

WriteDigitsY:
	JSL.l DUO_HexToDec
	STA.l DUO_Hi.Misc_StatusBarTilemap_YSpeed+4
	TXA
	CMP.b #0
	BNE.b WriteTensY
	; Copy space/minus over
	LDA.b #$FC
	STA.l DUO_Hi.Misc_StatusBarTilemap_YSpeed
	TYA
WriteTensY:
	STA.l DUO_Hi.Misc_StatusBarTilemap_YSpeed+2

UpdatePMeter:
	LDA.b #0
	LDX.b #0
	LDY.w !RAM_SMW_Player_PMeter

PLoop:
	CLC
	ADC.b #!Define_SMW_Physics_PMeterMax/8
	STA.b !RAM_SMW_Misc_ScratchRAM00
	CPY.b !RAM_SMW_Misc_ScratchRAM00
	BMI.b PNotFilled
PFilled:
	LDA.b #$3D
	BRA.b PNext
PNotFilled:
	LDA.b #$39
PNext:
	STA.l DUO_Hi.Misc_StatusBarTilemap_PMeter+1,x
	LDA.b !RAM_SMW_Misc_ScratchRAM00
	INX
	INX
	CMP.b #!Define_SMW_Physics_PMeterMax
	BMI.b PLoop

	; Overwritten code
	LDA.w !RAM_SMW_Timer_EndLevel
	ORA.b !RAM_SMW_Flag_SpritesLocked

	RTL
namespace off