require 'origin.common'
require 'pmd_sunpath.config'
require 'pmd_sunpath.PartnerEssentials'

--System for handling default dialogue situations.
function PartnerEssentials.Default_Partner_Chapter_0_Dialogue()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local partner2 = CH('Teammate2')
	if not SV.Chapter0.ReachedTestDungeon then 
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("dungeon_test")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("YOLO.")
	elseif not SV.Chapter0.FinishedTestDungeon then
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("dungeon_test")
		UI:WaitShowDialogue("Welp, you only live once.")
	else
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("dungeon_test")
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Hehe, made you look!")
	end
end
