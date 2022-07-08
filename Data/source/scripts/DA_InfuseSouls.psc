Scriptname DA_InfuseSouls extends ActiveMagicEffect  
{Script that implements Dragon Soul Infusion perk. Basically, it cast a second identical shout to imitate the double power}

Actor Property PlayerRef Auto  
{Player}

GlobalVariable Property DA_InfusionChance1stWord Auto
{A chance that a Dragon Soul will be infused into your next shout that used one word}

GlobalVariable Property DA_InfusionChance2ndWord Auto
{A chance that a Dragon Soul will be infused into your next shout that used two words}

GlobalVariable Property DA_InfusionChance3rdWord Auto
{A chance that a Dragon Soul will be infused into your next shout that used three words}

Keyword Property MagicShout Auto
{A keyword that identifies eligible shouts}

Spell Property InfusionFX Auto
{A spell to be applied to the played to visually supplement infusion}

Event OnSpellCast(Form akSpell)
	Spell shoutSpell = akSpell as Spell
	; If it's not a shout then we are not interested
	If !shoutSpell || !shoutSpell.HasKeyword(MagicShout) 
		Return
	EndIf
	Int chance = InfusionChance(shoutSpell)
	Debug.Notification("Infusion chance is " + chance + "%")
	If akSpell.HasKeyword(MagicShout) && Utility.RandomInt(0, 99) < chance
		Debug.Notification("Infused Dragon Soul")
		PlayerRef.ModActorValue("DragonSouls", -1)
		; Double shout's effect by casting a second copy of it.
		Spell akShout = akSpell as Spell
		akShout.Cast(PlayerRef)
		InfusionFX.Cast(PlayerRef, PlayerRef)
	EndIf
EndEvent

; Retrieves an infusion chance depending on a number of words used in a shout.
Int Function InfusionChance(Spell akSpell)
	Shout equippedShout = PlayerRef.GetEquippedShout()
	If akSpell == EquippedShout.GetNthSpell(0)
		Return DA_InfusionChance1stWord.GetValue() as Int
	ElseIf akSpell == EquippedShout.GetNthSpell(1)
		Return DA_InfusionChance2ndWord.GetValue() as Int
	ElseIf akSpell == EquippedShout.GetNthSpell(2)
		Return DA_InfusionChance3rdWord.GetValue() as Int
	EndIf
EndFunction
