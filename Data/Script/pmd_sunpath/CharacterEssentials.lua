require 'pmd_sunpath.common'
require 'pmd_sunpath.config'

----------------------
--Halcyon scripts
----------------------

--[[local function FirstToUpper(str)
	return string.gsub(str, "^%l", string.upper)
end]]

local function FirstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

function AdjustNickname(name, characters)
	local nickname = characters[name].nickname

	local species = characters[name].species
	if species == "nidoran_m" then -- Format Nidoran
		nickname = "Nidoran"
	elseif species == "farfetchd" then -- Format Farfetch'd
		nickname = "Farfetch'd"
	elseif species == "jangmo_o" then -- Format Jangmo-o
		nickname = "Jangmo-o"
	elseif species == "hakamo_o" then -- Format Hakamo-o
		nickname = "Hakamo-o"
	elseif species == "Kommo_o" then -- Format Kommo-o
		nickname = "Kommo-o"
	else
		nickname = FirstToUpper(species)
	end
	return nickname
end

CharacterEssentials = {}

characters = {
		--village guard
		Absol = {
			species = "absol",
			nickname = 'Absol',
			instance = 'Absol',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--village chief
		Krookodile = {
			species = "krookodile", 
			nickname = 'Krookodile',
			instance = 'Krookodile',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--partner's mother, where she's a ditto by default in order to be defined by other means
		PartnerParent = {
			species = "ditto", --Supposed to be the final stage of the partner's species
			nickname = 'Ditto', --Supposed to match the species name of the final stage of the partner's species
			instance = 'Ditto',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		--village shop
		Marowak = {
			species = "marowak", 
			nickname = 'Marowak',
			instance = 'Marowak',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--village storage
		Cacturne = {
			species = "cacturne", 
			nickname = 'Cacturne',
			instance = 'Cacturne',
			gender = Gender.Female,
			form = 0,
			skin = "normal"
		},
		--village banker
		Drapion = {
			species = "drapion", 
			nickname = 'Drapion',
			instance = 'Drapion',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		},
		--cave dweller
		Sandslash = {
			species = "sandslash", 
			nickname = 'Sandslash',
			instance = 'Sandslash',
			gender = Gender.Male,
			form = 0,
			skin = "normal"
		}
			
	}


--creates character from stored data and returns them
function CharacterEssentials.MakeCharactersFromList(list, retTable)
	retTable = retTable or false--return a table of chars rather than multiple chars if this is true
	local charTable = {}
	local chara = 0
	local length = 0
	for i = 1, #list, 1 do
		local name = list[i][1]
		length = #list[i]
		local nickname = AdjustNickname(name, characters)
		if length == 1 then--this case is so we can reference characters that aren't on the map. Put them at 0, 0 and hide them
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(0, 0), Direction.Down, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
			GROUND:Hide(chara.EntName)
			
		elseif length == 2 then --may be inefficient to do a length lookup so often...
			local marker = MRKR(list[i][2])
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(marker.Position.X, marker.Position.Y), marker.Direction, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)
		else
			local x = list[i][2]
			local y = list[i][3]
			local direction = list[i][4]
			local monster = RogueEssence.Dungeon.MonsterID(characters[name].species,
															characters[name].form,
															characters[name].skin,
															characters[name].gender)
			chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, nickname, characters[name].instance)
			chara:ReloadEvents()
			GAME:GetCurrentGround():AddTempChar(chara)

		end
		chara:OnMapInit()
		local result = RogueEssence.Script.TriggerResult()
		TASK:WaitTask(chara:RunEvent(RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned, result, chara))
		charTable[i] = chara
	end
	if retTable then 
		return charTable 
	else
		return table.unpack(charTable)
	end
end




--get a character's name without having to create them
function CharacterEssentials.GetCharacterName(name, no_color)
	local nickname = AdjustNickname(name, characters)
	if no_color then
		return nickname
	else
		return "[color=#00FFFF]" .. nickname .. "[color]"
	end
end



function CharacterEssentials.MakeCharacterAtMarker(charName, markerName)
	local marker = MRKR(markerName)
	local p = CharacterEssentials.GetCharacter(charName, marker.Position.X, marker.Position.Y, marker.Direction)
	GAME:GetCurrentGround():AddTempChar(p)
	return chara
end

--get a character whose data is stored in this script
--can give either species name (if they're the only one) or actual name
function CharacterEssentials.GetCharacter(name, x, y, direction)
	
	if x == nil then x = 0 end 
	if y == nil then y = 0 end
	--if dir == nil then dir = Direction.Down end--down is a good default direction
	
	local species = "missingno"
	local nickname = "default"
	local instance = "default"
	local gender = Gender.Genderless
	local form = 0--formes 
	local skin = "normal"--shiny?
	
	
	
	species = characters[name].species
	nickname = characters[name].nickname
	instance = characters[name].instance
	gender = characters[name].gender
	form = characters[name].form
	skin = characters[name].skin
	local monster = RogueEssence.Dungeon.MonsterID(species, form, skin, gender)
	local chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, nickname, instance)
	return chara
end



----------------------
--Sunpath scripts
----------------------

--Table for determinging the species for the partner's parent
--[[PARTNER_PARENT_SPECIES = {
	Bulbasaur = "Venusaur",
	Ivysaur = "Venusaur",
	Charmander = "Charizard",
	Charmeleon = "Charizard",
	Squirtle = "Blastoise",
	Wartortle = "Blastoise",
	Pidgey = "Pidgeot",
	Pidgeotto = "Pidgeot",
	Pichu = "Raichu",
	Pikachu = "Raichu",
	Vulpix = "Ninetales",
	--Ninetales = "Vulpix", -- Alolan form
	Zubat = "Crobat",
	Golbat = "Crobat",
	Meowth = "Persian",
	--Persian = "Meowth", -- Alolan form
	--Perrserker = "Meowth", --Galarian form
	Psyduck = "Golduck",
	Growlithe = "Arcanine",
	--Arcanine = "Growlithe", --Hisuian form
	Machop = "Machamp",
	Machoke = "Machamp",
	Geodude = "Golem",
	Graveler = "Golem",
	--Golem = "Geodude", -- Alolan form
	--Golem = "Graveler", -- Alolan form
	Eevee = "Flareon",
	Vaporeon = "Flareon",
	Jolteon = "Flareon",
	Espeon = "Flareon",
	Umbreon = "Flareon",
	Leafeon = "Flareon",
	Glaceon = "Flareon",
	Sylveon = "Flareon",
	Dratini = "Dragonite",
	Dragonair = "Dragonite",
	Chikorita = "Meganium",
	Bayleaf = "Meganium",
	Cyndaquil = "Typhlosion",
	Quilava = "Typhlosion",
	Totodile = "Feraligatr",
	Croconaw = "Feraligatr",
	Cleffa = "Clefable",
	Clefairy = "Clefable",
	Igglybuff = "Wigglytuff",
	Jigglypuff = "Wigglytuff",
	Togepi = "Togekiss",
	Togetic = "Togekiss",
	Mareep = "Ampharos",
	Flaafy = "Ampharos",
	Sunkern = "Sunflora",
	Wooper = "Quagsire",
	--Wooper = "Clodsire", -- Paldean form
	Teddiursa = "Ursaring", -- Stand-in for Ursaluna
	--Teddiursa = "Ursaluna", -- Missing sprites & portraits for Ursaluna
	--Ursaring = "Ursaluna", -- Missing sprites & portraits for Ursaluna
	Swinub = "Mamoswine",
	Piloswine = "Mamoswine",
	Phanpy = "Donphan",
	Elekid = "Electivire",
	Electabuzz = "Electivire",
	Magby = "Magmortar",
	Magmar = "Magmortar",
	Larvitar = "Tyranitar",
	Pupitar = "Tyranitar",
	Treeko = "Sceptile",
	Grovyle = "Sceptile",
	Torchic = "Blaziken",
	Combusken = "Blaziken",
	Mudkip = "Swampert",
	Marshtomp = "Swampert",
	Zigzagoon = "Mightyena", -- Stand-in for Obstagoon
	--Zigzagoon = "Obstagoon" -- Missing sprites & portraits for Obstagoon
	Seedot = "Shiftry",
	Nuzleaf = "Shiftry",
	Ralts = "Gardevoir",
	Kirlia = "Gardevoir",
	Gallade = "Gardevoir",
	Azurill = "Azumarill",
	Marill = "Azumarill",
	Skitty = "Delcatty",
	Aron = "Aggron",
	Lairon = "Aggron",
	Trapinch = "Flygon",
	Vibrava = "Flygon",
	Spheal = "Walrein",
	Sealeo = "Walrein",
	Bagon = "Salamance",
	Shelgon = "Salamance",
	Turtwig = "Torterra",
	Grotle = "Torterra",
	Chimchar = "Infernape",
	Monferno = "Infernape",
	Piplup = "Empoleon",
	Prinplup = "Empoleon",
	Starly = "Staraptor",
	Staravia = "Staraptor",
	Bidoof = "Bibarel",
	Shinx = "Luxray",
	Luxio = "Luxray",
	Pachirisu = "Raticate", -- Same egg group; I don't know, raticate seemed more sensible for me here
	Buneary = "Lopunny",
	Gible = "Garchomp",
	Gabite = "Garchomp",
	Munchlax = "Snorlax",
	Riolu = "Lucario",
	Snivy = "Serperior",
	Servine = "Serperior",
	Tepig = "Emboar",
	Pignite = "Emboar",
	Oshawott = "Samurott",
	Dewott = "Samurott",
	Lillipup = "Stoutland",
	Herdier = "Stoutland",
	Purrloin = "Liepard",
	Pidove = "Unfezant",
	Tranquill = "Unfezant",
	Roggenrola = "Gigalith",
	Boldore = "Gigalith",
	Timburr = "Conkeldurr",
	Gurdurr = "Conkeldurr",
	Sewaddle = "Leavanny",
	Swadloon = "Leavanny",
	Venipede = "Scolipede",
	Whirlipede = "Scolipede",
	Sandile = "Krookodile",
	Krokorok = "Krookodile",
	Zorua = "Zoroark",
	--Zorua = "Zoroark", -- Hisuian form
	Vanillite = "Vanilluxe",
	Vanillish = "Vanilluxe",
	Axew = "Haxorus",
	Fraxure = "Haxorus",
	Chespin = "Chesnaught",
	Quiladin = "Chesnaught",
	Fennekin = "Delphox",
	Braixen = "Delphox",
	Froakie = "Greninja",
	Frogadier = "Greninja",
	Skiddo = "Gogoat",
	Espurr = "Meowstic",
	Goomy = "Goodra",
	Sliggoo = "Goodra",
	--Sliggoo = "Goodra", -- Hisuian form
	Rowlet = "Decidueye",
	Dartrix = "Decidueye",
	Litten = "Incineroar",
	Torracat = "Incineroar",
	Popplio = "Primarina",
	Brionne = "Primarina",
	Grubbin = "Vikavolt",
	Charjabug = "Vikavolt",
	Rockruff = "Lycanroc",
	--Lycanroc = "Lycanroc", -- Dusk form
	--Lycanroc = "Lycanroc", -- Midnight form
	Jangmo_o = "Kommo_o", -- Unsure if this will work or not; Hypen near the o causes the game to "crash"
	Hakamo_o = "Kommo_o", -- Unsure if this will work or not; Hypen near the o causes the game to "crash"
	Scorbunny = "Cinderace",
	Raboot = "Cinderace",
	Sobble = "Inteleon",
	Drizzile = "Inteleon",
	Rookidee = "Corviknight",
	Corvisquire = "Corviknight",
	Sprigatito = "Meowscarada",
	Floragato = "Meowscarada",
	Fuecoco = "Skeledirge",
	Crocalor = "Skeledirge",
	Quaxly = "Quaquaval",
	Quaxwell = "Quaquaval",
	Pawmi = "Pawmot",
	Pawmo = "Pawmot",
	Smoliv = "Vileplume", -- Stand-in for Arboliva
	Dolliv = "Vileplume" -- Stand-in for Arboliva
	--Arboliva = "Smoliv",
	--Arboliva = "Dolliv"
}]]
