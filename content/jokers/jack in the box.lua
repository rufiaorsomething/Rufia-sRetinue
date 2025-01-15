local joker = {
	name = "rufia-jack in the box",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 5,
	discovered = true,
	config = {
		extra = {
			xmult = 1.0,
			scaling = 0.1
		}
	},
	loc_txt = {
		name = "Jack in the Box",
		text = {"Each scoring {C:attention}Jack{} grants {X:mult,C:white} X#2# {} Mult for", "each consecutive non-Jack card scored",
			"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"}
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
	if context.individual
	and context.cardarea == G.play then
		if context.other_card:get_id() == 11 then
			local prior_xmult = card.ability.extra.xmult
			
			if not context.blueprint then
				card.ability.extra.xmult = 1.0
			end
			return {
				x_mult = prior_xmult,
				colour = G.C.RED,
				message = localize("k_reset"),
				card = card,
			}
		elseif not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.scaling
		end
	end
end

return joker