!RAM_SA1_NorSprXXX_PowerUps_RisingOutOfBlockDirection = !RAM_SA1_NorSpr_Table7E1504

; Allow powerups to rise up/down/left/right out of pipes
org SMW_NorSprXXX_PowerUps_Status08_CODE_01C3A0+4
namespace DUO_HandlePowerupRiseDirection
	JSL.l Main
	; Updates both X and Y position
	JSR.w SMW_NorSpr082_BonusGame_Status08_CODE_01DE9F+$0A
freecode
Main:
	LDA.w !RAM_SA1_NorSprXXX_PowerUps_RisingOutOfBlockDirection,x
	BNE.b Down
Up:
	LDA.b #-4
	STA.b !RAM_SA1_NorSpr_YSpeed,x
	RTL
Down:
	CMP.b #1
	BNE.b Left
	LDA.b #4
	STA.b !RAM_SA1_NorSpr_YSpeed,x
	RTL
Left:
	CMP.b #2
	BNE.b Right
	LDA.b #-4
	STA.b !RAM_SA1_NorSpr_XSpeed,x
	RTL
Right:
	LDA.b #4
	STA.b !RAM_SA1_NorSpr_XSpeed,x
	RTL
namespace off

; Don't apply collision while a sprite is coming out of a block
org SMW_NorSprXXX_PowerUps_Status08_CODE_01C38F+5
	NOP #3