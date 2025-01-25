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
			"joker is destroyed, create",
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

	if context.destroying_cards and not context.blueprint_card then
		if context.destroyed_card and context.destroyed_card ~= card and not context.destroyed_card.edition then
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = "disfigured!",--localize{type='variable',key='a_chips',vars={eaten_chips}},
				colour = G.C.MULT})

			local ripped_to_shreds = pseudorandom("suture") > 0.5

			if ripped_to_shreds then
				local ripped_copy = copy_card(context.destroyed_card)
				local edition = {rufia_ripped = true}
				ripped_copy:set_edition(edition, true)
				ripped_copy:add_to_deck()
				G.jokers:emplace(ripped_copy)
				--ripped_copy:start_materialize() --Too noisy? Unnecessary with the original card's dematerialisng?
	
				local shredded_copy = copy_card(context.destroyed_card)
				edition = {rufia_shredded = true}
				shredded_copy:set_edition(edition, true)
				shredded_copy:add_to_deck()
				G.jokers:emplace(shredded_copy)
				--shredded_copy:start_materialize()
			else
				local torn_copy = copy_card(context.destroyed_card)
				local edition = {rufia_torn = true}
				torn_copy:set_edition(edition, true)
				torn_copy:add_to_deck()
				G.jokers:emplace(torn_copy)
				--torn_copy:start_materialize()
	
				local sundered_copy = copy_card(context.destroyed_card)
				edition = {rufia_sundered = true}
				sundered_copy:set_edition(edition, true)
				sundered_copy:add_to_deck()
				G.jokers:emplace(sundered_copy)
				--sundered_copy:start_materialize()
			end			
		end
	end
	if context.cards_destroyed then
	end
	if context.remove_playing_cards then
	end
end

return joker