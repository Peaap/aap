-- Passive static data definitions extracted by Stage 3 Task 2.2.
AAP = AAP or {}
AAP.Data = AAP.Data or {}

local flightPoints = {
	["Horde"] = {
		[572] = {
			["Iron Docks, Gorgrond"] = {
				["y"] = 19.1,
				["x"] = 52.3,
			},
			["Veil Terokk, Spires of Arak"] = {
				["y"] = 73.3,
				["x"] = 50.2,
			},
			["Breaker's Crown, Gorgrond"] = {
				["y"] = 30.7,
				["x"] = 53.6,
			},
			["Stonefang Outpost, Frostfire Ridge"] = {
				["y"] = 33.3,
				["x"] = 30.9,
			},
			["The Iron Front, Tanaan Jungle"] = {
				["y"] = 46.6,
				["x"] = 54.3,
			},
			["Darktide Roost, Shadowmoon Valley"] = {
				["y"] = 76.8,
				["x"] = 72.3,
			},
			["Riverside Post, Nagrand"] = {
				["y"] = 51.9,
				["x"] = 22,
			},
			["Exarch's Refuge, Talador"] = {
				["y"] = 60.3,
				["x"] = 45.9,
			},
			["Malo's Lookout, Tanaan Jungle"] = {
				["y"] = 43.7,
				["x"] = 65.2,
			},
			["Exile's Rise, Shadowmoon Valley"] = {
				["y"] = 61.6,
				["x"] = 66.5,
			},
			["Wor'gol, Frostfire Ridge"] = {
				["y"] = 34.3,
				["x"] = 24,
			},
			["Skysea Ridge, Gorgrond"] = {
				["y"] = 24.5,
				["x"] = 50.5,
			},
			["Axefall, Spires of Arak"] = {
				["y"] = 73.1,
				["x"] = 47.7,
			},
			["Vol'mar, Tanaan Jungle"] = {
				["y"] = 44.6,
				["x"] = 70.6,
			},
			["Socrethar's Rise, Shadowmoon Valley"] = {
				["y"] = 75.7,
				["x"] = 65.8,
			},
			["Darkspear's Edge, Frostfire Ridge"] = {
				["y"] = 30.6,
				["x"] = 35.2,
			},
			["Aktar's Post, Tanaan Jungle"] = {
				["y"] = 43,
				["x"] = 59.6,
			},
			["Throm'Var, Frostfire Ridge"] = {
				["y"] = 22.8,
				["x"] = 27.8,
			},
			["Apexis Excavation, Spires of Arak"] = {
				["y"] = 68.5,
				["x"] = 46.8,
			},
			["Wor'var, Nagrand"] = {
				["y"] = 51.1,
				["x"] = 33.7,
			},
			["Frostwall Garrison, Frostfire Ridge"] = {
				["y"] = 36.8,
				["x"] = 33.8,
			},
			["The Ring of Trials, Nagrand"] = {
				["y"] = 52.3,
				["x"] = 32.5,
			},
			["Pinchwhistle Gearworks, Spires of Arak"] = {
				["y"] = 80.5,
				["x"] = 55.6,
			},
			["Bastion Rise, Gorgrond"] = {
				["y"] = 42.6,
				["x"] = 54.4,
			},
			["Rilzit's Holdfast, Nagrand"] = {
				["y"] = 47.9,
				["x"] = 22.5,
			},
			["Wolf's Stand, Frostfire Ridge"] = {
				["y"] = 35.3,
				["x"] = 43.4,
			},
			["Nivek's Overlook, Nagrand"] = {
				["y"] = 58.3,
				["x"] = 22,
			},
			["Bladespire Citadel, Frostfire Ridge"] = {
				["y"] = 29.7,
				["x"] = 25,
			},
			["Akeeta's Hovel, Shadowmoon Valley"] = {
				["y"] = 66.7,
				["x"] = 57.4,
			},
			["Durotan's Grasp, Talador"] = {
				["y"] = 53.7,
				["x"] = 46.3,
			},
			["Frostwolf Overlook, Talador"] = {
				["y"] = 46.4,
				["x"] = 48.5,
			},
			["Warspear, Ashran"] = {
				["y"] = 38.2,
				["x"] = 85.7,
			},
			["Joz's Rylaks, Nagrand"] = {
				["y"] = 48.4,
				["x"] = 26.4,
			},
			["Sha'naari Refuge, Tanaan Jungle"] = {
				["y"] = 48.1,
				["x"] = 60.7,
			},
			["Retribution Point, Talador"] = {
				["y"] = 62.5,
				["x"] = 41.4,
			},
			["Evermorn Springs, Gorgrond"] = {
				["y"] = 41.4,
				["x"] = 51.4,
			},
			["Everbloom Wilds, Gorgrond"] = {
				["y"] = 27.6,
				["x"] = 59.2,
			},
			["Thunder Pass, Frostfire Ridge"] = {
				["y"] = 35.6,
				["x"] = 47.1,
			},
			["Talon Watch, Spires of Arak"] = {
				["y"] = 72.9,
				["x"] = 56,
			},
			["Terokkar Refuge, Talador"] = {
				["y"] = 57.7,
				["x"] = 51.7,
			},
			["Vol'jin's Pride, Talador"] = {
				["y"] = 51,
				["x"] = 51.9,
			},
			["Beastwatch, Gorgrond"] = {
				["y"] = 35.4,
				["x"] = 53.7,
			},
			["Crow's Crook, Spires of Arak"] = {
				["y"] = 70.1,
				["x"] = 52.3,
			},
			["Everbloom Overlook, Gorgrond"] = {
				["y"] = 22,
				["x"] = 65.1,
			},
			["Bloodmaul Slag Mines, Frostfire Ridge"] = {
				["y"] = 25.7,
				["x"] = 35.1,
			},
			["Shattrath City, Talador"] = {
				["y"] = 54.2,
				["x"] = 44.7,
			},
			["Throne of the Elements, Nagrand"] = {
				["y"] = 47,
				["x"] = 30.4,
			},
			["Zangarra, Talador"] = {
				["y"] = 50,
				["x"] = 55.3,
			},
			["Vault of the Earth, Tanaan Jungle"] = {
				["y"] = 49.7,
				["x"] = 66.3,
			},
		},
		[875] = {
			["Xibala, Zuldazar"] = {
				["y"] = 79.2,
				["x"] = 49.8,
			},
			["Vulpera Hideaway, Vol'dun"] = {
				["y"] = 26.7,
				["x"] = 43.3,
			},
			["Scaletrader Post, Zuldazar"] = {
				["y"] = 52.9,
				["x"] = 65.9,
			},
			["Sanctuary of the Devoted, Vol'dun"] = {
				["y"] = 27.2,
				["x"] = 28.6,
			},
			["Gloom Hollow, Nazmir"] = {
				["y"] = 27.6,
				["x"] = 64.4,
			},
			["Dreadpearl, Zuldazar"] = {
				["y"] = 60.2,
				["x"] = 71.6,
			},
			["Warbeast Kraal, Zuldazar"] = {
				["y"] = 61.2,
				["x"] = 63.7,
			},
			["The Great Seal"] = {
				["y"] = 61,
				["x"] = 58.3,
			},
			["Zeb'ahari, Zuldazar"] = {
				["y"] = 44.1,
				["x"] = 69.9,
			},
			["Tusk Isle, Zuldazar"] = {
				["y"] = 82.8,
				["x"] = 58.8,
			},
			["Isle of Fangs, Zuldazar"] = {
				["y"] = 88.4,
				["x"] = 55.7,
			},
			["Nesingwary's Gameland, Zuldazar"] = {
				["y"] = 45.5,
				["x"] = 63.1,
			},
			["Atal'Dazar, Zuldazar"] = {
				["y"] = 56.7,
				["x"] = 50.6,
			},
			["Port of Zandalar, Zuldazar"] = {
				["y"] = 71.1,
				["x"] = 58.4,
			},
			["Zul'jan, Nazmir"] = {
				["y"] = 41,
				["x"] = 53.6,
			},
			["Scorched Sands Outpost, Vol'dun"] = {
				["y"] = 40,
				["x"] = 36.7,
			},
			["Forlorn Ruins, Nazmir"] = {
				["y"] = 21.2,
				["x"] = 70,
			},
			["Seeker's Outpost, Zuldazar"] = {
				["y"] = 75,
				["x"] = 65.7,
			},
			["Devoted Sanctuary, Vol'dun"] = {
				["y"] = 27.2,
				["x"] = 28.6,
			},
			["Temple of Akunda, Vol'dun"] = {
				["y"] = 46.6,
				["x"] = 41.6,
			},
			["Tortaka Refuge, Vol'dun"] = {
				["y"] = 12.9,
				["x"] = 45.7,
			},
			["Temple of the Prophet, Zuldazar"] = {
				["y"] = 62.1,
				["x"] = 52.8,
			},
			["Garden of the Loa, Zuldazar"] = {
				["y"] = 50.8,
				["x"] = 52.8,
			},
			["Warport Rastari, Zuldazar"] = {
				["y"] = 71.9,
				["x"] = 51.9,
			},
			["Goldtusk Inn, Vol'dun"] = {
				["y"] = 32.6,
				["x"] = 36.2,
			},
			["Zo'bal Ruins, Nazmir"] = {
				["y"] = 27.4,
				["x"] = 54,
			},
			["Vorrik's Sanctum, Vol'dun"] = {
				["y"] = 19.6,
				["x"] = 38.4,
			},
			["Atal'Gral, Zuldazar"] = {
				["y"] = 60.2,
				["x"] = 71.6,
			},
			["The Sliver, Zuldazar"] = {
				["y"] = 56.5,
				["x"] = 58.6,
			},
			["The Mugambala, Zuldazar"] = {
				["y"] = 70,
				["x"] = 55.1,
			},
		},
		[13] = {
			["Flamestar Post, Burning Steppes"] = {
				["y"] = 70.9,
				["x"] = 47.1,
			},
			["Forsaken High Command, Silverpine Forest"] = {
				["y"] = 35.9,
				["x"] = 42.1,
			},
			["Light's Shield Tower, Eastern Plaguelands"] = {
				["y"] = 32.8,
				["x"] = 55.4,
			},
			["Bloodwatcher Point, Badlands"] = {
				["y"] = 66.5,
				["x"] = 53.2,
			},
			["Revantusk Village, The Hinterlands"] = {
				["y"] = 43.5,
				["x"] = 56.1,
			},
			["Light's Hope Chapel, Eastern Plaguelands"] = {
				["y"] = 32.8,
				["x"] = 57.7,
			},
			["Dragonmaw Port, Twilight Highlands"] = {
				["y"] = 55.9,
				["x"] = 60.1,
			},
			["The Sepulcher, Silverpine Forest"] = {
				["y"] = 39.4,
				["x"] = 40.8,
			},
			["Booty Bay, Stranglethorn"] = {
				["y"] = 94.3,
				["x"] = 43.3,
			},
			["New Kargath, Badlands"] = {
				["y"] = 65.7,
				["x"] = 50.5,
			},
			["Bloodgulch, Twilight Highlands"] = {
				["y"] = 54.5,
				["x"] = 57.5,
			},
			["Stonard, Swamp of Sorrows"] = {
				["y"] = 79.6,
				["x"] = 52.6,
			},
			["Fuselight, Badlands"] = {
				["y"] = 65.3,
				["x"] = 54.1,
			},
			["Fairbreeze Village, Eversong Woods"] = {
				["y"] = 17.7,
				["x"] = 55,
			},
			["Hardwrench Hideaway, Stranglethorn"] = {
				["y"] = 90.1,
				["x"] = 42.8,
			},
			["Plaguewood Tower, Eastern Plaguelands"] = {
				["y"] = 30.2,
				["x"] = 52,
			},
			["Hiri'watha Research Station, The Hinterlands"] = {
				["y"] = 41.2,
				["x"] = 51.5,
			},
			["The Menders' Stead, Western Plaguelands"] = {
				["y"] = 34.2,
				["x"] = 48.9,
			},
			["Eastwall Tower, Eastern Plaguelands"] = {
				["y"] = 31.8,
				["x"] = 56.3,
			},
			["Shattered Landing, Blasted Lands"] = {
				["y"] = 84.5,
				["x"] = 54,
			},
			["Forsaken Rear Guard, Silverpine Forest"] = {
				["y"] = 37.2,
				["x"] = 40.8,
			},
			["Eastpoint Tower, Hillsbrad"] = {
				["y"] = 43.2,
				["x"] = 47.1,
			},
			["Ruins of Southshore, Hillsbrad"] = {
				["y"] = 43.6,
				["x"] = 45.9,
			},
			["Bogpaddle, Swamp of Sorrows"] = {
				["y"] = 77,
				["x"] = 54.1,
			},
			["Tarren Mill, Hillsbrad"] = {
				["y"] = 41.2,
				["x"] = 46.7,
			},
			["The Gullet, Twilight Highlands"] = {
				["y"] = 54,
				["x"] = 55.3,
			},
			["Undercity, Tirisfal"] = {
				["y"] = 35.3,
				["x"] = 43.9,
			},
			["Strahnbrad, Alterac Mountains"] = {
				["y"] = 38.8,
				["x"] = 47,
			},
			["Hearthglen, Western Plaguelands"] = {
				["y"] = 30.7,
				["x"] = 48.2,
			},
			["Northpass Tower, Eastern Plaguelands"] = {
				["y"] = 29.6,
				["x"] = 55.2,
			},
			["Flame Crest, Burning Steppes"] = {
				["y"] = 68.8,
				["x"] = 49.9,
			},
			["The Bulwark, Tirisfal"] = {
				["y"] = 34.8,
				["x"] = 46.4,
			},
			["Grom'gol, Stranglethorn"] = {
				["y"] = 86.8,
				["x"] = 44.2,
			},
			["Brill, Tirisfal Glades"] = {
				["y"] = 32.7,
				["x"] = 43.6,
			},
			["Chiselgrip, Burning Steppes"] = {
				["y"] = 70.1,
				["x"] = 49.3,
			},
			["Tranquillien, Ghostlands"] = {
				["y"] = 22,
				["x"] = 55.3,
			},
			["Shattered Sun Staging Area"] = {
				["y"] = 2,
				["x"] = 55.6,
			},
			["Crown Guard Tower, Eastern Plaguelands"] = {
				["y"] = 34.2,
				["x"] = 53.6,
			},
			["The Forsaken Front, Silverpine Forest"] = {
				["y"] = 41.5,
				["x"] = 41.3,
			},
			["Crushblow, Twilight Highlands"] = {
				["y"] = 58.9,
				["x"] = 56.5,
			},
			["Andorhal, Western Plaguelands"] = {
				["y"] = 35.5,
				["x"] = 48.4,
			},
			["Forsaken Forward Command, Gilneas"] = {
				["y"] = 44.5,
				["x"] = 40.5,
			},
			["Thondroril River, Eastern Plaguelands"] = {
				["y"] = 34,
				["x"] = 51.2,
			},
			["Zul'Aman, Ghostlands"] = {
				["y"] = 24.9,
				["x"] = 57.7,
			},
			["Hammerfall, Arathi"] = {
				["y"] = 44.5,
				["x"] = 53.1,
			},
			["The Krazzworks, Twilight Highlands"] = {
				["y"] = 51.4,
				["x"] = 60.3,
			},
			["Falconwing Square, Eversong Woods"] = {
				["y"] = 15,
				["x"] = 55.3,
			},
			["Southpoint Gate, Hillsbrad"] = {
				["y"] = 43.3,
				["x"] = 43.5,
			},
			["Iron Summit, Searing Gorge"] = {
				["y"] = 67.4,
				["x"] = 47.6,
			},
			["Bambala, Stranglethorn"] = {
				["y"] = 85.7,
				["x"] = 46.6,
			},
			["Thorium Point, Searing Gorge"] = {
				["y"] = 65.3,
				["x"] = 47.3,
			},
		},
		[12] = {
			["Sen'jin Village, Durotar"] = {
				["y"] = 53.3,
				["x"] = 59.6,
			},
			["The Crossroads, Northern Barrens"] = {
				["y"] = 51.9,
				["x"] = 53.4,
			},
			["Zoram'gar Outpost, Ashenvale"] = {
				["y"] = 36.5,
				["x"] = 43.5,
			},
			["Bootlegger Outpost, Tanaris"] = {
				["y"] = 85.5,
				["x"] = 57.4,
			},
			["Everlook, Winterspring"] = {
				["y"] = 22.4,
				["x"] = 58.9,
			},
			["Hellscream's Watch, Ashenvale"] = {
				["y"] = 37.7,
				["x"] = 47.7,
			},
			["Bilgewater Harbor, Azshara"] = {
				["y"] = 35.7,
				["x"] = 63.4,
			},
			["Sun Rock Retreat, Stonetalon Mountains"] = {
				["y"] = 46.2,
				["x"] = 43.5,
			},
			["Dawnrise Expedition, Tanaris"] = {
				["y"] = 88.8,
				["x"] = 53,
			},
			["Gadgetzan, Tanaris"] = {
				["y"] = 79,
				["x"] = 56.7,
			},
			["Whisperwind Grove, Felwood"] = {
				["y"] = 25.3,
				["x"] = 48.6,
			},
			["Oasis of Vir'sar, Uldum"] = {
				["y"] = 84.3,
				["x"] = 44.2,
			},
			["Shadowprey Village, Desolace"] = {
				["y"] = 57.3,
				["x"] = 37.5,
			},
			["Orgrimmar, Durotar"] = {
				["y"] = 42.8,
				["x"] = 58.2,
			},
			["The Mor'Shan Ramparts, Ashenvale"] = {
				["y"] = 45.2,
				["x"] = 52.3,
			},
			["Irontree Clearing, Felwood"] = {
				["y"] = 22,
				["x"] = 50.7,
			},
			["Ratchet, Northern Barrens"] = {
				["y"] = 53.8,
				["x"] = 56.6,
			},
			["Nordrassil, Hyjal"] = {
				["y"] = 27.4,
				["x"] = 56,
			},
			["Mossy Pile, Un'Goro Crater"] = {
				["y"] = 78.5,
				["x"] = 49.3,
			},
			["Valormok, Azshara"] = {
				["y"] = 37.9,
				["x"] = 57.6,
			},
			["Brackenwall Village, Dustwallow Marsh"] = {
				["y"] = 63,
				["x"] = 54.1,
			},
			["Westreach Summit, Thousand Needles"] = {
				["y"] = 67.7,
				["x"] = 48.8,
			},
			["Bloodhoof Village, Mulgore"] = {
				["y"] = 59.5,
				["x"] = 47.4,
			},
			["Ethel Rethor, Desolace"] = {
				["y"] = 51.6,
				["x"] = 39.6,
			},
			["Stonemaul Hold, Feralas"] = {
				["y"] = 68.9,
				["x"] = 41.2,
			},
			["Camp Ataya, Feralas"] = {
				["y"] = 62.7,
				["x"] = 39.4,
			},
			["Marshal's Stand, Un'Goro Crater"] = {
				["y"] = 80.9,
				["x"] = 50.5,
			},
			["Southern Rocketway, Azshara"] = {
				["y"] = 39.3,
				["x"] = 63.2,
			},
			["Silverwind Refuge, Ashenvale"] = {
				["y"] = 41.3,
				["x"] = 49.4,
			},
			["Northern Rocketway, Azshara"] = {
				["y"] = 31.3,
				["x"] = 65.5,
			},
			["Splintertree Post, Ashenvale"] = {
				["y"] = 40.7,
				["x"] = 53.2,
			},
			["Mudsprocket, Dustwallow Marsh"] = {
				["y"] = 68.7,
				["x"] = 55.1,
			},
			["Krom'gar Fortress, Stonetalon Mountains"] = {
				["y"] = 46.3,
				["x"] = 46.4,
			},
			["Thunder Bluff, Mulgore"] = {
				["y"] = 55,
				["x"] = 46.2,
			},
			["Wildheart Point, Felwood"] = {
				["y"] = 30.8,
				["x"] = 48.7,
			},
			["Hunter's Hill, Southern Barrens"] = {
				["y"] = 53.4,
				["x"] = 50.6,
			},
			["Camp Mojache, Feralas"] = {
				["y"] = 68.1,
				["x"] = 45.8,
			},
			["The Sludgewerks, Stonetalon Mountains"] = {
				["y"] = 42.7,
				["x"] = 44.4,
			},
			["Razor Hill, Durotar"] = {
				["y"] = 49,
				["x"] = 59.3,
			},
			["Schnottz's Landing, Uldum"] = {
				["y"] = 93.8,
				["x"] = 43.4,
			},
			["Vendetta Point, Southern Barrens"] = {
				["y"] = 58.9,
				["x"] = 51,
			},
			["Moonglade"] = {
				["y"] = 19.7,
				["x"] = 52.1,
			},
			["Cliffwalker Post, Stonetalon Mountains"] = {
				["y"] = 41.2,
				["x"] = 43,
			},
			["Fizzle & Pozzik's Speedbarge, Thousand Needles"] = {
				["y"] = 74.9,
				["x"] = 57,
			},
			["Desolation Hold, Southern Barrens"] = {
				["y"] = 63.5,
				["x"] = 50.9,
			},
			["Nozzlepot's Outpost, Northern Barrens"] = {
				["y"] = 45.4,
				["x"] = 55.5,
			},
			["Furien's Post, Desolace"] = {
				["y"] = 51.9,
				["x"] = 40.2,
			},
			["Thunk's Abode, Desolace"] = {
				["y"] = 52.3,
				["x"] = 43.5,
			},
			["Malaka'jin, Stonetalon Mountains"] = {
				["y"] = 50.6,
				["x"] = 47,
			},
			["Karnum's Glade, Desolace"] = {
				["y"] = 54.4,
				["x"] = 41.9,
			},
			["Emerald Sanctuary, Felwood"] = {
				["y"] = 33.9,
				["x"] = 49.9,
			},
			["Ramkahen, Uldum"] = {
				["y"] = 88.5,
				["x"] = 49.2,
			},
		},
		[876] = {
			["Swiftwind Post, Drustvar"] = {
				["y"] = 73.8,
				["x"] = 46,
			},
			["Waning Glacier, Tiragarde Sound"] = {
				["y"] = 46.4,
				["x"] = 41.8,
			},
			["Stonetusk Watch, Stormsong Valley"] = {
				["y"] = 32.2,
				["x"] = 48.8,
			},
			["Castaway Point, Tiragarde Sound"] = {
				["y"] = 81.7,
				["x"] = 68.4,
			},
			["Ironmaul Overlook, Stormsong Valley"] = {
				["y"] = 31,
				["x"] = 65,
			},
			["Wolf's Den, Tiragarde Sound"] = {
				["y"] = 43.6,
				["x"] = 54.6,
			},
			["Freehold, Tiragarde Sound"] = {
				["y"] = 82.8,
				["x"] = 63.1,
			},
			["Timberfell Outpost, Tiragarde Sound"] = {
				["y"] = 65.3,
				["x"] = 60.3,
			},
			["Shrine of the Storm, Stormsong Valley"] = {
				["y"] = 13.6,
				["x"] = 65.8,
			},
			["Diretusk Hollow, Stormsong Valley"] = {
				["y"] = 24.6,
				["x"] = 55.5,
			},
			["Warfang Hold, Stormsong Valley"] = {
				["y"] = 17.8,
				["x"] = 54.3,
			},
			["Krazzlefrazz Outpost, Drustvar"] = {
				["y"] = 58.5,
				["x"] = 33.2,
			},
			["Tol Dagor, Tiragarde Sound"] = {
				["y"] = 60.8,
				["x"] = 77.1,
			},
			["Seekers Vista, Stormsong Valley"] = {
				["y"] = 19.4,
				["x"] = 49.3,
			},
			["Mudfisher Cove, Drustvar"] = {
				["y"] = 55.3,
				["x"] = 44.1,
			},
			["Plunder Harbor, Tiragarde Sound"] = {
				["y"] = 64.6,
				["x"] = 69,
			},
			["Windfall Cavern, Stormsong Valley"] = {
				["y"] = 15,
				["x"] = 58.4,
			},
			["Whitegrove Chapel, Drustvar"] = {
				["y"] = 55.1,
				["x"] = 28.1,
			},
			["Hillcrest Pasture, Stormsong Valley"] = {
				["y"] = 38,
				["x"] = 54.8,
			},
			["Stonefist Watch, Tiragarde Sound"] = {
				["y"] = 71.6,
				["x"] = 49.5,
			},
			["Anyport, Drustvar"] = {
				["y"] = 66.9,
				["x"] = 25.2,
			},
		},
		[619] = {
			["Dreadwake's Landing, Stormheim"] = {
				["y"] = 39,
				["x"] = 59.6,
			},
			["Illidari Stand, Azsuna"] = {
				["y"] = 58.7,
				["x"] = 32.9,
			},
			["Stonehoof Watch, Highmountain"] = {
				["y"] = 26.8,
				["x"] = 50.9,
			},
			["Crimson Thicket, Suramar"] = {
				["y"] = 42.7,
				["x"] = 53.1,
			},
			["Shackle's Den, Azsuna"] = {
				["y"] = 64,
				["x"] = 36.9,
			},
			["Valdisdall, Stormheim"] = {
				["y"] = 32.3,
				["x"] = 61.4,
			},
			["Vengeance Point, Broken Shore"] = {
				["y"] = 62.1,
				["x"] = 53.6,
			},
			["Forsaken Foothold, Stormheim"] = {
				["y"] = 26,
				["x"] = 54,
			},
			["Nesingwary, Highmountain"] = {
				["y"] = 22.1,
				["x"] = 43.8,
			},
			["Hafr Fjall, Stormheim"] = {
				["y"] = 43.5,
				["x"] = 59.8,
			},
			["Gloaming Reef, Val'sharah"] = {
				["y"] = 37.7,
				["x"] = 26.1,
			},
			["Azurewing Repose, Azsuna"] = {
				["y"] = 53.2,
				["x"] = 34.2,
			},
			["Stormtorn Foothills, Stormheim"] = {
				["y"] = 27.2,
				["x"] = 58.8,
			},
			["Thunder Totem, Highmountain"] = {
				["y"] = 24.7,
				["x"] = 46.3,
			},
			["Shipwreck Cove, Highmountain"] = {
				["y"] = 6.3,
				["x"] = 44.4,
			},
			["Aalgen Point, Broken Shore"] = {
				["y"] = 67.5,
				["x"] = 57.8,
			},
			["Felbane Camp, Highmountain"] = {
				["y"] = 17.1,
				["x"] = 39.9,
			},
			["Sylvan Falls, Highmountain"] = {
				["y"] = 27.1,
				["x"] = 42.1,
			},
			["Felblaze Ingress, Azsuna"] = {
				["y"] = 53.4,
				["x"] = 39.6,
			},
			["Shield's Rest, Stormheim"] = {
				["y"] = 19.8,
				["x"] = 70.5,
			},
			["Meredil, Suramar"] = {
				["y"] = 44.9,
				["x"] = 44.2,
			},
			["Dalaran"] = {
				["y"] = 64.6,
				["x"] = 46.7,
			},
			["Skyhorn, Highmountain"] = {
				["y"] = 19.3,
				["x"] = 48.4,
			},
			["Garden of the Moon, Val'sharah"] = {
				["y"] = 35.1,
				["x"] = 35.1,
			},
			["Bradensbrook, Val'sharah"] = {
				["y"] = 35.4,
				["x"] = 30.9,
			},
			["Obsidian Overlook, Highmountain"] = {
				["y"] = 34.1,
				["x"] = 46.4,
			},
			["Starsong Refuge, Val'sharah"] = {
				["y"] = 33.1,
				["x"] = 38.7,
			},
			["Watchers' Aerie, Azsuna"] = {
				["y"] = 72.1,
				["x"] = 35.4,
			},
			["Prepfoot, Highmountain"] = {
				["y"] = 13.1,
				["x"] = 50.5,
			},
			["Eye of Azshara, Azsuna"] = {
				["y"] = 84.5,
				["x"] = 43.9,
			},
			["Lorlathil, Val'sharah"] = {
				["y"] = 39.5,
				["x"] = 34.6,
			},
			["Illidari Perch, Azsuna"] = {
				["y"] = 59.6,
				["x"] = 28.4,
			},
			["Ironhorn Enclave, Highmountain"] = {
				["y"] = 33.8,
				["x"] = 50,
			},
			["Cullen's Post, Stormheim"] = {
				["y"] = 34.8,
				["x"] = 56.6,
			},
			["Challiane's Terrace, Azsuna"] = {
				["y"] = 46.6,
				["x"] = 31.6,
			},
			["Wardens' Redoubt, Azsuna"] = {
				["y"] = 69,
				["x"] = 34.2,
			},
			["The Witchwood, Highmountain"] = {
				["y"] = 17,
				["x"] = 43,
			},
			["Irongrove Retreat, Suramar"] = {
				["y"] = 39.7,
				["x"] = 41.7,
			},
			["Deliverance Point, Broken Shore"] = {
				["y"] = 70.9,
				["x"] = 52.6,
			},
		},
		[113] = {
			["Transitus Shield, Coldarra"] = {
				["y"] = 59.9,
				["x"] = 16.4,
			},
			["Warsong Hold, Borean Tundra"] = {
				["y"] = 65.1,
				["x"] = 18.6,
			},
			["Kamagua, Howling Fjord"] = {
				["y"] = 82.1,
				["x"] = 67.1,
			},
			["Moa'ki, Dragonblight"] = {
				["y"] = 66.1,
				["x"] = 46.9,
			},
			["Camp Tunka'lo, The Storm Peaks"] = {
				["y"] = 26.3,
				["x"] = 66.7,
			},
			["Death's Rise, Icecrown"] = {
				["y"] = 29.2,
				["x"] = 29.3,
			},
			["Unu'pe, Borean Tundra"] = {
				["y"] = 65.1,
				["x"] = 30.3,
			},
			["K3, The Storm Peaks"] = {
				["y"] = 39.1,
				["x"] = 57.4,
			},
			["Argent Tournament Grounds, Icecrown"] = {
				["y"] = 20.9,
				["x"] = 47,
			},
			["Bouldercrag's Refuge, The Storm Peaks"] = {
				["y"] = 20.9,
				["x"] = 53.6,
			},
			["Conquest Hold, Grizzly Hills"] = {
				["y"] = 62.4,
				["x"] = 63.8,
			},
			["The Argent Stand, Zul'Drak"] = {
				["y"] = 44.4,
				["x"] = 66,
			},
			["New Agamand, Howling Fjord"] = {
				["y"] = 85.2,
				["x"] = 75.9,
			},
			["Wyrmrest Temple, Dragonblight"] = {
				["y"] = 59.3,
				["x"] = 50.5,
			},
			["Amber Ledge, Borean Tundra"] = {
				["y"] = 59.8,
				["x"] = 20.1,
			},
			["River's Heart, Sholazar Basin"] = {
				["y"] = 44.5,
				["x"] = 26.6,
			},
			["Ebon Watch, Zul'Drak"] = {
				["y"] = 46.8,
				["x"] = 58.7,
			},
			["Grom'arsh Crash-Site, The Storm Peaks"] = {
				["y"] = 25.8,
				["x"] = 55.7,
			},
			["Bor'gorok Outpost, Borean Tundra"] = {
				["y"] = 52.7,
				["x"] = 21.4,
			},
			["Light's Breach, Zul'Drak"] = {
				["y"] = 47.1,
				["x"] = 63.5,
			},
			["Taunka'le Village, Borean Tundra"] = {
				["y"] = 60.9,
				["x"] = 30.1,
			},
			["Kor'kron Vanguard, Dragonblight"] = {
				["y"] = 49,
				["x"] = 45.6,
			},
			["Vengeance Landing, Howling Fjord"] = {
				["y"] = 73.1,
				["x"] = 84.6,
			},
			["Venomspite, Dragonblight"] = {
				["y"] = 62.6,
				["x"] = 55.3,
			},
			["Ulduar, The Storm Peaks"] = {
				["y"] = 17.8,
				["x"] = 58.8,
			},
			["Sunreaver's Command, Crystalsong Forest"] = {
				["y"] = 43.9,
				["x"] = 55.4,
			},
			["Camp Oneqwah, Grizzly Hills"] = {
				["y"] = 57.5,
				["x"] = 75.8,
			},
			["Camp Winterhoof, Howling Fjord"] = {
				["y"] = 67.3,
				["x"] = 75.1,
			},
			["The Argent Vanguard, Icecrown"] = {
				["y"] = 39.3,
				["x"] = 52.1,
			},
			["Zim'Torga, Zul'Drak"] = {
				["y"] = 42.4,
				["x"] = 70.9,
			},
			["Apothecary Camp, Howling Fjord"] = {
				["y"] = 71.6,
				["x"] = 67.5,
			},
			["Gundrak, Zul'Drak"] = {
				["y"] = 33.5,
				["x"] = 73.6,
			},
			["Agmar's Hammer, Dragonblight"] = {
				["y"] = 57.6,
				["x"] = 43.7,
			},
		},
	},
	["Alliance"] = {
		[572] = {
			["Wildwood Wash, Gorgrond"] = {
				["y"] = 31.5,
				["x"] = 62.7,
			},
			["Akeeta's Hovel, Shadowmoon Valley"] = {
				["y"] = 66.7,
				["x"] = 57.4,
			},
		},
		[875] = {
			["Xibala, Zuldazar"] = {
				["y"] = 78.8,
				["x"] = 47.2,
			},
			["Shatterstone Harbor, Vol'dun"] = {
				["y"] = 19.2,
				["x"] = 33.2,
			},
			["Sanctuary of the Devoted, Vol'dun"] = {
				["y"] = 27.2,
				["x"] = 28.6,
			},
			["Fort Victory, Nazmir"] = {
				["y"] = 26.9,
				["x"] = 62.5,
			},
			["Castaway Encampment, Zuldazar"] = {
				["y"] = 68.3,
				["x"] = 70.1,
			},
			["Redfield's Watch, Nazmir"] = {
				["y"] = 19,
				["x"] = 58.1,
			},
		},
		[113] = {
			["Transitus Shield, Coldarra"] = {
				["y"] = 59.9,
				["x"] = 16.4,
			},
			["Stars' Rest, Dragonblight"] = {
				["y"] = 60.5,
				["x"] = 41.2,
			},
			["Moa'ki, Dragonblight"] = {
				["y"] = 66.1,
				["x"] = 46.9,
			},
			["Wintergarde Keep, Dragonblight"] = {
				["y"] = 58.8,
				["x"] = 55.5,
			},
			["Valiance Keep, Borean Tundra"] = {
				["y"] = 70.3,
				["x"] = 24.3,
			},
			["Valgarde Port, Howling Fjord"] = {
				["y"] = 83.9,
				["x"] = 78.4,
			},
			["Ebon Watch, Zul'Drak"] = {
				["y"] = 46.8,
				["x"] = 58.7,
			},
			["Amberpine Lodge, Grizzly Hills"] = {
				["y"] = 60.9,
				["x"] = 66.4,
			},
			["Fizzcrank Airstrip, Borean Tundra"] = {
				["y"] = 55.5,
				["x"] = 23.6,
			},
			["Wyrmrest Temple, Dragonblight"] = {
				["y"] = 59.3,
				["x"] = 50.5,
			},
			["Light's Breach, Zul'Drak"] = {
				["y"] = 47.1,
				["x"] = 63.5,
			},
			["Amber Ledge, Borean Tundra"] = {
				["y"] = 59.8,
				["x"] = 20.1,
			},
			["Unu'pe, Borean Tundra"] = {
				["y"] = 65.1,
				["x"] = 30.3,
			},
		},
		[12] = {
			["Shadebough, Feralas"] = {
				["y"] = 70.5,
				["x"] = 46.1,
			},
			["Gunstan's Dig, Tanaris"] = {
				["y"] = 88.8,
				["x"] = 54.4,
			},
			["Theramore, Dustwallow Marsh"] = {
				["y"] = 65.7,
				["x"] = 58.6,
			},
			["Moonglade"] = {
				["y"] = 19.7,
				["x"] = 53.1,
			},
			["Tower of Estulan, Feralas"] = {
				["y"] = 69.9,
				["x"] = 42.3,
			},
			["Thal'darah Overlook, Stonetalon Mountains"] = {
				["y"] = 41.4,
				["x"] = 42.1,
			},
			["Astranaar, Ashenvale"] = {
				["y"] = 38.6,
				["x"] = 47.1,
			},
			["Forest Song, Ashenvale"] = {
				["y"] = 37.9,
				["x"] = 55,
			},
			["Stardust Spire, Ashenvale"] = {
				["y"] = 42.4,
				["x"] = 47.2,
			},
			["Everlook, Winterspring"] = {
				["y"] = 22.4,
				["x"] = 59.2,
			},
			["Azure Watch, Azuremyst Isle"] = {
				["y"] = 26.5,
				["x"] = 32.5,
			},
			["Gadgetzan, Tanaris"] = {
				["y"] = 79.4,
				["x"] = 56.6,
			},
			["Whisperwind Grove, Felwood"] = {
				["y"] = 25.3,
				["x"] = 48.6,
			},
			["Oasis of Vir'sar, Uldum"] = {
				["y"] = 84.3,
				["x"] = 44.2,
			},
			["Thunk's Abode, Desolace"] = {
				["y"] = 52.3,
				["x"] = 43.5,
			},
			["Grove of Aessina, Hyjal"] = {
				["y"] = 29.1,
				["x"] = 51.1,
			},
			["Shrine of Aviana, Hyjal"] = {
				["y"] = 29.8,
				["x"] = 53.6,
			},
			["Nordrassil, Hyjal"] = {
				["y"] = 27.4,
				["x"] = 56,
			},
			["Blackfathom Camp, Ashenvale"] = {
				["y"] = 34.3,
				["x"] = 44.5,
			},
			["Ramkahen, Uldum"] = {
				["y"] = 88.5,
				["x"] = 49.2,
			},
			["Northwatch Expedition Base Camp, Stonetalon Mountains"] = {
				["y"] = 49.2,
				["x"] = 47.1,
			},
			["Emerald Sanctuary, Felwood"] = {
				["y"] = 33.9,
				["x"] = 49.9,
			},
			["Windshear Hold, Stonetalon Mountains"] = {
				["y"] = 45,
				["x"] = 45.2,
			},
			["Ethel Rethor, Desolace"] = {
				["y"] = 51.6,
				["x"] = 39.6,
			},
			["Northwatch Hold, Southern Barrens"] = {
				["y"] = 58.8,
				["x"] = 56,
			},
			["Dolanaar, Teldrassil"] = {
				["y"] = 9.9,
				["x"] = 43.7,
			},
			["Marshal's Stand, Un'Goro Crater"] = {
				["y"] = 80.9,
				["x"] = 50.5,
			},
			["Grove of the Ancients, Darkshore"] = {
				["y"] = 29.9,
				["x"] = 45.9,
			},
			["Karnum's Glade, Desolace"] = {
				["y"] = 54.4,
				["x"] = 41.9,
			},
			["Mudsprocket, Dustwallow Marsh"] = {
				["y"] = 68.7,
				["x"] = 55.1,
			},
			["Nijel's Point, Desolace"] = {
				["y"] = 49.6,
				["x"] = 42.7,
			},
			["Sanctuary of Malorne, Hyjal"] = {
				["y"] = 32.2,
				["x"] = 52.1,
			},
			["Wildheart Point, Felwood"] = {
				["y"] = 30.8,
				["x"] = 48.7,
			},
			["Honor's Stand, Southern Barrens"] = {
				["y"] = 51.5,
				["x"] = 50.5,
			},
			["Thargad's Camp, Desolace"] = {
				["y"] = 57,
				["x"] = 39.3,
			},
			["Feathermoon, Feralas"] = {
				["y"] = 68.3,
				["x"] = 40.4,
			},
			["Rut'theran Village, Teldrassil"] = {
				["y"] = 16,
				["x"] = 43.7,
			},
			["Talonbranch Glade, Felwood"] = {
				["y"] = 24.8,
				["x"] = 51.4,
			},
			["Schnottz's Landing, Uldum"] = {
				["y"] = 93.8,
				["x"] = 43.4,
			},
			["The Exodar"] = {
				["y"] = 25.5,
				["x"] = 30.1,
			},
			["Lor'danel, Darkshore"] = {
				["y"] = 19.7,
				["x"] = 47.2,
			},
			["Darnassus, Teldrassil"] = {
				["y"] = 9.5,
				["x"] = 39.2,
			},
			["Mirkfallon Post, Stonetalon Mountains"] = {
				["y"] = 44.5,
				["x"] = 43.5,
			},
			["Fizzle & Pozzik's Speedbarge, Thousand Needles"] = {
				["y"] = 74.9,
				["x"] = 57,
			},
			["Dreamer's Rest, Feralas"] = {
				["y"] = 62.9,
				["x"] = 41,
			},
			["Farwatcher's Glen, Stonetalon Mountains"] = {
				["y"] = 46.2,
				["x"] = 40.9,
			},
			["Blood Watch, Bloodmyst Isle"] = {
				["y"] = 17.6,
				["x"] = 31,
			},
			["Bootlegger Outpost, Tanaris"] = {
				["y"] = 85.5,
				["x"] = 57.4,
			},
			["Fort Triumph, Southern Barrens"] = {
				["y"] = 63,
				["x"] = 52.5,
			},
			["Mossy Pile, Un'Goro Crater"] = {
				["y"] = 78.5,
				["x"] = 49.3,
			},
			["Ratchet, Northern Barrens"] = {
				["y"] = 53.8,
				["x"] = 56.6,
			},
			["Gates of Sothann, Hyjal"] = {
				["y"] = 33.6,
				["x"] = 57.1,
			},
		},
		[876] = {
			["Flight"] = {
				["Brennadam, Stormsong Valley"] = {
					["y"] = 33.8,
					["x"] = 57.9,
				},
				["Castaway Point, Tiragarde Sound"] = {
					["y"] = 81.7,
					["x"] = 68.4,
				},
				["The Amber Waves, Stormsong Valley"] = {
					["y"] = 33.6,
					["x"] = 54,
				},
				["Shrine of the Storm, Stormsong Valley"] = {
					["y"] = 15.7,
					["x"] = 65.9,
				},
				["Kennings Lodge, Tiragarde Sound"] = {
					["y"] = 72.9,
					["x"] = 62.9,
				},
				["Bridgeport, Tiragarde Sound"] = {
					["y"] = 63.4,
					["x"] = 62.4,
				},
				["Barbthorn Ridge, Drustvar"] = {
					["y"] = 58.3,
					["x"] = 44.4,
				},
				["Fallhaven, Drustvar"] = {
					["y"] = 63.1,
					["x"] = 41.1,
				},
				["Freehold, Tiragarde Sound"] = {
					["y"] = 82.8,
					["x"] = 63.1,
				},
				["Outrigger Post, Tiragarde Sound"] = {
					["y"] = 50,
					["x"] = 39.5,
				},
				["Proudmoore Keep, Tiragarde Sound"] = {
					["y"] = 56,
					["x"] = 58.5,
				},
				["Tradewinds Market, Tiragarde Sound"] = {
					["y"] = 49.2,
					["x"] = 61.1,
				},
				["Mariner's Row, Tiragarde Sound"] = {
					["y"] = 57,
					["x"] = 62.5,
				},
				["Tidecross, Stormsong Valley"] = {
					["y"] = 24,
					["x"] = 60.4,
				},
				["Vigil Hill, Tiragarde Sound"] = {
					["y"] = 70.7,
					["x"] = 52.1,
				},
				["Norwington Estate, Tiragarde Sound"] = {
					["y"] = 52.2,
					["x"] = 49.3,
				},
				["Millstone Hamlet, Stormsong Valley"] = {
					["y"] = 32.1,
					["x"] = 45.3,
				},
				["Seekers Vista, Stormsong Valley"] = {
					["y"] = 19.4,
					["x"] = 49.3,
				},
				["Arom's Stand, Drustvar"] = {
					["y"] = 70.9,
					["x"] = 33.6,
				},
				["Mildenhall Meadery, Stormsong Valley"] = {
					["y"] = 31.4,
					["x"] = 61.7,
				},
				["Roughneck Camp, Tiragarde Sound"] = {
					["y"] = 48.9,
					["x"] = 43.4,
				},
				["Whitegrove Chapel, Drustvar"] = {
					["y"] = 55.1,
					["x"] = 28.1,
				},
				["Hatherford, Tiragarde Sound"] = {
					["y"] = 49,
					["x"] = 57.3,
				},
				["Fort Daelin, Stormsong Valley"] = {
					["y"] = 23.7,
					["x"] = 46.8,
				},
				["Deadwash, Stormsong Valley"] = {
					["y"] = 28.1,
					["x"] = 50.5,
				},
			},
			["Boat"] = {
				["Firebreaker Expedition, Tiragarde Sound"] = {
					["y"] = 53.2,
					["x"] = 55.6,
				},
				["Fletcher's Hollow, Drustvar"] = {
					["y"] = 73,
					["x"] = 47.3,
				},
				["Eastpoint Station, Tiragarde Sound"] = {
					["y"] = 60.9,
					["x"] = 61.4,
				},
				["Anglepoint Wharf, Tiragarde Sound"] = {
					["y"] = 53.3,
					["x"] = 43.2,
				},
				["Fallhaven, Drustvar"] = {
					["y"] = 63.9,
					["x"] = 44,
				},
				["Old Drust Road, Tiragarde Sound"] = {
					["y"] = 66,
					["x"] = 50,
				},
				["Southwind Station, Tiragarde Sound"] = {
					["y"] = 64,
					["x"] = 57.2,
				},
			},
		},
		[619] = {
			["Felbane Camp, Highmountain"] = {
				["y"] = 17.1,
				["x"] = 39.9,
			},
			["Illidari Perch, Azsuna"] = {
				["y"] = 59.6,
				["x"] = 28.4,
			},
			["Illidari Stand, Azsuna"] = {
				["y"] = 58.7,
				["x"] = 32.9,
			},
			["Sylvan Falls, Highmountain"] = {
				["y"] = 27.1,
				["x"] = 42.1,
			},
			["Felblaze Ingress, Azsuna"] = {
				["y"] = 53.4,
				["x"] = 39.6,
			},
			["Challiane's Terrace, Azsuna"] = {
				["y"] = 46.6,
				["x"] = 31.6,
			},
			["Stonehoof Watch, Highmountain"] = {
				["y"] = 26.8,
				["x"] = 50.9,
			},
			["Shackle's Den, Azsuna"] = {
				["y"] = 64,
				["x"] = 36.9,
			},
			["Valdisdall, Stormheim"] = {
				["y"] = 32.3,
				["x"] = 61.4,
			},
			["Dalaran"] = {
				["y"] = 64.6,
				["x"] = 46.7,
			},
			["Skyhorn, Highmountain"] = {
				["y"] = 19.3,
				["x"] = 48.4,
			},
			["Garden of the Moon, Val'sharah"] = {
				["y"] = 35.1,
				["x"] = 35.1,
			},
			["Bradensbrook, Val'sharah"] = {
				["y"] = 35.4,
				["x"] = 30.9,
			},
			["Greywatch, Stormheim"] = {
				["y"] = 35,
				["x"] = 65,
			},
			["Lorna's Watch, Stormheim"] = {
				["y"] = 36.2,
				["x"] = 54.3,
			},
			["Starsong Refuge, Val'sharah"] = {
				["y"] = 33.1,
				["x"] = 38.7,
			},
			["Skyfire Triage Camp, Stormheim"] = {
				["y"] = 32.2,
				["x"] = 53.1,
			},
			["Lorlathil, Val'sharah"] = {
				["y"] = 39.5,
				["x"] = 34.6,
			},
			["Nesingwary, Highmountain"] = {
				["y"] = 22.1,
				["x"] = 43.8,
			},
			["Gloaming Reef, Val'sharah"] = {
				["y"] = 37.7,
				["x"] = 26.1,
			},
			["Azurewing Repose, Azsuna"] = {
				["y"] = 53.2,
				["x"] = 34.2,
			},
			["Stormtorn Foothills, Stormheim"] = {
				["y"] = 27.2,
				["x"] = 58.8,
			},
			["Thunder Totem, Highmountain"] = {
				["y"] = 24.7,
				["x"] = 46.3,
			},
			["The Witchwood, Highmountain"] = {
				["y"] = 17,
				["x"] = 43,
			},
			["Prepfoot, Highmountain"] = {
				["y"] = 13.1,
				["x"] = 50.5,
			},
			["Shipwreck Cove, Highmountain"] = {
				["y"] = 6.3,
				["x"] = 44.4,
			},
		},
		[13] = {
			["Sentinel Hill, Westfall"] = {
				["y"] = 80,
				["x"] = 42,
			},
			["Shalewind Canyon, Redridge"] = {
				["y"] = 76.6,
				["x"] = 53.1,
			},
			["Fort Livingston, Stranglethorn"] = {
				["y"] = 88.4,
				["x"] = 45.6,
			},
			["Thelsamar, Loch Modan"] = {
				["y"] = 61.1,
				["x"] = 51.7,
			},
			["Hearthglen, Western Plaguelands"] = {
				["y"] = 30.7,
				["x"] = 48.2,
			},
			["Thondroril River, Eastern Plaguelands"] = {
				["y"] = 34,
				["x"] = 51.2,
			},
			["Darkshire, Duskwood"] = {
				["y"] = 79.8,
				["x"] = 47.7,
			},
			["Light's Hope Chapel, Eastern Plaguelands"] = {
				["y"] = 32.8,
				["x"] = 57.7,
			},
			["Aerie Peak, The Hinterlands"] = {
				["y"] = 40.1,
				["x"] = 49.5,
			},
			["Goldshire, Elwynn"] = {
				["y"] = 75.9,
				["x"] = 44.3,
			},
			["Stormwind, Elwynn"] = {
				["y"] = 73.7,
				["x"] = 43.4,
			},
			["Chillwind Camp, Western Plaguelands"] = {
				["y"] = 37.7,
				["x"] = 48.1,
			},
			["Shattered Sun Staging Area"] = {
				["y"] = 2,
				["x"] = 55.6,
			},
			["Marshtide Watch, Swamp of Sorrows"] = {
				["y"] = 78.6,
				["x"] = 54,
			},
			["Booty Bay, Stranglethorn"] = {
				["y"] = 94.4,
				["x"] = 43.4,
			},
			["Menethil Harbor, Wetlands"] = {
				["y"] = 55.1,
				["x"] = 46.5,
			},
			["Morgan's Vigil, Burning Steppes"] = {
				["y"] = 71.9,
				["x"] = 51.3,
			},
			["Lakeshire, Redridge"] = {
				["y"] = 75.8,
				["x"] = 50,
			},
			["Fuselight, Badlands"] = {
				["y"] = 65.3,
				["x"] = 54.1,
			},
			["Camp Everstill, Redridge"] = {
				["y"] = 75.9,
				["x"] = 51.5,
			},
			["Eastvale Logging Camp, Elwynn"] = {
				["y"] = 76,
				["x"] = 47.8,
			},
			["Ironforge, Dun Morogh"] = {
				["y"] = 58.9,
				["x"] = 47.4,
			},
			["Rebel Camp, Stranglethorn Vale"] = {
				["y"] = 82.9,
				["x"] = 45.1,
			},
			["Thorium Point, Searing Gorge"] = {
				["y"] = 65.3,
				["x"] = 47.4,
			},
			["The Menders' Stead, Western Plaguelands"] = {
				["y"] = 34.2,
				["x"] = 48.9,
			},
			["Raven Hill, Duskwood"] = {
				["y"] = 80.7,
				["x"] = 43.9,
			},
			["Refuge Pointe, Arathi"] = {
				["y"] = 45.7,
				["x"] = 50.7,
			},
		},
	},
}

AAP.Data.ZoneSources = AAP.Data.ZoneSources or {}
AAP.Data.ZoneSources.FlightPoints = flightPoints
AAP.Data:RegisterZones(flightPoints)
