local enhancement = {
	name = "Confection",
	key = "confection"
	altas = "Rufia_Modifications"
	pos = {x = 0, y = 0},
	loc_txt = {
		-- Badge name (displayed on card description when seal is applied)
		label = 'Confection',
		-- Tooltip description
		description = {
			name = 'Confection',
			text = {
				"When scored, permanently increase the chips of cards held in hand by this card's chips, then destroy this card"
			}
		},
	},

	calculate = function(self, card, context, effect)
		
	end
}

return enhancement