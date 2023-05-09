!RAM_DUO_Lo = $000F5E
!RAM_DUO_Hi = $419C7B

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

macro Define_SA1_RAM(Name)
	!Address #= !RAM_SMW_<Name>
	if !Address >= $0000 && !Address <= $00FF
		!RAM_SA1_<Name> = !RAM_SMW_<Name>+$3000
	elseif !Address >= $0100 && !Address <= $1FFF
		!RAM_SA1_<Name> = !RAM_SMW_<Name>+$6000
	else
		!RAM_SA1_<Name> = !RAM_SMW_<Name>
	endif
	print "$",hex(!RAM_SMW_<Name>)," -> $",hex(!RAM_SA1_<Name>)," (RAM_SMW_<Name>)"
endmacro

; grep -ho '!RAM_SA1_[^,]*' Custom/Patches/Duo/*.asm | sort | uniq | sed -r 's/!RAM_SA1_(.*)/%Define_SA1_RAM(\1)/'
%Define_SA1_RAM(BounceSpr_YPosHi)
%Define_SA1_RAM(Counter_TimerFrames)
%Define_SA1_RAM(Flag_IceLevel)
%Define_SA1_RAM(Flag_ScrollUpToPlayer)
%Define_SA1_RAM(Flag_SpritesLocked)
%Define_SA1_RAM(Flag_StandingOnBetaCage)
%Define_SA1_RAM(IO_ControllerHold1)
%Define_SA1_RAM(IO_ControllerPress1)
%Define_SA1_RAM(IO_ControllerPress2)
%Define_SA1_RAM(IO_MusicCh1)
%Define_SA1_RAM(IO_SoundCh2)
%Define_SA1_RAM(IO_SoundCh3)
%Define_SA1_RAM(Misc_ScratchRAM00)
%Define_SA1_RAM(Misc_ScratchRAM01)
%Define_SA1_RAM(Misc_ScratchRAM02)
%Define_SA1_RAM(Misc_StatusBarTilemap)
%Define_SA1_RAM(Player_DuckingFlag)
%Define_SA1_RAM(Player_FacingDirection)
%Define_SA1_RAM(Player_HorizontalSideOfBlockBeingTouched)
%Define_SA1_RAM(Player_InAirFlag)
%Define_SA1_RAM(Player_PMeter)
%Define_SA1_RAM(Player_SlidingOnGround)
%Define_SA1_RAM(Player_SpinJumpFlag)
%Define_SA1_RAM(Player_SubXSpeed)
%Define_SA1_RAM(Player_SubYSpeed)
%Define_SA1_RAM(Player_XSpeed)
%Define_SA1_RAM(Player_YPosLo)
%Define_SA1_RAM(Player_YSpeed)
%Define_SA1_RAM(Timer_EndLevel)