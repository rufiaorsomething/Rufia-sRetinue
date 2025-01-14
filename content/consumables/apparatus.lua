local cons = {
	name = "rufia-apparatus",
	set = "Tarot",
	cost = 3,
	cost_mult = 1.0,
	consumeable = true,

	effect = "Enhance",
	config = {mod_conv = 'm_rufia_null', max_highlighted = 1},
	pos = {x = 1, y = 1},
	loc_txt = {
		name = "The Apparatus",
		text = {"Enhance {C:attention}#1#{} selected card",
			"into a {C:attention}Null Card{}"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rufia_null
		return {
			vars = { self.config.max_highlighted }
		}
	end,
}

return cons