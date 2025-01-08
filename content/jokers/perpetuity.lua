local joker = {
	name = "Perpetuity",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 2,
	cost = 8,
	discovered = true,
	config = { 
		mult = 5
	},
	loc_txt = {
		name = "Perpetuity",
		text = {"{C:mult}+#1#{} Mult for each copy of this joker you possess",
			"When {C:attention}Blind{} is selected, if there are no jokers",
			"to this card's right, {C:attention}Duplicate{} this Joker"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {self.config.mult}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
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
	--elseif context.joker_main then
	--	return {
	--		message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra}},
	--		Xmult_mod = self.ability.extra
	--	}
	end


	-- if context.setting_blind and not context.blueprint then
	-- 	local last_joker_i = 0
	-- 	local this_joker_i = 0
	-- 	for i = 1, #G.jokers.cards do
	-- 		last_joker_i = i
	-- 		if G.jokers.cards[i] == card then
	-- 			this_joker_i = i
	-- 			break
	-- 		end
	-- 	end

	-- 	print("last_joker_i: " .. last_joker_i)
	-- 	print("this_joker_i: " .. this_joker_i)

	-- 	if (last_joker_i == this_joker_i) then
	-- 	--	local duplicate_joker = copy_card(self)
	-- 	--	duplicate_joker:add_to_deck()
	-- 	--	G.jokers:emplace(duplicate_joker)

	-- 	--	card_eval_status_text(card, 'extra', nil, nil, nil, {
	-- 	--		message = localize(k_duplicated_ex),--localize{type='variable',key='a_chips',vars={eaten_chips}},
	-- 	--		colour = G.C.FILTER})
	-- 		G.GAME.joker_buffer = G.GAME.joker_buffer + 1
	-- 		G.E_MANAGER:add_event(Event({
	-- 			func = function() 
	-- 				local card = copy_card(self, nil, nil, nil, self.edition and self.edition.negative)
	-- 				card:add_to_deck()
	-- 				G.jokers:emplace(card)
	-- 				card:start_materialize()
	-- 				G.GAME.joker_buffer = 0
	-- 				return true
	-- 			end}))
	-- 		card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Mitosis!"}) 
	-- 	end

	-- -- 	and not (context.blueprint_card or self).getting_sliced then

	-- -- 	local last_joker_i = 0
	-- -- 	local this_joker_i = 0
	-- -- 	for i = 1, #G.jokers.cards do
	-- -- 		last_joker_i = i
	-- -- 		if G.jokers.cards[i] == card then
	-- -- 			this_joker_i = i
	-- -- 			break
	-- -- 		end
	-- -- 	end

		
	-- -- 	--local duplicate_joker = copy_card(card)
	-- -- 	--duplicate_joker:add_to_deck()
	-- -- 	--G.jokers:emplace(duplicate_joker)

	-- -- 	--card_eval_status_text(card, 'extra', nil, nil, nil, {
	-- -- 	--	message = localize(k_duplicated_ex),--localize{type='variable',key='a_chips',vars={eaten_chips}},
	-- -- 	--	colour = G.C.FILTER})

	-- -- 	return {
	-- -- 		message = localize(k_duplicated_ex),
	-- -- 		colour = G.C.FILTER
	-- -- 	}, true
	-- end
end

return joker