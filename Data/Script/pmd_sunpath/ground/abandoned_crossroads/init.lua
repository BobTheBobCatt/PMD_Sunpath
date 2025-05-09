--[[
    init.lua
    Created: 04/03/2025 19:57:36
    Description: Autogenerated script file for the map abandoned_crossroads.
]]--
-- Commonly included lua functions and data
require 'origin.common'
require 'pmd_sunpath.PartnerEssentials'
require 'pmd_sunpath.ground.abandoned_crossroads.abandoned_crossroads_ch_1'

-- Package name
local abandoned_crossroads = {}

-------------------------------
-- Map Callbacks
-------------------------------
---abandoned_crossroads.Init(map)
--Engine callback function
function abandoned_crossroads.Init(map)


end

---abandoned_crossroads.Enter(map)
--Engine callback function
function abandoned_crossroads.Enter(map)

	abandoned_crossroads.StoryScripting()

end

---abandoned_crossroads.Exit(map)
--Engine callback function
function abandoned_crossroads.Exit(map)


end

---abandoned_crossroads.Update(map)
--Engine callback function
function abandoned_crossroads.Update(map)


end

---abandoned_crossroads.GameSave(map)
--Engine callback function
function abandoned_crossroads.GameSave(map)


end

function abandoned_crossroads.StoryScripting()
  --Story scripting
	if SV.ChapterProgression.Chapter == 1 then 
		if SV.Chapter1.PlayerCompletedDune then
			abandoned_crossroads_ch_1.Story_Cutscene()
		end
	else
		GAME:FadeIn(20)
	end
end

---abandoned_crossroads.GameLoad(map)
--Engine callback function
function abandoned_crossroads.GameLoad(map)
	abandoned_crossroads.StoryScripting()
end

--------------------------------------------------
-- Objects Callbacks
--------------------------------------------------

function abandoned_crossroads.North_Exit_Touch(obj, activator)
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	
	if SV.Chapter1.PlayerMetPartner then
		UI:ResetSpeaker(false)
		SOUND:PlaySE("Menu/Skip")
		local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get('dusty_dune')
		UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_ENTER_DUNGEON", zone:GetColoredName()), false)
		UI:WaitForChoice()
		ch = UI:ChoiceResult()
		if ch then
			_DATA:PreLoadZone('dusty_dune')
			SOUND:PlayBGM("", true)
			GAME:FadeOut(false, 20)
			GAME:EnterDungeon("dusty_dune", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
		end
	else
		print("Map trigger failed.")
	end
end

function abandoned_crossroads.West_Exit_Touch(obj, activator)
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	if SV.Chapter1.PlayerMetPartner then
		GAME:FadeOut(false, 20)
		GAME:EnterGroundMap("qahil_village_entrance", "main_entrance_marker")
	else
		print("Map trigger failed.")
	end
end

-------------------------------
-- Entities Callbacks
-------------------------------


return abandoned_crossroads

