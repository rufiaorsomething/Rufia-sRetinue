local joker = {
	name = "rufia-todd weaver",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 1, y = 6 },
	rarity = 1,
	cost = 8,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Todd Weaver",
		text = {"When round begins, add a {C:tarot}Purple Seal{}", "to 1 random card in your hand",
				"Played cards with {C:tarot}Purple Seals{}", "are {C:attention}destroyed{} after scoring"}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.purple_seal
		return {
			vars = {}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	if context.first_hand_drawn then

		G.E_MANAGER:add_event(Event({
			func = function()
				local selected_card = pseudorandom_element(G.hand.cards, pseudoseed('rufia_todd weaver'))
				selected_card:set_seal("Purple")
				if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
				return true
			end}))
	end


	-- if context.cardarea == G.jokers and not context.blueprint then
    --     if context.before then
    --         for _, v in ipairs(context.scoring_hand) do
    --             if v:is_suit("Hearts") then
    --                 card.ability.extra.not_hearts = false
    --             else
    --                 card.ability.extra.all_hearts = false
    --             end
    --         end
    --     elseif context.after then
    --         card.ability.extra.not_hearts = true
    --         card.ability.extra.all_hearts = true
    --         card.ability.extra.first = false
    --     end
    -- end

	if context.destroying_card and not context.blueprint and 
		context.destroying_card.seal and context.destroying_card.seal == 'Purple' and not context.destroying_card.ability.eternal then
		card_eval_status_text(card, 'extra', nil, nil, nil, {
			message = "Defied Fate..."})--localize("k_duplicated_ex")});

		return true
	end
end

return joker