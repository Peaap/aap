-- Passive static data definitions extracted by Stage 3 Task 2.2.
AAP = AAP or {}
AAP.Data = AAP.Data or {}

local bonusObjectives = {
---- WoD Nonus Obj ----
	[36473] = 1,
---- Legion Bonus Obj ----
	[36811] = 1,
	[37466] = 1,
	[37779] = 1,
	[37965] = 1,
	[37963] = 1,
	[37495] = 1,
	[39393] = 1,
	[38842] = 1,
	[43241] = 1,
	[38748] = 1,
	[38716] = 1,
	[39274] = 1,
	[39576] = 1,
	[39317] = 1,
	[39371] = 1,
	[42373] = 1,
	[40316] = 1,
	[38442] = 1,
	[38343] = 1,
	[38939] = 1,
	[39998] = 1,
	[38374] = 1,
	[39119] = 1,
	[9785] = 1,
---- Duskwood ----
	[26623] = 1,
---- Hillsbrad Foothills ----
	[28489] = 1,
--- DH Start Area ----
	[39279] = 1,
	[39742] = 1,
}

local coreBothBreadcrumbs = {
		[39516] = {
			39515,
		},
		[39515] = {
			39516,
		},
		[38723] = {
			40253,
		},
		[40253] = {
			38723,
		},
		[39683] = {
			40254,
		},
		[40254] = {
			39683,
		},
		[39688] = {
			40256,
		},
		[40256] = {
			39688,
		},
		[39690] = {
			39689,
		},
		[39689] = {
			39690,
		},
	}

local vanillaAllianceBreadcrumbs = {
		[26728] = {
			26618,
		},
	}

local vanillaHordeBreadcrumbs = {
		[28344] = {
			28345,
		},
	}

local tbcAllianceBreadcrumbs = {
		[12157] = {
			12000,
			12166,
		},
		[11928] = {
			11901,
		},
	}

local bfaAllianceBreadcrumbs = {
		[48948] = {
			48793,
			48792,
        },
		[50158] = {
			50134,
			50135,
		},
		[50157] = {
			50041,
		},
		[49869] = {
			52750,
			49737,
		},
		[51151] = {
			49225,
			49229,
		},
		[50542] = {
			49897,
			49531,
		},
		[50349] = {
			50351,
			50352,
		},
		[49418] = {
			49433,
			49435,
		},
		[49225] = {
			49260,
		},
		[47485] = {
			47486,
			47488,
			47487,
		},
		[50544] = {
			48874,
			48873,
			48879,
		},
		[49393] = {
			49394,
			49395,
		},
		[50531] = {
			53041,
		},
		[49072] = {
			49039,
		},
		[50699] = {
			49465,
			49452,
		},
		[51144] = {
			48070,
		},
		[49290] = {
			49407,
		},
		[50612] = {
			50777,
			50778,
		},
		[50797] = {
			51343,
			51339,
			51352,
		},
		[50622] = {
			50354,
			50353,
		},
		[51582] = {
			50343,
		},
		[51554] = {
			50810,
			50674,
			50802,
		},
		[51140] = {
			50741,
		},
		[53045] = {
			50376,
		},
		[51552] = {
			49745,
			49744,
			49746,
		},
		[50675] = {
			50696,
			50704,
			50691,
			50697,
		},
		[49818] = {
			50621,
			50614,
			50616,
		},
	}

AAP.Data.QuestSources = AAP.Data.QuestSources or {}
AAP.Data.QuestSources.BonusObjectives = bonusObjectives
AAP.Data:RegisterQuests(bonusObjectives)
AAP.Data.QuestSources.CoreBothBreadcrumbs = coreBothBreadcrumbs
AAP.Data:RegisterQuests(coreBothBreadcrumbs)
AAP.Data.QuestSources.VanillaAllianceBreadcrumbs = vanillaAllianceBreadcrumbs
AAP.Data:RegisterQuests(vanillaAllianceBreadcrumbs)
AAP.Data.QuestSources.VanillaHordeBreadcrumbs = vanillaHordeBreadcrumbs
AAP.Data:RegisterQuests(vanillaHordeBreadcrumbs)
AAP.Data.QuestSources.TbcAllianceBreadcrumbs = tbcAllianceBreadcrumbs
AAP.Data:RegisterQuests(tbcAllianceBreadcrumbs)
AAP.Data.QuestSources.BfaAllianceBreadcrumbs = bfaAllianceBreadcrumbs
AAP.Data:RegisterQuests(bfaAllianceBreadcrumbs)
