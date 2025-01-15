local joker = {
	name = "rufia-medusa",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 1,
	cost = 5,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Medusa",
		text = {"{C:attention}Unscoring{} face cards become {C:attention}Stone{} cards when played"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		return {
			vars = {} 
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	
end

return joker