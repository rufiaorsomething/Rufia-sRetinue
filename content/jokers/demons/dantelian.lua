local joker = {
	key = "Dantelian",
	pos = {x = 0, y = 5},
	--soul_pos = { x = 1, y = 6 },
	rarity = 3,
	cost = 6,
	discovered = true,
	config = {
		extra = {
		}
	},
	loc_txt = {
		name = "Dantelian",
		text = {"Reduce the rank of each scored heart card",
			"Each {C:heart}2 of Hearts{} scored becomes a {C:attention}Null cards{}"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
			}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	
end

return joker