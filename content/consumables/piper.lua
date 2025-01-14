local cons = {
	name = "rufia-piper",
	set = "Tarot",
	cost = 3,
	cost_mult = 1.0,
	consumeable = true,

	effect = "Enhance",
	config = {mod_conv = 'm_rufia_hypnotic', max_highlighted = 2},
	pos = {x = 2, y = 1},
	loc_txt = {
		name = "The Piper",
		text = {"Enhance {C:attention}#1#{} selected cards",
			"to {C:attention}Hypnotic Cards{}"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rufia_hypnotic
		return {
			vars = { self.config.max_highlighted }
		}
	end,
}

return cons