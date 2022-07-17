Scriptname DA_MCM extends MCM_ConfigBase

import DA_Utils
import Debug

String Property sCurrentThuumPoints Auto

Int Property CurrentThuumPoints
    Int Function Get()
        Int maxPoints = DA_ThuumMaximumPoints.GetValueInt()
        Int shoutsPerPoint = DA_ShoutsPerPoint.GetValueInt()
        Int shoutsCount = Game.QueryStat("Times Shouted")	
        If shoutsPerPoint > 0
            Return Min((shoutsCount / shoutsPerPoint) as Int, maxPoints)
        Else
            Return 0
        EndIf
    EndFunction
EndProperty

GlobalVariable Property DA_AncestorsEchoShoutIncreasePerSoul Auto
GlobalVariable Property DA_AncientVigorAttributePerSoul Auto
GlobalVariable Property DA_SoulsCapacity Auto

GlobalVariable Property DA_EnableSoulsFusion Auto

GlobalVariable Property DA_EnableStaggeringThuum Auto
GlobalVariable Property DA_SoulInfusionBehavior Auto
GlobalVariable Property DA_InfusionChance1stWord Auto
GlobalVariable Property DA_InfusionChance2ndWord Auto
GlobalVariable Property DA_InfusionChance3rdWord Auto

GlobalVariable Property DA_ShoutsPerPoint Auto
GlobalVariable Property DA_ThuumFluencyReductionPerPoint Auto
GlobalVariable Property DA_ThuumMaximumPoints Auto

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

FormList Property Perks  Auto  
{All Perks that should be added to the player}

Perk Property DA_AncestorsEchoPerk Auto
{Perk that mods shouts magnitude and duration. It is used to adjust values dependning on DA_SoulsCapacity.}

Spell Property DA_AncestorsEchoAbility Auto

Spell Property DA_AncientVigorAbility Auto

Perk Property DA_AncientVigorPerk Auto
{Perk that boosts player attributes. It is used to adjust values dependning on DA_SoulsCapacity.}

Spell Property DA_ThuumFluencyAbility Auto

Perk Property DA_ThuumFluencyPerk Auto

Bool hasChanges = False

Event OnConfigInit()
    parent.OnConfigInit()
    Setup()
EndEvent

Event OnSettingChange(string a_ID)
    parent.OnSettingChange(a_ID)
    hasChanges = true
EndEvent

Event OnConfigOpen()
    parent.OnConfigOpen()
    sCurrentThuumPoints = CurrentThuumPoints
    ForcePageReset()
EndEvent

Event OnConfigClose()
    parent.OnConfigClose()
    If !hasChanges
        Return
    EndIf
    
    Reload()
EndEvent

Event OnGameReload()
    parent.OnGameReload()
    Reload()
EndEvent

Function Setup()
    Int index = Perks.GetSize()
    While index
    index -= 1
    Perk perkToApply = Perks.GetAt(index) as Perk
    If !PlayerRef.HasPerk(perkToApply)
        PlayerRef.AddPerk(perkToApply)
    EndIf 	
    EndWhile
EndFunction

Function Reload()
    UpdateSettings()
    UpdatePerks()
EndFunction

Function UpdateSettings()
    DA_AncestorsEchoShoutIncreasePerSoul.SetValueInt(GetModSettingInt("iShoutsPerSoul:General"))
    DA_AncientVigorAttributePerSoul.SetValueInt(GetModSettingInt("iAttributesPerSoul:General"))
    DA_SoulsCapacity.SetValueInt(GetModSettingInt("iSoulsCapacity:General"))
    
    DA_EnableSoulsFusion.SetValue(GetModSettingBool("bSoulsFusion:General") as Int)
    
    DA_EnableStaggeringThuum.SetValue(GetModSettingBool("bStaggeringThuum:Overflow") as Int)
    DA_SoulInfusionBehavior.SetValueInt(GetModSettingInt("iSoulInfusion:Overflow"))
    DA_InfusionChance1stWord.SetValueInt(GetModSettingInt("iSoulInfusionChance1stWord:Overflow"))
    DA_InfusionChance2ndWord.SetValueInt(GetModSettingInt("iSoulInfusionChance2ndWord:Overflow"))
    DA_InfusionChance3rdWord.SetValueInt(GetModSettingInt("iSoulInfusionChance3rdWord:Overflow"))
    
    DA_ThuumFluencyReductionPerPoint.SetValueInt(GetModSettingInt("iCooldownReduction:Thuum Fluency"))
    DA_ShoutsPerPoint.SetValueInt(GetModSettingInt("iShoutsPerThuumPoint:Thuum Fluency"))
    
    DA_ThuumMaximumPoints.SetValueInt(GetModSettingInt("iMaximumThuumPoints:Thuum Fluency"))
EndFunction

Function UpdatePerks()
    UpdateAncientVigor()
    UpdateAnecstorsEcho()
    UpdateThuumFluency()
EndFunction

Function UpdateAnecstorsEcho()
    {Updates magnitudes and perk entry points corresponding to number of contained Dragon Souls.}
    Int effectivePoints = DA_AncestorsEchoShoutIncreasePerSoul.GetValueInt()
    Int soulsCapacity = DA_SoulsCapacity.GetValueInt()
    
    Float modShout = 0.01 * effectivePoints
    Float modShoutFused = 0.02 * effectivePoints
    Float maximumModShout = 1 + 0.01 * soulsCapacity * effectivePoints
    Float maximumModShoutFused = 1 + 0.02 * soulsCapacity * effectivePoints
    Float modAbility = effectivePoints
    Float maximumModAbility = soulsCapacity * effectivePoints
    ; During Soul Fusion abilities are doubled by Soul Fusion Perk
 
    DA_AncestorsEchoPerk.SetNthEntryValue(0, 0, maximumModShoutFused)
    DA_AncestorsEchoPerk.SetNthEntryValue(1, 0, maximumModShout)
    DA_AncestorsEchoPerk.SetNthEntryValue(2, 1, modShoutFused)
    DA_AncestorsEchoPerk.SetNthEntryValue(3, 1, modShout)
    DA_AncestorsEchoPerk.SetNthEntryValue(4, 0, maximumModShoutFused)
    DA_AncestorsEchoPerk.SetNthEntryValue(5, 0, maximumModShout)
    DA_AncestorsEchoPerk.SetNthEntryValue(6, 1, modShoutFused)
    DA_AncestorsEchoPerk.SetNthEntryValue(7, 1, modShout)
    DA_AncestorsEchoPerk.SetNthEntryValue(8, 0, maximumModAbility)
    DA_AncestorsEchoPerk.SetNthEntryValue(9, 1, modAbility)
    
    Recast(PlayerRef, DA_AncestorsEchoAbility)
EndFunction

Function UpdateAncientVigor()
    {Updates magnitudes and perk entry points corresponding to number of contained Dragon Souls.}
    Int effectivePoints = DA_AncientVigorAttributePerSoul.GetValueInt()
    
    Float modAbility = effectivePoints
    Float maximumModAbility = DA_SoulsCapacity.GetValueInt() * effectivePoints
    ; During Soul Fusion abilities are doubled by Soul Fusion Perk
    
    DA_AncientVigorPerk.SetNthEntryValue(0, 1, modAbility)
    DA_AncientVigorPerk.SetNthEntryValue(1, 0, maximumModAbility)
    
    Recast(PlayerRef, DA_AncientVigorAbility)
EndFunction

Function UpdateThuumFluency()
    {Updates magnitudes and perk entry points corresponding to Thu'um Points.}
    Int effectivePoints = CurrentThuumPoints * DA_ThuumFluencyReductionPerPoint.GetValueInt()
    DA_ThuumFluencyPerk.SetNthEntryValue(0, 0, effectivePoints)
    Recast(PlayerRef, DA_ThuumFluencyAbility)
EndFunction