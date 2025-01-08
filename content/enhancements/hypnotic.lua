local enhancement = {
	name = "Hypnotic Card",
	key = "hypnotic",
	atlas = "Rufia_Modifications",
	pos = {x = 2, y = 0},
	loc_txt = {
		name = "Hypnotic Card",
		text = {"Card scores when",
			"held in hand",
			"Scores before other",
			"held in hand abilities"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,

	calculate = function(self, card, context, effect)
	end
}

return enhancement