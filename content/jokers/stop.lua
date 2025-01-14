local joker = {
	name = "rufia-stop",
	pos = {x = 6, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 2,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Stop",
		text = {"{C:attention}Debuff{} all jokers",
			"to this card's right"}
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)

end


return joker