local joker = {
	key = "withheld number",
	pos = {x = 9, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 4,
	discovered = true,
	config = {
		extra = {
			digits,
			discovered_digits = {"?", "?", "?", "?", "?"},
			xmult = 2,
		}
	},
	loc_txt = {
		name = "Withheld Number",
		text = {"On pickup generates a", "random 5 digit sequence",
			"Cards whose rank and position", "correspond to a number in the", "sequence grant {X:mult,C:white} X#6# {} Mult",
			"{C:inactive}Discovered Sequence:", "{C:inactive}#1#-#2#-#3#-#4#-#5#{}"}
	},
	loc_vars = function(self, info_queue, card)
		-- local return_text = { "?", "?", "?", "?", "?" }

		-- if card.ability.extra.discovered then
		-- 	for i = 1, #self.config.extra.discovered do
		-- 		if self.config.extra.discovered[i] then
		-- 			return_text[i] = self.config.extra.digits[i]
		-- 		end
		-- 	end
		-- end

		-- if card.ability.extra.digits then
		-- 	for i = 1, #card.ability.extra.digits do
		-- 		return_text[i] = card.ability.extra.digits[i]
		-- 	end
		-- end
		if not card.ability.extra.discovered_digits then
			card.ability.extra.discovered_digits = {"?", "?", "?", "?", "?"}
		end

		-- debug display, remove later
		-- if card.ability.extra.digits then
		-- 	for i = 1, #card.ability.extra.digits do
		-- 		if card.ability.extra.digits[i] == 14 then
		-- 			card.ability.extra.discovered_digits[i] = 1
		-- 		else
		-- 			card.ability.extra.discovered_digits[i] = card.ability.extra.digits[i]
		-- 		end
		-- 		--card.ability.extra.discovered_digits[i] = card.ability.extra.digits[i]
		-- 	end
		-- end


		return { 
			vars = {
				card.ability.extra.discovered_digits[1],
				card.ability.extra.discovered_digits[2],
				card.ability.extra.discovered_digits[3],
				card.ability.extra.discovered_digits[4],
				card.ability.extra.discovered_digits[5],
				card.ability.extra.xmult,
			}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	if context.individual
	and context.cardarea == G.play then
		local other_card_pos = nil
		for i = 1, #context.scoring_hand do
			if context.other_card == context.scoring_hand[i] then
				other_card_pos = i
			end
		end

		if other_card_pos and other_card_pos > 5 then other_card_pos = nil end

		--local is_match = other_card_pos and context.other_card:get_id() == card.ability.extra.digits[other_card_pos]
		-- if other_card_pos and card.ability.extra.digits[other_card_pos] == 1 and context.other_card:get_id() = 14 then
		-- 	is_match = true
		-- end 
		if other_card_pos then
			local is_match = context.other_card:get_id() == card.ability.extra.digits[other_card_pos]
			if card.ability.extra.digits[other_card_pos] == 0 and SMODS.has_no_rank(context.other_card) and not context.other_card.vampired then
				is_match = true
			end
			
			if is_match then
				if card.ability.extra.digits[other_card_pos] == 14 then
					card.ability.extra.discovered_digits[other_card_pos] = 1
				else
					card.ability.extra.discovered_digits[other_card_pos] = card.ability.extra.digits[other_card_pos]
				end

				return {
					x_mult = card.ability.extra.xmult,
					colour = G.C.RED,
					card = card
				}
			end
		end
	end
end

joker.add_to_deck = function(self, card, from_debuff)
	if not card.ability.extra.digits then
		card.ability.extra.digits = {
			pseudorandom("rufia-withheld number", 0, 9),
			pseudorandom("rufia-withheld number", 0, 9),
			pseudorandom("rufia-withheld number", 0, 9),
			pseudorandom("rufia-withheld number", 0, 9),
			pseudorandom("rufia-withheld number", 0, 9),
		}
		for i=1, #card.ability.extra.digits do
			if card.ability.extra.digits[i] == 1 then
				card.ability.extra.digits[i] = 14
			end
		end
	end
end


return joker