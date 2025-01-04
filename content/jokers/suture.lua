local joker = {
	name = "Suture",
	config = {extra = {mult = 15, rounds_played = 0, start_apoc = false}}, rarity = 1, cost = 5,
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 4,
	cost = 20,
	discovered = true,
	--config = { extra = { money = 3 } },
	loc_txt = {
		name = "Suture",
		text = {"When {C:attention}Blind{} is selected,",
			"destroy joker to the right.",
			"Whenever a base edition",
			"joker is destroyed, create",
			"either a {C:attention}Torn{} and {C:attention}Sundered{}",
			"or a {C:attention}Ripped{} and {C:attention}Shredded{} copy"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,
	blueprint_compat = false, 
	eternal_compat = true,
	perishable_compat = true,
	abno = true,
	risk = "teth",
	discover_rounds = 6,
	loc_txt = {},
	no_pool_flag = "apocalypse_bird_event",
}

joker.calculate = function(self, card, context)
	if context.setting_blind and not self.getting_sliced  and not context.blueprint then
		local my_pos = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == self then my_pos = i; break end
		end
		if my_pos and G.jokers.cards[my_pos+1] and not self.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
			local sliced_card = G.jokers.cards[my_pos+1]
			sliced_card.getting_sliced = true
			G.GAME.joker_buffer = G.GAME.joker_buffer - 1
			G.E_MANAGER:add_event(Event({func = function()
				G.GAME.joker_buffer = 0
				self.ability.mult = self.ability.mult + sliced_card.sell_cost*2
				self:juice_up(0.8, 0.8)
				sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
				play_sound('slice1', 0.96+math.random()*0.08)
			return true end }))
		end
	end
	if context.destroying_cards then
		if context.destroyed_card then --and context.destroyed_card ~= card then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod

			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_mod}}})
		end
	end
end

return joker

-- birds are supposed to be high