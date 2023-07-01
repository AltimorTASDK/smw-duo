org SMW_RunPlayerBlockCode_CODE_00F2C9+4
namespace DUO_StoreCheckpointPosition
	JSL.l Main
	; Don't replace midway tape tile
	BRA.b SMW_RunPlayerBlockCode_CODE_00F2C9+$0C
freecode
Main:
	LDA.b !RAM_SMW_Blocks_XPosLo
	AND.b #$F0
	STA.l DUO_Hi.CheckpointXPosLo
	LDA.b !RAM_SMW_Blocks_XPosHi
	STA.l DUO_Hi.CheckpointXPosHi
	LDA.b !RAM_SMW_Blocks_YPosLo
	AND.b #$F0
	STA.l DUO_Hi.CheckpointYPosLo
	LDA.b !RAM_SMW_Blocks_YPosHi
	STA.l DUO_Hi.CheckpointYPosHi
	RTL
namespace off

org SMW_OverworldProcess00_OverworldEntryInitialization_CODE_048F13+$3A
namespace DUO_StoreCheckpointOverworld
	; 8-bit accumulator can be set here because the ORA is overwritten
	%Mode8BitA()
	JSL.l Main
freecode
Main:
	LDA.l DUO_Hi.CheckpointXPosLo
	STA.l DUO_Hi.Level_CheckpointXPosLo,x
	LDA.l DUO_Hi.CheckpointXPosHi
	STA.l DUO_Hi.Level_CheckpointXPosHi,x
	LDA.l DUO_Hi.CheckpointYPosLo
	STA.l DUO_Hi.Level_CheckpointYPosLo,x
	LDA.l DUO_Hi.CheckpointYPosHi
	STA.l DUO_Hi.Level_CheckpointYPosHi,x

	; Overwritten code
	LDA.w !RAM_SMW_Overworld_LevelTileSettings,x
	ORA.b #$40
	RTL
namespace off

org SMW_SpecifySublevelToLoad_CODE_05DA17+5
namespace DUO_LoadCheckpoint
	JSL.l Main
	NOP #4
freecode
Main:
	TAX ; Level index

	LDA.w !RAM_SMW_Counter_SublevelsEntered
	BNE.b Return

	LDA.w !RAM_SMW_Overworld_LevelTileSettings,x
	AND.b #$40
	BEQ.b Return

	LDA.l DUO_Hi.Level_CheckpointXPosLo,x
	STA.b !RAM_SMW_Player_XPosLo
	LDA.l DUO_Hi.Level_CheckpointXPosHi,x
	STA.b !RAM_SMW_Player_XPosHi
	LDA.l DUO_Hi.Level_CheckpointYPosLo,x
	SEC
	SBC.b #$10
	STA.b !RAM_SMW_Player_YPosLo
	LDA.l DUO_Hi.Level_CheckpointYPosHi,x
	SBC.b #0
	STA.b !RAM_SMW_Player_YPosHi

	; Set layer Y positions
	LDA.b !RAM_SMW_Player_YPosLo
	SEC
	SBC.b #$70
	STA.b !RAM_SMW_Mirror_CurrentLayer1YPosLo
	LDA.b !RAM_SMW_Player_YPosHi
	SBC.b #0
	STA.b !RAM_SMW_Mirror_CurrentLayer1YPosHi

	LDY.w !RAM_SMW_Flag_Layer2VerticalScrollLevelSetting
	CPY.b #$03
	BEQ.b Return
	STA.b !RAM_SMW_Mirror_CurrentLayer2YPosHi
	LDA.b !RAM_SMW_Mirror_CurrentLayer1YPosLo
	STA.b !RAM_SMW_Mirror_CurrentLayer2YPosLo

Return:
	RTL
namespace off

; Spawn midway tape even if a midway has been collected
org SMW_ExtendedObj46_MidwayBar_Main
	BRA.b SMW_ExtendedObj46_MidwayBar_Main+$10