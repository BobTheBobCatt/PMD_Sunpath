require 'pmd_sunpath.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.GeneralFunctions'
require 'pmd_sunpath.CharacterEssentials'
require 'pmd_sunpath.DialogueFunctions'
require 'pmd_sunpath.CharacterActions'

qahil_village_entrance_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
--Play this scene after the Dusty Dune partner scene
function qahil_village_entrance_ch_1.Story_Cutscene()
	GeneralFunctions.DefaultPartyCH1(true)
	GROUND:AddMapStatus("dusk") --Adds the Dusk map status to make it appear late.
	GAME:CutsceneMode(true)
	GROUND:Hide('Teammate1')
	local hero = CH('PLAYER')
	local marker = MRKR("AbandonedCrossroadsExitLocation")
	local guard = CH('Absol')
	local town = 'Qahil Village'
	UI:ResetSpeaker()
	SOUND:FadeOutBGM()
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Left)
	UI:SetSpeaker(hero, true)
	UI:SetSpeakerEmotion('Pain')
	UI:WaitShowDialogue("...[pause=0]Sheesh...seems like I have been walking for hours. Does this road ever end...?")
	
	GAME:FadeIn(120)
	GAME:WaitFrames(40)
	GROUND:MoveToPosition(hero, 230, 360, false, 1)
	UI:WaitShowDialogue("How much longer is this road, I wonder...?")
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 204, 340, false, 1)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	CharacterActions.EmoteAndPause(hero, "Question", true)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("W-what is that? A village? Was that sign right somehow?")
	UI:SetSpeakerEmotion('Surprised')
	CharacterActions.EmoteAndPause(hero, "Shock", true)
	UI:WaitShowDialogue("Someone's at what seems to be the entrance!")
	GAME:MoveCamera(212, 115, 112, false)
	GAME:WaitFrames(120)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("I think they see me...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(guard, false)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("(A child? Out on their lonesome out here...?)")
	UI:WaitShowDialogue("(Bit concerning, but not too surprised unfortunately. If they're wild, I just hope they don't cause too much trouble...)")
	if hero.element1 == "fire" or hero.element2 == "fire" then
		UI:WaitShowDialogue("(And to hope they don't burn the place down...)")
	else
		UI:WaitShowDialogue("(Then again, they are a child. What could they do, exactly?)")
	end
	
	GAME:WaitFrames(20)
	GAME:MoveCamera(212, 265, 112, false)
	GAME:WaitFrames(120)
	UI:SetSpeaker(hero, false)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("(They seem to be staring at me, but it's a bit hard to tell how they seem from here...)")
	GAME:WaitFrames(20)
	UI:WaitShowDialogue("(I hope I didn't just get myself into trouble...)")
	GAME:WaitFrames(20)
	CharacterActions.MoveCharAndCamera(hero, 204, 80, false, 0.8)
	GAME:WaitFrames(20)
	UI:SetSpeaker(hero, true)
	CharacterActions.EmoteAndPause(hero, "Sweating", true)
	UI:WaitShowDialogue("H-hey. So, what is this place exactly?")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(guard)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("This place is called [color=#FFC663]" .. town .. "[color]. The better question is; What are you doing out here alone? You seem a bit young to just be wandering around by yourself.")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(hero)
	UI:SetSpeakerEmotion('Worried')
	UI:WaitShowDialogue("O-oh. Um...well, I was hoping I could find somewhere to stay. I don't really have anywhere to go...")
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(guard, false)
	UI:SetSpeakerEmotion('Worried')
	CharacterActions.EmoteAndPause(guard, "Sweatdrop", true)
	UI:WaitShowDialogue("(Somewhere to stay? I don't think the others in the village are going to like this...)")
	UI:WaitShowDialogue("(This kid looks tired, though. It'd be wrong of me to just leave " .. DialogueFunctions.GetPronoun(hero, "them", false) .. " out here by " .. DialogueFunctions.GetPronoun(hero, "themself", false) .. "...)")
	UI:SetSpeaker(guard, true)
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("Hmm...I'll have to see. Come with me, but stay close. This place is...rather weary of wanderers, so I'll need to ask about it.")
	UI:WaitShowDialogue("Oh, watch yourself around here.")
	GROUND:CharAnimateTurnTo(guard, Direction.Up, 4)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(guard, 204, -40, false, 0.5)
	
	GAME:WaitFrames(20)
	UI:SetSpeaker(hero, false)
	UI:SetSpeakerEmotion('Worried')
	CharacterActions.EmoteAndPause(hero, "Sweatdrop", true)
	UI:WaitShowDialogue("(W-weary of wanderers..? Well, here's hoping that they aren't too mean to me...)")
	UI:SetSpeakerEmotion('Normal')
	UI:WaitShowDialogue("(I've been through worse than just a few harsh words though, I'm sure I'll be fine.)")
	GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
	GAME:WaitFrames(20)
	GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
	GAME:WaitFrames(20)
	GROUND:MoveToPosition(hero, 204, -25, false, 1)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	SV.Chapter1.PlayerEnteredVillage = true
	GeneralFunctions.SendInvToStorage() --clear inventory
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("qahil_village", "Main_Entrance_Marker")	
	
end
