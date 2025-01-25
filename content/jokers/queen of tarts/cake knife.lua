local joker = {
	key = "cake knife",
	pos = {x = 0, y = 1},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			sliced_value = nil,
		}
	},
	loc_txt = {
		name = "Cake Knife",
		text = {"When round begins,", "{C:attention}destroy{} joker to the right and",
			"create a {C:attention}Confection{} card of rank equal", "to the destroyed card's {C:attention}sell value{}", "{C:inactive}(max {C:attention}Ace{C:inactive}){}"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_rufia_confection
		return {
			vars = {}
		}
	end,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
	local my_pos = nil
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			my_pos = i
			break
		end
	end

	if context.setting_blind
		and not (context.blueprint_card or self).getting_sliced
		and my_pos
		and G.jokers.cards[my_pos + 1]
		and not G.jokers.cards[my_pos + 1].ability.eternal
		and not G.jokers.cards[my_pos + 1].getting_sliced
	then
		local sliced_card = G.jokers.cards[my_pos + 1]
		local sliced_card_value = sliced_card.sell_cost
		sliced_card_value = math.max(2, sliced_card_value)
		if (sliced_card_value > 10) then sliced_card_value = 1 end

		card.ability.extra.sliced_value = sliced_card_value

		sliced_card.getting_sliced = true
		G.GAME.joker_buffer = G.GAME.joker_buffer - 1
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function()
				G.GAME.joker_buffer = 0
				card:juice_up(0.8, 0.8)
				sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
				play_sound("slice1", 0.96 + math.random() * 0.08)
				return true
			end,
		}))
		
		return nil, true
	end

	
	if context.first_hand_drawn and card.ability.extra.sliced_value then
		
		local potential_ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T'}
		local _rank = potential_ranks[card.ability.extra.sliced_value] --pseudorandom_element(, pseudoseed('incantation_create'))
		local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('rufia-cake knife'))

		card.ability.extra.sliced_value = nil

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function() 
				local _card = create_playing_card({
					front = G.P_CARDS[_suit..'_'.._rank], 
					center = G.P_CENTERS.m_rufia_confection},
					G.hand,
					nil,
					nil,
					{G.C.SECONDARY_SET.Enhanced})
				
				G.GAME.blind:debuff_card(_card)
				G.hand:sort()
				if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
				return true
			end}))
		playing_card_joker_effects({true})

		return nil, true
	end
end

return joker