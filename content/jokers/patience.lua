local is_rare = true
local joker = {
	name = "rufia-patience",
	rarity = 2,
	cost = 12,
	config =
	{
		chips=0,
		extra={
			chips = 0,
			chipgain = 2,
			progress_addition=0,
			progress_multiplication=0,
			progress_power=0,
			required_progress=12
		}
	},
	pos = {x = 1, y = 4}, 
	blueprint_compat = true, 
	eternal_compat = true,
	perishable_compat = false,
	loc_txt = {
		name = "Archangel Patience",
		text = {"Gains {C:chips}+#6#{} chips for every",
			"{C:attention}12{} cards scored {C:inactive}(Progress: #2#/#5#){}",
			"{C:attention}Double{} this Joker's chips for every",
			"{C:attention}12{} rounds played {C:inactive}(Progress: #3#/#5#){}",
			"{C:attention}Square{} this Joker's chips for every",
			"{C:attention}12{} antes beaten {C:inactive}(Progress: #4#/#5#){}",
			"{C:inactive}Currently{} {C:chips}+#1#{} {C:inactive}Chips){}"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.extra.chips,
				self.config.extra.progress_addition,
				self.config.extra.progress_multiplication,
				self.config.extra.progress_power,
				self.config.extra.required_progress,
				self.config.extra.chipgain
			}
		}
	end,
}

if is_rare then
	joker.rarity = 3

	joker.loc_txt.text = {"Gains {C:chips}+#6#{} chips for every",
			"{C:attention}12{} cards scored {C:inactive}(Progress: #2#/#5#){}",
			"{C:attention}Double{} this Joker's chips for every",
			"{C:attention}12{} hands played {C:inactive}(Progress: #3#/#5#){}",
			"{C:attention}Square{} this Joker's chips for every",
			"{C:attention}12{} antes beaten {C:inactive}(Progress: #4#/#5#){}",
			"{C:inactive}Currently{} {C:chips}+#1#{} {C:inactive}Chips){}"}
end


joker.calculate = function(self, card, context)
	local function patience_colour(progress, mode)
		if progress == 12 then
			if mode == "power" then return G.C.RARITY[4]
			elseif mode == "multiply" then return G.C.SECONDARY_SET.Spectral
			else return G.C.SECONDARY_SET.Planet end
		else
			if mode == "power" then return G.C.GOLD --G.C.RED?
			elseif mode == "multiply" then return G.C.FILTER--G.C.WHITE --G.C.FILTER?
			else return G.C.UI.TEXT_INACTIVE end
		end
	end

	local function romanise_num(num)
		if num == 1 then return "I"
		elseif num == 2 then return "II"
		elseif num == 3 then return "III"
		elseif num == 4 then return "IV"
		elseif num == 5 then return "V"
		elseif num == 6 then return "VI"
		elseif num == 7 then return "VII"
		elseif num == 8 then return "VIII"
		elseif num == 9 then return "IX"
		elseif num == 10 then return "X"
		elseif num == 11 then return "XI"
		elseif num == 12 then return "XII"
		end
	end


	if not context.blueprint then

		-- Level up per Card Scored
		if context.individual and context.cardarea == G.play then
			card.ability.extra.progress_addition = card.ability.extra.progress_addition + 1

			local ret_message = romanise_num(card.ability.extra.progress_addition)
			local ret_colour = patience_colour(card.ability.extra.progress_addition, "addition")

			if card.ability.extra.progress_addition == 12 then
				card.ability.extra.progress_addition = 0
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipgain
			end

			return {
				extra = {focus = card, message = ret_message, colour = ret_colour},--localize('k_upgrade_ex')},
				card = card,				
			}
		end

		-- Level up per Hand Played (Rare)
		if is_rare and context.cardarea == G.jokers and context.after then
			card.ability.extra.progress_multiplication = card.ability.extra.progress_multiplication + 1
			
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = romanise_num(card.ability.extra.progress_multiplication),
				colour = patience_colour(card.ability.extra.progress_multiplication, "multiply")})
			
			if card.ability.extra.progress_multiplication == 12 then
				card.ability.extra.progress_multiplication = 0
				card.ability.extra.chips = card.ability.extra.chips * 2
			end
		end


		if context.end_of_round
		and not context.repetition
		and not context.individual then

			-- Level up per Round Played (Uncommon)
			if not is_rare then
				card.ability.extra.progress_multiplication = card.ability.extra.progress_multiplication + 1

				card_eval_status_text(card, 'extra', nil, nil, nil, {
					message = romanise_num(card.ability.extra.progress_multiplication),
					colour = patience_colour(card.ability.extra.progress_multiplication, "multiply")})
				
				if card.ability.extra.progress_multiplication == 12 then
					card.ability.extra.progress_multiplication = 0
					card.ability.extra.chips = card.ability.extra.chips * 2
				end
			end

			-- Level up per Ante Beaten
			if G.GAME.blind.boss then
				card.ability.extra.progress_power = card.ability.extra.progress_power + 1
				
				card_eval_status_text(card, 'extra', nil, nil, nil, {
					message = romanise_num(card.ability.extra.progress_power),
					colour = patience_colour(card.ability.extra.progress_power, "power"),
					delay = 1.0})

				if card.ability.extra.progress_power == 12 then
					card.ability.extra.progress_power = 0
					card.ability.extra.chips = card.ability.extra.chips ^ 2
				end
			end
		end
	end




	if context.joker_main and card.ability.extra.chips > 0 then
		SMODS.eval_this(card, {
			message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS
		})
		return nil, true
	end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	local sign = card.ability.extra.chips >= 0 and "+" or ""
	local vars = {
		card.ability.extra.chips,
		card.ability.extra.progress_addition,
		card.ability.extra.progress_multiplication,
		card.ability.extra.progress_power,
		card.ability.extra.required_progress,
		card.ability.extra.chipgain
	}
	local desc_key = self.key
	--if card:check_rounds(2) < 2 then
	--    desc_key = 'dis_'..desc_key..'_1'
	--elseif card:check_rounds(5) < 5 then
	--    desc_key = 'dis_'..desc_key..'_2'
	--end

	full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	if not self.discovered and card.area ~= G.jokers then
		localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
	elseif specific_vars and specific_vars.debuffed then
		localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
	else
		localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
	end
end


if JokerDisplay then
	JokerDisplay.Definitions.j_lobc_old_lady = {
		text = {
			{ ref_table = "card.joker_display_values", ref_value = "sign" },
			{ ref_table = "card.ability.extra", ref_value = "chips" }
		},
		text_config = { colour = G.C.CHIPS },
		calc_function = function(card)
			card.joker_display_values.sign = card.ability.extra.chips >= 0 and "+" or ""
		end,
		style_function = function(card, text, reminder_text, extra)
			if text then 
				text.states.visible = card:check_rounds(2) >= 2
			end
			if reminder_text then
			end
			if extra then
			end
			return false
		end
	}
end

return joker
--[[ local config = SMODS.current_mod.config
local joker = {
	name = "rufia-patience",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 3,
	cost = 12,
	discovered = true,
	config =
	{
		chips=0,
		extra={
			progress_addition=0,
			progress_multiplication=0,
			progress_power=0,
			required_progress=12
		}
	},
	loc_txt = {
		name = "Archangel Patience",
		text = {"Gains {C:chips}+2{} chips for every",
			"{C:attention}12{} cards scored {C:inactive}(Progress: #2#/#5#){}",
			"{C:attention}Double{} this Joker's chips for every",
			"{C:attention}12{} rounds played {C:inactive}(Progress: #3#/#5#){}",
			"{C:attention}Square{} this Joker's chips for every",
			"{C:attention}12{} antes beaten {C:inactive}(Progress: #4#/#5#){}",
			"{C:inactive}Currently{} {C:chips}+#1#{} {C:inactive}Chips){}"}
			-- text = {"Gains {C:chips}+2{} chips for every 12 cards scored",
			-- "{C:attention}Double{} this Joker's chips for every 12 rounds played",
			-- "{C:attention}Square{} this Joker's chips for every 12 antes beaten",
			-- "{C:inactive}Currently {C:chips}+#1#{} Chips{}",
			-- "{C:inactive}(Progress: #2#/#5# cards scored){}",
			-- "{C:inactive}(Progress: #3#/#5# rounds played){}",
			-- "{C:inactive}(Progress: #4#/#5# antes beaten){}"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				self.config.chips,
				self.config.extra.progress_addition,
				self.config.extra.progress_multiplication,
				self.config.extra.progress_power,
				self.config.extra.required_progress
			}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
	local function patience_colour(progress, mode)
		if progress == 12 then
			if mode == "power" then return G.C.RARITY[4]
			elseif mode == "multiply" then return G.C.SECONDARY_SET.Spectral
			else return G.C.SECONDARY_SET.Planet end
		else
			if mode == "power" then return G.C.FILTER --G.C.RED?
			elseif mode == "multiply" then return G.C.WHITE --G.C.FILTER?
			else return G.C.UI.TEXT_INACTIVE end
		end
	end

	local function romanise_num(num)
		if num == 1 then return "I"
		elseif num == 2 then return "II"
		elseif num == 3 then return "III"
		elseif num == 4 then return "IV"
		elseif num == 5 then return "V"
		elseif num == 6 then return "VI"
		elseif num == 7 then return "VII"
		elseif num == 8 then return "VIII"
		elseif num == 9 then return "IX"
		elseif num == 10 then return "X"
		elseif num == 11 then return "XI"
		elseif num == 12 then return "XII"
		end
	end

	if context.individual and context.cardarea == G.play then
		self.config.extra.progress_addition = self.config.extra.progress_addition + 1

		local ret_message = romanise_num(self.config.progress_addition)
		local ret_colour = patience_colour(self.config.progress_addition, "add")
		
		--card_eval_status_text(card, 'extra', nil, nil, nil, {
		--	message = romanise_num(self.config.extra.progress_addition),
		--	colour = patience_colour(self.config.extra.progress_addition, "add"),
		--	delay = 0.5})

		if self.config.extra.progress_addition == 12 then
			self.config.extra.progress_addition = 0
			self.config.chips = self.config.chips + 2
		end
	
		return {
			extra = {focus = card, message = 'I'},--localize('k_upgrade_ex')},
			card = card,
			colour = G.C.CHIPS
		}
	end
	if context.end_of_round 
	and not context.blueprint
	and not context.repetition
	and not context.individual then
		self.config.extra.progress_multiplication = self.config.extra.progress_multiplication + 1

		--local ret_message = romanise_num(self.config.progress_addition)
		--local ret_colour = patience_colour(self.config.progress_addition, "addition")
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = romanise_num(self.config.extra.progress_multiplication),
			colour = patience_colour(self.config.extra.progress_multiplication, "multiply")})
		
		if self.config.extra.progress_multiplication == 12 then
			self.config.extra.progress_multiplication = 0
			self.config.chips = self.config.chips * 2
		end

		if G.GAME.blind.boss then
			self.config.extra.progress_power = self.config.extra.progress_power + 1
			
			--local ret_message = romanise_num(self.config.progress_addition)
			--local ret_colour = patience_colour(self.config.progress_addition, "addition")
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = romanise_num(self.config.extra.progress_power),
				colour = patience_colour(self.config.extra.progress_power, "multiply"),
				delay = 0.5})

			if self.config.extra.progress_power == 12 then
				self.config.extra.progress_power = 0
				self.config.chips = self.config.chips ^ 2
			end

			--return {
			--	message = ret_message,
			--	colour = ret_colour
			--}
		end
	
		--return {
		--	message = ret_message,
		--	colour = ret_colour
		--}
	end
end


return joker--]]