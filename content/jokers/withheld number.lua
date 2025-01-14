local joker = {
	name = "rufia-withheld number",
	pos = {x = 7, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 2,
	discovered = true,
	config = {
		extra = {
			digits = {0,0,0,0,0},
			discovered = {false, false, false, false, false}
		}
	},
	loc_txt = {
		name = "Withheld Number",
		text = {"On pickup generates a", "random 5 digit sequence",
			"Cards whose rank and position", "correspond to a number in the", "sequence grant {X:mult,C:white} X2 {} Mult",
			"{C:inactive}Discovered Sequence:", "{C:inactive}#1#-#2#-#3#-#4#-#5#{}"}
	},
	loc_vars = function(self, info_queue, card)
		local return_text = { "?", "?", "?", "?", "?" }

		if self.config.discovered then
			for i in #self.config.discovered do
				if self.config.discovered then
					return_text[i] = self.config.digits[i]
				end
			end
		end

		return {
			return_text[1],
			return_text[2],
			return_text[3],
			return_text[4],
			return_text[5],
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)

end


return joker