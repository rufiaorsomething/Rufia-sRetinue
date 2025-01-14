local joker = {
	name = "rufia-queen of tarts",
	atlas = "big",
	pos = {x = 0, y = 0},
	soul_pos = { x = 1, y = 0 },
	rarity = 4,
	cost = 20,
	discovered = true,
	discovered = true,
	config = { rufia_rescale = {x = 1.479, y = 1.484} },
	loc_txt = {
		name = "The Queen of Tarts",
		text = {"Played Kings become {C:attention}Confection Cards{}",
			"Played Queens grant {C:mult}Mult{}",
			"equal to their {C:chips}Chips{}."}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rufia_confection
		return {
			vars = {}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	if context.individual
	and context.cardarea == G.play
	and context.other_card:get_id() == 12 then
		local card_queen = context.other_card
		local card_chips = card_queen:get_chip_bonus()--card_queen.base.nominal + card_queen.ability.perma_bonus
		--if card_queen.ability then
		--	card_chips = card_chips + card_queen.ability.chips--bonus_chips
		--	if card_queen.ability.extra then
		--		card_chips = card_chips + card_queen.ability.extra.chips
		--	end
		--end
		if card_queen.edition then
			card_chips = card_chips + (card_queen.edition.chips or 0)
		end

		return {
			mult = card_chips,
			card = self
		}
	end

	if context.cardarea == G.jokers and context.before then
		local kings = {}
		for k, v in ipairs(context.scoring_hand) do
			if v:get_id() == 13 then
				kings[#kings+1] = v
				v:set_ability(G.P_CENTERS.m_rufia_confection, nil, true)
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						return true
					end
				})) 
			end
		end
		if #kings > 0 then
			return {
				message = "Time for Dessert!",--localize('k_gold'),
				colour = G.C.SUITS.Hearts,
				card = self
			}
		end
	end
end

return joker