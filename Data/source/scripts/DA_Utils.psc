ScriptName DA_Utils Hidden
{Misc functions}

Function RecastAll(Actor target, Spell[] abilities) Global
{Recasts all specified abilities on a given target}
	Int index = abilities.Length
	Debug.Trace("Recasting " + index + " abilities")
	While index
		index -= 1
		Spell ability = abilities[index]
		Recast(target, ability)
	EndWhile
EndFunction

Function Recast(Actor target, Spell ability) Global
{Recasts specified ability on a given target}
	If target.HasSpell(ability)
		target.RemoveSpell(ability)
	EndIf 	
	target.AddSpell(ability, False)
EndFunction

Int Function Min(Int a, Int b) Global
{Returns the smallest of two numbers}
	If a < b
		Return a
	Else
		Return b
	EndIf
EndFunction

Int Function Max(Int a, Int b) Global
{Returns the largest of two numbers}
	If a > b
		Return a
	Else
		Return b
	EndIf
EndFunction