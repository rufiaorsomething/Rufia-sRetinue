local joker = {
	name = "rufia-nightcap",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			xchips = 1.5,
		}
	},
	enhancement_gate = 'm_rufia_confection',
	loc_txt = {
		name = "Nightcap",
		text = {"First hand is drawn {C:attention}face down{}",
				"{C:attention}Face down{} cards {C:attention}held in hand{} grant {X:chips,C:white} X#1# {} chips",
				"After discarding {C:attention}4{} face down cards in a single round,",
				"{C:attention}destroy{} a random adjacent Joker"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xchips,
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