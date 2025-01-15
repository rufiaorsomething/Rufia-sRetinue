local joker = {
	name = "rufia-todd weaver",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 1,
	cost = 8,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Todd Weaver",
		text = {"When round begins, add a {C:tarot}Purple Seal{}", "to 1 random card in your hand",
				"Played cards with {C:tarot}Purple Seals{}", "are {C:attention}destroyed{} before scoring"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.purple_seal
		return {
			vars = {}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	
end

return joker