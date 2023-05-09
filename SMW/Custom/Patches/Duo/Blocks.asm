org SMW_CheckIfBlockWasHit_DATA_00F05C
	; Modify index 0D from 06 -> 07 to make spin blocks breakable
	db $01,$05,$01,$02,$01,$01,$00,$00
	db $00,$00,$00,$00,$00,$07,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$03,$03,$04,$02,$02,$02,$01
	db $01,$07,$11,$10

; Fix coins being replaced by invisible blocks when
; collected by a block hit from below
org SMW_GetBounceSpriteLevelCollisionMap16ID_CODE_02931A+$28
namespace DUO_GetBounceSpriteLevelCollisionMap16ID_FixCoinBug
	JSL.l Main
	NOP
	JSR.w SMW_SpawnMap16TileFromBounceSprite_Main
freecode
Main:
	; Overwritten code
	SBC.b #$00
	STA.w !RAM_SA1_BounceSpr_YPosHi,x

	LDA.b #2

	RTL
namespace off