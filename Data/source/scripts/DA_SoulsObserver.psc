Scriptname DA_SoulsObserver extends DA_RecastEffect  
{Observes changes in dragon souls to reapply Abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

Spell[] Property Spells Auto  
{Spells to be re-applied}

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

GlobalVariable Property LastKnownSoulsCount Auto  
{Number of Dragon Souls for which magnitudes were calculated}

GlobalVariable Property DA_SoulFusionMinimumSouls Auto
{Minimum number of Dragon Souls that Player must contain for Soul Fusion to happen}

GlobalVariable Property DA_SoulsCapacity Auto
{Souls capacity before reaching overflowing state}

Spell Property DA_SoulFusionSpell Auto
{An ability to be applied on player when number of Dragon Souls changes}  


Event OnEffectStart(actor akTarget, actor akCaster)
	Int soulsCount = PlayerRef.GetActorValue("DragonSouls") as Int
	Bool gainedSoul = soulsCount > LastKnownSoulsCount.GetValue()
	Int effectiveSoulsCount = Min(soulsCount, DA_SoulsCapacity.GetValue() as Int)
	
	; If Player gained new Soul then we recast Soul Fusion.
	If gainedSoul && soulsCount >= DA_SoulFusionMinimumSouls.GetValue()
		DA_SoulFusionSpell.Cast(PlayerRef, PlayerRef)
	ElseIf soulsCount != LastKnownSoulsCount.GetValue() && soulsCount < DA_SoulsCapacity.GetValue()
		RecastAll(PlayerRef, Spells)
	EndIf
	
	; Save last checked number of souls and perk state.
	LastKnownSoulsCount.SetValue(soulsCount)	
EndEvent


