Scriptname DA_ShoutsObserver extends ActiveMagicEffect  
{Observes shouts to earn progress in Thu'um and to reapply related abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

import DA_Utils

Actor Property PlayerRef Auto  

GlobalVariable Property DA_EnableStaggeringThuum Auto

GlobalVariable Property DA_ShoutsPerPoint Auto
{Number of Shouts required to get Thu'um point}

GlobalVariable Property DA_ThuumMaximumPoints Auto
{Maximum number of Thu'um points that Player can have. Values above this will be capped}

GlobalVariable Property DA_ThuumFluencyReductionPerPoint Auto
{Shouts cooldown reduction per point of Thu'um. Default is 1}

Spell Property DA_ThuumFluencyAbility Auto  
{Ability that is sensitive to Thu'um Points}

Perk Property DA_ThuumFluencyPerk Auto
{Perk that player must have in order to enable "Thu'um Fluency"}

Perk Property DA_StaggeringThuumPerk Auto
{Perk that player must have in order to enable "Staggering Thu'um"}

Spell Property DA_StaggeringThuumStaggerSpell Auto
{A Spell that will be applied when shouting }

Keyword Property MagicShout Auto
{A keyword that identifies eligible shouts}

; Tracks last active points to determine whether it was changed
Int currentPoints

Event OnSpellCast(Form akSpell)
    Spell shoutSpell = akSpell as Spell
    ; If it's a not shout then we are not interested
    If !shoutSpell || !shoutSpell.HasKeyword(MagicShout) 
        Return
    EndIf
    
    If UpdateThuumPoints()
        UpdateThuumFluency()
    EndIf
    
    If PlayerRef.IsInCombat()
        ApplyStaggeringThuum()
    EndIf
EndEvent

; Caclulates points earned by the player.
; Returns true if currentPoints was actually updated with new value.
Bool Function UpdateThuumPoints()
    Int maxPoints = DA_ThuumMaximumPoints.GetValueInt()
    Int shoutsPerPoint = DA_ShoutsPerPoint.GetValueInt()

    ; If Thuum Fluency is disabled or we reached maximum allowed points then there is no need to do anything.
    If shoutsPerPoint <= 0 || currentPoints >= maxPoints
        Return False
    EndIf
    
    Int shoutsCount = Game.QueryStat("Times Shouted")	
    Int newPoints = Min((shoutsCount / shoutsPerPoint) as Int, maxPoints)
    Bool isChanged = newPoints != currentPoints
    currentPoints = newPoints
    Return isChanged
EndFunction

; Sets magnitude of "Thu'um Fluency" ability correspondingly to Thuum Points.
; This requires SKSE, but the only alternative is to setup dozens of entry points for every single thuum point...
Function UpdateThuumFluency()
    Int effectivePoints = currentPoints * DA_ThuumFluencyReductionPerPoint.GetValueInt()
    DA_ThuumFluencyPerk.SetNthEntryValue(0, 0, effectivePoints)
    Recast(PlayerRef, DA_ThuumFluencyAbility)
EndFunction

Function ApplyStaggeringThuum()
    If PlayerRef.HasPerk(DA_StaggeringThuumPerk) && DA_EnableStaggeringThuum.GetValue()
        DA_StaggeringThuumStaggerSpell.Cast(PlayerRef)
    EndIf
EndFunction
