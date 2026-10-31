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
print('Loading default script variable values..')
-----------------------------------------------
-- Services Defaults
-----------------------------------------------
SV = {}

SV.Services =
{
  --Anything that applies to services should be put in here, or assigned to this or a subtable of this in the service's definition script
}

-----------------------------------------------
-- Settings Defaults
-----------------------------------------------
-- This needs to be nil to avoid PMDO's stray default loads
-- SV.Settings = {
-- 	  Starters = 0
-- 	  Tutorials = 0
-- }

-----------------------------------------------
-- General Defaults
-----------------------------------------------

SV.Experimental = false

SV.General =
{
  Rescue = nil,
  --Anything that applies to more than a single level, and that is too small to make a sub-table for, should be put in here ideally, or a sub-table of this
}

SV.checkpoint = 
{
  Zone    = "sp_test_zone", Structure  = -1,
  Map  = 1, Entry  = 0,
}

--Used for flags relevant for the current dungeon run. Currently just houses whether or not you've stolen from shopkeeps this dungeon run.
SV.adventure = 
{
  Thief    = false
}

SV.base_shop = {
	{ Index = "food_apple", Amount = 0, Price = 50},
	{ Index = "berry_leppa", Amount = 0, Price = 80},
	{ Index = "berry_oran", Amount = 0, Price = 80}
}

SV.base_shop_desert = {
	{ Index = "food_yucca_fruit", Amount = 0, Price = 40},
	{ Index = "berry_leppa", Amount = 0, Price = 80},
	{ Index = "berry_oran", Amount = 0, Price = 80}
}

SV.unlocked_trades = { }

SV.missions =
{
  Missions = { },
  FinishedMissions = { },
}

SV.floor_records = { }

SV.magnagate =
{
  Cards = 0
}

SV.partner = 
{
	Spawn = 'Default',
	Dialogue = 'Default',
	LoadPositionX = -1,
	LoadPositionY = -1,
	LoadDirection = -1

}

SV.partner2 = 
{
	Spawn = 'Default',
	Dialogue = 'Default',
	LoadPositionX = -1,
	LoadPositionY = -1,
	LoadDirection = -1

}

SV.partnerparent = 
{
	Spawn = 'Default',
	Dialogue = 'Default',
	LoadPositionX = -1,
	LoadPositionY = -1,
	LoadDirection = -1

}

--[[SV.PlayerNature =
{
	Nature = 'Default'

}]]

SV.DestinationFloorNotified = false
SV.MonsterHouseMessageNotified = false
SV.OutlawDefeated = false
SV.OutlawGoonsDefeated = false
SV.MapTurnCounter = -1



--empty string or a -1 indicates that there's nothing there currently.
--board of jobs you've actually taken.
SV.TakenBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = "",
		BackReference = -1
	}

}

--jobs on the mission board.
SV.MissionBoard =
{
		{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	}

}

--Jobs on the outlaw board.
SV.OutlawBoard =
{
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = 1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	},	
	{
		Client = "",
		Target = "",
		Flavor = "",
		Title = "",
		Zone = "",
		Segment = -1,
		Floor = -1,
		Reward = "",
		Type = -1,
		Completion = -1,
		Taken = false,
		Difficulty = "",
		Item = "",
		Special = "",
		ClientGender = -1,
		TargetGender = -1,
		BonusReward = ""
	}
}
		
	



-------------------------------------------------
-- Temporary Flags - Flags that reset at the end of the day or on screen transition are saved here
-------------------------------------------------
--todo, move existing daily flags here
--These flags are to be reset to their initial values at the end of the day.
--For now,  these are placeholder flags from Halcyon for if I decide to do something like this at a later time.
SV.DailyFlags = 
{
  --RedMerchantItem = "",
  --RedMerchantBought = false,
  --GreenMerchantItem = "",
  --GreenMerchantBought = false,
  
  --GreenKecleonRefreshedStock = false,
  --GreenKecleonStock = {},
  --PurpleKecleonRefreshedStock = false,
  --PurpleKecleonStock = {}

}

--Generic use flags 
--Some of these flags are placeholder flags from Halcyon, these will be changed as I get to them.
SV.TemporaryFlags = 
{
	OldDirection = Direction.None,--Used for remembering which way an NPC was facing before turning to speak to you
	Dinnertime = false,--used to indicate whether generic dinner cutscene should be played on entering dining room
	Bedtime = false,--used to indicate whether to do a generic bedtime cutscene or not 
	MorningWakeup = false,--used to indicate whether to do a generic morning wakeup call or not when entering the heros room
	MorningAddress = false,--used to indicate whether to do a generic morning address
	JustWokeUp = false,--Did the duo JUST wake up on a new day?
	LastDungeonEntered = '',--Used to mark what dungeon the player was in last. Dojo dungeons don't count.This variable is set by init scripts for relevant zones.
	MissionCompleted = false,--used to mark if there are any pending missions to hand in.
	PostJobsGround = '',--used to mark the ground to go to after handing in randomly generated missions if the default choice of generic dinnertime is not wanted.
	PriorMapSetting = nil--Used to mark what the player had their minimap setting whenever the game needs to temporarily change it to something else.
}


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

SV.shati_town = 
{
  Locale = 'Guild',--Where are we on the Shati Town map? Used for partner dialogue. Defaults to the guild.
  LastMarker = '',--which locale marker was touched last? We need to unhide it when another is touched.
  Song = 'Shati Town.ogg'--song being played by the musician
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
	CurrentStoryDungeon = "",--Used by the Destination Menu when leaving town to the right to know if it needs to set you somewhere else first before going to the dungeon (i.e. for a cutscene outside the dungeon). If the selected dungeon matches this value, then it will try to put you on the relevant ground that is that dungeon's entrance.
	
	UnlockedAssembly = false--this is set to true when player is allowed to recruit team members, unhides assembly objects
}

SV.Tutorials = 
{
	PickedUpFood = false,
	PickedUpSeed = false,
	PickedUpHeldItem = false,
	PickedUpOranBerry = false,
	PickedUpLeppaBerry = false,
	PickedUpMoney = false,
	PickedUpOrb = false,
	PickedUpWand = false,
	PickedUpStatusBerry = false
}


SV.Chapter1 = 
{
	PlayedIntroCutscene = false,
	PlayerEnteredDune = false,--Did player go into the dune dungeon yet?
	PlayerCompletedDune = false,--Did player complete solo run of first dungeon?
	PartnerEnteredDune = false,--Did partner go into the dune dungeon yet?
	PartnerCompletedDune = false,--Did partner complete solo run of first dungeon?
	PlayerEnteredVillage = false,--Did player go into the village yet?
	PlayerAllowedInVillage = false,--Finished player meeting chief cutscene in Qahil Village?
	PartnerEnteredVillage = false,--Did player go into the village yet?
	PlayerSleptInVillage = false,--Did player go to sleep in their tent?
	PlayerMetPartner = false,--Finished player meeting partner cutscene in Qahil Village?
	PlayedVillageTutorial = false,--Finished showing player the town and shops?
	TeamEnteredSandCave = false,--Did the player & partner go to Sandhill Cave?
	TeamCompletedSandCave = false,--Did the player & partner complete run of Sandhill Cave?
	TeamSleptInTent = false,--Did the player & partner go to sleep in the player's tent?


	TutorialProgression = 0
}

SV.Chapter2 = 
{
	TeamSleptInTent = false,--Did the player & partner go to sleep in the player's tent?
	TeamEnteredWoods = false,--Did the player & partner go to Dry Woods?
	TeamCompletedWoods = false,--Did the player & partner complete run of Dry Woods?
	TeamEnteredCoast = false,--Did the player & partner go to Madkhal Coast?
	TeamCompletedCoast = false,--Did the player & partner complete run of Madkhal Coast?
	TeamEnteredTown = false,--Did player & partner go into the town yet?
	TeamMetPartner2 = false,--Finished player & partner meeting 2nd partner cutscene in Shati Town?
	TeamEnteredMountain = false,--Did the player & partners go to Mt. Sahil?
	TeamCompletedMountain = false--Did the player & partners complete run of Mt. Sahil?
}

SV.Chapter3 = 
{
}

SV.Chapter4 = 
{
}

----------------------------------
--Dungeon relevant flags 
----------------------------------
SV.DungeonFlags = 
{
	GenericEnding = false--do a generic ending for the end of a dungeon in the relevant zone/ground
}





--base game stuff
SV.test_grounds =
{
  SpokeToPooch = false,
  AcceptedPooch = false,
  Starter = { Species="pikachu", Form=0, Skin="normal", Gender=2 },
  Partner = { Species="eevee", Form=0, Skin="normal", Gender=1 },
  DemoComplete = false,
}

SV.roaming_legends =
{
  Raikou = false,
  Entei = false,
  Suicune = false,
  Latios = false,
  Latias = false,
  Darkrai = false
}

SV.missions =
{
  Missions = { },
  FinishedMissions = { },
}


SV.base_camp = 
{
  IntroComplete    = false,
  ExpositionComplete  = false,
  FirstTalkComplete  = false
}

SV.base_shop = {
	{ Index = "food_apple", Amount = 0, Price = 50},
	{ Index = "food_apple_big", Amount = 0, Price = 150},
	{ Index = "food_banana", Amount = 0, Price = 500},
	--{ Index = "food_chestnut", Amount = 0, Price = 80},
	{ Index = "berry_leppa", Amount = 0, Price = 80}
}

SV.base_trades = {
	{ Item="xcl_family_bulbasaur_02", ReqItem={"",""}},
	{ Item="xcl_family_charmander_02", ReqItem={"",""}},
	{ Item="xcl_family_squirtle_02", ReqItem={"",""}}
}

SV.base_town = 
{
  Song    = "1 - Base Town.ogg"
}

SV.forest_camp = 
{
  ExpositionComplete  = false
}

SV.cliff_camp = 
{
  ExpositionComplete  = false,
  TeamRetreatIntro = false
}

SV.supply_corps =
{
  --0 = Stopped at Snorlax, 
  --1 = Cleared Snorlax and headed to cliff camp,
  --2 = deliver had package stolen
  --2 (completed) = deliver had package returned,
  --3 = deliver thanks given for return,
  --4 = manager moved to canyon camp with deliver,
  --5 = spoke at canyon camp,
  --6 = carry had package stolen,
  --6 (completed) = carry had package returned,
  --7 = carry thanks given for return,
  --8 = they found the boss,
  --8 (with unlock) = gave dungeon of the boss,
  --8 (with flag) = completed the boss,
  --9 = thanks for completing the boss,
  --10 = found the new cave, set up the post
  --11 = spoke at cave
  --12 = deliver and carry beaten up,
  --12 (completed) = deliver rescued from monster house,
  --13 = deliver thanks given for return,
  --14 = found snow camp, claims they will set up post
  --15 = spoke about snow camp
  --16 = manager disappeared,
  --16 (completed) = manager rescued from monster house,
  --17 = manager thanks given for return,
  --18 = they found the boss,
  --18 (with unlock) = gave dungeon of the boss,
  --18 (with flag) = completed the boss,
  --19 = thanks for completing the boss,
  --20 = questline and mountain complete, go into cycle routine
  Status = 0,
  
  DaysSinceCheckpoint = 0,
  
  --cyclical up and down from 1 to 5 inclusive
  --0 = base camp
  --1 = forest camp
  --2 = cliff camp
  --3 = canyon camp
  --4 = cave camp
  --5 = snow camp
  --6 = summit
  CarryCycle = 0,
  
  --random from 1 to 5 inclusive
  --0 = base camp
  --1 = forest camp
  --2 = cliff camp
  --3 = canyon camp
  --4 = cave camp
  --5 = snow camp
  --6 = summit
  DeliverCycle = 0,
  
  --cyclical.  overrides the other two if in base camp or summit
  --0 = base camp
  --1 = forest camp
  --2 = cliff camp
  --3 = canyon camp
  --4 = cave camp
  --5 = snow camp
  --6 = summit
  ManagerCycle = 0
}

SV.canyon_camp = 
{
  ExpositionComplete  = false
}

SV.rest_stop = 
{
  ExpositionComplete  = false
}

SV.final_stop = 
{
  ExpositionComplete  = false
}

SV.guildmaster_summit = 
{
  ExpositionComplete  = false,
  BattleComplete = false
}


----------------------------------------------
print('Script variables default values loaded!')
