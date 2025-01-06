--- Welcome to Lobcorp spaghetti code

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local config = SMODS.current_mod.config
local folder = string.match(mod_path, "[Mm]ods.*")
-- Since Cryptid completely overrides create_card, make sure it is only patched later, and only when needed
create_card_late_patched = false

--=============== STEAMODDED OBJECTS ===============--

-- To disable any object, comment it out by adding -- at the start of the line.
local joker_list = {
	--- Common
	--"one_sin",

	--- Uncommon
	--"scorched_girl",

	--- Rare
	--"queen_of_hatred",

	--- Legendary
	"suture",
}
local enhancement_list = {
	"confection",
	"null",
}
local seal_list = {
	--"serpentine",
}
local edition_list = {
	"torn",
	"sundered",
	"ripped",
	"shredded",
}
local consumable_list = {
	--- Tarots
	"forge",
	"gluttony",
	--- Planets
	--- Spectrals
	--"disfiguration",
}

local badge_colors = {
	--EGO_Gift = HEX('DD4930'),
}
-- Badge colors
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
	return badge_colors[key] or get_badge_colourref(key)
end

-- Load all jokers
for _, v in ipairs(joker_list) do
	local joker = SMODS.load_file("content/jokers/" .. v .. ".lua")()

	--joker.discovered = true
	if joker.dependency and not (SMODS.Mods[joker.dependency] or {}).can_load then goto continue end
	joker.key = v
	joker.atlas = "Rufia_Jokers"
	--[[if not joker.yes_pool_flag then
		joker.yes_pool_flag = "allow_abnormalities_in_shop"
	end]]--
	--joker.config.discover_rounds = 0

	if not joker.pos then
		joker.pos = { x = 0, y = 0 }
	end

	local joker_obj = SMODS.Joker(joker)

	for k_, v_ in pairs(joker) do
		if type(v_) == 'function' then
			joker_obj[k_] = joker[k_]
		end
	end

	if not joker.set_sprites then
		joker_obj.set_sprites = function(self, card, front)
			card.children.center.atlas = G.ASSET_ATLAS["rufia_Rufia_Jokers"]
			card.children.center:set_sprite_pos(card.config.center.pos)
		end
	end
	::continue::
end

--local enh_confection = NFS.load(SMODS.current_mod.path .. 'content/enhancements/confection.lua')()
--local enh_confection = SMODS.load_file("content/enhancements/confection.lua")()
--enh_confection.key = "confection"
--enh_confection.atlas = "Rufia_Modifications"
--SMODS.Enhancement(enh_confection)

-- Load all enhancements
for _, v in ipairs(enhancement_list) do
	local enhance = SMODS.load_file("content/enhancements/" .. v .. ".lua")()

	if enhance.dependency and not (SMODS.Mods[joker.dependency] or {}).can_load then goto continue end
	enhance.key = v
	enhance.atlas = "Rufia_Modifications"
	--joker.config.discover_rounds = 0

	local enhance_obj = SMODS.Enhancement(enhance)

	for k_, v_ in pairs(enhance) do
		if type(v_) == 'function' then
			enhance_obj[k_] = enhance[k_]
		end
	end

	if not enhance.set_sprites then
		enhance_obj.set_sprites = function(self, card, front)
			card.children.center.atlas = G.ASSET_ATLAS["rufia_Rufia_Modifications"]
			card.children.center:set_sprite_pos(card.config.center.pos)
		end
	end
	::continue::
end



-- Load all editions
for _, v in ipairs(edition_list) do
	local edition = SMODS.load_file("content/editions/" .. v .. ".lua")()

	if edition.dependency and not (SMODS.Mods[joker.dependency] or {}).can_load then goto continue end
	edition.key = v
	--edition.atlas = "Rufia_Modifications"
	--joker.config.discover_rounds = 0

	local edition_obj = SMODS.Edition(edition)
	SMODS.Shader({ key = v, path = v .. ".fs" })

	for k_, v_ in pairs(edition) do
		if type(v_) == 'function' then
			edition_obj[k_] = edition[k_]
		end
	end

	::continue::
end
--[[ -- Load consumables
for _, v in ipairs(consumable_list) do
	local cons = SMODS.load_file("content/consumables/" .. v .. ".lua")()

	cons.key = v
	cons.atlas = "Rufia_Consumables"
	cons.discovered = true
	cons.alerted = true
	local cons_obj = SMODS.Consumable(cons)

	for k_, v_ in pairs(cons) do
		if type(v_) == 'function' then
			cons_obj[k_] = cons[k_]
		end
	end
end ]]






-- Atlases
SMODS.Atlas({ 
	key = "Rufia_Jokers", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_jokers.png", 
	px = 71, 
	py = 95 
})
SMODS.Atlas({ 
	key = "Rufia_Consumables", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_consumables.png", 
	px = 71, 
	py = 95 
})
SMODS.Atlas({ 
	key = "Rufia_Modifications", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_modifications.png", 
	px = 71, 
	py = 95 
})

-- Clear all Cathys
sendInfoMessage("Loaded Rufia's Retinue!")
