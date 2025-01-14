local voucher = {
	name = "rufia-pandoras box",
	object_type = "Voucher",
	atlas = "atlasvoucher",
	order = 1,
	pos = { x = 0, y = 2 },
	config = { extra = { odds = 3 } },
	loc_txt = {
		name = "Pandora's Box",
		text = {"{C:green}#1# in #2#{} chance for each", "joker to become {C:attention}Eternal{}",
			"{C:green}#1# in #2#{} chance for each", "joker to become {C:attention}Perishable{}",
			"{C:green}#1# in #2#{} chance for each", "joker to become {C:attention}Rental{}"}
	},
	loc_vars = function(self, info_queue)
		--info_queue[#info_queue+1] = {set = "Tag", key = "tag_double"}
		--info_queue[#info_queue+1] = {set = "Tag", key = "tag_cry_triple", specific_vars = {2}}
		return { 
			vars = {
				"" .. (G.GAME and G.GAME.probabilities.normal or 1),
				self.config.extra.odds
			} 
		}
	end,
	redeem = function(self)
		for i = 1, #G.jokers.cards do
			local percent = 1.15 - (i-0.999)/(#G.jokers-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function() 
					G.jokers.cards[i]:flip()
					play_sound('card1', percent)
					--G.jokers.cards[i]:juice_up(0.3, 0.3)
					return true 
				end 
				}))
		end

		for i = 1, #G.jokers.cards do
			local percent = 1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					--Make Eternal
					if pseudorandom("rufia-pandoras box") < G.GAME.probabilities.normal / self.config.extra.odds then
						G.jokers.cards[i]:set_eternal(true)
					end
		
					--Make Perishable
					if pseudorandom("rufia-pandoras box") < G.GAME.probabilities.normal / self.config.extra.odds then
						G.jokers.cards[i]:set_perishable(true)
					end
		
					--Make Rental
					if pseudorandom("rufia-pandoras box") < G.GAME.probabilities.normal / self.config.extra.odds then
						G.jokers.cards[i]:set_rental(true)
					end

					--G.jokers.cards[i]:flip()
					--play_sound('card1', percent)
					G.jokers.cards[i]:juice_up(0.3, 0.3)
					return true 
				end 
				}))
		end

		for i = 1, #G.jokers.cards do
			local percent = 1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function() 
					G.jokers.cards[i]:flip()
					play_sound('card1', percent)
					--G.jokers.cards[i]:juice_up(0.3, 0.3)
					return true 
				end 
				}))
		end
	end,
}
return voucher