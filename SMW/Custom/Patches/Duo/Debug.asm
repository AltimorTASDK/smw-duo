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
	STA.w DUO.Misc_StatusBarTilemap,x
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
	dl DUO.Misc_StatusBarTilemap
	dw DUO.Misc_StatusBarTilemapEnd-DUO.Misc_StatusBarTilemap
namespace off

org SMW_UpdateStatusBarCounters_Main
namespace DUO_UpdateStatusBarCounters
	JSL.l Main
	NOP
freecode
Main:
	LDA.b !RAM_SMW_Player_XSpeed
	BPL.b PositiveX

	; Write minus
	LDY.b #$27
	STY.w DUO.Misc_StatusBarTilemap_XSpeed
	EOR.b #$FF
	INC
	BRA.b WriteDigitsX

PositiveX:
	; Write space
	LDY.b #$FC
	STY.w DUO.Misc_StatusBarTilemap_XSpeed

WriteDigitsX:
	JSL.l DUO_HexToDec
	CPX.b #0
	BNE.b WriteTensX
	; Copy space/minus over
	LDX.b #$FC
	STX.w DUO.Misc_StatusBarTilemap_XSpeed
	TYX
WriteTensX:
	STX.w DUO.Misc_StatusBarTilemap_XSpeed+2
	STA.w DUO.Misc_StatusBarTilemap_XSpeed+4

	LDA.b !RAM_SMW_Player_YSpeed
	BPL.b PositiveY

	; Write minus
	LDY.b #$27
	STY.w DUO.Misc_StatusBarTilemap_YSpeed
	EOR.b #$FF
	INC
	BRA.b WriteDigitsY

PositiveY:
	; Write space
	LDY.b #$FC
	STY.w DUO.Misc_StatusBarTilemap_YSpeed

WriteDigitsY:
	JSL.l DUO_HexToDec
	CPX.b #0
	BNE.b WriteTensY
	; Copy space/minus over
	LDX.b #$FC
	STX.w DUO.Misc_StatusBarTilemap_YSpeed
	TYX
WriteTensY:
	STX.w DUO.Misc_StatusBarTilemap_YSpeed+2
	STA.w DUO.Misc_StatusBarTilemap_YSpeed+4

UpdatePMeter:
	LDA.b #0
	LDX.w !RAM_SMW_Player_PMeter
	LDY.b #0

PLoop:
	CLC
	ADC.b #!Define_SMW_Physics_PMeterMax/8
	STA.b !RAM_SMW_Misc_ScratchRAM00
	CPX.b !RAM_SMW_Misc_ScratchRAM00
	BMI.b PNotFilled
PFilled:
	LDA.b #$35
	BRA.b PNext
PNotFilled:
	LDA.b #$39
PNext:
	STA.w DUO.Misc_StatusBarTilemap_PMeter+1,y
	LDA.b !RAM_SMW_Misc_ScratchRAM00
	INY
	INY
	CMP.b #!Define_SMW_Physics_PMeterMax
	BMI.b PLoop

	; Overwritten code
	LDA.w !RAM_SMW_Timer_EndLevel
	ORA.b !RAM_SMW_Flag_SpritesLocked

	RTL
namespace off