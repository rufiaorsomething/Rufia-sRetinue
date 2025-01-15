local joker = {
	name = "rufia-humility",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			blind_reduction = 0.01,
		}
	},
	loc_txt = {
		name = "Archangel Humility",
		text = {"Each card scored reduces Blind by {X:dark_edition,C:white} X#1# {}", "for each scoring {C:attention}unenhanced{} card played"}
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