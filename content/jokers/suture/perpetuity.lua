local joker = {
	key = "perpetuity",
	pos = {x = 0, y = 3},
	--soul_pos = { x = 3, y = 3 },
	rarity = 2,
	cost = 4,
	discovered = true,
	config = {
		extra = 3
	},
	loc_txt = {
		name = "Mock Angel Perpetuity",
		text = {"{C:mult}+#1#{} Mult for each copy of this joker you possess",
			"When {C:attention}Blind{} is selected, if there are no jokers",
			"to this card's right, {C:attention}Duplicate{} this Joker"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {self.config.extra}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
	if context.setting_blind and not self.getting_sliced then
		local last_joker_i = 0
		local this_joker_i = 0
		for i = 1, #G.jokers.cards do
			last_joker_i = i
			if G.jokers.cards[i] == card then
				this_joker_i = i
			end
		end
		--print("last_joker_i: " .. last_joker_i)
		--print("this_joker_i: " .. last_joker_i)

		local extra_slots = 0
		if (card.edition and card.edition.negative) then extra_slots = 1 end
		
		if last_joker_i == this_joker_i
		and #G.jokers.cards + G.GAME.joker_buffer - extra_slots < G.jokers.config.card_limit then
			--print("try duplicating!")
			G.GAME.joker_buffer = G.GAME.joker_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					local new_card = copy_card(card, nil, nil, nil, false)
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
					new_card:start_materialize()
					G.GAME.joker_buffer = 0
					return true
				end}))
			--card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(k_duplicated_ex)})
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_duplicated_ex")})
		end

	elseif context.cardarea == G.jokers and context.joker_main then
		local copies = 0
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.name == "rufia-perpetuity" then-- and not G.jokers.cards[i].debuff then
				copies = copies + 1
			end
		end

		return {
			message = localize{type='variable',key='a_mult',vars={copies * self.config.extra}},
			mult_mod = copies * self.config.extra
		}

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