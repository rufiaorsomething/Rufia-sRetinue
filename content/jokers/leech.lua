local joker = {
	name = "rufia-leech",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			mult = 0,
			scaling = 10
		}
	},
	loc_txt = {
		name = "Leech",
		text = {"Gains {C:mult}+#2#{} Mult for each scored {C:attention}face{} card",
			"{C:attention}Permanently Debuffs{} played face cards after scoring",
			"{C:inactive}(Currently) {C:mult} +#1# {C:inactive} Mult"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.scaling,
			}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	-- if context.individual
	-- and context.cardarea == G.play then
	-- 	if context.other_card:get_id() == 11 then
	-- 		local prior_xmult = card.ability.extra.xmult
			
	-- 		if not context.blueprint then
	-- 			card.ability.extra.xmult = 1.0
	-- 		end

	-- 		return {
	-- 			x_mult = prior_xmult,
	-- 			colour = G.C.RED,
	-- 			card = card
	-- 		}
	-- 	elseif not context.blueprint then
	-- 		card.ability.extra.xmult += card.ability.extra.scaling
	-- 	end
	-- end
end

return joker