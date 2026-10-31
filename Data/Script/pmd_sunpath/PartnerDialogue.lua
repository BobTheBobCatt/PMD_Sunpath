require 'pmd_sunpath.common'
require 'pmd_sunpath.config'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.CharacterEssentials'

--System for handling default dialogue situations.
--[[function PartnerDialogue.Chapter_1_Dialogue(partner)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion('Normal')
	
	if ground == 'players_tent' then 
		if SV.Chapter1.PlayerMetPartner and SV.TemporaryFlags.JustWokeUp then 
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Good morning,[pause=10] " .. hero:GetDisplayName() .. "!")
		end
	elseif ground == 'qahil_village' then 
		--if SV.Chapter1.PlayerMetPartner and SV.Chapter1.PlayedVillageTutorial then
		if SV.Chapter1.PlayedVillageTutorial then -- Testing purposes; Commented out for a reason
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("And that's that, pretty much. Everyone else tends to keep to themselves if you haven't figured that out already.")
			UI:WaitShowDialogue("I do have an idea, however...")
			GAME:WaitFrames(20)
			UI:SetSpeaker(hero)
			UI:WaitShowDialogue("And what is that?")
			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("There's this cave outside of town, I'm scared to explore it by myself.")
			UI:WaitShowDialogue("But with you here with me, I think I can do it!")
			GAME:WaitFrames(20)
			UI:SetSpeakerEmotion("Worried")
			UI:SetSpeaker(hero)
			UI:WaitShowDialogue("You're joking...")
			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("Nope! Come on, I know you can do it!")
			GAME:WaitFrames(20)
			UI:SetSpeakerEmotion("Worried")
			UI:SetSpeaker(hero)
			UI:WaitShowDialogue("I-I don't know...")
			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Determined")
			UI:WaitShowDialogue("Oh, don't be such a wuss!")
			UI:SetSpeakerEmotion("Normal")
			UI:WaitShowDialogue("At least be willing to try?")
			GAME:WaitFrames(20)
			UI:SetSpeakerEmotion("Worried")
			UI:SetSpeaker(hero)
			UI:WaitShowDialogue("Alright, I'll try with you at least.")
			GAME:WaitFrames(20)
			UI:SetSpeaker(partner)
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Wonderful! I love exploring!")
			UI:WaitShowDialogue("The cave north of the village, so you can head there when you're ready.")
		end
	else
		UI:WaitShowDialogue('Could not find dialogue for current ground map; Seeing this is a bug.')
	end
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end]]
