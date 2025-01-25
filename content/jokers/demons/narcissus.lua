local joker = {
	key = "Narcissus",
	pos = {x = 0, y = 5},
	--soul_pos = { x = 1, y = 6 },
	rarity = 3,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			xmult = 1.0,
			scaling = 1.0,
			penalty = 1.0,
		}
	},
	loc_txt = {
		name = "Narcissus",
		-- text = {"Gains {X:mult, C:white} X#2# {} mult for each hand played.",
		-- 	"Reduced by {X:mult, C:white} X#3# {} for each card of a different rank or suit held in hand",
		-- 	"{C:inactive}(Currently {X:mult, C:white} X#2# {:inactive} mult)"},
		text = {"Gains {X:mult, C:white} X#2# {} mult for each consecutive hand played", "with no cards of different {C:attention}rank{} or {C:attention}suit{} scored or held in hand.",
			"{C:inactive}(Currently {X:mult, C:white} X#2# {:inactive} mult)"},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
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