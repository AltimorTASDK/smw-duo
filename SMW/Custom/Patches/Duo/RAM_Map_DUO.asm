!RAM_DUO_Lo = $000F5E

if !Define_DUO_SA1 != !FALSE
	!RAM_DUO_Hi = $419C7B
else
	!RAM_DUO_Hi = $7F9C7B
endif

; 20 bytes max
struct DUO !RAM_DUO_Lo
	.ScratchRAM00: skip 1
	.ScratchRAM01: skip 1
	.ScratchRAM02: skip 1
	.ScratchRAM03: skip 1
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
	.CheckpointXPosLo: skip 1
	.CheckpointXPosHi: skip 1
	.CheckpointYPosLo: skip 1
	.CheckpointYPosHi: skip 1
	.Level_CheckpointXPosLo: skip 96
	.Level_CheckpointXPosHi: skip 96
	.Level_CheckpointYPosLo: skip 96
	.Level_CheckpointYPosHi: skip 96
	.Shooter_SpriteID:
	.Shooter_ExtraByte1: skip !Define_SMW_MaxShooterSpriteSlot
	.Shooter_PipeDirectionAndOffset:
	.Shooter_ExtraByte2: skip !Define_SMW_MaxShooterSpriteSlot
	.NorSpr_PipeExitDirection: skip !Define_SMW_MaxNormalSpriteSlot
	.NorSpr_PipeExitTimer: skip !Define_SMW_MaxNormalSpriteSlot
endstruct

macro Define_SA1_RAM(Name)
	if !Define_DUO_SA1 != !FALSE
		if !RAM_SMW_<Name> >= $0000 && !RAM_SMW_<Name> <= $00FF
			!RAM_SA1_<Name> = !RAM_SMW_<Name>+$3000
		elseif !RAM_SMW_<Name> >= $0100 && !RAM_SMW_<Name> <= $1FFF
			!RAM_SA1_<Name> = !RAM_SMW_<Name>+$6000
		else
			!RAM_SA1_<Name> = !RAM_SMW_<Name>
		endif
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

%Define_SA1_RAM(L1ScrollSpr_SpriteID)
%Define_SA1_RAM(L2ScrollSpr_SpriteID)
%Define_SA1_RAM(Mirror_CurrentLayer1XPosHi)
%Define_SA1_RAM(Mirror_CurrentLayer1XPosLo)
%Define_SA1_RAM(Mirror_CurrentLayer1YPosHi)
%Define_SA1_RAM(Mirror_CurrentLayer1YPosLo)
%Define_SA1_RAM(NorSpr_CurrentLayerPriority)
%Define_SA1_RAM(NorSpr_CurrentSlotID)
%Define_SA1_RAM(NorSpr_CurrentStatus)
%Define_SA1_RAM(NorSpr_FacingDirection)
%Define_SA1_RAM(NorSpr_SpriteID)
%Define_SA1_RAM(NorSpr_XPosHi)
%Define_SA1_RAM(NorSpr_XPosLo)
%Define_SA1_RAM(NorSpr_XSpeed)
%Define_SA1_RAM(NorSpr_YPosHi)
%Define_SA1_RAM(NorSpr_YPosLo)
%Define_SA1_RAM(NorSpr_YSpeed)
%Define_SA1_RAM(NorSprXXX_PowerUps_NoBlockSideInteractionTimer)
%Define_SA1_RAM(NorSprXXX_PowerUps_RisingOutOfBlockTimer)
%Define_SA1_RAM(NorSprXXX_PowerUps_RisingOutOfSpriteBlockFlag)
%Define_SA1_RAM(NorSprXXX_PowerUps_StayInPlaceFlag)
%Define_SA1_RAM(Player_XPosHi)
%Define_SA1_RAM(Player_XPosLo)
%Define_SA1_RAM(ShooterSpr_ShootTimer)
%Define_SA1_RAM(ShooterSpr_XPosHi)
%Define_SA1_RAM(ShooterSpr_XPosLo)
%Define_SA1_RAM(ShooterSpr_YPosHi)
%Define_SA1_RAM(ShooterSpr_YPosLo)
%Define_SA1_RAM(SmokeSpr_SpriteID)
%Define_SA1_RAM(SmokeSpr_Timer)
%Define_SA1_RAM(SmokeSpr_XPosLo)
%Define_SA1_RAM(SmokeSpr_YPosLo)

%Define_SA1_RAM(NorSpr_Table7E1504)

%Define_SA1_RAM(Pointer_SpriteListDataLo)