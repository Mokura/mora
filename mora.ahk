;==============================================================================
; Mora - FFRPG SeeD HP/MP/Limit Tracker with Status Tracking
; A Player Character stat-keeper.
; Coded by Mokura
; Version 0.21
;==============================================================================

#SingleInstance off
#NoTrayIcon
SetWorkingDir %A_ScriptDir%
Gui, Font,, Tahoma
AutoTrim, Off

;+ Tab 1 variables
; Character Stats.
CharaName := ""
CurHP := 0
MaxHP := 0
CurMP := 0
MaxMP := 0
CurLimit := 0
MaxLimit := 0
Armor := 0
MagicArmor := 0
Effect := 0
EffectiveDmg := 0

; Percent Healing/Damage (Gravity)-related variables.
GravityPercent := 0
GravityHealing := 0
UseMPGrav := 0
MaxBased := 0

; Other modification variables.
UseDefenseFactor := 0
DefenseFactorPercent := 100
UseBuffArmor := 0
BuffArmor := 0
UseBuffMagicArmor := 0
BuffMagicArmor := 0
UseBuffTempHP := 0
BuffTempHP := 0
UseBubbleEffect := 0
ReverseDamage := 0
RowPosition := "Front"
BuffRegen := 0
BuffRefresh := 0

; "Don't display" toggling variables.
; DontDisplayRow := 0
; DontDisplayStatuses := 0
;-

;+ Tab 2 variables
;+ Status slot toggles.
UseStat1 := 0
UseStat2 := 0
UseStat3 := 0
UseStat4 := 0
UseStat5 := 0
UseStat6 := 0
UseStat7 := 0
UseStat8 := 0
UseStat9 := 0
UseStat10 := 0
UseStat11 := 0
UseStat12 := 0
;-

;+ Status names.
Status1 := ""
Status2 := ""
Status3 := ""
Status4 := ""
Status5 := ""
Status6 := ""
Status7 := ""
Status8 := ""
Status9 := ""
Status10 := ""
Status11 := ""
Status12 := ""
;-

;+ Status timers.
StatusCount1 := 0
StatusCount2 := 0
StatusCount3 := 0
StatusCount4 := 0
StatusCount5 := 0
StatusCount6 := 0
StatusCount7 := 0
StatusCount8 := 0
StatusCount9 := 0
StatusCount10 := 0
StatusCount11 := 0
StatusCount12 := 0
;-
;-

; Status report output.
CurStatus := ""

;==============================================================================
; Create the Tab control.
;==============================================================================
Gui, Add, Tab2, x0 y0 h390 w395 Bottom, Player Tracker|Status Tracker

;+ Tab 1 GUI
;==============================================================================
; Tab 1 - Player Tracking.
;==============================================================================
Gui, Tab, Player Tracker,, Exact

; Header (Character Name, Save, Load)
Gui, Add, Text, x5 y8 w80 h20 +Center, Character Name
Gui, Add, Edit, x90 y5 w190 h20 r1 vCharaName
Gui, Add, Button, x285 y5 w50 h20 +Center gCharaSave, Save
Gui, Add, Button, x340 y5 w50 h20 +Center gCharaLoad, Load

; Left side row (Buttons that do stuff)
Gui, Add, Button, x5 y30 w100 h25 +Center gPhysDmg, Physical Damage
Gui, Add, Button, x5 y60 w100 h25 +Center gMagDmg, Magical Damage
Gui, Add, Button, x5 y90 w100 h25 +Center gPhysMPDmg, MP Damage (Phy)
Gui, Add, Button, x5 y120 w100 h25 +Center gMagMPDmg, MP Damage (Mag)
Gui, Add, Button, x5 y150 w100 h25 +Center gHPHeal, Healing (HP)
Gui, Add, Button, x5 y180 w100 h25 +Center gMPHeal, Healing (MP)
Gui, Add, Button, x5 y210 w100 h25 +Center gIncLimit, Increase Limit
Gui, Add, Button, x5 y240 w100 h25 +Center gDecLimit, Decrease Limit
Gui, Add, Button, x5 y270 w100 h25 +Center gUseMPSkill, Use MP Skill
Gui, Add, Button, x5 y300 w100 h25 +Center gDispStatus, Display Status

; Top middle (player stats)
Gui, Add, Text, x110 y28 w80 h20 +Center, Current HP
Gui, Add, Edit, x110 y45 w80 h20 Limit7 r1 Number vCurHP, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x195 y28 w80 h20 +Center, Maximum HP
Gui, Add, Edit, x195 y45 w80 h20 Limit7 r1 Number vMaxHP, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x110 y68 w80 h20 +Center, Current MP
Gui, Add, Edit, x110 y85 w80 h20 Limit7 r1 Number vCurMP, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x195 y68 w80 h20 +Center, Maximum MP
Gui, Add, Edit, x195 y85 w80 h20 Limit7 r1 Number vMaxMP, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x110 y108 w80 h20 +Center, Current Limit
Gui, Add, Edit, x110 y125 w80 h20 Limit7 r1 Number vCurLimit, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x195 y108 w80 h20 +Center, Maximum Limit
Gui, Add, Edit, x195 y125 w80 h20 Limit7 r1 Number vMaxLimit, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x110 y148 w80 h20 +Center, Armor
Gui, Add, Edit, x110 y165 w80 h20 Limit7 r1 Number vArmor, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x195 y148 w80 h20 +Center, Magic Armor
Gui, Add, Edit, x195 y165 w80 h20 Limit7 r1 Number vMagicArmor, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x110 y188 w80 h20 +Center, Dmg/Heal/Limit
Gui, Add, Edit, x110 y205 w80 h20 Limit7 r1 Number vEffect, 0
Gui, Add, UpDown, Range0-1000000

Gui, Add, Text, x195 y188 w80 h20 +Center, Damage Type
Gui, Add, DropDownList, x195 y205 w80 h20 r2 Choose1 vDamageType, Normal|Piercing

Gui, Add, Text, x110 y233 w80 h20 +Center, Effective Dmg.
Gui, Add, Edit, x195 y230 w80 h20 Limit7 r1 Number ReadOnly vEffectiveDmg

; Poison and Gravity
Gui, Add, Button, x110 y255 w165 h20 +Center gPoisonDmg, Poison Damage
Gui, Add, Button, x110 y280 w80 h20 +Center gGravityEffect, Gravity
Gui, Add, Edit, x195 y280 w44 h20 Limit3 r1 Number vGravityPercent
Gui, Add, UpDown, Range0-100
Gui, Add, Text, x240 y283 w40 h20, Grav `%
Gui, Add, CheckBox, x110 y305 w55 h20 vGravityHealing, Healing
Gui, Add, CheckBox, x170 y305 w35 h20 vUseMPGrav, MP
Gui, Add, CheckBox, x205 y305 w72 h20 vMaxBased, Max Based

; Modifiers and Options
Gui, Add, GroupBox, x280 y30 w110 h295, Modifiers/Options
Gui, Add, CheckBox, x285 y45 w100 h20 vUseDefenseFactor, Defense Factor
Gui, Add, Text, x285 y68 w50 h20 +Center, `% Rate
Gui, Add, Edit, x335 y65 w50 h20 Limit3 r1 Number vDefenseFactorPercent
Gui, Add, UpDown, Range0-100, 100
Gui, Add, CheckBox, x285 y85 w100 h20 vUseBuffArmor, Armor Buff
Gui, Add, Text, x285 y108 w50 h20 +Center, Amount
Gui, Add, Edit, x335 y105 w50 h20 Limit3 r1 Number vBuffArmor, 0
Gui, Add, UpDown, Range0-999
Gui, Add, CheckBox, x285 y125 w100 h20 vUseBuffMagicArmor, M. Armor Buff
Gui, Add, Text, x285 y148 w50 h20 +Center, Amount
Gui, Add, Edit, x335 y145 w50 h20 Limit3 r1 Number vBuffMagicArmor, 0
Gui, Add, UpDown, Range0-999
Gui, Add, CheckBox, x285 y165 w100 h20 vUseBuffTempHP, Temporary HP
Gui, Add, Text, x285 y188 w50 h20 +Center, Amount
Gui, Add, Edit, x335 y185 w50 h20 Limit4 r1 Number vBuffTempHP, 0
Gui, Add, UpDown, Range0-9999
Gui, Add, CheckBox, x285 y205 w100 h20 vUseBubbleEffect gBubbleEffect, Bubble Effect
Gui, Add, Checkbox, x285 y225 w103 h20 vReverseDamage, Reverse Effect
Gui, Add, Text, x285 y248 w25 h20 +Center, Row
Gui, Add, DropDownList, x315 y245 w70 h20 r2 Choose1 vRowPosition, Front|Back

Gui, Add, Text, x285 y273 w35 h20 +Center, Regen
Gui, Add, Edit, x320 y270 w45 h20 Limit3 r1 Number vBuffRegen
Gui, Add, UpDown, Range0-999
Gui, Add, Button, x367 y271 w18 h18 +Center gHealRegen, +

Gui, Add, Text, x285 y298 w35 h20 +Center, Refrs.
Gui, Add, Edit, x320 y295 w45 h20 Limit3 r1 Number vBuffRefresh
Gui, Add, UpDown, Range0-999
Gui, Add, Button, x367 y296 w18 h18 +Center gHealRefresh, +

; Player status area
Gui, Add, GroupBox, x0 y325 w390 h40, Current Status
Gui, Add, Edit, x5 y340 w380 h20 vCurStatus
;-

;+ Tab 2 GUI
;==============================================================================
; Tab 2 - Status Tracking.
;==============================================================================
Gui, Tab, Status Tracker,, Exact

;+ Headers
Gui, Add, Text, x4 y3 w50 h20 +Center, Use?
Gui, Add, Text, x55 y3 w140 h20 +Center, Status Name/Count
Gui, Add, Text, x200 y3 w190 h20 +Center, Status Options
;-

;+ Status slot checkboxes
Gui, Add, CheckBox, x4 y20 w50 h20 vUseStat1, Slot 1
Gui, Add, CheckBox, x4 y45 w50 h20 vUseStat2, Slot 2
Gui, Add, CheckBox, x4 y70 w50 h20 vUseStat3, Slot 3
Gui, Add, CheckBox, x4 y95 w50 h20 vUseStat4, Slot 4
Gui, Add, CheckBox, x4 y120 w50 h20 vUseStat5, Slot 5
Gui, Add, CheckBox, x4 y145 w50 h20 vUseStat6, Slot 6
Gui, Add, CheckBox, x4 y170 w50 h20 vUseStat7, Slot 7
Gui, Add, CheckBox, x4 y195 w50 h20 vUseStat8, Slot 8
Gui, Add, CheckBox, x4 y220 w50 h20 vUseStat9, Slot 9
Gui, Add, CheckBox, x4 y245 w50 h20 vUseStat10, Slot10
Gui, Add, CheckBox, x4 y270 w50 h20 vUseStat11, Slot11
Gui, Add, CheckBox, x4 y295 w50 h20 vUseStat12, Slot12
;-

;+ Status names
Gui, Add, Edit, x55 y20 w100 h20 r1 vStatus1
Gui, Add, Edit, x55 y45 w100 h20 r1 vStatus2
Gui, Add, Edit, x55 y70 w100 h20 r1 vStatus3
Gui, Add, Edit, x55 y95 w100 h20 r1 vStatus4
Gui, Add, Edit, x55 y120 w100 h20 r1 vStatus5
Gui, Add, Edit, x55 y145 w100 h20 r1 vStatus6
Gui, Add, Edit, x55 y170 w100 h20 r1 vStatus7
Gui, Add, Edit, x55 y195 w100 h20 r1 vStatus8
Gui, Add, Edit, x55 y220 w100 h20 r1 vStatus9
Gui, Add, Edit, x55 y245 w100 h20 r1 vStatus10
Gui, Add, Edit, x55 y270 w100 h20 r1 vStatus11
Gui, Add, Edit, x55 y295 w100 h20 r1 vStatus12
;-

;+ Status timers
Gui, Add, Edit, x155 y20 w40 h20 Limit2 r1 Number vStatusCount1, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y45 w40 h20 Limit2 r1 Number vStatusCount2, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y70 w40 h20 Limit2 r1 Number vStatusCount3, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y95 w40 h20 Limit2 r1 Number vStatusCount4, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y120 w40 h20 Limit2 r1 Number vStatusCount5, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y145 w40 h20 Limit2 r1 Number vStatusCount6, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y170 w40 h20 Limit2 r1 Number vStatusCount7, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y195 w40 h20 Limit2 r1 Number vStatusCount8, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y220 w40 h20 Limit2 r1 Number vStatusCount9, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y245 w40 h20 Limit2 r1 Number vStatusCount10, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y270 w40 h20 Limit2 r1 Number vStatusCount11, 0
Gui, Add, UpDown, Range-1-99
Gui, Add, Edit, x155 y295 w40 h20 Limit2 r1 Number vStatusCount12, 0
Gui, Add, UpDown, Range-1-99
;-

; Decrement buttons
Gui, Add, Button, x198 y20 w62 h20 +Center gDecStatus1, Decrement
Gui, Add, Button, x198 y45 w62 h20 +Center gDecStatus2, Decrement
Gui, Add, Button, x198 y70 w62 h20 +Center gDecStatus3, Decrement
Gui, Add, Button, x198 y95 w62 h20 +Center gDecStatus4, Decrement
Gui, Add, Button, x198 y120 w62 h20 +Center gDecStatus5, Decrement
Gui, Add, Button, x198 y145 w62 h20 +Center gDecStatus6, Decrement
Gui, Add, Button, x198 y170 w62 h20 +Center gDecStatus7, Decrement
Gui, Add, Button, x198 y195 w62 h20 +Center gDecStatus8, Decrement
Gui, Add, Button, x198 y220 w62 h20 +Center gDecStatus9, Decrement
Gui, Add, Button, x198 y245 w62 h20 +Center gDecStatus10, Decrement
Gui, Add, Button, x198 y270 w62 h20 +Center gDecStatus11, Decrement
Gui, Add, Button, x198 y295 w62 h20 +Center gDecStatus12, Decrement

; Increment buttons
Gui, Add, Button, x263 y20 w62 h20 +Center gIncStatus1, Increment
Gui, Add, Button, x263 y45 w62 h20 +Center gIncStatus2, Increment
Gui, Add, Button, x263 y70 w62 h20 +Center gIncStatus3, Increment
Gui, Add, Button, x263 y95 w62 h20 +Center gIncStatus4, Increment
Gui, Add, Button, x263 y120 w62 h20 +Center gIncStatus5, Increment
Gui, Add, Button, x263 y145 w62 h20 +Center gIncStatus6, Increment
Gui, Add, Button, x263 y170 w62 h20 +Center gIncStatus7, Increment
Gui, Add, Button, x263 y195 w62 h20 +Center gIncStatus8, Increment
Gui, Add, Button, x263 y220 w62 h20 +Center gIncStatus9, Increment
Gui, Add, Button, x263 y245 w62 h20 +Center gIncStatus10, Increment
Gui, Add, Button, x263 y270 w62 h20 +Center gIncStatus11, Increment
Gui, Add, Button, x263 y295 w62 h20 +Center gIncStatus12, Increment

; Clear buttons
Gui, Add, Button, x328 y20 w62 h20 +Center gClearStatus1, Clear
Gui, Add, Button, x328 y45 w62 h20 +Center gClearStatus2, Clear
Gui, Add, Button, x328 y70 w62 h20 +Center gClearStatus3, Clear
Gui, Add, Button, x328 y95 w62 h20 +Center gClearStatus4, Clear
Gui, Add, Button, x328 y120 w62 h20 +Center gClearStatus5, Clear
Gui, Add, Button, x328 y145 w62 h20 +Center gClearStatus6, Clear
Gui, Add, Button, x328 y170 w62 h20 +Center gClearStatus7, Clear
Gui, Add, Button, x328 y195 w62 h20 +Center gClearStatus8, Clear
Gui, Add, Button, x328 y220 w62 h20 +Center gClearStatus9, Clear
Gui, Add, Button, x328 y245 w62 h20 +Center gClearStatus10, Clear
Gui, Add, Button, x328 y270 w62 h20 +Center gClearStatus11, Clear
Gui, Add, Button, x328 y295 w62 h20 +Center gClearStatus12, Clear

; Status group buttons
Gui, Add, Button, x4 y320 w110 h20 +Center gDecUsed, Decrement Used
Gui, Add, Button, x4 y345 w110 h20 +Center gDecAll, Decrement All
Gui, Add, Button, x142 y320 w110 h20 +Center gIncUsed, Increment Used
Gui, Add, Button, x142 y345 w110 h20 +Center gIncAll, Increment All
Gui, Add, Button, x280 y320 w110 h20 +Center gClearUsed, Clear Used
Gui, Add, Button, x280 y345 w110 h20 +Center gClearAll, Clear All
;-

;==============================================================================
; Main GUI.
;==============================================================================
Gui, Show, h390 w395, Mora - Player Status Tracker
return

;+ Tab 1 routines
;==============================================================================
; Character data saving routine
;==============================================================================
CharaSave:
Gui, Submit, NoHide
Gui +OwnDialogs
FileSelectFile, OutputFile, S18, %A_WorkingDir%, Save Character Data, Configuration Files (*.ini)
if OutputFile=
  return
else
{
  IfNotInString, OutputFile, .ini
  {
    StringReplace, OutputFile, OutputFile, %OutputFile%, %OutputFile%.ini
  }
  
  ; name
  IniWrite, %CharaName%, %OutputFile%, Character Data, File_CharaName
  
  ; current/maximum HP
  IniWrite, %CurHP%, %OutputFile%, Character Data, File_CurHP
  IniWrite, %MaxHP%, %OutputFile%, Character Data, File_MaxHP
  
  ; current/maximum MP
  IniWrite, %CurMP%, %OutputFile%, Character Data, File_CurMP
  IniWrite, %MaxMP%, %OutputFile%, Character Data, File_MaxMP
  
  ; current/maximum LP
  IniWrite, %CurLimit%, %OutputFile%, Character Data, File_CurLimit
  IniWrite, %MaxLimit%, %OutputFile%, Character Data, File_MaxLimit
  
  ; current armor/m.armor
  IniWrite, %Armor%, %OutputFile%, Character Data, File_Armor
  IniWrite, %MagicArmor%, %OutputFile%, Character Data, File_MagicArmor
  
  ; current position
  IniWrite, %RowPosition%, %OutputFile%, Character Data, File_RowPosition
  
  ; regen/refresh values
  IniWrite, %BuffRegen%, %OutputFile%, Character Data, File_BuffRegen
  IniWrite, %BuffRefresh%, %OutputFile%, Character Data, File_BuffRefresh
}
return

;==============================================================================
; Character data loading routine
;==============================================================================
CharaLoad:
Gui, Submit, NoHide
Gui +OwnDialogs
FileSelectFile, InputFile, 3, %A_WorkingDir%, Load Character Data, Configuration Files (*.ini)
if InputFile=
  return
else
{
  ; name
  IniRead, F_CharaName, %InputFile%, Character Data, File_CharaName, %A_Space%
  GuiControl, , CharaName, %F_CharaName%
  
  ; current/maximum HP
  IniRead, F_CurHP, %InputFile%, Character Data, File_CurHP, 0
  GuiControl, , CurHP, %F_CurHP%
  IniRead, F_MaxHP, %InputFile%, Character Data, File_MaxHP, 0
  GuiControl, , MaxHP, %F_MaxHP%
  
  ; current/maximum MP
  IniRead, F_CurMP, %InputFile%, Character Data, File_CurMP, 0
  GuiControl, , CurMP, %F_CurMP%
  IniRead, F_MaxMP, %InputFile%, Character Data, File_MaxMP, 0
  GuiControl, , MaxMP, %F_MaxMP%
  
  ; current/maximum LP
  IniRead, F_CurLimit, %InputFile%, Character Data, File_CurLimit, 0
  GuiControl, , CurLimit, %F_CurLimit%
  IniRead, F_MaxLimit, %InputFile%, Character Data, File_MaxLimit, 0
  GuiControl, , MaxLimit, %F_MaxLimit%
  IniRead, F_Armor, %InputFile%, Character Data, File_Armor, 0
  
  ; current armor/m.armor
  GuiControl, , Armor, %F_Armor%
  IniRead, F_MagicArmor, %InputFile%, Character Data, File_MagicArmor, 0
  GuiControl, , MagicArmor, %F_MagicArmor%
  
  ; current position
  IniRead, F_RowPosition, %InputFile%, Character Data, File_RowPosition, 0
  if ((F_RowPosition == "Front") || (F_RowPosition == "Front Row"))
    GuiControl, , RowPosition, |Front||Back
  else
    GuiControl, , RowPosition, |Front|Back||

  ; regen/refresh values
  IniRead, F_BuffRegen, %InputFile%, Character Data, File_BuffRegen, 0
  GuiControl, , BuffRegen, %F_BuffRegen%
  IniRead, F_BuffRefresh, %InputFile%, Character Data, File_BuffRefresh, 0
  GuiControl, , BuffRefresh, %F_BuffRefresh%
}

return

;==============================================================================
; Physical damage routine
;==============================================================================
PhysDmg:
Gui, Submit, NoHide

TempArmor := Armor
TempPhysDmg := Effect
if (DamageType == "Normal")
{
  TempPhysDmg := TempPhysDmg - Armor
  if (UseBuffArmor == 1)
    TempPhysDmg := TempPhysDmg - BuffArmor
  if (UseDefenseFactor == 1)
    TempPhysDmg := Floor(TempPhysDmg * (DefenseFactorPercent * 0.01))
}

if (TempPhysDmg < 1)
  TempPhysDmg := 1

if (ReverseDamage == 1)
  TempPhysDmg := TempPhysDmg * -1

if (UseBuffTempHP == 1 && ReverseDamage == 0)
{
  if (TempPhysDmg >= BuffTempHP)
  {
    TempPhysDmg := TempPhysDmg - BuffTempHP
    BuffTempHP := 0
	GuiControl, , UseBuffTempHP, 0
	GuiControl, , BuffTempHP, %BuffTempHP%
  }
  
  else
  {
    BuffTempHP := BuffTempHP - TempPhysDmg
	TempPhysDmg := 0
	GuiControl, , BuffTempHP, %BuffTempHP%
  }
}

if (CurHP - TempPhysDmg < 0)
  CurHP := 0
else if (CurHP - TempPhysDmg > MaxHP)
  CurHP := MaxHP
else
  CurHP := CurHP - TempPhysDmg

GuiControl, , CurHP, %CurHP%
GuiControl, , EffectiveDmg, %TempPhysDmg%
return

;==============================================================================
; Magical damage routine
;==============================================================================
MagDmg:
Gui, Submit, NoHide
TempMagicArmor := MagicArmor
TempMagDmg := Effect

if (DamageType == "Normal")
{
  TempMagDmg := TempMagDmg - MagicArmor
  if (UseBuffMagicArmor == 1)
    TempMagDmg := TempMagDmg - BuffMagicArmor
  if (UseDefenseFactor == 1)
    TempMagDmg := Floor(TempMagDmg * (DefenseFactorPercent * 0.01))
}

if (TempMagDmg < 1)
  TempMagDmg := 1

if (ReverseDamage == 1)
  TempMagDmg := TempMagDmg * -1

if (UseBuffTempHP == 1 && ReverseDamage == 0)
{
  if (TempMagDmg >= BuffTempHP)
  {
    TempMagDmg := TempMagDmg - BuffTempHP
    BuffTempHP := 0
	GuiControl, , UseBuffTempHP, 0
	GuiControl, , BuffTempHP, %BuffTempHP%
  }
  
  else
  {
    BuffTempHP := BuffTempHP - TempMagDmg
	TempPhysDmg := 0
	GuiControl, , BuffTempHP, %BuffTempHP%
  }
}

if (CurHP - TempMagDmg < 0)
  CurHP := 0
else if (CurHP - TempMagDmg > MaxHP)
  CurHP := MaxHP
else
  CurHP := CurHP - TempMagDmg

GuiControl, , CurHP, %CurHP%
GuiControl, , EffectiveDmg, %TempMagDmg%
return

;==============================================================================
; Physical MP damage routine
;==============================================================================
PhysMPDmg:
Gui, Submit, NoHide
TempArmor := Armor
TempPhysMPDmg := Effect
if (DamageType == "Normal")
{
  TempPhysMPDmg := TempPhysMPDmg - Armor
  if (UseBuffArmor == 1)
    TempPhysMPDmg := TempPhysMPDmg - BuffArmor
  if (UseDefenseFactor == 1)
    TempPhysMPDmg := Floor(TempPhysMPDmg * (DefenseFactorPercent * 0.01))
}

if (TempPhysMPDmg < 1)
  TempPhysMPDmg := 1

if (ReverseDamage == 1)
  TempPhysMPDmg := TempPhysMPDmg * -1

if (CurMP - TempPhysMPDmg < 0)
  CurMP := 0
else if (CurMP - TempPhysMPDmg > MaxMP)
  CurMP := MaxMP
else
  CurMP := CurMP - TempPhysMPDmg

GuiControl, , CurMP, %CurMP%
GuiControl, , EffectiveDmg, %TempPhysMPDmg%
return

;==============================================================================
; Magical MP damage routine
;==============================================================================
MagMPDmg:
Gui, Submit, NoHide
TempMagicArmor := MagicArmor
TempMagMPDmg := Effect
if (DamageType == "Normal")
{
  TempMagMPDmg := TempMagMPDmg - MagicArmor
  if (UseBuffMagicArmor == 1)
    TempMagMPDmg := TempMagMPDmg - BuffMagicArmor
  if (UseDefenseFactor == 1)
    TempMagMPDmg := Floor(TempMagMPDmg * (DefenseFactorPercent * 0.01))
}

if (TempMagMPDmg < 1)
  TempMagMPDmg := 1

if (ReverseDamage == 1)
  TempMagMPDmg := TempMagMPDmg * -1

if (CurMP - TempMagMPDmg < 0)
  CurMP := 0
else if (CurMP - TempMagMPDmg > MaxMP)
  CurMP := MaxMP
else
  CurMP := CurMP - TempMagMPDmg

GuiControl, , CurMP, %CurMP%
GuiControl, , EffectiveDmg, %TempMagMPDmg%
return

;==============================================================================
; HP healing routine
;==============================================================================
HPHeal:
Gui, Submit, NoHide
TempHeal := Effect
if (ReverseDamage == 1)
  TempHeal := TempHeal * -1

if (CurHP + TempHeal > MaxHP)
  CurHP := MaxHP
else if (CurHP + TempHeal < 0)
  CurHP := 0
else
  CurHP := CurHP + TempHeal

GuiControl, , CurHP, %CurHP%
GuiControl, , EffectiveDmg, %TempHeal%
return

;==============================================================================
; MP healing routine
;==============================================================================
MPHeal:
Gui, Submit, NoHide
TempMPHeal := Effect
if (ReverseDamage == 1)
  TempMPHeal := TempMPHeal * -1

if (CurMP + TempMPHeal > MaxMP)
  CurMP := MaxMP
else if (CurMP + TempMPHeal < 0)
  CurMP := 0
else
  CurMP := CurMP + TempMPHeal

GuiControl, , CurMP, %CurMP%
GuiControl, , EffectiveDmg, %TempMPHeal%
return

;==============================================================================
; Limit increase routine
;==============================================================================
IncLimit:
Gui, Submit, NoHide
TempLimitUp := Effect
if (CurLimit + TempLimitUp > MaxLimit)
  CurLimit := MaxLimit
else
  CurLimit := CurLimit + TempLimitUp

GuiControl, , CurLimit, %CurLimit%
GuiControl, , EffectiveDmg, %TempLimitUp%
return

;==============================================================================
; Limit decrease routine
;==============================================================================
DecLimit:
Gui, Submit, NoHide
TempLimitDown := Effect
if (CurLimit - TempLimitDown < 0)
  CurLimit := 0
else
  CurLimit := CurLimit - TempLimitDown

GuiControl, , CurLimit, %CurLimit%
GuiControl, , EffectiveDmg, %TempLimitDown%
return

;==============================================================================
; Use MP Skill routine (not just for spells anymore!)
;==============================================================================
UseMPSkill:
Gui, Submit, NoHide

TempSkillMP := Effect
TempSkillWarn := ""

if (CurMP < TempSkillMP)
  TempSkillWarn := "Not enough MP!"
else
{
  CurMP := CurMP - TempSkillMP
  TempSkillWarn := "Skill attempted!"
}

GuiControl, , CurMP, %CurMP%
GuiControl, , CurStatus, %TempSkillWarn%
return

;==============================================================================
; Regen routine
;==============================================================================
HealRegen:
Gui, Submit, NoHide
TempHeal := BuffRegen
if (ReverseDamage == 1)
  TempHeal := TempHeal * -1

if (CurHP + TempHeal > MaxHP)
  CurHP := MaxHP
else if (CurHP + TempHeal < 0)
  CurHP := 0
else
  CurHP := CurHP + TempHeal

GuiControl, , CurHP, %CurHP%
GuiControl, , EffectiveDmg, %TempHeal%
return

;==============================================================================
; Refresh routine
;==============================================================================
HealRefresh:
Gui, Submit, NoHide
TempMPHeal := BuffRefresh
if (ReverseDamage == 1)
  TempMPHeal := TempMPHeal * -1

if (CurMP + TempMPHeal > MaxMP)
  CurMP := MaxMP
else if (CurMP + TempMPHeal < 0)
  CurMP := 0
else
  CurMP := CurMP + TempMPHeal

GuiControl, , CurMP, %CurMP%
GuiControl, , EffectiveDmg, %TempMPHeal%
return

;==============================================================================
; Display status routine
;==============================================================================
DispStatus:
Gui, Submit, NoHide
FinalOutput := ""

TempCritHP := Floor(MaxHP * 0.25)

; Row output
if (RowPosition == "Front")
  RowOut = [F]%A_Space%
else
  RowOut = [B]%A_Space%

; HP output
if ((UseBuffTempHP != 0) && (BuffTempHP > 0))
{
  TempHP = [%BuffTempHP%]
  
  if (CurHP <= TempCritHP )
    HPOut = HP: ! %TempHP% %CurHP%/%MaxHP% !
  else
    HPOut = HP: %TempHP% %CurHP%/%MaxHP%
}

else
{
  if (CurHP <= TempCritHP )
    HPOut = HP: ! %CurHP%/%MaxHP% !
  else
    HPOut = HP: %CurHP%/%MaxHP%
}

; MP output
MPOut = MP: %CurMP%/%MaxMP%

; Limit output
LimitOut = Limit: %CurLimit%/%MaxLimit%

; SoS output
SoSOut = SoS: %TempCritHP%

; Status output
StatusOut := ""

if (StatusCount1 == -1)
  StatusCount1 = U
if (StatusCount2 == -1)
  StatusCount2 = U
if (StatusCount3 == -1)
  StatusCount3 = U
if (StatusCount4 == -1)
  StatusCount4 = U
if (StatusCount5 == -1)
  StatusCount5 = U
if (StatusCount6 == -1)
  StatusCount6 = U
if (StatusCount7 == -1)
  StatusCount7 = U
if (StatusCount8 == -1)
  StatusCount8 = U
if (StatusCount9 == -1)
  StatusCount9 = U
if (StatusCount10 == -1)
  StatusCount10 = U
if (StatusCount11 == -1)
  StatusCount11 = U
if (StatusCount12 == -1)
  StatusCount12 = U

if ((UseStat1 == 0) && (UseStat2 == 0) && (UseStat3 == 0) && (UseStat4 == 0) && (UseStat5 == 0) && (UseStat6 == 0) && (UseStat7 == 0) && (UseStat8 == 0) && (UseStat9 == 0) && (UseStat10 == 0) && (UseStat11 == 0) && (UseStat12 == 0))
{
  ;StringTrimRight, StatusOut, StatusOut, 3
  SONull = Normal
  StatusOut := StatusOut . SONull
}

if (UseStat1 == 1)
{
  SO1 = %A_Space%%Status1% (%StatusCount1%),
  StatusOut := StatusOut . SO1
}

if (UseStat2 == 1)
{
  SO2 = %A_Space%%Status2% (%StatusCount2%),
  StatusOut := StatusOut . SO2
}

if (UseStat3 == 1)
{
  SO3 = %A_Space%%Status3% (%StatusCount3%),
  StatusOut := StatusOut . SO3
}

if (UseStat4 == 1)
{
  SO4 = %A_Space%%Status4% (%StatusCount4%),
  StatusOut := StatusOut . SO4
}

if (UseStat5 == 1)
{
  SO5 = %A_Space%%Status5% (%StatusCount5%),
  StatusOut := StatusOut . SO5
}

if (UseStat6 == 1)
{
  SO6 = %A_Space%%Status6% (%StatusCount6%),
  StatusOut := StatusOut . SO6
}

if (UseStat7 == 1)
{
  SO7 = %A_Space%%Status7% (%StatusCount7%),
  StatusOut := StatusOut . SO7
}

if (UseStat8 == 1)
{
  SO8 = %A_Space%%Status8% (%StatusCount8%),
  StatusOut := StatusOut . SO8
}

if (UseStat9 == 1)
{
  SO9 = %A_Space%%Status9% (%StatusCount9%),
  StatusOut := StatusOut . SO9
}

if (UseStat10 == 1)
{
  SO10 = %A_Space%%Status10% (%StatusCount10%),
  StatusOut := StatusOut . SO10
}

if (UseStat11 == 1)
{
  SO11 = %A_Space%%Status11% (%StatusCount11%),
  StatusOut := StatusOut . SO11
}

if (UseStat12 == 1)
{
  SO12 = %A_Space%%Status12% (%StatusCount12%),
  StatusOut := StatusOut . SO12
}

if ((UseStat1 == 1) || (UseStat2 == 1) || (UseStat3 == 1) || (UseStat4 == 1) || (UseStat5 == 1) || (UseStat6 == 1) || (UseStat7 == 1) || (UseStat8 == 1) || (UseStat9 == 1) || (UseStat10 == 1) || (UseStat11 == 1) || (UseStat12 == 1))
{
  StringTrimLeft, StatusOut, StatusOut, 1
  StringTrimRight, StatusOut, StatusOut, 1
}

; Final output
if (MaxLimit > 0)
  FinalOutput = (( %RowOut%%HPOut% | %MPOut% | %LimitOut% | %SoSOut% | %StatusOut% ))
else
  FinalOutput = (( %RowOut%%HPOut% | %MPOut% | %SoSOut% | %StatusOut% ))


clipboard = %FinalOutput%

GuiControl, , CurStatus, %FinalOutput%
return

;==============================================================================
; Poison damage routine
;==============================================================================
PoisonDmg:
Gui, Submit, NoHide
if (CurHP > 1 and CurHP < 5)
  TempPosionDamage := 1
else
  TempPoisonDamage := Floor(CurHP * 0.2)

if (CurHP - TempPoisonDamage < 0)
  CurHP := 0
else
  CurHP := CurHP - TempPoisonDamage

GuiControl, , CurHP, %CurHP%
GuiControl, , EffectiveDmg, %TempPoisonDamage%
return

;==============================================================================
; Gravity effect routine
;==============================================================================
GravityEffect:
Gui, Submit, NoHide

TempGravityLevel := 0.01 * GravityPercent

if (UseMPGrav == 0)
{
  if (MaxBased == 0)
  {
    if(GravityHealing == 0)
    {
      TempGravityDamage := Floor(TempGravityLevel * CurHP)
      CurHP := CurHP - TempGravityDamage
    }

    ; HP Gravity, Current based, healing
    else
    {
      TempGravityDamage := Floor(TempGravityLevel * CurHP)
      CurHP := CurHP + TempGravityDamage
    }
  }

  else
  {
    ; HP Gravity, Maximum based, damage
    if(GravityHealing == 0)
    {
      TempGravityDamage := Floor(TempGravityLevel * MaxHP)
      if (CurHP - TempGravityDamage < 0)
        CurHP := 0
      else
        CurHP := CurHP - TempGravityDamage
    }

    ; HP Gravity, Maximum based, healing
    else
    {
      TempGravityDamage := Floor(TempGravityLevel * MaxHP)
      if (CurHP + TempGravityDamage > MaxHP)
        CurHP := MaxHP
      else
        CurHP := CurHP + TempGravityDamage
    }
  }
}

else
{
  if (MaxBased == 0)
  {
    if(GravityHealing == 0)
    {
      TempGravityDamage := Floor(TempGravityLevel * CurMP)
      CurMP := CurMP - TempGravityDamage
    }

    ; MP Gravity, Current based, healing
    else
    {
      TempGravityDamage := Floor(TempGravityLevel * CurMP)
      CurMP := CurMP + TempGravityDamage
    }
  }

  else
  {
    ; MP Gravity, Maximum based, damage
    if(GravityHealing == 0)
    {
      TempGravityDamage := Floor(TempGravityLevel * MaxMP)
      if (CurMP - TempGravityDamage < 0)
        CurMP := 0
      else
        CurMP := CurMP - TempGravityDamage
    }

    ; MP Gravity, Maximum based, healing
    else
    {
      TempGravityDamage := Floor(TempGravityLevel * MaxMP)
      if (CurMP + TempGravityDamage > MaxMP)
        CurMP := MaxMP
      else
        CurMP := CurMP + TempGravityDamage
    }
  }
}

GuiControl, , CurHP, %CurHP%
GuiControl, , CurMP, %CurMP%
GuiControl, , EffectiveDmg, %TempGravityDamage%
return

;==============================================================================
; Bubble effect routine
;==============================================================================
BubbleEffect:
Gui, Submit, NoHide
if (UseBubbleEffect == 1)
{
  CurHP := CurHP * 2
  MaxHP := MaxHP * 2
  GuiControl, , CurHP, %CurHP%
  GuiControl, , MaxHP, %MaxHP%
}

else
{
  CurHP := Floor(CurHP / 2)
  MaxHP := Floor(MaxHP / 2)
  GuiControl, , CurHP, %CurHP%
  GuiControl, , MaxHP, %MaxHP%
}
return
;-

;+ Tab 2 routines
;+ Status decrementing
;==============================================================================
; Status decrementing routines.
;==============================================================================
DecStatus1:
Gui, Submit, NoHide
if ((Status1 != "") && (StatusCount1 > 0))
{
  StatusCount1 := StatusCount1 - 1
  GuiControl, , StatusCount1, %StatusCount1%
}
return

DecStatus2:
Gui, Submit, NoHide
if ((Status2 != "") && (StatusCount2 > 0))
{
  StatusCount2 := StatusCount2 - 1
  GuiControl, , StatusCount2, %StatusCount2%
}
return

DecStatus3:
Gui, Submit, NoHide
if ((Status3 != "") && (StatusCount3 > 0))
{
  StatusCount3 := StatusCount3 - 1
  GuiControl, , StatusCount3, %StatusCount3%
}
return

DecStatus4:
Gui, Submit, NoHide
if ((Status4 != "") && (StatusCount4 > 0))
{
  StatusCount4 := StatusCount4 - 1
  GuiControl, , StatusCount4, %StatusCount4%
}
return

DecStatus5:
Gui, Submit, NoHide
if ((Status5 != "") && (StatusCount5 > 0))
{
  StatusCount5 := StatusCount5 - 1
  GuiControl, , StatusCount5, %StatusCount5%
}
return

DecStatus6:
Gui, Submit, NoHide
if ((Status6 != "") && (StatusCount6 > 0))
{
  StatusCount6 := StatusCount6 - 1
  GuiControl, , StatusCount6, %StatusCount6%
}
return

DecStatus7:
Gui, Submit, NoHide
if ((Status7 != "") && (StatusCount7 > 0))
{
  StatusCount7 := StatusCount7 - 1
  GuiControl, , StatusCount7, %StatusCount7%
}
return

DecStatus8:
Gui, Submit, NoHide
if ((Status8 != "") && (StatusCount8 > 0))
{
  StatusCount8 := StatusCount8 - 1
  GuiControl, , StatusCount8, %StatusCount8%
}
return

DecStatus9:
Gui, Submit, NoHide
if ((Status9 != "") && (StatusCount9 > 0))
{
  StatusCount9 := StatusCount9 - 1
  GuiControl, , StatusCount9, %StatusCount9%
}
return

DecStatus10:
Gui, Submit, NoHide
if ((Status10 != "") && (StatusCount10 > 0))
{
  StatusCount10 := StatusCount10 - 1
  GuiControl, , StatusCount10, %StatusCount10%
}
return

DecStatus11:
Gui, Submit, NoHide
if ((Status11 != "") && (StatusCount11 > 0))
{
  StatusCount11 := StatusCount11 - 1
  GuiControl, , StatusCount11, %StatusCount11%
}
return

DecStatus12:
Gui, Submit, NoHide
if ((Status12 != "") && (StatusCount12 > 0))
{
  StatusCount12 := StatusCount12 - 1
  GuiControl, , StatusCount12, %StatusCount12%
}
return
;-

;+ Status incrementing
;==============================================================================
; Status incrementing routines.
;==============================================================================
IncStatus1:
Gui, Submit, NoHide
if ((Status1 != "") && (StatusCount1 >= 0))
{
  StatusCount1 := StatusCount1 + 1
  GuiControl, , StatusCount1, %StatusCount1%
}
return

IncStatus2:
Gui, Submit, NoHide
if ((Status2 != "") && (StatusCount2 >= 0))
{
  StatusCount2 := StatusCount2 + 1
  GuiControl, , StatusCount2, %StatusCount2%
}
return

IncStatus3:
Gui, Submit, NoHide
if ((Status3 != "") && (StatusCount3 >= 0))
{
  StatusCount3 := StatusCount3 + 1
  GuiControl, , StatusCount3, %StatusCount3%
}
return

IncStatus4:
Gui, Submit, NoHide
if ((Status4 != "") && (StatusCount4 >= 0))
{
  StatusCount4 := StatusCount4 + 1
  GuiControl, , StatusCount4, %StatusCount4%
}
return

IncStatus5:
Gui, Submit, NoHide
if ((Status5 != "") && (StatusCount5 >= 0))
{
  StatusCount5 := StatusCount5 + 1
  GuiControl, , StatusCount5, %StatusCount5%
}
return

IncStatus6:
Gui, Submit, NoHide
if ((Status6 != "") && (StatusCount6 >= 0))
{
  StatusCount6 := StatusCount6 + 1
  GuiControl, , StatusCount6, %StatusCount6%
}
return

IncStatus7:
Gui, Submit, NoHide
if ((Status7 != "") && (StatusCount7 >= 0))
{
  StatusCount7 := StatusCount7 + 1
  GuiControl, , StatusCount7, %StatusCount7%
}
return

IncStatus8:
Gui, Submit, NoHide
if ((Status8 != "") && (StatusCount8 >= 0))
{
  StatusCount8 := StatusCount8 + 1
  GuiControl, , StatusCount8, %StatusCount8%
}
return

IncStatus9:
Gui, Submit, NoHide
if ((Status9 != "") && (StatusCount9 >= 0))
{
  StatusCount9 := StatusCount9 + 1
  GuiControl, , StatusCount9, %StatusCount9%
}
return

IncStatus10:
Gui, Submit, NoHide
if ((Status10 != "") && (StatusCount10 >= 0))
{
  StatusCount10 := StatusCount10 + 1
  GuiControl, , StatusCount10, %StatusCount10%
}
return

IncStatus11:
Gui, Submit, NoHide
if ((Status11 != "") && (StatusCount11 >= 0))
{
  StatusCount11 := StatusCount11 + 1
  GuiControl, , StatusCount11, %StatusCount11%
}
return

IncStatus12:
Gui, Submit, NoHide
if ((Status12 != "") && (StatusCount12 >= 0))
{
  StatusCount12 := StatusCount12 + 1
  GuiControl, , StatusCount12, %StatusCount12%
}
return
;-

;+ Status clearing
;==============================================================================
; Status clearing routines.
;==============================================================================
ClearStatus1:
Gui, Submit, NoHide
Status1 := ""
StatusCount1 := 0
GuiControl, , UseStat1, 0
GuiControl, , Status1, %Status1%
GuiControl, , StatusCount1, %StatusCount1%
return

ClearStatus2:
Gui, Submit, NoHide
Status2 := ""
StatusCount2 := 0
GuiControl, , UseStat2, 0
GuiControl, , Status2, %Status2%
GuiControl, , StatusCount2, %StatusCount2%
return

ClearStatus3:
Gui, Submit, NoHide
Status3 := ""
StatusCount3 := 0
GuiControl, , UseStat3, 0
GuiControl, , Status3, %Status3%
GuiControl, , StatusCount3, %StatusCount3%
return

ClearStatus4:
Gui, Submit, NoHide
Status4 := ""
StatusCount4 := 0
GuiControl, , UseStat4, 0
GuiControl, , Status4, %Status4%
GuiControl, , StatusCount4, %StatusCount4%
return

ClearStatus5:
Gui, Submit, NoHide
Status5 := ""
StatusCount5 := 0
GuiControl, , UseStat5, 0
GuiControl, , Status5, %Status5%
GuiControl, , StatusCount5, %StatusCount5%
return

ClearStatus6:
Gui, Submit, NoHide
Status6 := ""
StatusCount6 := 0
GuiControl, , UseStat6, 0
GuiControl, , Status6, %Status6%
GuiControl, , StatusCount6, %StatusCount6%
return

ClearStatus7:
Gui, Submit, NoHide
Status7 := ""
StatusCount7 := 0
GuiControl, , UseStat7, 0
GuiControl, , Status7, %Status7%
GuiControl, , StatusCount7, %StatusCount7%
return

ClearStatus8:
Gui, Submit, NoHide
Status8 := ""
StatusCount8 := 0
GuiControl, , UseStat8, 0
GuiControl, , Status8, %Status8%
GuiControl, , StatusCount8, %StatusCount8%
return

ClearStatus9:
Gui, Submit, NoHide
Status9 := ""
StatusCount9 := 0
GuiControl, , UseStat9, 0
GuiControl, , Status9, %Status9%
GuiControl, , StatusCount9, %StatusCount9%
return

ClearStatus10:
Gui, Submit, NoHide
Status10 := ""
StatusCount10 := 0
GuiControl, , UseStat10, 0
GuiControl, , Status10, %Status10%
GuiControl, , StatusCount10, %StatusCount10%
return

ClearStatus11:
Gui, Submit, NoHide
Status11 := ""
StatusCount11 := 0
GuiControl, , UseStat11, 0
GuiControl, , Status11, %Status11%
GuiControl, , StatusCount11, %StatusCount11%
return

ClearStatus12:
Gui, Submit, NoHide
Status12 := ""
StatusCount12 := 0
GuiControl, , UseStat12, 0
GuiControl, , Status12, %Status12%
GuiControl, , StatusCount12, %StatusCount12%
return
;-

;+ All-status routines
;==============================================================================
; Routines for all statuses.
;==============================================================================
DecUsed:
Gui, Submit, NoHide
if (UseStat1 == 1)
  GoSub DecStatus1
if (UseStat2 == 1)
  GoSub DecStatus2
if (UseStat3 == 1)
  GoSub DecStatus3
if (UseStat4 == 1)
  GoSub DecStatus4
if (UseStat5 == 1)
  GoSub DecStatus5
if (UseStat6 == 1)
  GoSub DecStatus6
if (UseStat7 == 1)
  GoSub DecStatus7
if (UseStat8 == 1)
  GoSub DecStatus8
if (UseStat9 == 1)
  GoSub DecStatus9
if (UseStat10 == 1)
  GoSub DecStatus10
if (UseStat11 == 1)
  GoSub DecStatus11
if (UseStat12 == 1)
  GoSub DecStatus12
return

DecAll:
Gui, Submit, NoHide
GoSub DecStatus1
GoSub DecStatus2
GoSub DecStatus3
GoSub DecStatus4
GoSub DecStatus5
GoSub DecStatus6
GoSub DecStatus7
GoSub DecStatus8
GoSub DecStatus9
GoSub DecStatus10
GoSub DecStatus11
GoSub DecStatus12
return

IncUsed:
Gui, Submit, NoHide
if (UseStat1 == 1)
  GoSub IncStatus1
if (UseStat2 == 1)
  GoSub IncStatus2
if (UseStat3 == 1)
  GoSub IncStatus3
if (UseStat4 == 1)
  GoSub IncStatus4
if (UseStat5 == 1)
  GoSub IncStatus5
if (UseStat6 == 1)
  GoSub IncStatus6
if (UseStat7 == 1)
  GoSub IncStatus7
if (UseStat8 == 1)
  GoSub IncStatus8
if (UseStat9 == 1)
  GoSub IncStatus9
if (UseStat10 == 1)
  GoSub IncStatus10
if (UseStat11 == 1)
  GoSub IncStatus11
if (UseStat12 == 1)
  GoSub IncStatus12
return

IncAll:
Gui, Submit, NoHide
GoSub IncStatus1
GoSub IncStatus2
GoSub IncStatus3
GoSub IncStatus4
GoSub IncStatus5
GoSub IncStatus6
GoSub IncStatus7
GoSub IncStatus8
GoSub IncStatus9
GoSub IncStatus10
GoSub IncStatus11
GoSub IncStatus12
return

ClearUsed:
Gui, Submit, NoHide
if (UseStat1 == 1)
  GoSub ClearStatus1
if (UseStat2 == 1)
  GoSub ClearStatus2
if (UseStat3 == 1)
  GoSub ClearStatus3
if (UseStat4 == 1)
  GoSub ClearStatus4
if (UseStat5 == 1)
  GoSub ClearStatus5
if (UseStat6 == 1)
  GoSub ClearStatus6
if (UseStat7 == 1)
  GoSub ClearStatus7
if (UseStat8 == 1)
  GoSub ClearStatus8
if (UseStat9 == 1)
  GoSub ClearStatus9
if (UseStat10 == 1)
  GoSub ClearStatus10
if (UseStat11 == 1)
  GoSub ClearStatus11
if (UseStat12 == 1)
  GoSub ClearStatus12
return

ClearAll:
Gui, Submit, NoHide
GoSub ClearStatus1
GoSub ClearStatus2
GoSub ClearStatus3
GoSub ClearStatus4
GoSub ClearStatus5
GoSub ClearStatus6
GoSub ClearStatus7
GoSub ClearStatus8
GoSub ClearStatus9
GoSub ClearStatus10
GoSub ClearStatus11
GoSub ClearStatus12
return
;-
;-

;==============================================================================
; Exit the script when the GUI is closed.
;==============================================================================
GuiClose:
ExitApp
