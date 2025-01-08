--- Welcome to Lobcorp spaghetti code

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local config = SMODS.current_mod.config
local folder = string.match(mod_path, "[Mm]ods.*")
-- Since Cryptid completely overrides create_card, make sure it is only patched later, and only when needed
create_card_late_patched = false

--================= GAME COLOURS ===================--
-- red = G.C.RED,
-- mult = G.C.MULT,
-- blue = G.C.BLUE,
-- chips = G.C.CHIPS,
-- green = G.C.GREEN,
-- money = G.C.MONEY,
-- gold = G.C.GOLD,
-- attention = G.C.FILTER,
-- purple = G.C.PURPLE,
-- white = G.C.WHITE,
-- inactive = G.C.UI.TEXT_INACTIVE,
-- spades = G.C.SUITS.Spades,
-- hearts = G.C.SUITS.Hearts,
-- clubs = G.C.SUITS.Clubs,
-- diamonds = G.C.SUITS.Diamonds,
-- tarot = G.C.SECONDARY_SET.Tarot,
-- planet = G.C.SECONDARY_SET.Planet,
-- spectral = G.C.SECONDARY_SET.Spectral,
-- edition = G.C.EDITION,
-- dark_edition = G.C.DARK_EDITION,
-- legendary = G.C.RARITY[4],
-- enhanced = G.C.SECONDARY_SET.Enhanced
--=============== STEAMODDED OBJECTS ===============--

-- To disable any object, comment it out by adding -- at the start of the line.
local joker_list = {
	--- Common
	--"one_sin",

	--- Uncommon
	--"perpetuity",

	--- Rare
	"patience",

	--- Legendary
	"suture",
	"queen of tarts",
	"matthias",
}
local enhancement_list = {
	"confection",
	"null",
	"hypnotic",
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

local amoeba = {
	name = "Amoeba",
	slug = 'rufia_amoeba',
	key = 'rufia_amoeba',
	desc = {
		"{X:red,C:white}X#1#{} Mult,",
		"duplicate this {C:attention}Joker",
		"when {C:attention}Blind{} is selected",
		"{C:inactive}(Must have room)"
	},
	config = {
		extra = 1.5
	},
	pos = {x = 3, y = 1},
	rarity = 3,
	cost = 9,
	loc_def = function(card) return {
		card.ability.extra} end,
	blueprint_compat = false,
	eternal_compat = false
}

amoeba.calculate = function(self, context)
	if context.setting_blind and not self.getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
		G.GAME.joker_buffer = G.GAME.joker_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = function() 
				local card = copy_card(self, nil, nil, nil, self.edition and self.edition.negative)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				G.GAME.joker_buffer = 0
				return true
			end}))
		card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Mitosis!"}) 
	elseif context.joker_main then
		return {
			message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra}},
			Xmult_mod = self.ability.extra
		}
	end
end

--SMODS.Joker(amoeba)

local amoeba_joker = SMODS.Joker:new(
	amoeba.name, 
	amoeba.slug, 
	amoeba.config,
	amoeba.pos,
	{name = amoeba.name, text = amoeba.desc},
	amoeba.rarity,
	amoeba.cost, 
	nil, 
	nil, 
	amoeba.blueprint_compat, 
	amoeba.eternal_compat, 
	nil, 
	'new_jokers',
	nil
)
amoeba_joker.atlas = "Rufia_Jokers"
amoeba_joker.loc_def = amoeba.loc_def
amoeba_joker:register()


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
