ScriptName DA_RecastEffect extends ActiveMagicEffect
{Base effect that provides a function to re-cast any number of abilities on target}

Function Recast(Actor target, Spell[] abilities)
	Int index = abilities.Length
	Debug.Notification("Recasting " + index + " abilities")
	While index
		index -= 1
		Spell spellToApply = abilities[index]
		If target.HasSpell(spellToApply)
			target.RemoveSpell(spellToApply)
		EndIf 	
		target.AddSpell(spellToApply, False)
	EndWhile
EndFunction