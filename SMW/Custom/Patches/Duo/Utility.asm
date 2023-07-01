macro Mode16BitA()
	REP.b #$20
endmacro
macro Mode8BitA()
	SEP.b #$20
endmacro
macro Mode16BitXY()
	REP.b #$10
endmacro
macro Mode8BitXY()
	SEP.b #$10
endmacro
macro Mode16BitAXY()
	REP.b #$30
endmacro
macro Mode8BitAXY()
	SEP.b #$30
endmacro

freecode
DUO_HexToDec:
	LDX.b #$00
-:
	CMP.b #$0A
	BCC.b +
	SBC.b #$0A
	INX
	BRA.b -
+:
	RTL