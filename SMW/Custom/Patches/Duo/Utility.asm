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