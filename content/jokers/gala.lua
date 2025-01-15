local joker = {
	name = "rufia-gala",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			xmult = 1.0,
			scaling = 0.1,
		}
	},
	enhancement_gate = 'm_rufia_confection',
	loc_txt = {
		name = "Gala",
		text = {"Gains {X:mult,C:white} X#2# {} Mult for each {C:attention}Steel{} Card held in hand",
				"{C:attention}Destroy{} a random Joker whenever a {C:attention}Steel{} Card is scored",
				"{C:inactive}(Currently) {X:mult,C:white} X#1# {} Mult"}
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