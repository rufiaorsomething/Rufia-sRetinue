local joker = {
	key = "temperance",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			joker_slots = 3,
		}
	},
	loc_txt = {
		name = "Archangel Temperance",
		text = {"{C:attention}+#1# Joker Slots",
				"{C:attention}Debuffs{} all jokers not", "adjacent to this one"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.joker_slots,
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