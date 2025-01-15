local joker = {
	name = "rufia-humility",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			blind_reduction
		}
	},
	loc_txt = {
		name = "Archangel Humility",
		text = {"Each scoring unenhanced reduces the {C:attention}-#1#% Blind Size{}", "for each scoring unenhanced card played"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.blind_reduction,
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