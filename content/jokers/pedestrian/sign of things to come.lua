local joker = {
	key = "sign of things to come",
	name = "rufia-sottc",
	pos = {x = 9, y = 1},
	--soul_pos = { x = 3, y = 3 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Sign of Things to Come",
		text = {"Copies ability of {C:attention}Joker{} to the right",
			"Transform a random Joker into a copy",
			"of this card at the end of round",
			"{s:0.8}Max 1 tranformed Joker each round{}"}
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	if context.end_of_round
	and not context.blueprint
	and not context.repetition
	and not context.individual then
		local first_copy = nil
		local nonsign_cards = {}
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.name == "rufia-sottc" then-- and not G.jokers.cards[i].debuff then				
				if not first_copy then
					first_copy = G.jokers.cards[i]
				end
				
				-- if G.jokers.cards[i] ~= card then
				-- 	first_copy = false
				-- end
			else
				nonsign_cards[#nonsign_cards + 1] = i
			end
		end

		-- if first_copy then
		-- 	print("first_copy: true")
		-- else
		-- 	print("first_copy: false")
		-- end
		-- print("#nonsign_cards: ".. #nonsign_cards)
		-- for i = 1, #nonsign_cards do
		-- 	print("nonsign_cards[".. i .. "]: " .. nonsign_cards[i])
		-- end

		if first_copy == card and nonsign_cards[1] then
			-- print("attempting to Assimilate...")

			local idx = pseudorandom("rufia-sottc", 1, #nonsign_cards)
			idx = nonsign_cards[idx]

			-- print("target_id: " .. idx)

			if G.jokers.cards[idx] then
				--_card = create_card("Joker", G.jokers, nil, nil, nil, nil, nil, "cry_vermillion_virus_gen")
				local new_card = copy_card(card, nil, nil, nil, false)
				G.jokers.cards[idx]:remove_from_deck()
				new_card:add_to_deck()
				new_card:start_materialize()
				G.jokers.cards[idx] = new_card
				new_card:set_card_area(G.jokers)
				G.jokers:set_ranks()
				G.jokers:align_cards()

				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Assimilated!"})
			end
		end
	end

	local other_joker = nil
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
	end
	if other_joker and other_joker ~= card and not context.no_blueprint then
		context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
		context.copy_depth = (context.copy_depth and (context.copy_depth + 1)) or 1
		context.blueprint_card = context.blueprint_card or card
		if context.blueprint > #G.jokers.cards + 1 then return end
		context.no_callback = true
		local other_joker_ret, trig = other_joker:calculate_joker(context)
		if other_joker_ret then 
			other_joker_ret.card = context.blueprint_card or card
			context.no_callback = not (context.copy_depth <= 1)
			context.copy_depth = context.copy_depth - 1;
			other_joker_ret.colour = G.C.BLUE
			return other_joker_ret
		end
	end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card)}
	if card.area and card.area == G.jokers then
		desc_nodes[#desc_nodes+1] = {
			{n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
				{n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.blueprint_compat == 'compatible' and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
					{n=G.UIT.T, config={text = ' '..localize('k_'..card.ability.blueprint_compat)..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
				}}
			}}
		}
	end
end

joker.update = function(self, card)
	if G.STAGE == G.STAGES.RUN then
		local other_joker = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
		end
		if other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat then
			card.ability.blueprint_compat = 'compatible'
		else
			card.ability.blueprint_compat = 'incompatible'
		end
	end
end


return joker