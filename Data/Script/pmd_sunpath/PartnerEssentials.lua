require 'pmd_sunpath.CharacterEssentials'
PartnerEssentials = {}

---------------------
-- Halcyon scripts
---------------------

--helper function, used if a dialogue bit will be used on multiple maps...
local function in_array(value, array)
    for index = 1, #array do
        if array[index] == value then
            return true
        end
    end

    return false -- We could ommit this part, as nil is like false
end

--This function is called to move partner to a specific marker on loading a new map
function PartnerEssentials.InitializePartnerSpawn(dir, customPosition)
	--Each map has an initial point where the partner spawns. 
	--Set the Partner Spawn variable to default to let the partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 2 then return end --do nothing if party is only size 1 
	
	local partner = CH('Teammate1')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner.Direction
		GROUND:TeleportTo(partner, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner.Spawn)
		dir = dir or marker.Direction or partner.Direction
		
		
		GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
	end	
	
	

	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
    partner.CollisionDisabled = true
	
end

--This function is called to move both partners to specific markers on loading a new map
--Edited script from Halcyon
function PartnerEssentials.InitializeBothPartnersSpawn(dir, customPosition)
	--Each map has an initial point where the other partner spawns. 
	--Set the Partner Spawn variable to default to let the other partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 3 then return end --do nothing if party is only size 1 or 2
	
	local partner2 = CH('Teammate2')
	local partner = CH('Teammate1')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner.Direction
		GROUND:TeleportTo(partner, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner.Spawn)
		dir = dir or marker.Direction or partner.Direction
		
		
		GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
	end
	if customPosition ~= nil then 
		dir = dir or partner2.Direction
		GROUND:TeleportTo(partner2, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner2.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner2.Spawn)
		dir = dir or marker.Direction or partner2.Direction
		
		
		GROUND:TeleportTo(partner2, marker.Position.X, marker.Position.Y, dir)
	end	
	
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	AI:SetCharacterAI(partner2, "origin.ai.ground_partner", CH('PLAYER'), partner2.Position)
    partner.CollisionDisabled = true
    partner2.CollisionDisabled = true
	
end

--when reloading a save, load the partner back in at the proper coordinates.
function PartnerEssentials.LoadGamePartnerPosition(partner)
	print("loading partner in, activating their AI")
	GROUND:TeleportTo(partner, SV.partner.LoadPositionX, SV.partner.LoadPositionY, PartnerEssentials.NumToDir(SV.partner.LoadDirection))--sv doesn't seem to like storing custom classes
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
	AI:EnableCharacterAI(partner)
end

--when saving the game, make note of where the partner is and where they're facing so we can reload them that way.
function PartnerEssentials.SaveGamePartnerPosition(partner)
	SV.partner.LoadPositionX = partner.Position.X
	SV.partner.LoadPositionY = partner.Position.Y
	SV.partner.LoadDirection = PartnerEssentials.DirToNum(partner.Direction)--sv doesnt seem to like storing custom classes
end


--assigns a number value to each direction, useful for figuring out how many turn a direction is from another
function PartnerEssentials.DirToNum(dir)
	--up is 0, upright is 1, ... up left is 7
	local num = -1
	if dir == Direction.Up then
		num = 0
	elseif dir == Direction.UpRight then
		num = 1
	elseif dir == Direction.Right then
		num = 2
	elseif dir == Direction.DownRight then
		num = 3
	elseif dir == Direction.Down then
		num = 4
	elseif dir == Direction.DownLeft then
		num = 5
	elseif dir == Direction.Left then
		num = 6
	elseif dir == Direction.UpLeft then
		num = 7
	end
	
	return num
	
end


--converts a number to a direction
function PartnerEssentials.NumToDir(num)
	local dir = Direction.None
	if num % 8 == 0 then 
		dir = Direction.Up
	elseif num % 8 == 1 then
		dir = Direction.UpRight
	elseif num % 8 == 2 then
		dir = Direction.Right
	elseif num % 8 == 3 then
		dir = Direction.DownRight
	elseif num % 8 == 4 then
		dir = Direction.Down
	elseif num % 8 == 5 then
		dir = Direction.DownLeft
	elseif num % 8 == 6 then
		dir = Direction.Left
	elseif num % 8 == 7 then
		dir = Direction.UpLeft
	end

	return dir
end



--[[
partner's dialogue can be changed by walking over markers that indicate where in a map you're standing. This gives you the ability
to have the partner's dialogue be much more dynamic than the normal PMD games.
]]--
function PartnerEssentials.GetPartnerDialogue(partner)
	
	assert(pcall(load("PartnerEssentials.Chapter_" .. tostring(SV.ChapterProgression.Chapter) .. "_Dialogue(...)"), partner))
	
end




--This function is called to move second partner to a specific marker on loading a new map
--Edited Halcyon script
function PartnerEssentials.InitializePartner2Spawn(dir, customPosition)
	--Each map has an initial point where the partner spawns. 
	--Set the Partner Spawn variable to default to let the partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	
	if GAME:GetPlayerPartyCount() < 2 then return end --do nothing if party is only size 1 
	
	local partner2 = CH('Teammate2')
	local player = CH('PLAYER')

	
	--in case a custom position is ever needed
	if customPosition ~= nil then 
		dir = dir or partner2.Direction
		GROUND:TeleportTo(partner2, customPosition.X, customPosition.Y, dir)
	--otherwise use the marker system
	elseif SV.partner2.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local marker = MRKR(SV.partner2.Spawn)
		dir = dir or marker.Direction or partner2.Direction
		
		
		GROUND:TeleportTo(partner2, marker.Position.X, marker.Position.Y, dir)
	end	
	
	

	AI:SetCharacterAI(partner2, "origin.ai.ground_partner", CH('PLAYER'), partner2.Position)
    partner2.CollisionDisabled = true
	
end

--Edited Halcyon script
function PartnerEssentials.LoadGamePartnerPosition(partner2)
	print("loading other partner in, activating their AI")
	GROUND:TeleportTo(partner2, SV.partner2.LoadPositionX, SV.partner2.LoadPositionY, PartnerEssentials.NumToDir(SV.partner2.LoadDirection))--sv doesn't seem to like storing custom classes
	AI:SetCharacterAI(partner2, "origin.ai.ground_partner", CH('PLAYER'), partner2.Position)
	AI:EnableCharacterAI(partner2)
end

--Edited Halcyon script
function PartnerEssentials.SaveGamePartnerPosition(partner2)
	SV.partner2.LoadPositionX = partner2.Position.X
	SV.partner2.LoadPositionY = partner2.Position.Y
	SV.partner2.LoadDirection = PartnerEssentials.DirToNum(partner2.Direction)--sv doesnt seem to like storing custom classes
end


--Edited Halcyon script
function PartnerEssentials.GetPartnerDialogue(partner2)
	
	assert(pcall(load("PartnerEssentials.Chapter_" .. tostring(SV.ChapterProgression.Chapter) .. "_Dialogue(...)"), partner2))
	
end


local function FirstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

----------------------
--Sunpath scripts
----------------------

--Brute-force way of setting the species of the partner's parent based on the partner's species. I don't know any other way in order to do this.
--Can be done via a table, but I'll try learning that later.
function PartnerEssentials.SetPartnerParentSpecies()
	local partner = CH('Teammate1')
	if partner.CurrentForm.Species == "bulbasaur" or partner.CurrentForm.Species == "ivysaur" or partner.CurrentForm.Species == "venusaur" then
		characters.PartnerParent.species = "venusaur"
		characters.PartnerParent.nickname = 'Venusaur'
		characters.PartnerParent.instance = 'Venusaur'
	elseif partner.CurrentForm.Species == "charmander" or partner.CurrentForm.Species == "charmeleon" or partner.CurrentForm.Species == "charizard" then
		characters.PartnerParent.species = "charizard"
		characters.PartnerParent.nickname = 'Charizard'
		characters.PartnerParent.instance = 'Charizard'
	elseif partner.CurrentForm.Species == "squirtle" or partner.CurrentForm.Species == "wartortle" or partner.CurrentForm.Species == "blastoise" then
		characters.PartnerParent.species = "blastoise"
		characters.PartnerParent.nickname = 'Blastoise'
		characters.PartnerParent.instance = 'Blastoise'
	elseif partner.CurrentForm.Species == "caterpie" or partner.CurrentForm.Species == "metapod" or partner.CurrentForm.Species == "butterfree" then
		characters.PartnerParent.species = "butterfree"
		characters.PartnerParent.nickname = 'Butterfree'
		characters.PartnerParent.instance = 'Butterfree'
	elseif partner.CurrentForm.Species == "weedle" or partner.CurrentForm.Species == "kakuna" or partner.CurrentForm.Species == "beedrill" then
		characters.PartnerParent.species = "beedrill"
		characters.PartnerParent.nickname = 'Beedrill'
		characters.PartnerParent.instance = 'Beedrill'
	elseif partner.CurrentForm.Species == "pidgey" or partner.CurrentForm.Species == "pidgeotto" or partner.CurrentForm.Species == "pidgeot" then
		characters.PartnerParent.species = "pidgeot"
		characters.PartnerParent.nickname = 'Pidgeot'
		characters.PartnerParent.instance = 'Pidgeot'
	elseif partner.CurrentForm.Species == "rattata" or partner.CurrentForm.Species == "raticate" then
		characters.PartnerParent.species = "raticate"
		characters.PartnerParent.nickname = 'Raticate'
		characters.PartnerParent.instance = 'Raticate'
	elseif partner.CurrentForm.Species == "pichu" or partner.CurrentForm.Species == "pikachu" or partner.CurrentForm.Species == "raichu" then
		characters.PartnerParent.species = "raichu"
		characters.PartnerParent.nickname = 'Raichu'
		characters.PartnerParent.instance = 'Raichu'
	elseif partner.CurrentForm.Species == "vulpix" or partner.CurrentForm.Species == "ninetails" then
		characters.PartnerParent.species = "ninetails"
		characters.PartnerParent.nickname = 'Ninetails'
		characters.PartnerParent.instance = 'Ninetails'
	elseif partner.CurrentForm.Species == "zubat" or partner.CurrentForm.Species == "golbat" or partner.CurrentForm.Species == "crobat" then
		characters.PartnerParent.species = "crobat"
		characters.PartnerParent.nickname = 'Crobat'
		characters.PartnerParent.instance = 'Crobat'
	elseif partner.CurrentForm.Species == "meowth" or partner.CurrentForm.Species == "persian" then
		characters.PartnerParent.species = "persian"
		characters.PartnerParent.nickname = 'Persian'
		characters.PartnerParent.instance = 'Persian'
	--[[elseif partner.CurrentForm.Species == "meowth" or partner.CurrentForm.Species == "perrserker" then -- Galarian form
		characters.PartnerParent.species = "perrserker"
		characters.PartnerParent.nickname = 'Perrserker'
		characters.PartnerParent.instance = 'Perrserker']]
	elseif partner.CurrentForm.Species == "psyduck" or partner.CurrentForm.Species == "golduck" then
		characters.PartnerParent.species = "golduck"
		characters.PartnerParent.nickname = 'Golduck'
		characters.PartnerParent.instance = 'Golduck'
	elseif partner.CurrentForm.Species == "growlithe" or partner.CurrentForm.Species == "arcanine" then
		characters.PartnerParent.species = "arcanine"
		characters.PartnerParent.nickname = 'Arcanine'
		characters.PartnerParent.instance = 'Arcanine'
	elseif partner.CurrentForm.Species == "machop" or partner.CurrentForm.Species == "machoke" or partner.CurrentForm.Species == "machamp" then
		characters.PartnerParent.species = "machamp"
		characters.PartnerParent.nickname = 'Machamp'
		characters.PartnerParent.instance = 'Machamp'
	elseif partner.CurrentForm.Species == "geodude" or partner.CurrentForm.Species == "graveler" or partner.CurrentForm.Species == "golem" then
		characters.PartnerParent.species = "golem"
		characters.PartnerParent.nickname = 'Golem'
		characters.PartnerParent.instance = 'Golem'
	elseif partner.CurrentForm.Species == "cubone" or partner.CurrentForm.Species == "marowak" then
		characters.PartnerParent.species = "marowak"
		characters.PartnerParent.nickname = 'Marowak'
		characters.PartnerParent.instance = 'Marowak'
	elseif partner.CurrentForm.Species == "eevee" or partner.CurrentForm.Species == "vaporeon" or partner.CurrentForm.Species == "jolteon" or partner.CurrentForm.Species == "flareon" or partner.CurrentForm.Species == "espeon" or partner.CurrentForm.Species == "umbreon" or partner.CurrentForm.Species == "leafeon" or partner.CurrentForm.Species == "glaceon" or partner.CurrentForm.Species == "sylveon" or partner.CurrentForm.Species == "aereon" or partner.CurrentForm.Species == "eeveon" or partner.CurrentForm.Species == "terreon" or partner.CurrentForm.Species == "spectreon" then
		characters.PartnerParent.species = "flareon"
		characters.PartnerParent.nickname = 'Flareon'
		characters.PartnerParent.instance = 'Flareon'
	elseif partner.CurrentForm.Species == "dratini" or partner.CurrentForm.Species == "dragonair" or partner.CurrentForm.Species == "dragonite" then
		characters.PartnerParent.species = "dragonite"
		characters.PartnerParent.nickname = 'Dragonite'
		characters.PartnerParent.instance = 'Dragonite'
	elseif partner.CurrentForm.Species == "chikorita" or partner.CurrentForm.Species == "bayleef" or partner.CurrentForm.Species == "meganium" then
		characters.PartnerParent.species = "meganium"
		characters.PartnerParent.nickname = 'Meganium'
		characters.PartnerParent.instance = 'Meganium'
	elseif partner.CurrentForm.Species == "cyndaquil" or partner.CurrentForm.Species == "quilava" or partner.CurrentForm.Species == "typhlosion" then
		characters.PartnerParent.species = "typhlosion"
		characters.PartnerParent.nickname = 'Typhlosion'
		characters.PartnerParent.instance = 'Typhlosion'
	elseif partner.CurrentForm.Species == "totodile" or partner.CurrentForm.Species == "croconaw" or partner.CurrentForm.Species == "feraligatr" then
		characters.PartnerParent.species = "feraligatr"
		characters.PartnerParent.nickname = 'Feraligatr'
		characters.PartnerParent.instance = 'Feraligatr'
	elseif partner.CurrentForm.Species == "cleffa" or partner.CurrentForm.Species == "clefairy" or partner.CurrentForm.Species == "clefable" then
		characters.PartnerParent.species = "clefable"
		characters.PartnerParent.nickname = 'Clefable'
		characters.PartnerParent.instance = 'Clefable'
	elseif partner.CurrentForm.Species == "igglybuff" or partner.CurrentForm.Species == "jigglypuff" or partner.CurrentForm.Species == "wigglytuff" then
		characters.PartnerParent.species = "wigglytuff"
		characters.PartnerParent.nickname = 'Wigglytuff'
		characters.PartnerParent.instance = 'Wigglytuff'
	elseif partner.CurrentForm.Species == "togepi" or partner.CurrentForm.Species == "togetic" or partner.CurrentForm.Species == "togekiss" then
		characters.PartnerParent.species = "togekiss"
		characters.PartnerParent.nickname = 'Togekiss'
		characters.PartnerParent.instance = 'Togekiss'
	elseif partner.CurrentForm.Species == "mareep" or partner.CurrentForm.Species == "flaafy" or partner.CurrentForm.Species == "ampharos" then
		characters.PartnerParent.species = "ampharos"
		characters.PartnerParent.nickname = 'Ampharos'
		characters.PartnerParent.instance = 'Ampharos'
	elseif partner.CurrentForm.Species == "wooper" or partner.CurrentForm.Species == "quagsire" then
		characters.PartnerParent.species = "quagsire"
		characters.PartnerParent.nickname = 'Quagsire'
		characters.PartnerParent.instance = 'Quagsire'
	--[[elseif partner.CurrentForm.Species == "wooper" or partner.CurrentForm.Species == "clodsire" then -- Paldean form
		characters.PartnerParent.species = "clodsire"
		characters.PartnerParent.nickname = 'Clodsire'
		characters.PartnerParent.instance = 'Clodsire']]
	elseif partner.CurrentForm.Species == "teddiursa" or partner.CurrentForm.Species == "ursaring" then
		characters.PartnerParent.species = "ursaring"
		characters.PartnerParent.nickname = 'Ursaring'
		characters.PartnerParent.instance = 'Ursaring'
	--[[elseif partner.CurrentForm.Species == "teddiursa" or partner.CurrentForm.Species == "ursaring" or partner.CurrentForm.Species == "ursaluna" then -- Unfinished sprites & portraits for Ursaluna
		characters.PartnerParent.species = "ursaluna"
		characters.PartnerParent.nickname = 'Ursaluna'
		characters.PartnerParent.instance = 'Ursaluna']]
	elseif partner.CurrentForm.Species == "swinub" or partner.CurrentForm.Species == "piloswine" or partner.CurrentForm.Species == "mamoswine" then
		characters.PartnerParent.species = "mamoswine"
		characters.PartnerParent.nickname = 'Mamoswine'
		characters.PartnerParent.instance = 'Mamoswine'
	elseif partner.CurrentForm.Species == "phanpy" or partner.CurrentForm.Species == "donphan" then
		characters.PartnerParent.species = "donphan"
		characters.PartnerParent.nickname = 'Donphan'
		characters.PartnerParent.instance = 'Donphan'
	elseif partner.CurrentForm.Species == "elekid" or partner.CurrentForm.Species == "electabuzz" or partner.CurrentForm.Species == "electivire" then
		characters.PartnerParent.species = "electivire"
		characters.PartnerParent.nickname = 'Electivire'
		characters.PartnerParent.instance = 'Electivire'
	elseif partner.CurrentForm.Species == "magby" or partner.CurrentForm.Species == "magmar" or partner.CurrentForm.Species == "magmortar" then
		characters.PartnerParent.species = "magmortar"
		characters.PartnerParent.nickname = 'Magmortar'
		characters.PartnerParent.instance = 'Magmortar'
	elseif partner.CurrentForm.Species == "larvitar" or partner.CurrentForm.Species == "pupitar" or partner.CurrentForm.Species == "tyranitar" then
		characters.PartnerParent.species = "tyranitar"
		characters.PartnerParent.nickname = 'Tyranitar'
		characters.PartnerParent.instance = 'Tyranitar'
	elseif partner.CurrentForm.Species == "treecko" or partner.CurrentForm.Species == "grovyle" or partner.CurrentForm.Species == "sceptile" then
		characters.PartnerParent.species = "sceptile"
		characters.PartnerParent.nickname = 'Sceptile'
		characters.PartnerParent.instance = 'Sceptile'
	elseif partner.CurrentForm.Species == "torchic" or partner.CurrentForm.Species == "combusken" or partner.CurrentForm.Species == "blaziken" then
		characters.PartnerParent.species = "blaziken"
		characters.PartnerParent.nickname = 'Blaziken'
		characters.PartnerParent.instance = 'Blaziken'
	elseif partner.CurrentForm.Species == "mudkip" or partner.CurrentForm.Species == "marshtomp" or partner.CurrentForm.Species == "swampert" then
		characters.PartnerParent.species = "swampert"
		characters.PartnerParent.nickname = 'Swampert'
		characters.PartnerParent.instance = 'Swampert'
	elseif partner.CurrentForm.Species == "wurmple" or partner.CurrentForm.Species == "silcoon" or partner.CurrentForm.Species == "cascoon" or partner.CurrentForm.Species == "dustox" or partner.CurrentForm.Species == "beautifly" then
		characters.PartnerParent.species = "beautifly"
		characters.PartnerParent.nickname = 'Beautifly"'
		characters.PartnerParent.instance = 'Beautifly"'
	--[[elseif partner.CurrentForm.Species == "zigzagoon" or partner.CurrentForm.Species == "linoone" or partner.CurrentForm.Species == "obstagoon" then -- Unfinished sprites & portraits for Obstagoon
		characters.PartnerParent.species = "obstagoon"
		characters.PartnerParent.nickname = 'Obstagoon'
		characters.PartnerParent.instance = 'Obstagoon']]
	elseif partner.CurrentForm.Species == "zigzagoon" or partner.CurrentForm.Species == "linoone" or partner.CurrentForm.Species == "obstagoon" then -- Stand-in for Obstagoon
		characters.PartnerParent.species = "mightyena"
		characters.PartnerParent.nickname = 'Mightyena'
		characters.PartnerParent.instance = 'Mightyena'
	elseif partner.CurrentForm.Species == "seedot" or partner.CurrentForm.Species == "nuzleaf" or partner.CurrentForm.Species == "shiftry" then
		characters.PartnerParent.species = "shiftry"
		characters.PartnerParent.nickname = 'Shiftry'
		characters.PartnerParent.instance = 'Shiftry'
	elseif partner.CurrentForm.Species == "ralts" or partner.CurrentForm.Species == "kirlia" or partner.CurrentForm.Species == "gallade" or partner.CurrentForm.Species == "gardevoir" then
		characters.PartnerParent.species = "gardevoir"
		characters.PartnerParent.nickname = 'Gardevoir'
		characters.PartnerParent.instance = 'Gardevoir'
	elseif partner.CurrentForm.Species == "azurill" or partner.CurrentForm.Species == "marill" or partner.CurrentForm.Species == "azumarill" then
		characters.PartnerParent.species = "azumarill"
		characters.PartnerParent.nickname = 'Azumarill'
		characters.PartnerParent.instance = 'Azumarill'
	elseif partner.CurrentForm.Species == "skitty" or partner.CurrentForm.Species == "delcatty" then
		characters.PartnerParent.species = "delcatty"
		characters.PartnerParent.nickname = 'Delcatty'
		characters.PartnerParent.instance = 'Delcatty'
	elseif partner.CurrentForm.Species == "aron" or partner.CurrentForm.Species == "lairon" or partner.CurrentForm.Species == "aggron" then
		characters.PartnerParent.species = "aggron"
		characters.PartnerParent.nickname = 'Aggron'
		characters.PartnerParent.instance = 'Aggron'
	elseif partner.CurrentForm.Species == "trapinch" or partner.CurrentForm.Species == "vibrava" or partner.CurrentForm.Species == "flygon" then
		characters.PartnerParent.species = "flygon"
		characters.PartnerParent.nickname = 'Flygon'
		characters.PartnerParent.instance = 'Flygon'
	elseif partner.CurrentForm.Species == "spheal" or partner.CurrentForm.Species == "sealeo" or partner.CurrentForm.Species == "walrein" then
		characters.PartnerParent.species = "walrein"
		characters.PartnerParent.nickname = 'Walrein'
		characters.PartnerParent.instance = 'Walrein'
	elseif partner.CurrentForm.Species == "bagon" or partner.CurrentForm.Species == "shelgon" or partner.CurrentForm.Species == "salamance" then
		characters.PartnerParent.species = "salamance"
		characters.PartnerParent.nickname = 'Salamance'
		characters.PartnerParent.instance = 'Salamance'
	elseif partner.CurrentForm.Species == "turtwig" or partner.CurrentForm.Species == "grotle" or partner.CurrentForm.Species == "torterra" then
		characters.PartnerParent.species = "torterra"
		characters.PartnerParent.nickname = 'Torterra'
		characters.PartnerParent.instance = 'Torterra'
	elseif partner.CurrentForm.Species == "chimchar" or partner.CurrentForm.Species == "monferno" or partner.CurrentForm.Species == "infernape" then
		characters.PartnerParent.species = "infernape"
		characters.PartnerParent.nickname = 'Infernape'
		characters.PartnerParent.instance = 'Infernape'
	elseif partner.CurrentForm.Species == "piplup" or partner.CurrentForm.Species == "prinplup" or partner.CurrentForm.Species == "empoleon" then
		characters.PartnerParent.species = "empoleon"
		characters.PartnerParent.nickname = 'Empoleon'
		characters.PartnerParent.instance = 'Empoleon'
	elseif partner.CurrentForm.Species == "starly" or partner.CurrentForm.Species == "staravia" or partner.CurrentForm.Species == "staraptor" then
		characters.PartnerParent.species = "staraptor"
		characters.PartnerParent.nickname = 'Staraptor'
		characters.PartnerParent.instance = 'Staraptor'
	elseif partner.CurrentForm.Species == "bidoof" or partner.CurrentForm.Species == "bibarel" then
		characters.PartnerParent.species = "bibarel"
		characters.PartnerParent.nickname = 'Bibarel'
		characters.PartnerParent.instance = 'Bibarel'
	elseif partner.CurrentForm.Species == "shinx" or partner.CurrentForm.Species == "luxio" or partner.CurrentForm.Species == "luxray" then
		characters.PartnerParent.species = "luxray"
		characters.PartnerParent.nickname = 'Luxray'
		characters.PartnerParent.instance = 'Luxray'
	elseif partner.CurrentForm.Species == "buneary" or partner.CurrentForm.Species == "lopunny" then
		characters.PartnerParent.species = "lopunny"
		characters.PartnerParent.nickname = 'Lopunny'
		characters.PartnerParent.instance = 'Lopunny'
	elseif partner.CurrentForm.Species == "gible" or partner.CurrentForm.Species == "gabite" or partner.CurrentForm.Species == "garchomp" then
		characters.PartnerParent.species = "garchomp"
		characters.PartnerParent.nickname = 'Garchomp'
		characters.PartnerParent.instance = 'Garchomp'
	elseif partner.CurrentForm.Species == "munchlax" or partner.CurrentForm.Species == "snorlax" then
		characters.PartnerParent.species = "snorlax"
		characters.PartnerParent.nickname = 'Snorlax'
		characters.PartnerParent.instance = 'Snorlax'
	elseif partner.CurrentForm.Species == "riolu" or partner.CurrentForm.Species == "lucario" then
		characters.PartnerParent.species = "lucario"
		characters.PartnerParent.nickname = 'Lucario'
		characters.PartnerParent.instance = 'Lucario'
	elseif partner.CurrentForm.Species == "snivy" or partner.CurrentForm.Species == "servine" or partner.CurrentForm.Species == "serperior" then
		characters.PartnerParent.species = "serperior"
		characters.PartnerParent.nickname = 'Serperior'
		characters.PartnerParent.instance = 'Serperior'
	elseif partner.CurrentForm.Species == "tepig" or partner.CurrentForm.Species == "pignite" or partner.CurrentForm.Species == "emboar" then
		characters.PartnerParent.species = "emboar"
		characters.PartnerParent.nickname = 'Emboar'
		characters.PartnerParent.instance = 'Emboar'
	elseif partner.CurrentForm.Species == "oshawott" or partner.CurrentForm.Species == "dewott" or partner.CurrentForm.Species == "samurott" then
		characters.PartnerParent.species = "samurott"
		characters.PartnerParent.nickname = 'Samurott'
		characters.PartnerParent.instance = 'Samurott'
	elseif partner.CurrentForm.Species == "lillipup" or partner.CurrentForm.Species == "herdier" or partner.CurrentForm.Species == "stoutland" then
		characters.PartnerParent.species = "stoutland"
		characters.PartnerParent.nickname = 'Stoutland'
		characters.PartnerParent.instance = 'Stoutland'
	elseif partner.CurrentForm.Species == "purrloin" or partner.CurrentForm.Species == "liepard" then
		characters.PartnerParent.species = "liepard"
		characters.PartnerParent.nickname = 'Liepard'
		characters.PartnerParent.instance = 'Liepard'
	elseif partner.CurrentForm.Species == "pidove" or partner.CurrentForm.Species == "tranquill" or partner.CurrentForm.Species == "unfezant" then
		characters.PartnerParent.species = "unfezant"
		characters.PartnerParent.nickname = 'Unfezant'
		characters.PartnerParent.instance = 'Unfezant'
	elseif partner.CurrentForm.Species == "roggenrola" or partner.CurrentForm.Species == "boldore" or partner.CurrentForm.Species == "gigalith" then
		characters.PartnerParent.species = "gigalith"
		characters.PartnerParent.nickname = 'Gigalith'
		characters.PartnerParent.instance = 'Gigalith'
	elseif partner.CurrentForm.Species == "timburr" or partner.CurrentForm.Species == "gurdurr" or partner.CurrentForm.Species == "conkeldurr" then
		characters.PartnerParent.species = "conkeldurr"
		characters.PartnerParent.nickname = 'Conkeldurr'
		characters.PartnerParent.instance = 'Conkeldurr'
	elseif partner.CurrentForm.Species == "sewaddle" or partner.CurrentForm.Species == "swadloon" or partner.CurrentForm.Species == "leavanny" then
		characters.PartnerParent.species = "leavanny"
		characters.PartnerParent.nickname = 'Leavanny'
		characters.PartnerParent.instance = 'Leavanny'
	elseif partner.CurrentForm.Species == "venipede" or partner.CurrentForm.Species == "whirlipede" or partner.CurrentForm.Species == "scolipede" then
		characters.PartnerParent.species = "scolipede"
		characters.PartnerParent.nickname = 'Scolipede'
		characters.PartnerParent.instance = 'Scolipede'
	elseif partner.CurrentForm.Species == "sandile" or partner.CurrentForm.Species == "krokorok" or partner.CurrentForm.Species == "krookodile" then
		characters.PartnerParent.species = "krookodile"
		characters.PartnerParent.nickname = 'Krookodile'
		characters.PartnerParent.instance = 'Krookodile'
	elseif partner.CurrentForm.Species == "zorua" or partner.CurrentForm.Species == "zoroark" then
		characters.PartnerParent.species = "zoroark"
		characters.PartnerParent.nickname = 'Zoroark'
		characters.PartnerParent.instance = 'Zoroark'
	elseif partner.CurrentForm.Species == "minccino" or partner.CurrentForm.Species == "cinccino" then
		characters.PartnerParent.species = "cinccino"
		characters.PartnerParent.nickname = 'Cinccino'
		characters.PartnerParent.instance = 'Cinccino'
	elseif partner.CurrentForm.Species == "vanillite" or partner.CurrentForm.Species == "vanillish" or partner.CurrentForm.Species == "vanilluxe" then
		characters.PartnerParent.species = "vanilluxe"
		characters.PartnerParent.nickname = 'Vanilluxe'
		characters.PartnerParent.instance = 'Vanilluxe'
	elseif partner.CurrentForm.Species == "axew" or partner.CurrentForm.Species == "fraxure" or partner.CurrentForm.Species == "haxorus" then
		characters.PartnerParent.species = "haxorus"
		characters.PartnerParent.nickname = 'Haxorus'
		characters.PartnerParent.instance = 'Haxorus'
	elseif partner.CurrentForm.Species == "chespin" or partner.CurrentForm.Species == "quilladin" or partner.CurrentForm.Species == "chesnaught" then
		characters.PartnerParent.species = "chesnaught"
		characters.PartnerParent.nickname = 'Chesnaught'
		characters.PartnerParent.instance = 'Chesnaught'
	elseif partner.CurrentForm.Species == "fennekin" or partner.CurrentForm.Species == "braixen" or partner.CurrentForm.Species == "delphox" then
		characters.PartnerParent.species = "delphox"
		characters.PartnerParent.nickname = 'Delphox'
		characters.PartnerParent.instance = 'Delphox'
	elseif partner.CurrentForm.Species == "froakie" or partner.CurrentForm.Species == "frogadier" or partner.CurrentForm.Species == "greninja" then
		characters.PartnerParent.species = "greninja"
		characters.PartnerParent.nickname = 'Greninja'
		characters.PartnerParent.instance = 'Greninja'
	elseif partner.CurrentForm.Species == "fletchling" or partner.CurrentForm.Species == "fletchinder" or partner.CurrentForm.Species == "talonflame" then
		characters.PartnerParent.species = "talonflame"
		characters.PartnerParent.nickname = 'Talonflame'
		characters.PartnerParent.instance = 'Talonflame'
	elseif partner.CurrentForm.Species == "skiddo" or partner.CurrentForm.Species == "gogoat" then
		characters.PartnerParent.species = "gogoat"
		characters.PartnerParent.nickname = 'Gogoat'
		characters.PartnerParent.instance = 'Gogoat'
	elseif partner.CurrentForm.Species == "espurr" or partner.CurrentForm.Species == "meowstic" then
		characters.PartnerParent.species = "meowstic"
		characters.PartnerParent.nickname = 'Meowstic'
		characters.PartnerParent.instance = 'Meowstic'
	elseif partner.CurrentForm.Species == "goomy" or partner.CurrentForm.Species == "sliggoo" or partner.CurrentForm.Species == "goodra" then
		characters.PartnerParent.species = "goodra"
		characters.PartnerParent.nickname = 'Goodra'
		characters.PartnerParent.instance = 'Goodra'
	elseif partner.CurrentForm.Species == "rowlet" or partner.CurrentForm.Species == "dartrix" or partner.CurrentForm.Species == "decidueye" then
		characters.PartnerParent.species = "decidueye"
		characters.PartnerParent.nickname = 'Decidueye'
		characters.PartnerParent.instance = 'Decidueye'
	elseif partner.CurrentForm.Species == "litten" or partner.CurrentForm.Species == "torracat" or partner.CurrentForm.Species == "incineroar" then
		characters.PartnerParent.species = "incineroar"
		characters.PartnerParent.nickname = 'Incineroar'
		characters.PartnerParent.instance = 'Incineroar'
	elseif partner.CurrentForm.Species == "popplio" or partner.CurrentForm.Species == "brionne" or partner.CurrentForm.Species == "primarina" then
		characters.PartnerParent.species = "primarina"
		characters.PartnerParent.nickname = 'Primarina'
		characters.PartnerParent.instance = 'Primarina'
	elseif partner.CurrentForm.Species == "grubbin" or partner.CurrentForm.Species == "charjabug" or partner.CurrentForm.Species == "vikavolt" then
		characters.PartnerParent.species = "vikavolt"
		characters.PartnerParent.nickname = 'Vikavolt'
		characters.PartnerParent.instance = 'Vikavolt'
	elseif partner.CurrentForm.Species == "rockruff" or partner.CurrentForm.Species == "lycanroc" then
		characters.PartnerParent.species = "lycanroc"
		characters.PartnerParent.nickname = 'Lycanroc'
		characters.PartnerParent.instance = 'Lycanroc'
	elseif partner.CurrentForm.Species == "jangmo_o" or partner.CurrentForm.Species == "hakamo_o" or partner.CurrentForm.Species == "kommo_o" then
		characters.PartnerParent.species = "kommo_o"
		characters.PartnerParent.nickname = 'Kommo_o'
		characters.PartnerParent.instance = 'Kommo_o'
	elseif partner.CurrentForm.Species == "grookey" or partner.CurrentForm.Species == "thwackey" or partner.CurrentForm.Species == "rillaboom" then
		characters.PartnerParent.species = "rillaboom"
		characters.PartnerParent.nickname = 'Rillaboom'
		characters.PartnerParent.instance = 'Rillaboom'
	elseif partner.CurrentForm.Species == "scorbunny" or partner.CurrentForm.Species == "raboot" or partner.CurrentForm.Species == "cinderace" then
		characters.PartnerParent.species = "cinderace"
		characters.PartnerParent.nickname = 'Cinderace'
		characters.PartnerParent.instance = 'Cinderace'
	elseif partner.CurrentForm.Species == "sobble" or partner.CurrentForm.Species == "drizzile" or partner.CurrentForm.Species == "inteleon" then
		characters.PartnerParent.species = "inteleon"
		characters.PartnerParent.nickname = 'Inteleon'
		characters.PartnerParent.instance = 'Inteleon'
	elseif partner.CurrentForm.Species == "rookidee" or partner.CurrentForm.Species == "corvisquire" or partner.CurrentForm.Species == "corviknight" then
		characters.PartnerParent.species = "corviknight"
		characters.PartnerParent.nickname = 'Corviknight'
		characters.PartnerParent.instance = 'Corviknight'
	elseif partner.CurrentForm.Species == "yamper" or partner.CurrentForm.Species == "boltund" then
		characters.PartnerParent.species = "boltund"
		characters.PartnerParent.nickname = 'Boltund'
		characters.PartnerParent.instance = 'Boltund'
	elseif partner.CurrentForm.Species == "sprigatito" or partner.CurrentForm.Species == "floragato" or partner.CurrentForm.Species == "meowscarada" then
		characters.PartnerParent.species = "meowscarada"
		characters.PartnerParent.nickname = 'Meowscarada'
		characters.PartnerParent.instance = 'Meowscarada'
	elseif partner.CurrentForm.Species == "fuecoco" or partner.CurrentForm.Species == "crocalor" or partner.CurrentForm.Species == "skeledirge" then
		characters.PartnerParent.species = "skeledirge"
		characters.PartnerParent.nickname = 'Skeledirge'
		characters.PartnerParent.instance = 'Skeledirge'
	elseif partner.CurrentForm.Species == "quaxly" or partner.CurrentForm.Species == "quaxwell" or partner.CurrentForm.Species == "quaquaval" then
		characters.PartnerParent.species = "quaquaval"
		characters.PartnerParent.nickname = 'Quaquaval'
		characters.PartnerParent.instance = 'Quaquaval'
	elseif partner.CurrentForm.Species == "pawmi" or partner.CurrentForm.Species == "pawmo" or partner.CurrentForm.Species == "pawmot" then
		characters.PartnerParent.species = "pawmot"
		characters.PartnerParent.nickname = 'Pawmot'
		characters.PartnerParent.instance = 'Pawmot'
	--[[elseif partner.CurrentForm.Species == "smoliv" or partner.CurrentForm.Species == "dolliv" or partner.CurrentForm.Species == "arboliva" then -- No portraits or sprites for Arvoliva
		characters.PartnerParent.species = "arboliva"
		characters.PartnerParent.nickname = 'Arboliva'
		characters.PartnerParent.instance = 'Arboliva']]
	elseif partner.CurrentForm.Species == "smoliv" or partner.CurrentForm.Species == "dolliv" or partner.CurrentForm.Species == "arboliva" then -- Stand-in for Arboliva
		characters.PartnerParent.species = "vileplume"
		characters.PartnerParent.nickname = 'Vileplume'
		characters.PartnerParent.instance = 'Vileplume'
	elseif partner.CurrentForm.Species == "charcadet" or partner.CurrentForm.Species == "ceruledge" or partner.CurrentForm.Species == "armarouge" then
		characters.PartnerParent.species = "armarouge"
		characters.PartnerParent.nickname = 'Armarouge'
		characters.PartnerParent.instance = 'Armarouge'
	end
end
