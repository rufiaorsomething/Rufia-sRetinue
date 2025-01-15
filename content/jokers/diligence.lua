local joker = {
	name = "rufia-diligence",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			xmult = 1.0,
			scaling = 0.2
		}
	},
	loc_txt = {
		name = "Archangel Diligence",
		text = {"Gains {X:mult,C:white} X#2# {} Mult for each consecutive played", "hand which is your first hand of round",
				"{C:inactive}(Currently) {X:mult,C:white} X#1# {C:inactive} Mult"}
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