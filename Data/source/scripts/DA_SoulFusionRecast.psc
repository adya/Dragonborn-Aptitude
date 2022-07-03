Scriptname DA_SoulFusionRecast extends DA_RecastEffect  
{Tracks Soul Fusion perk to reapply Abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

Spell[] Property Spells Auto  
{Spells to be re-applied}

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

Event OnEffectStart(actor akTarget, actor akCaster)
	Debug.Notification("Soul Fusion Active")
	Recast(PlayerRef, Spells)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Debug.Notification("Soul Fusion Dispelled")
	Recast(PlayerRef, Spells)
EndEvent