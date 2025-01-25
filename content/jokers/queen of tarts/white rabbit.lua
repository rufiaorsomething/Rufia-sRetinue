local joker = {
	key = "white rabbit",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 4,
	discovered = true,
	config = {
		extra = {
			chips = 200,
			penalty = 50,
		}
	},
	loc_txt = {
		name = "White Rabbit",
		text = {"{C:chips}+#1#{} Chips",
			"{C:chips}-#2#{} for every {C:attention}Non-Boss Blind{} selected"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.penalty,
			}
		}
	end,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
	if context.setting_blind and not self.getting_sliced
	and not context.blueprint and not context.blind.boss then
		if card.ability.extra.chips - card.ability.extra.penalty <= 0 then 
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
						func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
							return true; end})) 
					return true
				end
			}))
			SMODS.eval_this(card, {
				message = localize('k_eaten_ex'),
				colour = G.C.CHIPS
			})
		else
			card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.penalty
			-- return {
			-- 	message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.penalty}},
			-- 	colour = G.C.CHIPS
			-- }
			SMODS.eval_this(card, {
				message = localize{type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.penalty}},
				colour = G.C.CHIPS
			})
		end
	end

	if context.cardarea == G.jokers and context.joker_main then
		SMODS.eval_this(card, {
			message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
			chip_mod = card.ability.extra.chips, 
			colour = G.C.CHIPS
		})
	end
end


return joker