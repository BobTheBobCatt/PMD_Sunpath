require 'pmd_sunpath.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.CharacterEssentials'

test_map_ch_1 = {}

-------------------------------
--Cutscene functions
-------------------------------
--Test cutscene, mostly to test movements.
function test_map_ch_1.Story_Cutscene()
	GAME:CutsceneMode(true)
	local hero = CH('PLAYER')
	GROUND:Hide('Teammate1')
	local marker = MRKR("Main_Entrance_Marker")
	UI:ResetSpeaker()
	GROUND:TeleportTo(hero, marker.Position.X, marker.Position.Y, Direction.Up)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(60)
	GROUND:MoveToPosition(hero, 300, 287, false, 1)
	GAME:WaitFrames(10)
	UI:SetSpeaker(hero, true)
	UI:WaitShowDialogue("Wee, woo. Wee, woo. Wee, woo.")
	GAME:WaitFrames(10)
	GROUND:MoveToPosition(hero, 138, 191, false, 1)
	GAME:WaitFrames(10)
	GAME:FadeOut(false, 20)
	GAME:WaitFrames(60)
	
	GAME:CutsceneMode(false)
	
end
