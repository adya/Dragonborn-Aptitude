ScriptName DA_InitQuest extends Quest  

Actor Property PlayerRef  Auto  
{Player who'll receive the perks}

FormList Property Perks  Auto  
{All Perks that should be added to the player}

Event OnInit()
	Int index = Perks.GetSize()
	While index
		index -= 1
		Perk perkToApply = Perks.GetAt(index) as Perk
		If !PlayerRef.HasPerk(perkToApply)
			PlayerRef.AddPerk(perkToApply)
		EndIf 	
	EndWhile
	Debug.Notification("Added " + Perks.GetSize() + " perks")
EndEvent