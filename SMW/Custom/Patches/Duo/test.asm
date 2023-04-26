; Before 1.5x multiplier
!Define_DUO_LongJumpSpeed = 43

; Update wall touch flag
org SMW_RunPlayerBlockCode_LMBlockOffset_MarioSide+3
namespace DUO_RunPlayerBlockCode_UpdateWallFlag
	JML.l Main
freecode
Main:
	STZ.w DUO.Player_WallTouchFlag
	BEQ.b NoCollision

Collision:
	CPY.b #$11
	INC.w DUO.Player_WallTouchFlag
	JML.l SMW_RunPlayerBlockCode_LMBlockOffset_MarioSide+3+4

NoCollision:
	JML.l SMW_RunPlayerBlockCode_CODE_00EC35
namespace off

; High jumps and long jumps
org SMW_HandlePlayerPhysics_CODE_00D663
namespace DUO_HandlePlayerPhysics_JumpPhysics
	JSL.l Main
	NOP
freecode
Main:
	; Don't walljump when jumping against a corner
	STZ.w DUO.Player_WallTouchFlag

	LDA.w !RAM_SMW_Player_SpinJumpFlag
	BEQ.b NormalJump

	LDA.b !RAM_SMW_IO_ControllerHold1
	AND.b #!Joypad_DPadU>>8
	BNE.b HighJump

	; Need at least 16 speed to long jump
	CPX.b #4
	BCC.b NormalJump

	LDA.b !RAM_SMW_IO_ControllerHold1
	AND.b #!Joypad_DPadD>>8
	BNE.b LongJump

	BRA.b NormalJump

HighJump:
	LDA.b #1
	STA.w DUO.Player_HighJumpFlag

	; Cap to walk speed
	LDA.b !RAM_SMW_Player_XSpeed
	CMP.b #21
	BPL.b HighJumpCapSpeedRight
	CMP.b #-21
	BPL.b HighJumpSpeed

HighJumpCapSpeedLeft:
	LDA.b #-21
	BRA.b HighJumpSpeed

HighJumpCapSpeedRight:
	LDA.b #21

HighJumpSpeed:
	STA.b !RAM_SMW_Player_XSpeed
	LDA.b #-102
	BRA.b SetYSpeed

LongJump:
	LDA.b #1
	STA.w DUO.Player_LongJumpFlag
	STZ.w !RAM_SMW_Player_SpinJumpFlag

	; Cap to max speed
	LDA.b !RAM_SMW_Player_XSpeed
	CMP.b #!Define_DUO_LongJumpSpeed
	BPL.b LongJumpCapSpeedRight
	CMP.b #-!Define_DUO_LongJumpSpeed
	BPL.b LongJumpSpeed

LongJumpCapSpeedLeft:
	LDA.b #-!Define_DUO_LongJumpSpeed
	BRA.b LongJumpSpeed

LongJumpCapSpeedRight:
	LDA.b #!Define_DUO_LongJumpSpeed

LongJumpSpeed:
	; Multiply X speed by 1.5
	STA.b !RAM_SMW_Misc_ScratchRAM00
	CMP.b #$80 ; Set carry to sign
	ROR
	CMP.b #$80 ; Set carry to sign
	ADC.b !RAM_SMW_Misc_ScratchRAM00
	STA.b !RAM_SMW_Player_XSpeed
	LDA.b #-60
	BRA.b SetYSpeed

NormalJump:
	; Fix the OOB read at high speeds, preserving spin jump low bit
	CPX.b #16
	BMI.b +
	TXA
	LSR
	LDA.b #7
	ROL
	TAX
+:
	LDA.w SMW_HandlePlayerPhysics_JumpHeightTable,x

SetYSpeed:
	STA.b !RAM_SMW_Player_YSpeed
	RTL
namespace off

; Handles air control toggle and walljumps
org SMW_HandlePlayerPhysics_CODE_00D682
namespace DUO_HandlePlayerPhysics_AirControlAndWalljump
	LDA.w !RAM_SMW_Player_SlidingOnGround
	BMI.b SMW_HandlePlayerPhysics_CODE_00D692
	JSL.l Main
freecode
Main:
	LDA.b !RAM_SMW_Player_InAirFlag
	BEQ.b OnGround

	; Decrement walljump timer
	DEC.w DUO.Player_WalljumpTimer
	BPL +
	STZ.w DUO.Player_WalljumpTimer
+:

	; Check for A/B press
	LDA.b !RAM_SMW_IO_ControllerPress1
	AND.b #!Joypad_A|(!Joypad_B>>8)
	BEQ.b CheckAirControl

	; Check if touching wall
	LDA.w DUO.Player_WallTouchFlag
	BEQ.b CheckAirControl

	LDA.b !RAM_SMW_Player_HorizontalSideOfBlockBeingTouched
	BNE.b WalljumpRight

WalljumpLeft:
	STZ.b !RAM_SMW_Player_FacingDirection
	LDA.b #-30
	BRA.b Walljump

WalljumpRight:
	LDA.b #1
	STA.b !RAM_SMW_Player_FacingDirection
	LDA.b #30

Walljump:
	STA.b !RAM_SMW_Player_XSpeed
	LDA.b #-74
	STA.b !RAM_SMW_Player_YSpeed

	LDA.b #!Define_SMW_Sound1DFA_Jump
	STA.w !RAM_SMW_IO_SoundCh2

	LDA.b #20
	STA.w DUO.Player_WalljumpTimer

	STZ.w DUO.Player_HighJumpFlag
	STZ.w DUO.Player_LongJumpFlag

	BRA.b CheckAirControl

OnGround:
	STZ.w DUO.Player_WalljumpTimer

CheckAirControl:
	; Overwritten code (exit if L/R not held)
	LDA.b !RAM_SMW_IO_ControllerHold1
	AND.b #(!Joypad_DPadL>>8)|(!Joypad_DPadR>>8)
	BEQ.b Return

	; Set zero flag if no air control
	TAY
	LDA.w DUO.Player_WalljumpTimer
	ORA.w DUO.Player_LongJumpFlag
	TAX
	TYA
	CPX.b #0
	BEQ.b AirControl

NoAirControl:
	LDX.b #0
	RTL

AirControl:
	LDX.b #1

Return:
	RTL
namespace off

org SMW_HandlePlayerPhysics_CODE_00D713
namespace DUO_HandlePlayerPhysics_HighJumpSpeedCap
	JSL.l Main
freecode
Main:
	; Overwritten code (exit if run not held)
	LDY.b #$00
	BIT.b !RAM_SMW_IO_ControllerHold1
	BVC.b Return

	; Set overflow if high jump flag not set
	LDA.w DUO.Player_HighJumpFlag
	BEQ.b Return
	CLV

Return:
	RTL
namespace off

org SMW_HandlePlayerPhysics_CODE_00D92E
namespace DUO_HandlePlayerPhysics_HighJumpFallSpeed
	LDY.b #$00
	LDA.b !RAM_SMW_Player_YSpeed
	BMI.b SMW_HandlePlayerPhysics_CODE_00D948
	CMP.w SMW_HandlePlayerPhysics_DATA_00D7AF,y
	JSL.l Main
	NOP
freecode
Main:
	; Check base fall speed
	BCC.b CheckHighJump
	LDA.w SMW_HandlePlayerPhysics_DATA_00D7AF,y
	RTL

CheckHighJump:
	LDX.w DUO.Player_HighJumpFlag
	BEQ.b Return

	; Check high jump fall speed
	CMP.b #35
	BCC.b Return
	LDA.b #35

Return:
	RTL
namespace off

org SMW_DamagePlayer_PitFall
namespace DUO_DamagePlayer_PitFall_ResetAirFlags
	JSL.l Main
	NOP
freecode
Main:
	; Overwritten code
	LDA.b #!Define_SMW_LevelMusic_MarioDied
	STA.w !RAM_SMW_IO_MusicCh1
	JSL.l DUO_ResetAirFlags
	RTL
namespace off

freecode
DUO_ResetAirFlags:
	STZ.w DUO.Player_HighJumpFlag
	STZ.w DUO.Player_LongJumpFlag
	RTL

org SMW_RunPlayerBlockCode_CODE_00EF68
namespace DUO_RunPlayerBlockCode_Land_ResetAirFlags
	JSL.l Main
	NOP
freecode
Main:
	; Overwritten code
	STZ.w !RAM_SMW_Flag_StandingOnBetaCage
	STZ.b !RAM_SMW_Player_InAirFlag
	JSL.l DUO_ResetAirFlags
	RTL
namespace off

org SMW_HandlePlayerPhysics_Swimming
namespace DUO_HandlePlayerPhysics_Swimming_ResetAirFlags
	JSL.l Main
	NOP
freecode
Main:
	; Overwritten code
	STZ.w !RAM_SMW_Player_SlidingOnGround
	STZ.b !RAM_SMW_Player_DuckingFlag
	JSL.l DUO_ResetAirFlags
	RTL
namespace off

org SMW_HandlePlayerPhysics_Climbing
namespace DUO_HandlePlayerPhysics_Climbing_ResetAirFlags
	JSL.l Main
freecode
Main:
	; Overwritten code
	STZ.b !RAM_SMW_Player_InAirFlag
	STZ.b !RAM_SMW_Player_YSpeed
	JSL.l DUO_ResetAirFlags
	RTL
namespace off

org SMW_PlayerState0A_NoYoshiCutscene_CODE_00C8EC
namespace DUO_PlayerState0A_NoYoshiCutscene_Land_ResetAirFlags
	CMP.b !RAM_SMW_Player_YPosLo
	BCS.b SMW_PlayerState0A_NoYoshiCutscene_CODE_00C8F8
	INC
	JSL.l Main
	STZ.w !RAM_SMW_Player_SpinJumpFlag
freecode
Main:
	; Overwritten code
	STA.b !RAM_SMW_Player_YPosLo
	STZ.b !RAM_SMW_Player_InAirFlag
	JSL.l DUO_ResetAirFlags
	RTL
namespace off