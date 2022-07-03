Scriptname DA_SoulsObserver extends DA_RecastEffect  
{Observes changes in dragon souls to reapply Abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

Spell[] Property Spells Auto  
{Spells to be re-applied}

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

GlobalVariable Property LastKnownSoulsCount Auto  
{Number of Dragon Souls for which magnitudes were calculated}

Spell Property SoulFusionAbility Auto
{An ability to be applied on player when number of Dragon Souls changes}  

Event OnEffectStart(actor akTarget, actor akCaster)
	Int soulsCount = PlayerRef.GetActorValue("DragonSouls") as Int
	
	Debug.Notification("You contain " + soulsCount  + " dragon souls")
	
	; If Player gained new Soul then we recast Soul Fusion.
	If soulsCount > LastKnownSoulsCount.GetValue()
		SoulFusionAbility.Cast(PlayerRef, PlayerRef)
		; Save last checked number of souls and perk state.
		LastKnownSoulsCount.SetValue(soulsCount)	
	ElseIf soulsCount != LastKnownSoulsCount.GetValue()
		Recast(PlayerRef, Spells)
	EndIf
EndEvent
