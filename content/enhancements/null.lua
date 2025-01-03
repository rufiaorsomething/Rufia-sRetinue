local enhancement = {
	name = "Null",
	key = "null"
	altas = "Rufia_Modifications"
	pos = {x = 1, y = 0},
	loc_txt = {
		-- Badge name (displayed on card description when seal is applied)
		label = 'Null',
		-- Tooltip description
		description = {
			name = 'Null',
			text = {
				"No rank or suit",
				"When scored, permanently upgrade the level of played poker hand",
				"Card always scores"
			}
		},
	},

	calculate = function(self, card, context, effect)
		
	end
}

return enhancement