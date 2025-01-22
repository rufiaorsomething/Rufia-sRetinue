local joker = {
	name = "rufia-playing card",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	--rarity = 1,
	--cost = 4,
	--discovered = true,
	config = {
		extra = {
			playing_card_data = {}
		}
	},
	loc_txt = {},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	no_collection = true,
	no_atlas = true,
}

local function score_playing_card(self, card, context) then
	local effects = {eval_card(card, {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, poker_hand = text})}
	local post_effect = {seals = effects[1].seals, edition = effects[1].edition}
	effects[1].seals = nil
	effects[1].edition = nil
	local extra_enhancements = SMODS.get_enhancements(card, true)
	local old_ability = copy_table(card.ability)
	local old_center = card.config.center
	local old_center_key = card.config.center_key
	for k, _ in pairs(extra_enhancements) do
		if G.P_CENTERS[k] then
			card:set_ability(G.P_CENTERS[k])
			card.ability.extra_enhancement = k
			effects[#effects+1] = eval_card(card, {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, poker_hand = text, extra_enhancement = true})
		end
	end
	effects[#effects+1] = post_effect
	card.ability = old_ability
	card.config.center = old_center
	card.config.center_key = old_center_key
	card:set_sprites(old_center)
	for k=1, #G.jokers.cards do
		--calculate the joker individual card effects
		local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = card, individual = true,
		callback = function(card, eval, retrigger)
			if eval then 
				table.insert(effects, eval)
				effects[#effects].from_retrigger = retrigger
				end
		end,
		no_retrigger_anim = true})
	end
	card.lucky_trigger = nil

	for ii = 1, #effects do
		if effects[ii].level_up then
			--if effects[ii].card then juice_card(effects[ii].card) end
			local hand_i = G.GAME.last_hand_played
			level_up_hand(effects[ii].card, hand_i, true, effects[ii].level_up)
		
			local col = G.C.GREEN
			
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					play_sound('tarot1')
					if effects[ii].card and effects[ii].card.juice_up then effects[ii].card:juice_up(0.8, 0.5) end
					G.TAROT_INTERRUPT_PULSE = true
					return true 
				end }))
			mult = mod_mult(mult + G.GAME.hands[hand_i].l_mult)
			update_hand_text({delay = 0}, {mult = mult, StatusText = true})
		
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.9,
				func = function()
					play_sound('tarot1')
					if effects[ii].card and effects[ii].card.juice_up then effects[ii].card:juice_up(0.8, 0.5) end
					return true 
				end }))
			hand_chips = mod_chips(hand_chips + G.GAME.hands[hand_i].l_chips)
			update_hand_text({delay = 0}, {chips = hand_chips, StatusText = true})
		
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.9,
				func = function()
					play_sound('tarot1')
					if effects[ii].card and effects[ii].card.juice_up then effects[ii].card:juice_up(0.8, 0.5) end
					G.TAROT_INTERRUPT_PULSE = nil
					return true
				end }))
			update_hand_text(
				{sound = 'button', volume = 0.7, pitch = 0.9, delay = 0},
				{level=G.GAME.hands[hand_i].level}
			)
			delay(1.3)
		end
		--If chips added, do chip add event and add the chips to the total
		if effects[ii].chips then 
			if effects[ii].card then juice_card(effects[ii].card) end
			hand_chips = mod_chips(hand_chips + effects[ii].chips)
			update_hand_text({delay = 0}, {chips = hand_chips})
			card_eval_status_text(card, 'chips', effects[ii].chips, percent)
		end

		--If mult added, do mult add event and add the mult to the total
		if effects[ii].mult then 
			G.GAME.current_round.kcv_mults_scored = (G.GAME.current_round.kcv_mults_scored or 0) + 1
		
			if effects[ii].card then juice_card(effects[ii].card) end
			mult = mod_mult(mult + effects[ii].mult)
			update_hand_text({delay = 0}, {mult = mult})
			card_eval_status_text(card, 'mult', effects[ii].mult, percent)
		end

		--If play dollars added, add dollars to total
		if effects[ii].p_dollars then 
			if effects[ii].card then juice_card(effects[ii].card) end
			ease_dollars(effects[ii].p_dollars)
			card_eval_status_text(card, 'dollars', effects[ii].p_dollars, percent)
		end

		--If dollars added, add dollars to total
		if effects[ii].dollars then 
			if effects[ii].card then juice_card(effects[ii].card) end
			ease_dollars(effects[ii].dollars)
			card_eval_status_text(card, 'dollars', effects[ii].dollars, percent)
		end

		--Any extra effects
		
		if effects[ii].kcv_juice_card_until then
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = function()
					local eval = function(card)
						return true
					end
					juice_card_until(effects[ii].card, eval, true)
					return true
				end
			}))
		end
		
		if effects[ii].extra then 
			if effects[ii].card then juice_card(effects[ii].card) end
			local extras = {mult = false, hand_chips = false}
			if effects[ii].extra.mult_mod then mult =mod_mult( mult + effects[ii].extra.mult_mod);extras.mult = true end
			if effects[ii].extra.chip_mod then hand_chips = mod_chips(hand_chips + effects[ii].extra.chip_mod);extras.hand_chips = true end
			if effects[ii].extra.swap then 
				local old_mult = mult
				mult = mod_mult(hand_chips)
				hand_chips = mod_chips(old_mult)
				extras.hand_chips = true; extras.mult = true
			end
			if effects[ii].extra.func then effects[ii].extra.func() end
			update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
			card_eval_status_text(card, 'extra', nil, percent, nil, effects[ii].extra)
		end

		if effects[ii].seals then
			if effects[ii].seals.chips then 
				if effects[ii].card then juice_card(effects[ii].card) end
				hand_chips = mod_chips(hand_chips + effects[ii].seals.chips)
				update_hand_text({delay = 0}, {chips = hand_chips})
				card_eval_status_text(card, 'chips', effects[ii].seals.chips, percent)
			end
			
			if effects[ii].seals.mult then 
				if effects[ii].card then juice_card(effects[ii].card) end
				mult = mod_mult(mult + effects[ii].seals.mult)
				update_hand_text({delay = 0}, {mult = mult})
				card_eval_status_text(card, 'mult', effects[ii].seals.mult, percent)
			end
			
			if effects[ii].seals.p_dollars then 
				if effects[ii].card then juice_card(effects[ii].card) end
				ease_dollars(effects[ii].seals.p_dollars)
				card_eval_status_text(card, 'dollars', effects[ii].seals.p_dollars, percent)
			end
			
			if effects[ii].seals.dollars then 
				if effects[ii].card then juice_card(effects[ii].card) end
				ease_dollars(effects[ii].seals.dollars)
				card_eval_status_text(card, 'dollars', effects[ii].seals.dollars, percent)
			end
			
			if effects[ii].seals.x_mult then 
				if effects[ii].card then juice_card(effects[ii].card) end
				mult = mod_mult(mult*effects[ii].seals.x_mult)
				update_hand_text({delay = 0}, {mult = mult})
				card_eval_status_text(card, 'x_mult', effects[ii].seals.x_mult, percent)
			end
		
			if effects[ii].seals.func then
				effects[ii].seals.func()
			end
		end
		
		-- --If x_mult added, do mult add event and mult the mult to the total
		-- if effects[ii].x_mult then 
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	mult = mod_mult(mult*effects[ii].x_mult)
		-- 	update_hand_text({delay = 0}, {mult = mult})
		-- 	card_eval_status_text(card, 'x_mult', effects[ii].x_mult, percent)
		-- 	if next(find_joker("cry-Exponentia")) then
		-- 		for _, v in pairs(find_joker("cry-Exponentia")) do
		-- 			local old = v.ability.extra.Emult
		-- 			v.ability.extra.Emult = v.ability.extra.Emult + v.ability.extra.Emult_mod
		-- 			card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_powmult',vars={number_format(to_big(v.ability.extra.Emult))}}})
		-- 			exponentia_scale_mod(v, v.ability.extra.Emult_mod, old, v.ability.extra.Emult)
		-- 		end
		-- 	end
		-- end

		-- if effects[ii].x_chips then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	hand_chips = mod_chips(hand_chips*effects[ii].x_chips)
		-- 	update_hand_text({delay = 0}, {chips = hand_chips})
		-- 	card_eval_status_text(card, 'x_chips', effects[ii].x_chips, percent)
		-- end
		-- if effects[ii].e_chips then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	hand_chips = mod_chips(hand_chips^effects[ii].e_chips)
		-- 	update_hand_text({delay = 0}, {chips = hand_chips})
		-- 	card_eval_status_text(card, 'e_chips', effects[ii].e_chips, percent)
		-- end
		-- if effects[ii].ee_chips then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	hand_chips = mod_chips(hand_chips:arrow(2, effects[ii].ee_chips))
		-- 	update_hand_text({delay = 0}, {chips = hand_chips})
		-- 	card_eval_status_text(card, 'ee_chips', effects[ii].ee_chips, percent)
		-- end
		-- if effects[ii].eee_chips then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	hand_chips = mod_chips(hand_chips:arrow(3, effects[ii].eee_chips))
		-- 	update_hand_text({delay = 0}, {chips = hand_chips})
		-- 	card_eval_status_text(card, 'eee_chips', effects[ii].eee_chips, percent)
		-- end
		-- if effects[ii].hyper_chips and type(effects[ii].hyper_chips) == 'table' then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	hand_chips = mod_chips(hand_chips:arrow(effects[ii].hyper_chips[1], effects[ii].hyper_chips[2]))
		-- 	update_hand_text({delay = 0}, {chips = hand_chips})
		-- 	card_eval_status_text(card, 'hyper_chips', effects[ii].hyper_chips, percent)
		-- end
		-- if effects[ii].e_mult then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	mult = mod_mult(mult^effects[ii].e_mult)
		-- 	update_hand_text({delay = 0}, {mult = mult})
		-- 	card_eval_status_text(card, 'e_mult', effects[ii].e_mult, percent)
		-- end
		-- if effects[ii].ee_mult then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	mult = mod_mult(mult:arrow(2, effects[ii].ee_mult))
		-- 	update_hand_text({delay = 0}, {mult = mult})
		-- 	card_eval_status_text(card, 'ee_mult', effects[ii].ee_mult, percent)
		-- end
		-- if effects[ii].eee_mult then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	mult = mod_mult(mult:arrow(3, effects[ii].eee_mult))
		-- 	update_hand_text({delay = 0}, {mult = mult})
		-- 	card_eval_status_text(card, 'eee_mult', effects[ii].eee_mult, percent)
		-- end
		-- if effects[ii].hyper_mult and type(effects[ii].hyper_mult) == 'table' then
		-- 	mod_percent = true
		-- 	if effects[ii].card then juice_card(effects[ii].card) end
		-- 	mult = mod_mult(mult:arrow(effects[ii].hyper_mult[1], effects[ii].hyper_mult[2]))
		-- 	update_hand_text({delay = 0}, {mult = mult})
		-- 	card_eval_status_text(card, 'hyper_mult', effects[ii].hyper_mult, percent)
		-- end
		
		
		-- if effects[ii].from_retrigger then
		-- 	card_eval_status_text(effects[ii].from_retrigger.card, 'jokers', nil, nil, nil, effects[ii].from_retrigger)
		-- end
	end
end

joker.calculate = function(self, card, context)
	if context.cardarea == G.jokers and context.joker_main then
		local playing_card = score_playing_card(self, card, context)
		
		-- SMODS.eval_this(card, {
		-- 	message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
		-- 	chip_mod = card.ability.extra.chips, 
		-- 	colour = G.C.CHIPS
		-- })
	end	
end


return joker