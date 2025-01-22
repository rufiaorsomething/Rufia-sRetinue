local cons = {
	name = "rufia-banquet",
	set = "Tarot",
	cost = 3,
	cost_mult = 1.0,
	consumeable = true,

	effect = "Enhance",
	config = {mod_conv = 'm_rufia_confection', max_highlighted = 1},
	pos = {x = 0, y = 1},
	loc_txt = {
		name = "The Banquet",
		text = {"Enhance {C:attention}#1#{} selected card",
			"into a {C:attention}Confection Card{}"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rufia_confection
		return {
			vars = { self.config.max_highlighted }
		}
	end,
}

return cons