--- Mod structure modelled significantly after the Lobcorp mod structure <3

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local mod_settings = SMODS.current_mod.config
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
	"pedestrian/stop",
	"pedestrian/withheld number",
	--"queen of tarts/white rabbit",
	--"queen of tarts/cheshire",
	--"queen of tarts/mad hatter",
	--"queen of tarts/the march hare",
	--"queen of tarts/the dormouse",
	--"queen of tarts/knave of hearts",
	--"queen of tarts/cowgirl",
	--"queen of tarts/bread and butterfly",
	--"queen of tarts/flamingo lollipop",
	--"queen of tarts/gummy catterpillar",
	--"queen of tarts/jabberwock",
	--"queen of tarts/candyfloss sheep",
	--"queen of tarts/tweedledee",
	--"queen of tarts/tweedledum",
	--"queen of tarts/humpty dumpty",
	--"queen of tarts/page of hearts",
	--"queen of tarts/page of tiles",
	--"queen of tarts/page of pikes",
	--"queen of tarts/page of clovers",
	--"suture/handy hydra/the beadle",
	--"suture/handy hydra/the constable",
	--"suture/hobby horse",
	--"suture/jack in the box",
	--"suture/playground rocker",
	"suture/todd weaver",
	--"demons/drone",
	--"leech",
	--"nomios",
	--"follyfish",
	--"anasdesia",
	--"orran",
	--"rat maid",

	--- Uncommon
	--"medusa",
	--"euryale",
	--"stheno",
	"pedestrian/sign of things to come",
	--"matthias/calliope",
	--"matthias/clio",
	--"matthias/erato",
	--"matthias/euterpe",
	--"matthias/melpomene",
	--"matthias/polyhymnia",
	--"matthias/thalia",
	--"matthias/urania",
	--"matthias/terpsichore",
	"queen of tarts/cake knife",
	--"queen of tarts/amber slime",
	--"queen of tarts/caramel imp",
	--"queen of tarts/gummy frog",
	--"queen of tarts/taiyaki fish",
	--"queen of tarts/white rose",
	--"suture/handy hydra/punch",
	--"suture/handy hydra/the devil",
	--"suture/handy hydra/the puppeteers",
	--"suture/handy hydra/the hangman",
	--"suture/handy hydra/the skeleton",
	--"suture/handy hydra/the mime",
	"suture/langwidere",
	--"suture/lophop",
	--"suture/hopper",
	--"suture/gala",
	--"suture/nightcap",
	--"suture/owl",
	--"suture/possum",
	"suture/perpetuity",
	-- "suture/obedience",
	-- "suture/silence",
	-- "suture/adversity",
	-- "suture/shame",
	-- "suture/proliferation",
	-- "suture/trust",
	--"judgement hour",

	--- Rare
	"pedestrian/mixed signals",
	--"matthias/ziggurat",
	--"queen of tarts/queen bee",
	--"queen of tarts/the red queen",
	--"queen of tarts/the white queen",
	--"queen of tarts/duchess of hearts",
	--"queen of tarts/duchess of tiles",
	--"queen of tarts/duchess of pikes",
	--"queen of tarts/duchess of clovers",
	--"suture/handy hydra/handy hydra",
	--"suture/handy hydra/the crocodile",
	"angels/patience",
	--"angels/chastity",
	--"angels/diligence",
	--"angels/humility",
	--"angels/temperance",
	--"angels/charity",
	--"angels/kindness",
	--"angels/pandaemonium",
	--"demons/dantelian",
	--"demons/karabas",
	--"demons/narcissus",
	--"en-v",

	--- Legendary
	"matthias/matthias",
	"queen of tarts/queen of tarts",
	"suture/suture",
	-- "angels/archangel assimilation",
	-- "angels/tryphochor",
	-- "demons/voyeur",
	-- "demons/malphas",
	-- "coronet",
	-- "mr light",
	-- "inferno",
	-- "purgatorio",
	-- "paradiso",
	-- "the empress",
	-- "the great god nym",
	--"maw",

	--- Special
	-- "suture/obedience/precept 1",
	-- "suture/obedience/precept 2",
	-- "suture/obedience/precept 3",
	-- "suture/obedience/precept 4",
	-- "suture/obedience/precept 5",
	-- "suture/obedience/precept 6",
	-- "suture/obedience/precept 7",
	-- "suture/obedience/precept 8",
	-- "suture/obedience/precept 9",
	-- "suture/obedience/precept 10",
}
local voucher_list = {
	--- 'Free' Legendary Joker Voucher
	"pandoras box",
	"hope",
	--- Torn Voucher
	--"torn asunder",
	--"ripped to shreds"
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
	"banquet",
	"apparatus",
	"piper",
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



-- Load Modified m6x11 Font
local nativefs = require("nativefs")
local lovely = require("lovely")

local font_path = mod_path.."assets/fonts/m6x11++.ttf"
local file = nativefs.read(font_path)
love.filesystem.write("temp-font.ttf", file)
G.LANG.font.FONT = love.graphics.newFont("temp-font.ttf", G.TILESIZE * 10)
love.filesystem.remove("temp-font.ttf")


-- Load all jokers
for _, v in ipairs(joker_list) do
	print("loading: " .. "content/jokers/" .. v .. ".lua")
	local joker = SMODS.load_file("content/jokers/" .. v .. ".lua")()

	--joker.discovered = true
	if joker.dependency and not (SMODS.Mods[joker.dependency] or {}).can_load then goto continue end
	
	if not joker.key then joker.key = v end
	if not joker.name then joker.name = "rufia-" .. joker.key end
	
	local is_big = (joker.atlas == "big")
	local is_really_big = (joker.atlas == "really_big")

	if is_big then
		joker.atlas = "Rufia_Jokers_Big"
	elseif is_really_big then
		joker.atlas = "Rufia_Jokers_Really_Big"
	else
		joker.atlas = "Rufia_Jokers"
	end

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
			if (is_big) then
				card.children.center.atlas = G.ASSET_ATLAS["rufia_Rufia_Jokers_Big"]
			elseif (is_really_big) then
				card.children.center.atlas = G.ASSET_ATLAS["rufia_Rufia_Jokers_Really_Big"]
			else
				card.children.center.atlas = G.ASSET_ATLAS["rufia_Rufia_Jokers"]
			end
			card.children.center:set_sprite_pos(card.config.center.pos)
		end
	end
	::continue::
end


-- Load all vouchers
for _, v in ipairs(voucher_list) do
	local voucher = SMODS.load_file("content/vouchers/" .. v .. ".lua")()

	--joker.discovered = true
	if voucher.dependency and not (SMODS.Mods[voucher.dependency] or {}).can_load then goto continue end
	voucher.key = v
	voucher.atlas = "Rufia_Vouchers"

	if not voucher.pos then
		voucher.pos = { x = 0, y = 0 }
	end

	local voucher_obj = SMODS.Voucher(voucher)

	for k_, v_ in pairs(voucher) do
		if type(v_) == 'function' then
			voucher_obj[k_] = voucher[k_]
		end
	end

	if not voucher.set_sprites then
		voucher_obj.set_sprites = function(self, card, front)
			card.children.center.atlas = G.ASSET_ATLAS["rufia_Rufia_Vouchers"]
			card.children.center:set_sprite_pos(card.config.center.pos)
		end
	end
	::continue::
end


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
	if edition.shader_debuff then
		SMODS.Shader({ key = v .. "_debuff", path = v .. "_debuff" .. ".fs" })
	end

	for k_, v_ in pairs(edition) do
		if type(v_) == 'function' then
			edition_obj[k_] = edition[k_]
		end
	end

	::continue::
end


-- local cons = SMODS.load_file("content/consumables/piper.lua")()
-- cons.key = v
-- cons.atlas = "Rufia_Consumables"
-- cons.discovered = true
-- cons.alerted = true
-- local cons_obj = SMODS.Consumable(cons)

-- for k_, v_ in pairs(cons) do
-- 	if type(v_) == 'function' then
-- 		cons_obj[k_] = cons[k_]
-- 	end
-- end

-- Load consumables
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
end





-- Debuffing effects
local should_debuff_ability = {
	"stop_debuff",
	--"leech_debuff",
}
function SMODS.current_mod.set_debuff(card, should_debuff)
	-- if card.ability then
	-- 	for _, v in ipairs(should_debuff_ability) do
	-- 		if card.ability[v] then
	-- 			return true
	-- 		end
	-- 	end
	-- end
end


local smods_calculate_repetitions = SMODS.calculate_repetitions
SMODS.calculate_repetitions = function(card, context, reps)
	reps = smods_calculate_repetitions(card, context, reps)
	
	--Hypnotic Cards Held in Hand
	if card.config.center == G.P_CENTERS.m_rufia_hypnotic and not card.debuff
		and context.cardarea == G.play and card.hypnotic_in_hand then
		
		
		context.retrigger_hypnotics = true
		context.cardarea = G.hand


		--From jokers
		for _, area in ipairs(SMODS.get_card_areas('jokers')) do
			for _, _card in ipairs(area.cards) do
			--calculate the joker effects
				local eval, post = eval_card(_card, context)
				if next(post) then SMODS.trigger_effects({post}, card) end
				local rt = eval and eval.retriggers and #eval.retriggers or 0
				for key, value in pairs(eval) do
					if value.repetitions and key ~= 'retriggers' then
	
						for h=1, value.repetitions do
							value.card = value.card or _card
							reps[#reps+1] = {key = value}
							for i=1, rt do
								local rt_eval, rt_post = eval_card(_card, context)
								rt_eval.card = rt_eval.card or _card
								reps[#reps+1] = {key = value}
								if next(rt_post) then SMODS.trigger_effects({rt_post}, card) end
							end
						end
					end
				end
			end
		end

		context.retrigger_hypnotics = nil
		context.cardarea = G.play
	end

	--Shredded Edition
	if context.cardarea == G.play then
		local self_index = nil
		--local is_in_play = false
		for i_hand=1, #G.play.cards do
			if card == G.play.cards[i_hand] then self_index = i_hand end--is_in_play = true end
		end
	
		--if is_in_play and i == 1 and #G.play.cards <= 2 then
		if self_index and self_index == 1 and #G.play.cards <= 2 then
			for j=1, #G.jokers.cards do
				if G.jokers.cards[j] and not G.jokers.cards[j].debuff and G.jokers.cards[j].edition and G.jokers.cards[j].edition.key == "e_rufia_shredded" then  --and G.jokers[j].edition and G.jokers[j].edition.name == "Shredded" then
					for k=1, 2 do
						reps[#reps+1] = {jokers = {
							message = localize("k_again_ex"),
							card = G.jokers.cards[j]
						}}
					end
				end
			end
			for j=1, #context.scoring_hand do
				if context.scoring_hand[j] and not context.scoring_hand[j].debuff and context.scoring_hand[j].edition and context.scoring_hand[j].edition.key == "e_rufia_shredded" then --and scoring_hand[j].edition.name == "Shredded" then
					for k=1, 2 do
						reps[#reps+1] = {seals = {
							message = localize("k_again_ex"),
							card = context.scoring_hand[j]
						}}
					end
				end
			end
		end
	end
	
	return reps
end

-- add a new context for removing cards
local card_remove_ref = Card.remove
function Card:remove()
	--G.vouchers
	--G.booster_pack
	--G.pack_cards
	--G.shop
	--G.shop_jokers
	--G.shop_booster
	--G.shop_voucher
	--print("card removed")
	
	-- Food jokers remove themselves from the Joker cardarea before calling remove.
	-- As a result, this current implementation fails to catch them.
	-- Maybe add an override to the emplace function storing the last area they were emplaced?
	if self.area and
		--not (self.ability.set == 'Booster' or self.ability.set == 'Voucher' or self.ability.set == 'Consumable') and
		(self.ability.set == "Joker" or self.ability.set == "Default" or self.ability.set == "Enhanced") and
		--not self.opening and
		(self.area == G.jokers or
		self.area == G.consumable or
		self.area == G.play or
		self.area == G.hand) then
		--print("valid card removed")
		-- print("self.area:")
		-- for _k, _v in pairs(self.area) do
		-- 	print("self.area." .. _k)
		-- end

		if G.jokers and G.jokers.cards then
			for i=1, #G.jokers.cards do
				G.jokers.cards[i]:calculate_joker({rufia_card_remove = true, removed_card = self})
			end
			if not self.rufia_sold then
				for i=1, #G.jokers.cards do
					G.jokers.cards[i]:calculate_joker({rufia_card_destroyed = true, destroyed_card = self})
				end
			end
		end
	end


	card_remove_ref(self)
end

local card_sell_ref = Card.sell_card
function Card:sell_card()
	self.rufia_sold = true

	card_sell_ref(self)
end

local card_redeem_ref = Card.redeem
function Card:redeem()
	self.rufia_redeemed = true

	card_redeem_ref(self)
end



--Null Cards
SMODS.calculation_keys[#SMODS.calculation_keys + 1] = 'null_level_up'

local calculate_individual_effect_ref = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
	if key == 'null_level_up' then
		local hand_i = G.GAME.last_hand_played
		level_up_hand(scored_card, hand_i, true, amount)
	
		local col = G.C.GREEN
		
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				play_sound('tarot1')
				if scored_card and scored_card.juice_up then scored_card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = true
				return true 
			end }))
		mult = mod_mult(mult + G.GAME.hands[hand_i].l_mult)
		update_hand_text({delay = 0}, {mult = mult, StatusText = true})
	
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.9,
			func = function()
				play_sound('tarot1')
				if scored_card and scored_card.juice_up then scored_card:juice_up(0.8, 0.5) end
				return true 
			end }))
		hand_chips = mod_chips(hand_chips + G.GAME.hands[hand_i].l_chips)
		update_hand_text({delay = 0}, {chips = hand_chips, StatusText = true})
	
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.9,
			func = function()
				play_sound('tarot1')
				if scored_card and scored_card.juice_up then scored_card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = nil
				return true
			end }))
		update_hand_text(
			{sound = 'button', volume = 0.7, pitch = 0.9, delay = 0},
			{level=G.GAME.hands[hand_i].level}
		)
		delay(1.3)

		return true
	end

	return calculate_individual_effect_ref(effect, scored_card, key, amount, from_edition)
end

-- --Ortalab Compat
-- local card_highlight = Card.highlight
-- function Card:highlight(highlighted)
-- 	card_highlight(self, highlighted)
-- 	-- --print("card highlighted")
-- 	-- if highlighted and self.config.center_key == 'm_ortalab_index' and self.area == G.jokers and #G.jokers.highlighted == 1 and not G.booster_pack then
--     --     -- self.children.use_button = UIBox{
--     --     --     definition = G.UIDEF.use_index_buttons(self), 
--     --     --     config = {align = 'cl', offset = {x=0.5, y=0}, parent = self, id = 'ortalab_index'}
--     --     -- }
-- 	-- 	local x_off = (self.ability.consumeable and -0.1 or 0)
-- 	-- 	self.children.use_button = UIBox{
-- 	-- 		definition = G.UIDEF.use_and_sell_buttons(self), 
-- 	-- 		config = {align=
-- 	-- 				((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
-- 	-- 				"bmi"
-- 	-- 			, offset = 
-- 	-- 				((self.area == G.jokers) or (self.area == G.consumeables)) and {x=x_off - 0.4,y=0} or
-- 	-- 				{x=0,y=0.65},
-- 	-- 			parent =self}
-- 	-- 	}
-- 	-- end
-- 	if self.config.center_key == 'm_ortalab_index' and self.area == G.jokers and not G.booster_pack then
-- 		self.highlighted = highlighted
-- 		if true then
-- 			if self.highlighted and self.area and self.area.config.type ~= 'shop' then
-- 				local x_off = (self.ability.consumeable and -0.1 or 0)
-- 				self.children.sell_button = UIBox{
-- 					definition = G.UIDEF.use_and_sell_buttons(self), 
-- 					config = {align=
-- 							((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
-- 							"bmi"
-- 						, offset = 
-- 							((self.area == G.jokers) or (self.area == G.consumeables)) and {x=x_off - 0.4,y=0} or
-- 							{x=0,y=0.65},
-- 						parent =self}
-- 				}
-- 			elseif self.children.sell_button then
-- 				self.children.sell_button:remove()
-- 				self.children.sell_button = nil
-- 			end
-- 		end
-- 		if self.ability.consumeable or self.ability.set == 'Joker' then
-- 			if not self.highlighted and self.area and self.area.config.type == 'joker' and
-- 				(#G.jokers.cards >= G.jokers.config.card_limit or (self.edition and self.edition.negative)) then
-- 					if G.shop_jokers then G.shop_jokers:unhighlight_all() end
-- 			end
-- 		end
-- 	end
-- end


--=============== CONFIG UI ===============--

local function create_config_node(config_name, label_text)
	return {
		n = G.UIT.R,
		config = {
			align = "cm", 
			padding = 0
		}, 
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "cr",
					padding = 0
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = label_text,--localize('rufia_'..config_name),
							scale = 0.35,
							colour = G.C.UI.TEXT_LIGHT
						}
					},
				}
			},
			{
				n = G.UIT.C,
				config = { 
					align = "cr",
					padding = 0.05
				},
				nodes = {
					create_toggle{ 
						col = true,
						label = "",
						scale = 0.85,
						w = 0,
						shadow = true,
						ref_table = mod_settings,
						ref_value = config_name
					},
				}
			},
		}
	}
end

local function create_config_button(function_name, button_text, description_text)
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			padding = 0.05
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					minw = 0.5,
					maxw = 2,
					minh = 0.6,
					padding = 0,
					r = 0.1,
					hover = true,
					colour = G.C.RED,
					button = function_name,
					shadow = true,
					focus_args = {nav = 'wide'}
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = button_text,
							scale = 0.35,
							colour = G.C.UI.TEXT_LIGHT
						}
					}
				}
			},
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					padding = 0
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = description_text,
							scale = 0.35,
							colour = G.C.JOKER_GREY,
							shadow = true
						}
					}
				}
			},
		}
	}
end

local function create_config_button_small(function_name, button_text)
	return {
		n = G.UIT.C,
		config = {
			align = "cm",
			padding = 0.05
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					minw = 0.5,
					maxw = 2,
					minh = 0.6,
					padding = 0.2,
					r = 0.1,
					hover = true,
					colour = G.C.RED,
					button = function_name,
					shadow = true,
					focus_args = {nav = 'wide'}
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = button_text,
							scale = 0.35,
							colour = G.C.UI.TEXT_LIGHT
						}
					}
				}
			},
		}
	}
end

local function create_config_button_pair(function_suffix, text_left, text_right)
	return {
		n = G.UIT.R,
		config = {
			align = "cm", 
			padding = 0.1
		},
		nodes = {
			create_config_button_small("rufia_skip_".. function_suffix, text_left),
			create_config_button_small("rufia_reset_" .. function_suffix, text_right),
		}
	}
end


-- SMODS.current_mod.config_tab = function()
-- 	return {
-- 		n = G.UIT.ROOT,
-- 		config = {
-- 			r = 0.1,
-- 			align = "c",
-- 			padding = 0.1,
-- 			colour = G.C.BLACK,
-- 			minh = 6
-- 		},
		
-- 		nodes = {
-- 		{
-- 			n = G.UIT.C,
-- 			config = {
-- 				align = "t",
-- 				padding = 0.1
-- 			},
-- 			nodes = {
-- 			--create_config_node("Confection Cards", "Enable Confection Cards"),
-- 			--create_config_node("Null Cards", "Enable Null Cards"),
-- 			--create_config_node("Hypnotic Cards", "Enable Hypnotic Cards"),
-- 			--create_config_node("Soul Vouchers", "Soul Vouchers"),
-- 			--create_toggle({ label = "Soul Vouchers", ref_table = mod_settings, ref_value = "Soul Vouchers" }),
-- 			--create_config_node("Explicit Artwork", "Explicit Artwork"),
			
-- 			create_toggle({ label = "Confection Cards", ref_table = mod_settings, ref_value = "Soul Vouchers" }),
-- 			create_toggle({ label = "Null Cards", ref_table = mod_settings, ref_value = "Soul Vouchers" }),
-- 			create_toggle({ label = "Hypnotic Cards", ref_table = mod_settings, ref_value = "Soul Vouchers" }),
-- 			create_toggle({ label = "Soul Vouchers", ref_table = mod_settings, ref_value = "Soul Vouchers" }),
-- 			create_toggle({ label = "Explicit Artwork", ref_table = mod_settings, ref_value = "Explicit Artwork" }),

			

-- 			--create_config_node("Unlock Conditions", "Enable Unlock Conditions"),
-- 			--create_toggle({ label = "Enable Unlock Conditions", ref_table = mod_settings, "Unlock Conditions" }),
-- 			--create_config_button("rufia_reset_unlocks", "Reset Unlock Status", "Click this button reset the unlock status of all Rufia's Retinue additions"),

-- 			--create_config_node("Discovery", "Enable Undiscovered Status"),
-- 			--create_config_button("rufia_reset_discovery", "Undiscover All", "Click this button reset the discovery status of all Rufia's Retinue additions"),	
			

-- 			create_config_button_pair("discovery", "Discover All", "Reset Discovered"),
-- 			create_config_button_pair("unlocks", "Unlock All", "Reset Unlocks"),

-- 			--create_config_node("Achievements", "Enable Achievements"),
-- 			create_toggle({ label = "Enable Achievements", ref_table = mod_settings, ref_value = "Achievements" }),
-- 			create_config_button("rufia_reset_trophies", "Reset Achievements", "Click this button reset all Rufia's Retinue achievements"),

-- 			}
-- 		},

-- 		-- {
-- 		-- 	n = G.UIT.C,
-- 		-- 	config = {
-- 		-- 		align = "t",
-- 		-- 		padding = 0.1
-- 		-- 	},
-- 		-- 	nodes = {
-- 		-- 		create_config_node("show_art_undiscovered"),
-- 		-- 		create_config_node("disable_ordeals"),
-- 		-- 		create_config_node("discover_all"),
-- 		-- 		create_config_node("unlock_challenges"),
-- 		-- 		create_config_node("lobcorp_music"),
-- 		-- 		}
-- 		-- 	},
-- 		}
-- 	}
-- end

G.FUNCS.rufia_reset_trophies = function(e)
end

G.FUNCS.rufia_skip_unlocks = function(e)
end
G.FUNCS.rufia_reset_unlocks = function(e)
end

G.FUNCS.rufia_skip_discovery = function(e)
end
G.FUNCS.rufia_reset_discovery = function(e)
end




-- Atlases
SMODS.Atlas({ 
	key = "Rufia_Jokers", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_jokers.png", 
	px = 71, 
	py = 95 
})
SMODS.Atlas({ 
	key = "Rufia_Jokers_Big", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_jokers_big.png", 
	px = 105, 
	py = 141 
})
SMODS.Atlas({ 
	key = "Rufia_Jokers_Really_Big", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_jokers_really_big.png", 
	px = 139, 
	py = 187 
})
SMODS.Atlas({ 
	key = "Rufia_Vouchers", 
	atlas_table = "ASSET_ATLAS", 
	path = "rufia_vouchers.png", 
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

SMODS.Sound({
	key = "e_torn",
	path = "e_torn.ogg",
})
SMODS.Sound({
	key = "e_sundered",
	path = "e_sundered.ogg",
})
SMODS.Sound({
	key = "e_ripped",
	path = "e_ripped.ogg",
})
SMODS.Sound({
	key = "e_shredded",
	path = "e_shredded.ogg",
})

-- Clear all Cathys
sendInfoMessage("Loaded Rufia's Retinue!")
