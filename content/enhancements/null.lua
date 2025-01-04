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
		name = "Null",
		text = {
			"no rank or suit",
			"When scored, permanently",
			"upgrade the level",
			"of played poker hand"
		}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,

	calculate = function(self, card, context, effect)
		if context.cardarea == G.play and not context.repetition then
			local hand = G.GAME.last_hand_played
			
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
			level_up_hand(card, hand, nil, 1)
			update_hand_text(
				{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname=localize(hand, 'poker_hands'), chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level}
			)
		end
	end
}

return enhancement