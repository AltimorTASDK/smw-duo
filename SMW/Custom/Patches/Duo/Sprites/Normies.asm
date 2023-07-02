org SMW_NorSpr026_Thwomp_Status08_Main+$11
	NOP #3

org SMW_NorSpr026_Thwomp_Status08_Main+$0A
namespace DUO_Thwomp_Solid
	JML.l Main
freecode
Main:
	STZ.w !RAM_SMW_NorSpr_PlayerXSpeedOffset,x
	JSL.l SMW_SolidSpriteBlock_Main
	; Overwritten code
	LDA.b !RAM_SMW_Flag_SpritesLocked
	BNE.b +
	JML.l SMW_NorSpr026_Thwomp_Status08_Main+$0E
+:
	JML.l SMW_NorSpr026_Thwomp_Status01_Return
namespace off

org SMW_SolidSpriteBlock_NotRidingYoshi2+9
namespace DUO_Thwomp_SolidPushDown
	NOP #2 ; Detect bottom collisions even if player isn't moving upward
	JSL.l Main
freecode
Main:
	LDA.b !RAM_SMW_NorSpr_YSpeed,x
	BEQ.b NotFalling
	BMI.b NotFalling

	LDA.b !RAM_SMW_Player_BlockedFlags
	AND.b #$04
	BEQ.b NoCrush

	; crushma
	STZ.w !RAM_SMW_Timer_PlayerHurt
	JSL.l SMW_DamagePlayer_Hurt
	RTL

NoCrush:
	LDA.b !RAM_SMW_NorSpr_YSpeed,x
	STA.b !RAM_SMW_Player_YSpeed
	LDA.b #32
	LDY.b !RAM_SMW_Player_DuckingFlag
	BNE.b IsSmall
	LDY.b !RAM_SMW_Player_CurrentPowerUp
	BNE.b IsNotSmall
IsSmall:
	SEC
	SBC.b #8
	LDY.w !RAM_SMW_Player_RidingYoshiFlag
	BNE.b IsNotSmall
	SEC
	SBC.b #6
IsNotSmall:
	CLC
	ADC.b !RAM_SMW_NorSpr_YPosLo,x
	STA.b !RAM_SMW_Player_YPosLo
	LDA.b #0
	ADC.w !RAM_SMW_NorSpr_YPosHi,x
	STA.b !RAM_SMW_Player_YPosHi
	RTL

NotFalling:
	LDA.b #16
	STA.b !RAM_SMW_Player_YSpeed
	RTL
namespace off

org SMW_SolidSpriteBlock_NotRidingYoshi2+1
namespace DUO_Thwomp_SolidHeight
	JSL.l Main
freecode
Main:
	LDA.b #-15
	LDY.b !RAM_SMW_Player_DuckingFlag
	BNE.b IsSmall
	LDY.b !RAM_SMW_Player_CurrentPowerUp
	BNE.b IsNotSmall
IsSmall:
	ADC.b #8
	LDY.w !RAM_SMW_Player_RidingYoshiFlag
	BNE.b IsNotSmall
	ADC.b #6
IsNotSmall:
	; Overwritten code
	ADC.b !RAM_SMW_Player_OnScreenPosYLo
	CMP.b !RAM_SMW_Misc_ScratchRAM00
	RTL
namespace off

; Push upwards even if player is moving upwards or blocked
org SMW_SolidSpriteBlock_Sub+$1F
	NOP #4
org SMW_SolidSpriteBlock_Sub+$15
namespace DUO_Thwomp_PushUp
	JSL.l Main
freecode
Main:
	LDA.b !RAM_SMW_Player_YSpeed
	BMI.b NoYSpeed
	LDA.b #80
	STA.b !RAM_SMW_Player_YSpeed

NoYSpeed:
	LDA.b !RAM_SMW_Player_BlockedFlags
	AND.b #$08
	BEQ.b NoCrush
	; crushma
	STZ.w !RAM_SMW_Timer_PlayerHurt
	JSL.l SMW_DamagePlayer_Hurt
NoCrush:
	RTL
namespace off

org SMW_SolidSpriteBlock_HandleMarioSide+3
namespace DUO_Thwomp_SolidWidth
	JML.l Main
freecode
Main:
	LDA.b !RAM_SMW_NorSpr_SpriteID,x
	CMP.b #!Define_SMW_SpriteID_NorSpr026_Thwomp
	BNE.b NotThwomp

	CPY.b #0
	BNE.b Left

Right:
	LDA.b #2
	STA.w DUO.Player_SpriteWallTouchFlag

	LDA.b #$0E
	CLC
	ADC.b !RAM_SMW_NorSpr_XPosLo,x
	STA.b !RAM_SMW_Player_XPosLo
	LDA.b #$00
	ADC.w !RAM_SMW_NorSpr_XPosHi,x
	STA.b !RAM_SMW_Player_XPosHi

	LDA.b !RAM_SMW_Player_XSpeed
	BPL.b Return
	STZ.b !RAM_SMW_Player_XSpeed
	BRA.b Return

Left:
	LDA.b #1
	STA.w DUO.Player_SpriteWallTouchFlag

	LDA.b #$F2
	CLC
	ADC.b !RAM_SMW_NorSpr_XPosLo,x
	STA.b !RAM_SMW_Player_XPosLo
	LDA.b #$FF
	ADC.w !RAM_SMW_NorSpr_XPosHi,x
	STA.b !RAM_SMW_Player_XPosHi

	LDA.b !RAM_SMW_Player_XSpeed
	BMI.b Return
	STZ.b !RAM_SMW_Player_XSpeed
	BRA.b Return

Return:
	JML.l SMW_SolidSpriteBlock_NoContact2

NotThwomp:
	; Overwritten code
	CMP.b #!Define_SMW_SpriteID_NorSpr0A9_Reznor
	JML.l SMW_SolidSpriteBlock_HandleMarioSide+7
namespace off