; Override sprite type ranges
org SMW_ParseLevelSpriteList_CODE_02A84C+$1E
namespace DUO_HandleCustomSprites
	JML.l Main
freecode
Main:
	CMP.b #$F0
	BNE.b Generator
	; Handle as a shooter
	JML.l SMW_ParseLevelSpriteList_CODE_02A8D4+4
Generator:
	; Overwritten code
	LDA.w !RAM_SA1_L1ScrollSpr_SpriteID
	ORA.w !RAM_SA1_L2ScrollSpr_SpriteID
	JML.l SMW_ParseLevelSpriteList_CODE_02A84C+$1E+6
namespace off

; Handle extra bytes
org SMW_NorSprXXX_LoadShooter_CODE_02ABDF+$0B
namespace DUO_HandleShooterData
	JSL.l Main
freecode
Main:
	INY #2

	LDA.w !RAM_SMW_ShooterSpr_SpriteID,x
	CMP.b #$F0-$C8
	BNE.b NextSprite

	LDA.b [!RAM_SMW_Pointer_SpriteListDataLo],y
	STA.l DUO_Hi.Shooter_SpriteID,x
	INY
	LDA.b [!RAM_SMW_Pointer_SpriteListDataLo],y
	STA.l DUO_Hi.Shooter_PipeDirection,x
	INY

NextSprite:
	; Overwritten code
	LDX.b !RAM_SMW_Misc_ScratchRAM02
	RTL
namespace off

; Extend shooter sprite table
org SMW_ProcessShooterSprites_CODE_02B3AB
namespace DUO_ShooterSpriteTable
	JML.l Main
freecode
Main:
	DEC
	JSL.l SMW_ExecutePtr_Long

ShooterSprPtrs:
.ShooterSpr01_BulletBillShooter: dl SMW_ShooterSpr01_BulletBillShooter_Main
.ShooterSpr02_TorpedoShooter:    dl SMW_ShooterSpr02_TorpedoShooter_Main
.ShooterSpr03_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr04_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr05_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr06_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr07_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr08_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr09_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr0A_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr0B_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr0C_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr0D_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr0E_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr0F_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr10_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr11_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr12_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr13_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr14_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr15_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr16_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr17_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr18_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr19_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr1A_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr1B_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr1C_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr1D_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr1E_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr1F_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr20_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr21_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr22_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr23_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr24_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr25_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr26_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr27_Unused:            dl SMW_ShooterSpr03_Unused_Main
.ShooterSpr28_Unused:            dl SMW_ShooterSpr28_MushroomShooter_Thunk
namespace off

namespace SMW_ShooterSpr28_MushroomShooter
freecode
Thunk:
	; Return to bank 02
	JSR.w Main
	JML.l SMW_ShooterSpr01_BulletBillShooter_Return02B4DD
Return1:
	RTS
Main:
	LDA.w !RAM_SA1_ShooterSpr_ShootTimer,x
	BNE.b Return1
	LDA.b #$60
	STA.w !RAM_SA1_ShooterSpr_ShootTimer,x
	LDA.w !RAM_SA1_ShooterSpr_YPosLo,x
	CMP.b !RAM_SA1_Mirror_CurrentLayer1YPosLo
	LDA.w !RAM_SA1_ShooterSpr_YPosHi,x
	SBC.b !RAM_SA1_Mirror_CurrentLayer1YPosHi
	BNE.b Return1
	LDA.w !RAM_SA1_ShooterSpr_XPosLo,x
	CMP.b !RAM_SA1_Mirror_CurrentLayer1XPosLo
	LDA.w !RAM_SA1_ShooterSpr_XPosHi,x
	SBC.b !RAM_SA1_Mirror_CurrentLayer1XPosHi
	BNE.b Return
	LDA.w !RAM_SA1_ShooterSpr_XPosLo,x
	SEC
	SBC.b !RAM_SA1_Mirror_CurrentLayer1XPosLo
	CLC
	ADC.b #$10
	CMP.b #$10
	BCC.b Return
	JSL.l SMW_FindFreeNormalSpriteSlot_LowPriority
	BMI.b Return
	LDA.b #!Define_SMW_NorSprStatus08_Normal
	STA.w !RAM_SA1_NorSpr_CurrentStatus,y
	LDA.l DUO_Hi.Shooter_SpriteID,x
	STA.w !RAM_SA1_NorSpr_SpriteID,y
	LDA.b #1
	CMP.l DUO_Hi.Shooter_PipeDirection,x
	LDA.w !RAM_SA1_ShooterSpr_XPosLo,x
	BCC.b NoXOffset
	; Spawn from middle of pipe
	CLC
	ADC.b #8
NoXOffset:
	STA.w !RAM_SA1_NorSpr_XPosLo,y
	LDA.w !RAM_SA1_ShooterSpr_XPosHi,x
	ADC.b #0
	STA.w !RAM_SA1_NorSpr_XPosHi,y
	LDA.b #1
	CMP.l DUO_Hi.Shooter_PipeDirection,x
	LDA.w !RAM_SA1_ShooterSpr_YPosLo,x
	BCS.b NoYOffset
	; Spawn from middle of pipe
	SEC
	SBC.b #8
NoYOffset:
	STA.w !RAM_SA1_NorSpr_YPosLo,y
	LDA.w !RAM_SA1_ShooterSpr_YPosHi,x
	SBC.b #0
	STA.w !RAM_SA1_NorSpr_YPosHi,y
	PHX
	TYX
	JSL.l SMW_InitializeNormalSpriteRAMTables_Main
	STZ.w !RAM_SA1_NorSprXXX_PowerUps_StayInPlaceFlag,x
	STZ.w !RAM_SA1_NorSpr_CurrentLayerPriority,x
	LDA.b #60
	STA.w !RAM_SA1_NorSprXXX_PowerUps_RisingOutOfBlockTimer,x
	TXY
	PLX
	LDA.l DUO_Hi.Shooter_PipeDirection,x
	STA.w !RAM_SA1_NorSprXXX_PowerUps_RisingOutOfBlockDirection,y
	CMP.b #2
	BNE.b Return
	; Come out to the left
	LDA.b #1
	STA.w !RAM_SA1_NorSpr_FacingDirection,y
Return:
	RTS