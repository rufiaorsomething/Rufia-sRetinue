local joker = {
	name = "rufia-sottc",
	pos = {x = 7, y = 1},
	--soul_pos = { x = 3, y = 3 },
	rarity = 2,
	cost = 2,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Sign of Things to Come",
		text = {"Copies ability of {C:attention}Joker{} to the right",
			"Transform a random Joker into a copy",
			"of this card at the end of round",
			"{s:0.8}Max 1 tranformed Joker each round{}"}
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