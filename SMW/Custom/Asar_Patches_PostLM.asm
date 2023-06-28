lorom
!addr = $0000
!ram = $7E0000
!bank = $800000

!RAM_SMW_Pointer_SpriteListDataLo = $0000CE

!LM_LoadNextSprite #= read3($02A847)
!SpriteSizes       #= read3($0EF30C)

org $02A846
namespace SkipExtraSpriteBytes
	JML.l Main
freecode cleaned
Main:
	; Extra bits as high byte for table index
	DEY
	LDA.b [!RAM_SMW_Pointer_SpriteListDataLo],y
	LSR #2
	AND #3
	XBA

	; Sprite ID as low byte
	INY #2
	LDA.b [!RAM_SMW_Pointer_SpriteListDataLo],y

	; Y will be incremented twice by the loop
	DEY #4

	; 16-bit A/X/Y
	REP.b #$30

	; Add data size to Y
	PHX
	TAX
	TYA
	CLC
	ADC.l !SpriteSizes,x
	TAY
	PLX

	; 8-bit A/X/Y
	SEP.b #$30

	JML.l !LM_LoadNextSprite
namespace off
