Scriptname DA_InfuseSouls extends ActiveMagicEffect  
{Script that implements Dragon Soul Infusion perk. Basically, it cast a second identical shout to imitate the double power}

Actor Property PlayerRef Auto  
{Player}

GlobalVariable Property DA_SoulInfusionBehavior Auto
{Behavior of the Soul Infusion. 0 - don't use Dragon Soul, 1 - use Dragon Soul only in combat, 2 - use Drargon Soul always}

GlobalVariable Property DA_InfusionChance1stWord Auto
{A chance that a Dragon Soul will be infused into your next shout that used one word}

GlobalVariable Property DA_InfusionChance2ndWord Auto
{A chance that a Dragon Soul will be infused into your next shout that used two words}

GlobalVariable Property DA_InfusionChance3rdWord Auto
{A chance that a Dragon Soul will be infused into your next shout that used three words}

Keyword Property MagicShout Auto
{A keyword that identifies eligible Shouts}

FormList Property DA_ExcludedSoulInfusionShouts Auto
{A list of Shouts that cannot trigger Soul Infusion}

Spell Property InfusionFX Auto
{A spell to be applied to the played to visually supplement infusion}

Event OnSpellCast(Form akSpell)
    Spell shoutSpell = akSpell as Spell
    ; If it's not a shout or it is excluded then we are not interested
    If !shoutSpell || !shoutSpell.HasKeyword(MagicShout) || DA_ExcludedSoulInfusionShouts.HasForm(shoutSpell)
        Return
    EndIf
    Int chance = InfusionChance(shoutSpell)
    If Utility.RandomInt(0, 99) < chance
        Debug.Trace("Infused Dragon Soul")
        Int behavior = DA_SoulInfusionBehavior.GetValueInt()
        If behavior == 2 || (behavior == 1 && PlayerRef.IsInCombat())
            PlayerRef.ModActorValue("DragonSouls", -1)
        EndIf
        ; Double shout's effect by casting a second copy of it.
        Spell akShout = akSpell as Spell
        akShout.Cast(PlayerRef)
        InfusionFX.Cast(PlayerRef, PlayerRef)
    EndIf
EndEvent

Int Function InfusionChance(Spell akSpell)
{Retrieves an infusion chance depending on a number of words used in a shout}
    
    Shout equippedShout = PlayerRef.GetEquippedShout()
    If akSpell == EquippedShout.GetNthSpell(0)
        Return DA_InfusionChance1stWord.GetValue() as Int
    ElseIf akSpell == EquippedShout.GetNthSpell(1)
        Return DA_InfusionChance2ndWord.GetValue() as Int
    ElseIf akSpell == EquippedShout.GetNthSpell(2)
        Return DA_InfusionChance3rdWord.GetValue() as Int
    EndIf
EndFunction
