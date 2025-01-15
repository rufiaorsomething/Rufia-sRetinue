local joker = {
	name = "rufia-knave of hearts",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 1,
	cost = 5,
	discovered = true,
	config = {},
	enhancement_gate = 'm_rufia_confection',
	loc_txt = {
		name = "Knave of Hearts",
		text = {"{C:attention}Retrigger{} scoring confection cards", "once for each {C:hearts}Heart{} card played",
				"{C:attention}Discard{} all {C:attention}Non-Jack{} cards held in hand"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rufia_confection
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