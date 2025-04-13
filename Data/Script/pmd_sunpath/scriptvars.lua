--[[
    scriptvars.lua
      This file contains all the default values for the script variables. AKA on a new game this file is loaded!
      Script variables are stored in a table  that gets saved when the game is saved.
      Its meant to be used for scripters to add data to be saved and loaded during a playthrough.
      
      You can simply refer to the "SV" global table like any other table in any scripts!
      You don't need to write a default value in this lua script to add a new value.
      However its good practice to set a default value when you can!
      
      It is important to stress that this file initializes the SV table ONCE when the player begins a new save file, and NEVER EVER again.
      This means that edits on this file will NOT be added on the script variables of an already existing file!
      To upgrade existing script variables, use the OnUpgrade in script services.  Example found in Data/Script/services/debug_tools/init.lua
      
    --Examples:
    SV.SomeVariable = "Smiles go for miles!"
    SV.AnotherVariable = 2526
    SV.AnotherVariable = { something={somethingelse={} } }
    SV.AnotherVariable = function() PrintInfo('lmao') end
]]--

-----------------------------------------------
-- Level Specific Defaults
-----------------------------------------------

--todo: cleanup a lot of these
SV.qahil_village = 
{
  Locale = 'Village',--Where are we on the Qahil Village map? Used for partner dialogue. Defaults to the village.
  LastMarker = '',--Which locale marker was touched last? We need to unhide it when another is touched.
  Song = 'Qahil Village.ogg'--song being played by the musician
}

SV.alraas_town = 
{
  Locale = 'Guild',--Where are we on the Alraas Town map? Used for partner dialogue. Defaults to the guild.
  LastMarker = '',--which locale marker was touched last? We need to unhide it when another is touched.
  Song = 'Alraas Town.ogg'--song being played by the musician
}


-----------------------------------------------------------------------------
-- Chapter / Cutscenes flags. Flags that control the state of the story are stored here
----------------------------------------------------------------------------


--Keeps track of overall game progression flags (chapter number, important overarching flags, etc)
SV.ChapterProgression = 
{
	DaysPassed = 0,--total number of in game days played in the game
	DaysToReach = -1, --Used to figure out what day needs to be reached to continue the story
	Chapter = 1,
	CurrentStoryDungeon = "",--Used by the Destination Menu when leaving town to the right to know if it needs to set you somewhere else first before going to the dungeon (i.e. for a cutscene outside the dungeon). If the selected dungeon matches this value, then it will try to put you on the relevant ground that is that dungeon's entrance. Note: Relic Forest 1 and Illuminant Riverbed are handled by other objects, and thus aren't ever set to the current story dungeon.
	
	UnlockedAssembly = false--this is set to true when player is allowed to recruit team members, unhides assembly objects
}


SV.Chapter1 = 
{
	PlayedIntroCutscene = false,
	PlayerEnteredDune = false,--Did player go into the dune dungeon yet?
	PlayerCompletedDune = false,--Did player complete solo run of first dungeon?
	PlayerEnteredVillage = false,--Did player go into the village yet?
	PlayerAllowedInVillage = false,--Finished player meeting chief cutscene in Qahil Village?
	PlayerMetPartner = false,--Finished player meeting partner cutscene in Qahil Village?


	TutorialProgression = 0
}

SV.Chapter2 = 
{
}

SV.Chapter3 = 
{
}

SV.Chapter4 = 
{
	PlayerAndPartnerMetPartner2 = false--Finished player & partner meeting 2nd partner cutscene in Alraas Town?
}

----------------------------------
--Dungeon relevant flags 
----------------------------------
SV.DungeonFlags = 
{
	GenericEnding = false--do a generic ending for the end of a dungeon in the relevant zone/ground
}

----------------------------------------------