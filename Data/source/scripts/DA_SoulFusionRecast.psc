Scriptname DA_SoulFusionRecast extends ActiveMagicEffect  
{Tracks Soul Fusion perk to reapply Abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

import DA_Utils

Spell[] Property Spells Auto  
{Spells to be re-applied}

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

Event OnEffectStart(actor akTarget, actor akCaster)
	Debug.Trace("Soul Fusion Active")
	RecastAll(PlayerRef, Spells)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Debug.Trace("Soul Fusion Dispelled")
	RecastAll(PlayerRef, Spells)
EndEvent