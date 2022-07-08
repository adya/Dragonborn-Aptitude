ScriptName DA_RecastEffect extends ActiveMagicEffect
{Base effect that provides a function to re-cast any number of abilities on target and some misc functions}

Function RecastAll(Actor target, Spell[] abilities)
	Int index = abilities.Length
	Debug.Notification("Recasting " + index + " abilities")
	While index
		index -= 1
		Spell ability = abilities[index]
		Recast(target, ability)
	EndWhile
EndFunction

Function Recast(Actor target, Spell ability)
	If target.HasSpell(ability)
		target.RemoveSpell(ability)
	EndIf 	
	target.AddSpell(ability, False)
EndFunction

Int Function Min(Int a, Int b)
	If a < b
		Return a
	Else
		Return b
	EndIf
EndFunction

Int Function Max(Int a, Int b)
	If a > b
		Return a
	Else
		Return b
	EndIf
EndFunction