local joker = {
	key = "stop",
	pos = {x = 8, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 2,
	discovered = true,
	config = {},
	loc_txt = {
		name = "Stop",
		text = {"{C:attention}Debuff{} all jokers",
			"to this card's right"}
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
}

local function StopDebuff(self, card, debuff_active)
	if G.jokers and card and not card.debuff then
		local found_self = false
		for i = 1, #G.jokers.cards do
			-- if not G.jokers.cards[i].debuffed_by_blind then

			-- 	if debuff_active and found_self then
			-- 		SMODS.debuff_card(G.jokers.cards[i], true, card)
			-- 		--SMODS.recalc_debuff(G.jokers.cards[i])
			-- 		--G.jokers.cards[i].ability.stop_debuff = true
			-- 		--G.jokers.cards[i]:set_debuff(debuff_active)
			-- 		--G.jokers.cards[i]:set_debuff()
			-- 	else
			-- 		SMODS.debuff_card(G.jokers.cards[i], false, card)
					
			-- 		--SMODS.recalc_debuff(G.jokers.cards[i])
			-- 		--G.jokers.cards[i].ability.stop_debuff = nil
			-- 		--G.jokers.cards[i]:set_debuff(false)
			-- 		--G.jokers.cards[i]:set_debuff(G.jokers.cards[i].debuff)
			-- 		if G.jokers.cards[i] == card then
			-- 			found_self = true
			-- 		end
			-- 	end
			-- end

			-- if debuff_active and found_self then
			-- 	SMODS.debuff_card(G.jokers.cards[i], true, card)
			-- else
			-- 	local debuffed_by_blind = G.jokers.cards[i].debuffed_by_blind
			-- 	SMODS.debuff_card(G.jokers.cards[i], false, card)
			-- 	if debuffed_by_blind then
			-- 		SMODS.recalc_debuff(G.jokers.cards[i])
			-- 	end
				
			-- 	if G.jokers.cards[i] == card then
			-- 		found_self = true
			-- 	end
			-- end

			if debuff_active and found_self then
				-- if G.jokers.cards[i].ability.debuff_sources then
				-- 	print("G.jokers.cards[i].ability.debuff_sources")
				-- 	for k_, v_ in pairs(G.jokers.cards[i].ability.debuff_sources) do
				-- 		if type(k_) == "string" or type(v_) == "number" then
				-- 			print("debuffed by " .. k_)
				-- 			print("debuffed by " .. card)
				-- 		else
				-- 			print("debuffed by ???")
				-- 		end
				-- 	end
				-- end
				-- if G.jokers.cards[i].ability.debuff_sources[card] then
				-- 	print("G.jokers.cards[i].ability.debuff_sources[stop sign]")
				-- end
				if not G.jokers.cards[i].ability.stop_debuff then
					-- if not G.jokers.cards[i].ability.extra then
					-- 	G.jokers.cards[i].ability.extra = {}
					-- end
					-- G.jokers.cards[i].ability.extra.stop_debuff = true
					G.jokers.cards[i].ability.stop_debuff = true
				--if not G.jokers.cards[i].ability.debuff_sources["rufia_stop"] then
					SMODS.debuff_card(G.jokers.cards[i], true, card)
				end
			else
				if G.jokers.cards[i].ability.stop_debuff or G.jokers.cards[i].ability.stop_debuff == nil then
					--G.jokers.cards[i].ability.extra.stop_debuff = nil
					G.jokers.cards[i].ability.stop_debuff = false
				--if G.jokers.cards[i].ability.debuff_sources[tostring(card)] then
					SMODS.debuff_card(G.jokers.cards[i], 'reset', card)
					SMODS.recalc_debuff(G.jokers.cards[i])
				end

				-- local debuffed_by_blind = G.jokers.cards[i].debuffed_by_blind
				-- SMODS.debuff_card(G.jokers.cards[i], false, card)
				-- -- if debuffed_by_blind then
				-- -- 	--SMODS.recalc_debuff(G.jokers.cards[i])
				-- -- 	G.jokers.cards[i].debuffed_by_blind = true
				-- -- 	G.jokers.cards[i]:set_debuff(true)
				-- -- end
				-- G.jokers.cards[i].debuffed_by_blind = debuffed_by_blind
				
				if G.jokers.cards[i] == card then
					found_self = true
				end
			end

		end
	end
end

joker.update = function(self, card)
	-- if G.jokers and not card.debuff then
	-- 	local found_self = false
	-- 	for i = 1, #G.jokers.cards do
	-- 		if found_self then
	-- 			G.jokers.cards[i].ability.stop_debuff = true
	-- 			G.jokers.cards[i]:set_debuff(true)
	-- 		else
	-- 			G.jokers.cards[i].ability.stop_debuff = nil
	-- 			G.jokers.cards[i]:set_debuff(false)
	-- 			if G.jokers.cards[i] == card then
	-- 				found_self = true
	-- 			end
	-- 		end
	-- 	end
	-- end
	StopDebuff(self, card, true)
end

joker.remove_from_deck = function(self, card, from_debuff)
	StopDebuff(self, card, false)
end


return joker