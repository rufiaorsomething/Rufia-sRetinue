local joker = {
	name = "Matthias",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 4,
	cost = 20,
	discovered = true,
	--config = { extra = 1 },
	loc_txt = {
		name = "Matthias",
		text = {"Played Gold Cards grant",
			"{C:mult}Mult{} equal to your {C:money}${}"}
	},
	loc_vars = function(self, info_queue, card)
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