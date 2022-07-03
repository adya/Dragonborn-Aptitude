ScriptName DA_RecastEffect extends ActiveMagicEffect

Function Recast(Actor target, Spell[] abilities)
	Int index = abilities.Length
	Debug.Notification("Recasting " + index + "abilities")
	While index
		index -= 1
		Spell spellToApply = abilities[index]
		If target.HasSpell(spellToApply)
			target.RemoveSpell(spellToApply)
		EndIf 	
		target.AddSpell(spellToApply, False)
	EndWhile
EndFunction