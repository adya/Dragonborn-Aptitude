Scriptname DA_SoulsObserver extends ActiveMagicEffect  
{Observes changes in dragon souls to reapply Abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

import DA_Utils

Spell[] Property Spells Auto  
{Spells to be re-applied}

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

GlobalVariable Property LastKnownSoulsCount Auto  
{Number of Dragon Souls for which magnitudes were calculated}

GlobalVariable Property DA_SoulsCapacity Auto
{Souls capacity before reaching overflowing state}

GlobalVariable Property DA_EnableSoulsFusion Auto

Spell Property DA_SoulFusionSpell Auto
{An ability to be applied on player when number of Dragon Souls changes}  

Event OnEffectStart(actor akTarget, actor akCaster)
	Int soulsCount = PlayerRef.GetActorValue("DragonSouls") as Int
	Bool gainedSoul = soulsCount > LastKnownSoulsCount.GetValue()
	
	; If Player gained new Soul and it Soul Fusion is enabled we cast it.
	; Abilities will be recasted automatically by Soul Fusion.
	; Otherwise we need to recast abilities manually.
	If gainedSoul && DA_EnableSoulsFusion.GetValue()
		DA_SoulFusionSpell.Cast(PlayerRef, PlayerRef)
	ElseIf soulsCount < DA_SoulsCapacity.GetValue()
		RecastAll(PlayerRef, Spells)
	EndIf
	
	; Save last checked number of souls and perk state.
	LastKnownSoulsCount.SetValue(soulsCount)	
EndEvent


