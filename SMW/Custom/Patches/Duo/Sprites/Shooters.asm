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
	STA.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
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
.ShooterSpr28_Unused:            dl SMW_ShooterSpr28_PipeShooter_Thunk
namespace off

namespace SMW_ShooterSpr28_PipeShooter
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
	BNE.b Return1
	LDA.w !RAM_SA1_ShooterSpr_XPosLo,x
	SEC
	SBC.b !RAM_SA1_Mirror_CurrentLayer1XPosLo
	CLC
	ADC.b #$10
	CMP.b #$10
	BCC.b Return
	JSL.l SMW_FindFreeNormalSpriteSlot_LowPriority
	BMI.b Return
	LDA.b #!Define_SMW_NorSprStatus01_Init
	STA.w !RAM_SA1_NorSpr_CurrentStatus,y
	LDA.l DUO_Hi.Shooter_SpriteID,x
	STA.w !RAM_SA1_NorSpr_SpriteID,y
	LDA.b #$3F
	CMP.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
	LDA.w !RAM_SA1_ShooterSpr_XPosLo,x
	BCC.b NoXOffset
	; Spawn from middle of pipe
	LDA.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
	AND.b #$0F
	CLC
	ADC.w !RAM_SA1_ShooterSpr_XPosLo,x
NoXOffset:
	STA.w !RAM_SA1_NorSpr_XPosLo,y
	LDA.w !RAM_SA1_ShooterSpr_XPosHi,x
	ADC.b #0
	STA.w !RAM_SA1_NorSpr_XPosHi,y
	LDA.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
	CMP.b #$3F
	LDA.w !RAM_SA1_ShooterSpr_YPosLo,x
	BCC.b NoYOffset
	; Spawn from middle of pipe
	LDA.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
	AND.b #$0F
	CLC
	ADC.w !RAM_SA1_ShooterSpr_YPosLo,x
NoYOffset:
	STA.w !RAM_SA1_NorSpr_YPosLo,y
	LDA.w !RAM_SA1_ShooterSpr_YPosHi,x
	ADC.b #0
	STA.w !RAM_SA1_NorSpr_YPosHi,y
	PHX
	TYX
	JSL.l SMW_InitializeNormalSpriteRAMTables_Main
	TXY
	PLX
	LDA.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
	LSR #5
	PHX
	TYX
	STA.l DUO_Hi.NorSpr_PipeExitDirection,x
	LDA.b #63
	STA.l DUO_Hi.NorSpr_PipeExitTimer,x
	PLX
	LDA.l DUO_Hi.Shooter_PipeDirectionAndOffset,x
	AND.b #$10
	BNE.b Return
	; Come out to the left
	LDA.b #1
	STA.w !RAM_SA1_NorSpr_FacingDirection,y
Return:
	RTS

org SMW_InitializeNormalSpriteRAMTables_ClearTables
namespace DUO_ClearNorSprData
	JSL.l Main
	NOP #2
freecode
Main:
	LDA.b #0
	STA.l DUO_Hi.NorSpr_PipeExitTimer,x
	; Overwritten code
	STZ.w !RAM_SMW_NorSpr_Table7E164A,x
	STZ.w !RAM_SMW_NorSpr_CurrentLayerPriority,x
	RTL

; Decrement pipe exit timer
org SMW_ProcessNormalSprites_GetNormalSpriteOAMIndexAndDecrementTimers+$18
namespace DUO_DecrementNormalSpriteTimers
	JML.l Main
freecode
Main:
	; Overwritten code
	LDA.b !RAM_SMW_Flag_SpritesLocked
	BNE.b Locked

	LDA.l DUO_Hi.NorSpr_PipeExitTimer,x
	BEQ.b +
	DEC
	STA.l DUO_Hi.NorSpr_PipeExitTimer,x
+:

	JML.l SMW_ProcessNormalSprites_GetNormalSpriteOAMIndexAndDecrementTimers+$1C
Locked:
	JML.l SMW_ProcessNormalSprites_Return018126
namespace off

; Set tile priority for sprites coming out of pipes
org SMW_ProcessNormalSprites_CODE_0180A9+6
	JSR.w SMW_ProcessNormalSprites_Main+4

org SMW_ProcessNormalSprites_Main
namespace DUO_HandleSpritePriorityOutOfPipe
	JML.l Overwritten
	JSL.l PreHandleSprite
	JSR.w SMW_ProcessNormalSprites_HandleSprite
	JSL.l PostHandleSprite
	RTS
freecode
Overwritten:
	PHB
	; PHK
	LDA.b #$01
	PHA
	PLB
	LDA.w !RAM_SMW_Player_CarryingSomethingFlag2
	STA.w !RAM_SMW_Player_CarryingSomethingFlag1
	STZ.w !RAM_SMW_Player_CarryingSomethingFlag2
	STZ.w !RAM_SMW_Misc_PlayerOnSolidSprite
	STZ.w !RAM_SMW_Flag_PlayerInLakitusCloud
	JML.l SMW_ProcessNormalSprites_Main+$12

PreHandleSprite:
	LDA.l DUO_Hi.NorSpr_PipeExitTimer,x
	STA.w DUO.ScratchRAM00
	BEQ.b .Return

	LDA.b !RAM_SMW_Flag_SpritesLocked
	STA.w DUO.ScratchRAM01
	LDA.b #1
	STA.b !RAM_SMW_Flag_SpritesLocked

	LDA.b !RAM_SMW_Sprites_TilePriority
	STA.w DUO.ScratchRAM02
	STZ.b !RAM_SMW_Sprites_TilePriority

	LDA.w !RAM_SMW_NorSpr_CurrentLayerPriority,x
	STA.w DUO.ScratchRAM03
	STZ.w !RAM_SMW_NorSpr_CurrentLayerPriority,x

	; Don't move if sprites locked
	LDA.w DUO.ScratchRAM01
	BNE.w .Return

	STZ.b !RAM_SA1_NorSpr_XSpeed,x
	LDA.l DUO_Hi.NorSpr_PipeExitDirection,x
	BNE.b .Down
.Up:
	LDA.b #-4
	STA.b !RAM_SA1_NorSpr_YSpeed,x
	BRA.b .UpdatePosition
.Down:
	CMP.b #1
	BNE.b .Left
	LDA.b #4
	STA.b !RAM_SA1_NorSpr_YSpeed,x
	BRA.b .UpdatePosition
.Left:
	STZ.b !RAM_SA1_NorSpr_YSpeed,x
	CMP.b #2
	BNE.b .Right
	LDA.b #-4
	STA.b !RAM_SA1_NorSpr_XSpeed,x
	BRA.b .UpdatePosition
.Right:
	LDA.b #4
	STA.b !RAM_SA1_NorSpr_XSpeed,x

.UpdatePosition:
	JSL.l SMW_UpdateNormalSpritePositionBank01_Main_X
	JSL.l SMW_UpdateNormalSpritePositionBank01_Main_Y

.Return:
	RTL

PostHandleSprite:
	LDA.w DUO.ScratchRAM00
	BEQ.b .Return

	LDA.w DUO.ScratchRAM01
	STA.b !RAM_SMW_Flag_SpritesLocked

	LDA.w DUO.ScratchRAM02
	STA.b !RAM_SMW_Sprites_TilePriority

	LDA.w DUO.ScratchRAM03
	STA.w !RAM_SMW_NorSpr_CurrentLayerPriority,x

.Return:
	RTL
namespace off

; Disable level collision for sprites coming out of pipes
org SMW_HandleNormalSpriteLevelCollision_Sub+$0F
namespace DUO_HandleSpriteCollisionOutOfPipe
	JML.l Main
freecode
Main:
	; Overwritten code
	STA.w !RAM_SMW_Sprites_SpriteEnterOrExitingWater
	STZ.w !RAM_SMW_NorSpr_InLiquidFlag,x

	LDA.l DUO_Hi.NorSpr_PipeExitTimer,x
	BNE.b NoCollision
	JML.l SMW_HandleNormalSpriteLevelCollision_Sub+$15
NoCollision:
	JML.l SMW_HandleNormalSpriteLevelCollision_Return019210
namespace off

; Prevent enemies coming out of pipes from automatically facing the player
org SMW_NorSprXXX_GenericEnemies_Status01_MakeSpriteFacePlayer+3
namespace DUO_HandleEnemyFacingOutOfPipe
	JSL.l Main
freecode
Main:
	LDA.l DUO_Hi.NorSpr_PipeExitTimer,x
	BNE.b +
	; Overwritten code
	TYA
	STA.w !RAM_SMW_NorSpr_FacingDirection,x
+:
	RTL
namespace off