local joker = {
	name = "rufia-cheshire",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 1,
	cost = 5,
	discovered = true,
	config = { extra = { odds = 3 } },
	loc_txt = {
		name = "Cheshire",
		text = {"{C:green}#1# in #2#{} chance to duplicate", "destroyed face cards"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				"" .. (G.GAME and G.GAME.probabilities.normal or 1),
				self.config.extra.odds
			} 
		}
	end,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

local function cheshire_duplicate(self, card, context, dupe_target)
	if pseudorandom("rufia-cheshire") < G.GAME.probabilities.normal / card.ability.extra.odds then
		local duplicated_card = copy_card(dupe_target)
		duplicated_card:add_to_deck()
		G.hand:emplace(duplicated_card)

		G.E_MANAGER:add_event(Event({
			func = function() 
				card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize("k_duplicated_ex")});
				return true
			end
		}))
	end

end

joker.calculate = function(self, card, context)
	if context.cards_destroyed and not context.blueprint then
		--local faces = 0
		for k, v in ipairs(context.glass_shattered) do
			if v:is_face() then
				--faces = faces + 1

				cheshire_duplicate(self, card, context, v)
			end
		end
		return
	end

	if context.remove_playing_cards and not context.blueprint then
		--local face_cards = 0
		for k, val in ipairs(context.removed) do
			if val:is_face() then 
				--face_cards = face_cards + 1 
				
				cheshire_duplicate(self, card, context, val)
			end
		end
		return
	end
end

return joker