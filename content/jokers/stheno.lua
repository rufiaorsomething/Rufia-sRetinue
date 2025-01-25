local joker = {
	key = "stheno",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 1,
	cost = 5,
	discovered = true,
	config = {
		extra = {
			x_mult
		}
	},
	loc_txt = {
		name = "Stheno",
		text = {"Cards with {C:green}Serpent Seals{} give", "{X:chips,C:white} X#1# {} chips when held in hand."}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return {
			vars = {
				card.ability.extra.x_mult
			} 
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	
end

return joker