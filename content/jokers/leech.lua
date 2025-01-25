local joker = {
	key = "leech",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			mult = 0,
			scaling = 8
		}
	},
	loc_txt = {
		name = "Leech",
		text = {"Gains {C:mult}+#2#{} Mult for each scored {C:attention}face{} card",
			"{C:attention}Permanently debuffs{} played", "{C:attention}face{} cards after scoring",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"}
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
	if context.individual
	and context.cardarea == G.play
	and context.other_card:is_face() and not context.blueprint then
		card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.scaling

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function()
				context.other_card:juice_up()
				return true
			end
		}))
		SMODS.eval_this(card, {
			message = localize("k_upgrade_ex"),
			colour = G.C.MULT
		})
	end

	if context.cardarea == G.jokers then
		if context.after and not context.blueprint then

			local faces = {}
			for k, v in ipairs(context.full_hand) do--(context.scoring_hand) do
				if v:is_face() then
					faces[#faces+1] = v

					G.E_MANAGER:add_event(Event({
						func = function()
							v.ability.perma_debuff = true
							v:set_debuff(true)
							v:juice_up()
							return true
						end
					}))
				end
			end

			if #faces > 0 then
				SMODS.eval_this(card, {
					message = "Leeched!",
					colour = G.C.MULT
				})
			end
		end

		if context.cardarea == G.jokers and context.joker_main then
			SMODS.eval_this(card, {
				message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
				mult_mod = card.ability.extra.mult, 
				colour = G.C.MULT
			})
		end
	end
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