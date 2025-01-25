local joker = {
	key = "chastity",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			chips = 100,
			scaling = 100,
			penalty = 25
		}
	},
	loc_txt = {
		name = "Archangel Chastity",
		text = {"Gains {C:chips}+#2#{} chips whenever blind is selected",
				"Loses {C:chips}#3#{} chips for each card held in hand",
				"{C:inactive}(Currently {C:chips}+#1# {C:inactive} chips)"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.scaling,
				card.ability.extra.penalty,
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