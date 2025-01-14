local enhancement = {
	name = "Confection Card",
	key = "confection",
	atlas = "Rufia_Modifications",
	pos = {x = 0, y = 0},
	loc_txt = {
		name = "Confection Card",
		text = {"When scored, permanently",
			"increase the chips of",
			"cards {C:attention}held in hand{} by",
			"this card's chips",
			"Destroy this card after scoring"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,

	calculate = function(self, card, context, effect)
		if context.cardarea == G.play and not context.repetition then
			--if (card.ability.name) then print(card.ability.name) end

			local eaten_chips = card:get_chip_bonus()--card.base.nominal + card.ability.perma_bonus --card.ability.chips + card.ability.perma_bonus
			if card.edition then
				eaten_chips = eaten_chips + (card.edition.chips or 0)
			end
			
			for i, held_card in pairs(G.hand.cards) do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.5,
					func = function()
						held_card:juice_up()
						play_sound('chips1', 0.8+ (0.9 + 0.2*math.random())*0.2, 1)
						card:juice_up(0.6, 0.1)
						G.ROOM.jiggle = G.ROOM.jiggle + 0.7
						return true
					end
				}))
				held_card.ability.perma_bonus = held_card.ability.perma_bonus + eaten_chips
				--if i ~= # G.hand.cards then
						card_eval_status_text(held_card, 'extra', nil, nil, nil, {
						message = localize{type='variable',key='a_chips',vars={eaten_chips}},
						colour = G.C.BLUE,
						delay = 0,
						chip_mod = true
					})
				--end
			end
			-- G.E_MANAGER:add_event(Event({
			-- 	trigger = 'after',
			-- 	delay = 0.5,
			-- 	func = function()
			-- 		-- Just to give the card a lil extra pause before scoring
			-- 		-- there's probably a better way to do this
			-- 		return true
			-- 	end
			-- }))
			delay(1)
		end
	end
}

return enhancement