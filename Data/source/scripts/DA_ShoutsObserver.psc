Scriptname DA_ShoutsObserver extends DA_RecastEffect  
{Observes changes in dragon souls to reapply Abilities with correct magnitudes (they seem to be calculated only once upon being applied)}

Spell[] Property Spells Auto  
{Spells to be re-applied}

Actor Property PlayerRef Auto  
{Player who'll receive the spells}

GlobalVariable Property LastKnownShoutsCount Auto 
{Number of Shouts Player did. This is used to determine Thuum progress}

GlobalVariable Property ShoutsPerPoint Auto
{Number of Shouts required to get Thuum progress point}

GlobalVariable Property ThuumProgressPoints Auto
{Number of Thuum progress points that are used to buff Shouts}

Event OnEffectStart(actor akTarget, actor akCaster)
	Int currentPoints = ThuumProgressPoints.GetValue() as Int
	Int shoutsCount = Game.QueryStat("Times Shouted")	
	Debug.Notification("You shouted " + shoutsCount + "times")
	; Save last checked number of shouts and thuum progress points.
	LastKnownShoutsCount.SetValue(shoutsCount)
	Int newPoints = (shoutsCount / ShoutsPerPoint.GetValue()) as Int
	ThuumProgressPoints.SetValue(newPoints)
	
	; If Thuum didn't progress, then no need to update corresponding perks.
	If currentPoints == newPoints
		Return
	Endif
	
	Recast(PlayerRef, Spells)
EndEvent
