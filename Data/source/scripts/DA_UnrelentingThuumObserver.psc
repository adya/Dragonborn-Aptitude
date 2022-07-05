Scriptname DA_UnrelentingThuumObserver extends activemagiceffect  
{Detects when Player uses Shout and casts a stagger spell}

Actor Property PlayerRef Auto  
{Player}

Spell Property StaggerSpell Auto
{ A Spell that will be applied when shouting }

Keyword Property ShoutKeyword Auto
{A keyword that indentifies eligible shouts}

Event OnSpellCast(Form akSpell)
	If !PlayerRef.IsInCombat()
		Return
	EndIf

	If akSpell.HasKeyword(ShoutKeyword)
		Debug.Notification("Unrelenting Thu'um staggers everyone!")
		StaggerSpell.Cast(PlayerRef)
	EndIf
EndEvent
