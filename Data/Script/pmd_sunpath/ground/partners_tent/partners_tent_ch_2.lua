require 'pmd_sunpath.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.CharacterEssentials'
require 'pmd_sunpath.CharacterActions'
require 'pmd_sunpath.DialogueFunctions'

partners_tent_ch_2 = {}

-------------------------------
--Cutscene functions
-------------------------------
--Play this cutscene after the scene where the player enters their own tent and while the player makes their own bed
--[[function partners_tent_ch_2.Story_Cutscene()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	GROUND:Hide('PLAYER')
	local marker = MRKR("Main_Entrance_Marker")
	UI:ResetSpeaker()
	SOUND:PlayBGM('Qahil Village.ogg', true)
	GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, Direction.Up)
	AI:DisableCharacterAI(partner)
	GAME:CutsceneMode(true)
	PartnerEssentials.SetPartnerParentSpecies() -- Works, but this code is going to be redone to be more efficient.
	local partnerparentscene =   -- Partnerparent interferes with the other scripts, so this is gonna have to be the variable used for scenes
		CharacterEssentials.MakeCharactersFromList({
			{"PartnerParent", 148, 106, Direction.Down} -- Line to actually spawn in the parent from the CharacterEssentials list
		})
	
	
	UI:SetSpeaker(partnerparentscene, true)
	
	GAME:FadeIn(120)
	GAME:WaitFrames(60)
	GAME:FadeOut(false, 40)
	GAME:WaitFrames(60)
	
	GAME:CutsceneMode(false)
	GAME:EnterGroundMap("players_tent", "Main_Entrance_Marker")	
	
end]]
