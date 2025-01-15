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
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

joker.update = function(self, card)
	if G.jokers then
		local found_self = false
		for i = 1, #G.jokers.cards do
			if found_self then
				G.jokers.cards[i].ability.stop_debuff = true
				G.jokers.cards[i]:set_debuff(true)
			else
				G.jokers.cards[i].ability.stop_debuff = nil
				G.jokers.cards[i]:set_debuff(false)
				if G.jokers.cards[i] == card then
					found_self = true
				end
			end
		end
	end
end


return joker