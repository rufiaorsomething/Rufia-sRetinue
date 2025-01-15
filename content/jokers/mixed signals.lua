local joker = {
	name = "rufia-mixed signals",
	pos = {x = 7, y = 1},
	--soul_pos = { x = 3, y = 3 },
	rarity = 3,
	cost = 10,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Mixed Signals",
		text = {"Copies ability of each {C:red}Rare{} Joker on first hand of round",
			"Copies ability of each {C:green}Uncommon{} Joker on last hand of round"}
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}


local function copy_jokers_of_rarity(self, card, context, target_rarity)
	for i = 1, #G.jokers.cards do
		local other_joker = G.jokers.cards[i]
		
		if other_joker and other_joker ~= card
		and other_joker.config.center.rarity == target_rarity) then
			
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
end

joker.calculate = function(self, card, context)	
	-- local other_joker = nil
	-- for i = 1, #G.jokers.cards do
	-- 	if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
	-- end

	if not context.no_blueprint then
		if G.GAME.current_round.hands_left == 0 then
			copy_jokers_of_rarity(self, card, context, 2)
		end
		if G.GAME.current_round.hands_played == 0 then
			copy_jokers_of_rarity(self, card, context, 3)
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
		for i = 1, #card.ability.incompatible_jokers do
			desc_nodes[#desc_nodes+1] = {
				{
					n = G.UIT.C,
					config = {
						align = "bm",
						minh = 0.4
					},
					nodes = {
						{
							n = G.UIT.C,
							config = {
								ref_table = self,
								align = "m",
								colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = ' '.. joker.ability.name .. ' ' ..localize('k_incompatible')..' ',
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32*0.8
									}
								},
							}
						}
					}
				}
			}
		end
	end
end

local function add_incompatible_joker(self, card, joker) {
	local already_on_list

	for i = 1, #card.ability.incompatible_jokers do
		if card.ability.incompatible_jokers[i] == joker.ability.name then
			already_on_list
		end
	end

	if not already_on_list then
		card.ability.incompatible_jokers[#card.ability.incompatible_jokers] = joker.ability.name
	end
}

joker.update = function(self, card)
	if G.STAGE == G.STAGES.RUN then
		card.ability.incompatible_jokers = {}

		for i = 1, #G.jokers.cards do
			local other_joker = G.jokers.cards[i]
			--if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
			if other_joker and other_joker ~= card
				and (other_joker.config.center.rarity == 2 or other_joker.config.center.rarity == 3)
				and not other_joker.config.center.blueprint_compat then
				--card.ability.incompatible_jokers[#card.ability.incompatible_jokers] = other_joker
				add_incompatible_joker(self, card, add_incompatible_joker)
			end
		end

		if #card.ability.incompatible_jokers > 4 then
			card.ability.incompatible_jokers = {
				card.ability.incompatible_jokers[1],
				card.ability.incompatible_jokers[2],
				card.ability.incompatible_jokers[3],
				card.ability.incompatible_jokers[4],
				"...",
			}
		end
	end
end


return joker