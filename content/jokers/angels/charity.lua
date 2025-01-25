local joker = {
	key = "charity",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 8,
	discovered = true,
	config = {
		extra = {
		}
	},
	loc_txt = {
		name = "Archangel Charity",
		text = {"Create a random {C:attention{}Consumable{} whenever played hand contains no {C:attention}enhanced{} cards",
			"Consumables can no longer be sold"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
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