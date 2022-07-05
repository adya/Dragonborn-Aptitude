Scriptname DA_InfuseSouls extends activemagiceffect  
{Script that implements Dragon Soul Infusion perk. Basically, it cast a second identical shout to imitate the double power}

Actor Property PlayerRef Auto  
{Player}

GlobalVariable Property InfusionChance Auto
{A chance that a Dragon Soul will be infused into your next shout}

FormList Property ApplicableShouts Auto
{A FormList containing shouts that can be infused. It should be all damaging shouts}

Spell Property InfusionFX Auto

Event OnSpellCast(Form akSpell)
	If !PlayerRef.IsInCombat()
		Return
	EndIf

	If ApplicableShouts.HasForm(akSpell) && Utility.RandomInt(0, 100) <= InfusionChance.GetValue()
		Debug.Notification("Infused Dragon Soul")
		PlayerRef.ModActorValue("DragonSouls", -1)
		Spell akShout = akSpell as Spell
		akShout.Cast(PlayerRef)
		InfusionFX.Cast(PlayerRef, PlayerRef)
	EndIf
EndEvent
