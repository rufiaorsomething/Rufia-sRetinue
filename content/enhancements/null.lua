local enhancement = {
	name = "Null Card",
	key = "null",
	atlas = "Rufia_Modifications",
	no_rank = true,
	no_suit = true,
	replace_base_card = true,
	always_scores = true,
	pos = {x = 1, y = 0},
--[[ 	loc_txt = {
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
	}, ]]
	loc_txt = {
		name = "Null Card",
		text = {
			"No rank or suit",
			"Permanently level up played",
			"poker hand when scored"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,

	calculate = function(self, card, context, effect)
		if context.cardarea == G.play and context.main_scoring and not context.repetition then

			--effect.level_up = 1
			--effect.card = card
			return {
				null_level_up = 1,
				card = card
			}
		end
	end
}

return enhancement