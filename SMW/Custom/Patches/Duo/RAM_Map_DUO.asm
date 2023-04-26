!RAM_DUO_Base = $000695

struct DUO !RAM_DUO_Base
	.Player_HighJumpFlag: skip 1
	.Player_LongJumpFlag: skip 1
	.Player_WallTouchFlag: skip 1
	.Player_WalljumpTimer: skip 1
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