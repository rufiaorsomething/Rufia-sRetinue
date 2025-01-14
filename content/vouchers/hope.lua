local voucher = {
	name = "rufia-hope",
	object_type = "Voucher",
	order = 2,
	atlas = "atlasvoucher",
	pos = { x = 1, y = 2 },
	loc_txt = {
		name = "Hope",
		text = {"Creates a {C:legendary}Legendary{} Joker", "(Must have room)",}
	},
	loc_vars = function(self, info_queue)
		--info_queue[#info_queue+1] = {set = "Tag", key = "tag_double"}
		--info_queue[#info_queue+1] = {set = "Tag", key = "tag_cry_quadruple", specific_vars = {3}}
		return { vars = {} }
	end,
	requires = { "v_rufia_pandoras box" },
	redeem = function(self)
		local createjoker = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
		G.GAME.joker_buffer = G.GAME.joker_buffer + createjoker
		local new_card = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
		new_card:add_to_deck()
		G.jokers:emplace(new_card)
		G.GAME.joker_buffer = 0
	end,
}
return voucher