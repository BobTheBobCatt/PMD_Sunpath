require 'origin.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.GeneralFunctions'
require 'pmd_sunpath.CharacterEssentials'

qahil_village_entrance_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
function qahil_village_entrance_ch_1.Story_Cutscene()
	GAME:CutsceneMode(true)
	local hero = CH('PLAYER')
	local marker = MRKR("AbandonedCrossroadsExitLocation")
	local marker2 = MRKR("Village_Guard_Marker")
	local guard = CH('Absol')
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Left)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue("...[pause=0]Man...seems like I have been walking for hours. Does this road ever end...?")
	
	GAME:FadeIn(120)
	GAME:WaitFrames(120)
	UI:ResetSpeaker()
	GROUND:MoveToPosition(hero, 203, 360, false, 1)
	UI:WaitShowDialogue("How much longer is this road, I wonder...?")
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	GROUND:CharSetEmote(hero, "question", 1)
	SOUND:PlayBattleSE("EVT_Emote_Confused")
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("W-what is that? A village? Was that sign right somehow?")
	UI:SetSpeakerEmotion('Surprised')
	UI:WaitShowDialogue("Someone's at what seems to be the entrance!")
	GAME:_MoveCamera(211, 115, 112, false)
	GAME:WaitFrames(120)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("I think they see me...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(guard)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("(A child? Out on their lonesome out here...?)")
	UI:WaitShowDialogue("(Bit concerning, but not too surprised unfortunately. If they're wild, I just hope they aren't violent...)")
	
	GAME:WaitFrames(20)
	GAME:_MoveCamera(211, 265, 112, false)
	GAME:WaitFrames(120)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("(They seem to be staring at me, they seem...a bit concerned maybe? It's a bit hard to tell from here...)")
	UI:WaitShowDialogue("(I hope I didn't just get myself into trouble...)")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 212, 80, false, 0.8)
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE('EVT_Emote_Sweating')
	GROUND:CharSetEmote(hero, "sweating", 1)
	UI:WaitShowDialogue("H-hey. So, what is this place exactly?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(guard)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("This place is called Qahil Village. Better question is; What are you doing out here alone? You seem a bit young to just be wandering around by yourself.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("O-oh. Um...well, I was hoping I could find somewhere to stay. I don't really have anywhere to go...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(guard)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("(Somewhere to stay? I don't think the others in the village are going to like this...)")
	UI:WaitShowDialogue("(This kid looks tired, though. It'd be wrong of me to just leave " .. GeneralFunctions.GetPronoun(hero, "them", false) .. " out here by " .. GeneralFunctions.GetPronoun(hero, "themself", false) .. "...)")
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Hmm...I'll have to see. Come with me, but stay close. This place is...rather weary of wanderers, so I'll need to ask about it.")
	UI:WaitShowDialogue("Oh, watch yourself around here.")
	GROUND:CharAnimateTurnTo(guard, Direction.Up, 4)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(guard, 212, -40, false, 0.5)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker('', false, hero.CurrentForm.Species, hero.CurrentForm.Form, hero.CurrentForm.Skin, hero.CurrentForm.Gender)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("(W-weary of wanderers..? Well, here's hoping that they aren't too mean to me...)")
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("(I've been through worse than just a few harsh words though, I'm sure I'll be fine.)")
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 212, -25, false, 1)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	SV.Chapter1.PlayerEnteredVillage = true
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("qahil_village", "Main_Entrance_Marker")	
	
end
