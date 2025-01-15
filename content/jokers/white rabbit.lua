local joker = {
	name = "rufia-white rabbit",
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
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
	if context.setting_blind and not self.getting_sliced
	and not context.blueprint and not context.blind.boss then
		card.ability.chips = card.ability.chips - card.ability.penalty
	end

	if context.cardarea == G.jokers and context.joker_main then
		return {
			message = localize{type='variable',key='a_chips',vars=card.ability.chips},
			chips_mod = card.ability.chips
		}
	end
end


return joker