local joker = {
	name = "rufia-matthias",
	atlas = "big",
	pos = {x = 2, y = 0},
	soul_pos = { x = 3, y = 0 },
	rarity = 4,
	cost = 20,
	discovered = true,
	config = { rufia_rescale = {x = 1.479, y = 1.484} },
	enhancement_gate = 'm_gold',
	loc_txt = {
		name = "Matthias",
		text = {"Played {C:attention}Gold{} cards grant",
			"{C:mult}Mult{} equal to your {C:money}${}"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		return {
			vars = {}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	if context.individual and context.cardarea == G.play
	and context.other_card.config.center == G.P_CENTERS.m_gold then
		return {
			mult = (G.GAME.dollars + (G.GAME.dollar_buffer or 0)),--self.ability.extra*math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))),
			card = self
		}
	end
end

return joker