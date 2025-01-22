local joker = {
	name = "rufia-mixed signals",
	pos = {x = 7, y = 1},
	--soul_pos = { x = 3, y = 3 },
	rarity = 3,
	cost = 10,
	discovered = true,
	config = {
		extra = {
			incompatible_jokers,
			retriggers = 1,
		}
	},
	loc_txt = {
		name = "Mixed Signals",
		text = {"Copies ability of each {C:red}Rare{} Joker", "on {C:attention}first hand{} of round",
			"Copies ability of each {C:green}Uncommon{} Joker", "on {C:attention}final hand{} of round"}
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}


local function read_table(prefix, table, depth)
	if not table then return nil end

	for k_, v_ in pairs(table) do
		if type(v_) == "string"
		or type(v_) == "number" then
			print(prefix .. k_ .. ": " .. v_)			
		elseif type(v_) == "table" then
			--read_table(suffix .. "  ", v_, depth + 1)
			if v_.name and type(v_.name) == "string" then
				print(prefix .. "table[" .. v_.name .. "] of size: " .. #v_)
			else
				print(prefix .. "table of size: " .. #v_)
			end
			if #v_ < 10 and depth > 1 then
				read_table(prefix .. "  ", v_, depth - 1)
			end
		end
	end
end

local function merge_returns(ret_a, ret_b)
	--local new_ret = {}
	if type(ret_b) == "table" then
		for k_, v_ in pairs(ret_b) do
			if ret_a[k_] and
				(k_ == "x_mult"
				or k_ == "x_chips"
				or k_ == "e_mult"
				or k_ == "e_chips") then
				ret_a[k_] = ret_a[k_] * ret_b[k_]
			elseif type(v_) == "number" then
				if ret_a[k_] then
					ret_a[k_] = ret_a[k_] + ret_b[k_]
				else
					ret_a[k_] = ret_b[k_]
				end
			elseif not ret_a[k_] then
				ret_a[k_] = ret_b[k_]
			end
			--ret_a[k_] = v_--ret_b[k_]
		end
	end

	return ret_a
end

local function copy_jokers_of_rarity(self, card, context, target_rarity)
	local copied_returns = {}
	local next_context_blueprint = (context.blueprint and (context.blueprint + 1)) or 1
	local next_context_blueprint_card = context.blueprint_card or card

	for i = 1, #G.jokers.cards do
		local other_joker = G.jokers.cards[i]

		if other_joker and other_joker ~= card --and other_joker ~= next_context_blueprint_card
		and other_joker.config.center.rarity == target_rarity then
			context.blueprint = next_context_blueprint--(context.blueprint and (context.blueprint + 1)) or 1
			context.blueprint_card = next_context_blueprint_card--context.blueprint_card or card
			if context.blueprint > #G.jokers.cards + 1 then return end
			context.no_callback = true
			local other_joker_ret = other_joker:calculate_joker(context) 
			if other_joker_ret then
				other_joker_ret.card = context.blueprint_card or card				
				context.no_callback = false --this needs to be moved or else things break
				other_joker_ret.colour = G.C.RED
				--SMODS.eval_this(card, other_joker_ret)
				-- return other_joker_ret
				copied_returns[#copied_returns + 1] = other_joker_ret
			end
		end
	end
	


	if #copied_returns > 0 then
		context.no_callback = false
		if context.cardarea == G.jokers then
			for k_, v_ in pairs(copied_returns) do
				SMODS.eval_this(card, v_)
			end
		else
			local new_return = {}
	
			for k_, v_ in pairs(copied_returns) do
				--print("Key[".. k_ .."]")
				merge_returns(new_return, v_)
			end
	
			return new_return
		end
	end
end


local function retrigger_jokers_of_rarity(self, card, context, target_rarity)
	--[[
	Less thematic, but a lot less of a headache

	I'll probably stick with this until the devil on my shoulder convinces me the suffering is worth it

	-edit-
	that didn't take long
	]]--
	print("retriggering jokers...")

	if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self then
		--print("retriggering(1/2)..." .. other_card.ability.name)
		if context.other_card and context.other_card.config.center.rarity == target_rarity then
			--print("retriggering(2/2)..." .. other_card.ability.name)
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.extra.retriggers,
				card = card,
			}
		else
			return nil, true
		end
	end
end

joker.calculate = function(self, card, context)	
	-- local other_joker = nil
	-- for i = 1, #G.jokers.cards do
	-- 	if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
	-- end

	if not context.no_blueprint and not context.blueprint then
		if G.GAME.current_round.hands_left == 0 then
			--print("copying uncommon jokers...")
			--return retrigger_jokers_of_rarity(self, card, context, 2)
			return copy_jokers_of_rarity(self, card, context, 2)
		end
		if G.GAME.current_round.hands_played == 0 then
			--print("copying rare jokers...")
			--return retrigger_jokers_of_rarity(self, card, context, 3)
			return copy_jokers_of_rarity(self, card, context, 3)
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
		for i = 1, #card.ability.extra.incompatible_jokers do
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
										text = ' '.. card.ability.extra.incompatible_jokers[i] .. ' ' ..localize('k_incompatible')..' ',
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

	-- local compatibility = "compatible"
	-- if #card.ability.extra.incompatible_jokers > 0 then compatibility = "incompatible" end
	-- if card.area and card.area == G.jokers then
	-- 	desc_nodes[#desc_nodes+1] = {
	-- 		{n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
	-- 			{n=G.UIT.C, config={ref_table = self, align = "m", colour = compatibility == 'compatible' and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
	-- 				{n=G.UIT.T, config={text = ' '..localize('k_'.. compatibility)..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
	-- 			}}
	-- 		}}
	-- 	}
	-- end
end

local function add_incompatible_joker(self, card, joker)
	local already_on_list = false

	for i = 1, #card.ability.extra.incompatible_jokers do
		if card.ability.extra.incompatible_jokers[i] == joker.ability.name then
			already_on_list = true
		end
	end

	if not already_on_list then
		card.ability.extra.incompatible_jokers[#card.ability.extra.incompatible_jokers + 1] = joker.ability.name
	end
end

joker.update = function(self, card)
	if G.STAGE == G.STAGES.RUN then
		card.ability.extra.incompatible_jokers = {}

		for i = 1, #G.jokers.cards do
			local other_joker = G.jokers.cards[i]
			--if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
			if other_joker and other_joker ~= card
				and (other_joker.config.center.rarity == 2 or other_joker.config.center.rarity == 3)
				and not other_joker.config.center.blueprint_compat then
				--card.ability.extra.incompatible_jokers[#card.ability.extra.incompatible_jokers] = other_joker
				add_incompatible_joker(self, card, other_joker)
			end
		end

		if #card.ability.extra.incompatible_jokers > 3 then
			card.ability.extra.incompatible_jokers = {
				card.ability.extra.incompatible_jokers[1],
				card.ability.extra.incompatible_jokers[2],
				--card.ability.extra.incompatible_jokers[3],
				--card.ability.extra.incompatible_jokers[4],
				"...and more",
			}
		end
	end
end


return joker