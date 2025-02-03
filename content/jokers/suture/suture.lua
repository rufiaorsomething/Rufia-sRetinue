local joker = {
	key = "suture",
	pos = {x = 0, y = 6},
	soul_pos = { x = 1, y = 6 },
	rarity = 4,
	cost = 20,
	discovered = true,
	--config = { extra = { money = 3 } },
	loc_txt = {
		name = "Suture",
		text = {"When {C:attention}Blind{} is selected,",
			"destroy joker to the right.",
			"Whenever a base edition",
			"card is destroyed, create",
			"either a {C:attention}Torn{} and {C:attention}Sundered{}",
			"or a {C:attention}Ripped{} and {C:attention}Shredded{} copy"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_rufia_torn
		info_queue[#info_queue + 1] = G.P_CENTERS.e_rufia_sundered
		info_queue[#info_queue + 1] = G.P_CENTERS.e_rufia_ripped
		info_queue[#info_queue + 1] = G.P_CENTERS.e_rufia_shredded
		return {
			vars = {}
		}
	end,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

local function get_card_position(card, cardarea)
	for i=1, #cardarea.cards do
		if cardarea.cards[i] == card then return i end
	end
end

local function suture_copy_joker(original, edition, delay)
	local new_copy = copy_card(original)
	new_copy:add_to_deck()
	new_copy.states.visible = nil
	
	local card_pos = get_card_position(original, G.jokers)

	G.jokers:emplace(new_copy)
	if card_pos then
		table.remove(G.jokers.cards)
		table.insert(G.jokers.cards, card_pos, new_copy)
		G.jokers:set_ranks()
		G.jokers:align_cards()
	end
	--local edition = {rufia_torn = true}
	new_copy:set_edition(edition, true)
	new_copy:start_materialize()

	
	-- G.E_MANAGER:add_event(Event({
	-- 	trigger = 'after',
	-- 	--blockable = false,
	-- 	--delay = delay,
	-- 	delay = 0.1,
	-- 	func = function()
	-- 		G.jokers:emplace(new_copy)
	-- 		table.remove(G.jokers.cards)
	-- 		table.insert(G.jokers.cards, card_pos, new_copy)
	-- 		G.jokers:set_ranks()
	-- 		G.jokers:align_cards()
	-- 		--local edition = {rufia_torn = true}
	-- 		new_copy:set_edition(edition, true)
	-- 		new_copy:start_materialize()
	-- 		return true
	-- 	end
	-- }))
end

local function suture_copy_playing_card(original, edition, delay)
	G.playing_card = (G.playing_card and G.playing_card + 1) or 1
	local new_copy = copy_card(original)
	new_copy:add_to_deck()
	G.deck.config.card_limit = G.deck.config.card_limit + 1
	table.insert(G.playing_cards, new_copy)
	new_copy.states.visible = nil

	local card_pos = get_card_position(original, G.hand)

	G.hand:emplace(new_copy)
	if card_pos then
		table.remove(G.hand.cards)
		table.insert(G.hand.cards, card_pos, new_copy)
		G.hand:set_ranks()
		G.hand:align_cards()
	end
	--edition = {rufia_sundered = true}
	new_copy:set_edition(edition, true)
	new_copy:start_materialize()
	playing_card_joker_effects({new_copy})


	-- G.E_MANAGER:add_event(Event({
	-- 	trigger = 'after',
	-- 	--blockable = false,
	-- 	--delay = delay,
	-- 	delay = 0.1,
	-- 	func = function()
	-- 		G.hand:emplace(new_copy)
	-- 		table.remove(G.hand.cards)
	-- 		table.insert(G.hand.cards, card_pos, new_copy)
	-- 		G.hand:set_ranks()
	-- 		G.hand:align_cards()
	-- 		--edition = {rufia_sundered = true}
	-- 		new_copy:set_edition(edition, true)
	-- 		new_copy:start_materialize()
	-- 		playing_card_joker_effects({new_copy})
	-- 		return true
	-- 	end
	-- }))
end

joker.calculate = function(self, card, context)
	local my_pos = nil
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			my_pos = i
			break
		end
	end
	if
		context.setting_blind
		and not (context.blueprint_card or self).getting_sliced
		and my_pos
		and G.jokers.cards[my_pos + 1]
		and not G.jokers.cards[my_pos + 1].ability.eternal
		and not G.jokers.cards[my_pos + 1].getting_sliced
	then
		local sliced_card = G.jokers.cards[my_pos + 1]
		sliced_card.getting_sliced = true
		G.GAME.joker_buffer = G.GAME.joker_buffer - 1
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.joker_buffer = 0
				card:juice_up(0.8, 0.8)
				sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
				play_sound("slice1", 0.96 + math.random() * 0.08)
				return true
			end,
		}))
		return nil, true
	end

	-- print("context:")
	-- for _k, _v in pairs(context) do
	-- 	print("context." .. _k)
	-- end

	if context.rufia_card_destroyed and not context.blueprint_card then
		local copy_func = nil

		if context.destroyed_card and context.destroyed_card ~= card and not context.destroyed_card.edition then
			if context.destroyed_card.area == G.jokers then
				copy_func = suture_copy_joker
			elseif context.destroyed_card.area == G.hand or context.destroyed_card.area == G.play then
				copy_func = suture_copy_playing_card
			end
		end

		

		
		if copy_func then
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = "disfigured!",--localize{type='variable',key='a_chips',vars={eaten_chips}},
				colour = G.C.MULT})

			local ripped_to_shreds = pseudorandom("suture") > 0.5

			if ripped_to_shreds then
				local edition = {rufia_ripped = true}
				copy_func(context.destroyed_card, edition, 1.0)
				edition = {rufia_shredded = true}
				copy_func(context.destroyed_card, edition, 2.0)

				-- local ripped_copy = copy_card(context.destroyed_card)
				-- local edition = {rufia_ripped = true}
				-- ripped_copy:set_edition(edition, true)
				-- ripped_copy:add_to_deck()
				-- G.jokers:emplace(ripped_copy)
				-- --ripped_copy:start_materialize() --Too noisy? Unnecessary with the original card's dematerialisng?
	
				-- local shredded_copy = copy_card(context.destroyed_card)
				-- edition = {rufia_shredded = true}
				-- shredded_copy:set_edition(edition, true)
				-- shredded_copy:add_to_deck()
				-- G.jokers:emplace(shredded_copy)
				-- --shredded_copy:start_materialize()
			else
				local edition = {rufia_torn = true}
				copy_func(context.destroyed_card, edition, 1.0)
				edition = {rufia_sundered = true}
				copy_func(context.destroyed_card, edition, 2.0)

				-- local torn_copy = copy_card(context.destroyed_card)
				-- local edition = {rufia_torn = true}
				-- torn_copy:set_edition(edition, true)
				-- torn_copy:add_to_deck()
				-- G.jokers:emplace(torn_copy)
				-- --torn_copy:start_materialize()
	
				-- local sundered_copy = copy_card(context.destroyed_card)
				-- edition = {rufia_sundered = true}
				-- sundered_copy:set_edition(edition, true)
				-- sundered_copy:add_to_deck()
				-- G.jokers:emplace(sundered_copy)
				-- --sundered_copy:start_materialize()
			end			
		end
	end
	if context.cards_destroyed then
	end
	if context.remove_playing_cards then
	end
end

return joker