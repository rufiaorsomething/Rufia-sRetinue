local joker = {
	key = "Karabas",
	pos = {x = 0, y = 5},
	--soul_pos = { x = 1, y = 6 },
	rarity = 3,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			chips = 0,
			mult = 0,
		}
	},
	loc_txt = {
		name = "Karabas",
		text = {"Halve the chips and mult of the first played poker hand",
			"This Joker Gains chips and mult equal to amount reduced",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} chips and {C:mult}+#2#{C:inactive} mult)"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.scaling,
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