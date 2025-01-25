local joker = {
	key = "langwidere",
	-- pos = {x = 0, y = 0},
	-- soul_pos = { x = 1, y = 0 },
	-- atlas = "really_big",
	-- config = { rufia_rescale = {x = 1.958, y = 1.968} },
	pos = {x = 0, y = 1},
	soul_pos = { x = 1, y = 1 },
	atlas = "big",
	config = { rufia_rescale = {x = 1.479, y = 1.484} },
	rarity = 2,
	cost = 8,
	discovered = true,
	loc_txt = {
		name = "The Magician Langwidere",
		text = {"If played hand contains only", "a single scoring base edition",
				"face card {C:attention}destroy{} it and", "add {C:attention}Torn{} copy of it to your jokers", "and a {C:attention}Sundered{} copy of it to your hand"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_rufia_torn
		info_queue[#info_queue + 1] = G.P_CENTERS.e_rufia_sundered
		return {
			vars = {}
		}
	end,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	if context.destroying_card and not context.blueprint and 
		#context.full_hand == 1 and
		context.destroying_card:is_face() and not context.destroying_card.edition
		and not context.destroying_card.ability.eternal then

		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = "Decapitated!"})
		
			local torn_copy = copy_card(context.destroying_card)
			torn_copy:add_to_deck()
			torn_copy.states.visible = nil
			
			
			G.playing_card = (G.playing_card and G.playing_card + 1) or 1
			local sundered_copy = copy_card(context.destroying_card)
			sundered_copy:add_to_deck()
			G.deck.config.card_limit = G.deck.config.card_limit + 1
			table.insert(G.playing_cards, sundered_copy)
			sundered_copy.states.visible = nil


			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 1,
				func = function()
					G.jokers:emplace(torn_copy)
					local edition = {rufia_torn = true}
					torn_copy:set_edition(edition, true)
					torn_copy:start_materialize()

					G.hand:emplace(sundered_copy)
					edition = {rufia_sundered = true}
					sundered_copy:set_edition(edition, true)
					sundered_copy:start_materialize()
					playing_card_joker_effects({sundered_copy})
					return true
				end
			})) 
		

		return true
	end
end

return joker