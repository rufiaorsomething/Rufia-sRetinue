local joker = {
	key = "mixed signals",
	pos = {x = 9, y = 2},
	--soul_pos = { x = 3, y = 3 },
	rarity = 3,
	cost = 10,
	discovered = true,
	config = {
		extra = {
			incompatible_jokers,
			retriggers = 1,
			pos_red = {x = 9, y = 2},
			pos_yellow = {x = 9, y = 3},
			pos_green = {x = 9, y = 4},
			pos_both = {x = 9, y = 5},
			current_mode = nil,
			hands_played = nil,
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

--'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
local xmult_keys = {
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod'
}

local function merge_returns(ret_a, ret_b, hand_score, scored_card)
	--local new_ret = {}
	local ignore_message = false

	if type(ret_b) == "table" then
		for k_, v_ in pairs(ret_b) do
			if type(v_) == "number" then
				local status_text_type = nil
				local status_text_amount = nil
				ignore_message = true

				if (k_ == "x_mult"
				or k_ == "Xmult"
				or k_ == "xmult"
				or k_ == "x_mult_mod"
				or k_ == "Xmult_mod") then
						
					if not ret_a["x_mult"] then ret_a["x_mult"] = 1 end
					ret_a["x_mult"] = ret_a["x_mult"] * ret_b[k_]
					--card_eval_status_text(scored_card, 'x_mult', ret_b[k_], percent)
					status_text_type = 'x_mult'
					status_text_amount = ret_b[k_]

					hand_score.mult = hand_score.mult * ret_b[k_]

				elseif (k_ == "x_chips"
					or k_ == "Xchips"
					or k_ == "xchips"
					or k_ == "x_chip_mod"
					or k_ == "Xchip_mod") then
							
						if not ret_a["x_chips"] then ret_a["x_chips"] = 1 end
						ret_a["x_chips"] = ret_a["x_chips"] * ret_b[k_]
						--card_eval_status_text(scored_card, 'x_mult', ret_b[k_], percent)
						status_text_type = 'x_chips'
						status_text_amount = ret_b[k_]
	
						hand_score.chips = hand_score.chips * ret_b[k_]
	
				elseif ret_a[k_]
				and (k_ == "e_mult"
				or k_ == "e_chips") then

					ret_a[k_] = ret_a[k_] * ret_b[k_]
				
				else
					if (k_ == "chips"
					or k_ == "h_chips"
					or k_ == "chip_mod") then
						if not ret_a["chips"] then ret_a["chips"] = 0 end
						ret_a["chips"] = ret_a["chips"] + ret_b[k_]
						--card_eval_status_text(scored_card, 'chips', ret_b[k_], percent)
						status_text_type = 'chips'
						status_text_amount = ret_b[k_]

						hand_score.chips = hand_score.chips + ret_b[k_]
					
					elseif (k_ == "mult"
					or k_ == "h_mult"
					or k_ == "mult_mod") then
						if not ret_a["mult"] then ret_a["mult"] = 0 end
						ret_a["mult"] = ret_a["mult"] + ret_b[k_]
						--card_eval_status_text(scored_card, 'mult', ret_b[k_], percent)
						status_text_type = 'mult'
						status_text_amount = ret_b[k_]

						hand_score.mult = hand_score.mult + ret_b[k_]
					
					else
						if not ret_a[k_] then ret_a[k_] = 0 end
						ret_a[k_] = ret_a[k_] + ret_b[k_]
						ignore_message = false
					end




				end

				-- update_hand_text({ delay = 0 }, { chips = hand_score.chips, mult = hand_score.mult})
				-- if (status_text_type) then
				-- 	card_eval_status_text(scored_card, status_text_type, status_text_amount, percent)
				-- end

				--ignore_message = true

			elseif not ret_a[k_] and not (k_ == 'message') then
				ret_a[k_] = ret_b[k_]
				
			end
			--ret_a[k_] = v_--ret_b[k_]
		end
	end

	if not ignore_message and ret_b.message then
		--ret_a['message'] = ret_b['message']
		card_eval_status_text(ret_b.card, 'extra', nil, nil, nil,{
			message = ret_b.message,
			colour = ret_b.colour,
			card = ret_b.card
		})
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
			-- print("attempting to copy... " .. other_joker.ability.name)

			context.blueprint = next_context_blueprint--(context.blueprint and (context.blueprint + 1)) or 1
			context.blueprint_card = next_context_blueprint_card--context.blueprint_card or card
			if context.blueprint > #G.jokers.cards + 1 then return end
			local other_joker_ret = other_joker:calculate_joker(context)
			--context.blueprint = nil
			--local eff_card = context.blueprint_card or card
			--context.blueprint_card = nil
			if other_joker_ret then 
				--other_joker_ret.card = eff_card
				--other_joker_ret.colour = G.C.BLUE
				--return other_joker_ret
				copied_returns[#copied_returns + 1] = other_joker_ret
			end
		end

		
	end


	if #copied_returns > 0 then
		context.no_callback = false

		local ret_colour = G.C.RED
		if target_rarity == 2 then ret_colour = G.C.GREEN end
		copied_returns[1].card = context.blueprint_card or card
		copied_returns[1].colour = ret_colour

		context.blueprint = nil
		context.blueprint_card = nil
		
		return copied_returns[1]
	end

	if #copied_returns > 0 then
		context.no_callback = false
		local ret_colour = G.C.RED
		if target_rarity == 2 then ret_colour = G.C.GREEN end
		-- if context.cardarea == G.jokers then
		-- 	for k_, v_ in pairs(copied_returns) do
		-- 		SMODS.eval_this(card, v_)
		-- 	end
		-- else
		-- 	local new_return = {}
	
		-- 	for k_, v_ in pairs(copied_returns) do
		-- 		--print("Key[".. k_ .."]")
		-- 		merge_returns(new_return, v_)
		-- 	end
	
		-- 	return new_return
		-- end

		local new_return = {}
		local hand_score = {
			chips = hand_chips,
			mult = mult
		}
	
		for k_, v_ in pairs(copied_returns) do
			-- if v_.card and v_.card.ability then
			-- 	print("copying effect of... " .. v_.card.ability.name)
			-- else
			-- 	print("copying effect of... ???")
			-- end
			v_.card = context.blueprint_card or card
			v_.colour = ret_colour
			--print("Key[".. k_ .."]")
			merge_returns(new_return, v_, hand_score)
		end
		context.blueprint = nil
		context.blueprint_card = nil

		--new_return.remove_default_message = true

		return new_return
	end
end

local function copy_jokers_of_rarity_mk2(self, card, context, target_rarity)
	local copied_returns = {}
	local next_context_blueprint = (context.blueprint and (context.blueprint + 1)) or 1
	local next_context_blueprint_card = context.blueprint_card or card
	local ret_colour = G.C.RED
	if target_rarity == 2 then ret_colour = G.C.GREEN end

	for i = 1, #G.jokers.cards do
		local other_joker = G.jokers.cards[i]

		if other_joker and other_joker ~= card
		and other_joker.config.center.rarity == target_rarity then

			context.blueprint = next_context_blueprint--(context.blueprint and (context.blueprint + 1)) or 1
			context.blueprint_card = next_context_blueprint_card--context.blueprint_card or card
			if context.blueprint > #G.jokers.cards + 1 then return end
			local other_joker_ret = other_joker:calculate_joker(context)
			--context.blueprint = nil
			local eff_card = context.blueprint_card or card
			--context.blueprint_card = nil
			if other_joker_ret then 
				other_joker_ret.card = eff_card
				other_joker_ret.colour = ret_colour
				--return other_joker_ret
				copied_returns[#copied_returns + 1] = other_joker_ret
			end
		end
	end
	context.blueprint = nil
	context.blueprint_card = nil

	-- if copied_returns[1] then
	-- 	return copied_returns[1]
	-- end

	if #copied_returns > 0 then
		local new_return = {}
		local hand_score = {
			chips = hand_chips,
			mult = mult
		}
	
		for k_, v_ in pairs(copied_returns) do
			merge_returns(new_return, v_, hand_score, (context.other_card or card))
		end

		--new_return.remove_default_message = true

		--read_table("", new_return, 1)

		return new_return
	end
end

local function copy_jokers_blueprint(self, card, context)
	local other_joker = nil
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
	end
	if other_joker and other_joker ~= card and not context.no_blueprint then
		context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
		context.blueprint_card = context.blueprint_card or card
		if context.blueprint > #G.jokers.cards + 1 then return end
		local other_joker_ret = other_joker:calculate_joker(context)
		context.blueprint = nil
		local eff_card = context.blueprint_card or card
		context.blueprint_card = nil
		if other_joker_ret then 
			other_joker_ret.card = eff_card
			other_joker_ret.colour = G.C.BLUE
			return other_joker_ret
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


local function update_sprite(self, card)
	local new_mode = "yellow"
	local new_pos = card.ability.extra.pos_yellow

	if G.GAME.current_round.hands_left <= 1 then
		if card.ability.extra.current_mode == "green" or card.ability.hands_played ~= G.GAME.current_round.hands_played then
			new_mode = "green"
			new_pos = card.ability.extra.pos_green
		end
	end
	if G.GAME.current_round.hands_played == 0 then
		if card.ability.extra.current_mode == "both" or new_mode == "green" then
			new_mode = "both"
			new_pos = card.ability.extra.pos_both
		else
			new_mode = "red"
			new_pos = card.ability.extra.pos_red
		end
	end

	card.ability.hands_played = G.GAME.current_round.hands_played

	if (card.ability.extra.current_mode ~= new_mode) then
		card.ability.extra.current_mode = new_mode
		
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function()
				card.children.center:set_sprite_pos(new_pos)
				card:juice_up()
				return true
			end
		}))
	end
end

joker.calculate = function(self, card, context)	
	-- local other_joker = nil
	-- for i = 1, #G.jokers.cards do
	-- 	if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
	-- end
	--return copy_jokers_blueprint(self, card, context)

	if not context.no_blueprint and not context.blueprint then
		
		local returns = {}
		if G.GAME.current_round.hands_left == 0 then
			--print("copying uncommon jokers...")
			--return retrigger_jokers_of_rarity(self, card, context, 2)
			--return copy_jokers_of_rarity_mk2(self, card, context, 2)
			returns[#returns + 1] = copy_jokers_of_rarity_mk2(self, card, context, 2)
		end
		if G.GAME.current_round.hands_played == 0 then
			--print("copying rare jokers...")
			--return retrigger_jokers_of_rarity(self, card, context, 3)
			--return copy_jokers_of_rarity_mk2(self, card, context, 3)
			returns[#returns + 1] = copy_jokers_of_rarity_mk2(self, card, context, 3)
		end

		if #returns > 0 then
			local new_return = {}
			local hand_score = {
				chips = hand_chips,
				mult = mult
			}
		
			for k_, v_ in pairs(returns) do
				merge_returns(new_return, v_, hand_score, (context.other_card or card))
			end
	
			--new_return.remove_default_message = true
	
			--read_table("", new_return, 1)
	
			return new_return
		end


		-- if context.cardarea == G.jokers and context.joker_main then
		-- 	return {
		-- 		x_mult = 1.5,
		-- 		mult = 2,
		-- 		chips = 10,
		-- 	}
		-- end
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
	update_sprite(self, card)
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