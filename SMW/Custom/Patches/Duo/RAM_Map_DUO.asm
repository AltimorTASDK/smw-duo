!RAM_DUO_Lo = $000F5E
!RAM_DUO_Hi = $7F9C7B

; 20 bytes max
struct DUO !RAM_DUO_Lo
	.Player_HighJumpFlag: skip 1
	.Player_LongJumpFlag: skip 1
	.Player_WallTouchFlag: skip 1
	.Player_WalljumpTimer: skip 1
endstruct

; 11141 bytes max
struct DUO_Hi !RAM_DUO_Hi
	.Misc_StatusBarTilemap:
	.Misc_StatusBarTilemap_SpeedLabel: skip 6*2
	.Misc_StatusBarTilemap_XLabel: skip 1*2
	.Misc_StatusBarTilemap_XSpeed: skip 3*2
	.Misc_StatusBarTilemap_Blank1: skip 1*2
	.Misc_StatusBarTilemap_YLabel: skip 1*2
	.Misc_StatusBarTilemap_YSpeed: skip 3*2
	.Misc_StatusBarTilemap_Blank2: skip 4*2
	.Misc_StatusBarTilemap_PMeterLabel: skip 1*2
	.Misc_StatusBarTilemap_PMeter: skip 8*2
	.Misc_StatusBarTilemapEnd:
endstruct