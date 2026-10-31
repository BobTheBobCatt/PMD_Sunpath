require 'pmd_sunpath.common'
require 'pmd_sunpath.config'
require 'pmd_sunpath.PartnerEssentials'

--System for handling default dialogue situations.
--[[function Partner2Dialogue.Chapter_2_Dialogue(partner2)
	local ground = GAME:GetCurrentGround().AssetName--get ground's internal name
	UI:SetSpeaker(partner)
	local hero = CH('PLAYER')
	partner.IsInteracting = true
	GROUND:CharSetAnim(partner, 'None', true)
	GROUND:CharSetAnim(hero, 'None', true)
	GROUND:CharTurnToCharAnimated(partner, hero, 4)
	GROUND:CharTurnToCharAnimated(hero, partner, 4)
	UI:SetSpeakerEmotion('Normal')
	
	if ground == 'guild_players_room' then 
		if SV.TemporaryFlags.JustWokeUp then 
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue("Good morning,[pause=10] " .. hero:GetDisplayName() .. "!")
		end
	elseif in_array(ground, {'ground_1',
						     'ground_2'}) then 
		
	end
	
	GROUND:CharEndAnim(partner)
	GROUND:CharEndAnim(hero)
	partner.IsInteracting = false
end]]
