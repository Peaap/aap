-- Passive static data definitions extracted by Stage 3 Task 2.2.
AAP = AAP or {}
AAP.Data = AAP.Data or {}

local brutalCCList = {
	[131515] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[120951] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[123007] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127079] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[124801] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[122666] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[128770] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[124976] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[137089] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[122754] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[131153] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[139440] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[124977] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[126890] = {
		["Fearable"] = 1,
		["Stunable"] = 1,
		["Interruptable"] = 1,
	},
	[128184] = {
		["Interruptable"] = 1,
	},
	[122866] = {
		["Fearable"] = 1,
		["Stunable"] = 1,
	},
	[133980] = {
		["Interruptable"] = 1,
	},
	[120850] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[141521] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[124978] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[126891] = {
		["Fearable"] = 1,
		["Stunable"] = 1,
		["Interruptable"] = 1,
	},
	[133140] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[120946] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[134601] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127074] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[123653] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127225] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[123550] = {
		["Stunable"] = 1,
	},
	[133570] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[123328] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[136428] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[139365] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[133539] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[123757] = {
		["Stunable"] = 1,
	},
	[128472] = {
		["Stunable"] = 1,
	},
	[136334] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127766] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[125996] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127298] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[126703] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[137082] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[131256] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[130466] = {
		["Fearable"] = 1,
		["Stunable"] = 1,
	},
	[126616] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[132650] = {
		["Stunable"] = 1,
	},
	[127394] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[132230] = {
		["Stunable"] = 1,
	},
	[133400] = {
		["Stunable"] = 1,
	},
	[129323] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[120949] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127072] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[128712] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[130948] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[128728] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[130260] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[137084] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[134052] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[122664] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[130713] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[128474] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[124085] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[133297] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[124652] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[122204] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[131241] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[120950] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[129848] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[132979] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[124088] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[126316] = {
		["Fearable"] = 1,
		["Stunable"] = 1,
	},
	[130741] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[131555] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[121504] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[130412] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[125328] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127919] = {
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[127935] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
		["Fearable"] = 1,
	},
	[126888] = {
		["Stunable"] = 1,
		["Interruptable"] = 1,
	},
	[127073] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[133172] = {
		["Interruptable"] = 1,
		["Stunable"] = 1,
	},
	[133472] = {
		["Interruptable"] = 1,
	},
}

local allyBoatNpcs = {
	[135064] = 1,
	[132105] = 1,
	[132039] = 1,
	[132146] = 1,
	[132166] = 1,
	[132044] = 1,
	[132116] = 1,
	[135056] = 1,
}

AAP.Data.NPCSources = AAP.Data.NPCSources or {}
AAP.Data.NPCSources.BrutalCCList = brutalCCList
AAP.Data.NPCSources.AllyBoatNpcs = allyBoatNpcs
AAP.Data:RegisterNPCs(brutalCCList)
AAP.Data:RegisterNPCs(allyBoatNpcs)
