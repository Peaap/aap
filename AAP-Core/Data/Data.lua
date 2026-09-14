-- Stage 2 Data: passive route and metadata registration only.
-- AAP.Data has no runtime, lifecycle, engine, or presentation dependencies.

AAP = AAP or {}
AAP.Data = AAP.Data or {}
AAP.Data.Dependencies = AAP.Data.Dependencies or {}
AAP.Data.RouteRegistry = AAP.Data.RouteRegistry or {}

local function registerRouteTable(registry, routes)
	if (type(routes) ~= "table") then
		return 0
	end

	local registered = 0
	for routeKey, steps in pairs(routes) do
		if (type(steps) == "table") then
			-- Retain the legacy route value directly. The Data boundary owns this
			-- registry mapping, but never rewrites route keys or step schemas.
			registry[routeKey] = steps
			registered = registered + 1
		end
	end
	return registered
end

function AAP.Data:RegisterRoutes(routes)
	return registerRouteTable(self.RouteRegistry, routes)
end

function AAP.Data:RegisterLegacyRouteTables(...)
	local registered = 0
	for index = 1, select("#", ...) do
		registered = registered + self:RegisterRoutes(select(index, ...))
	end
	return registered
end

function AAP.Data:RegisterAvailableLegacyRoutes()
	-- Core-zone and expansion route providers historically merge these tables
	-- into AAP.QuestStepList. Temporary tables are also accepted so providers
	-- can register before performing that legacy merge.
	return self:RegisterLegacyRouteTables(
		AAP.QuestStepList,
		AAP.QuestStepListBoth,
		AAP.QuestStepList2060,
		AAP.QuestStepList2062
	)
end

function AAP.Data:RouteFor(routeKey)
	return self.RouteRegistry[routeKey]
end

-- Match the DataApi naming used by the engine design while preserving the
-- existing Lua-style method name for direct addon callers.
AAP.Data.routeFor = AAP.Data.RouteFor
