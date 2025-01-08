local enhancement = {
	name = "Hypnotic Card",
	key = "hypnotic",
	atlas = "Rufia_Modifications",
	pos = {x = 2, y = 0},
	loc_txt = {
		name = "Hypnotic Card",
		text = {"Card scores when",
			"held in hand",
			"Scores before other",
			"held in hand abilities"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {}
		}
	end,

	calculate = function(self, card, context, effect)
		--[[ if context.cardarea == G.hand then
			if context.repetition_only then
				--print("held in hand - repetition_only")
				--retrigger_hypnotic_card(self, card, context, effect)
			--elseif context.repetition then
			--	print("held in hand - repetition")
			else
				--print("held in hand - not repetition")
				score_hypnotic_card(self, card, context, effect)
				--effect.h_mult = 1
				effect.scored_hypnotic = true
			end
		end ]]
		--if context.cardarea == G.hand and context.repetition then
		--	effect.scored_hypnotic = true
		--end
	end
}

function retrigger_hypnotic_card(self, card, context, effect)
	local reps = {1}

				
	----From Red seal
	--local eval = eval_card(card, {repetition_only = true,cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true})
	--if next(eval) then 
	--	for h = 1, eval.seals.repetitions do
	--		reps[#reps+1] = eval
	--	end
	--end

	--From jokers
	for j=1, #G.jokers.cards do
		--calculate the joker effects
		local eval = eval_card(G.jokers.cards[j], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = card, repetition = true, callback = function(card, ret) eval = {jokers = ret}
		if next(eval) and eval.jokers then 
			if not eval.jokers.repetitions then eval.jokers.repetitions = 0 end
			for h = 1, eval.jokers.repetitions do
				reps[#reps+1] = eval
			end

			-- effect.jokers = {
			-- 	message = eval.jokers.message,
			-- 	card = eval.jokers.card,
			-- 	repetitions = eval.jokers.repetitions
			-- }
		end end})
	end
	--From edition
	if card.edition and card.edition.key then
		local ed = SMODS.Centers[card.edition.key]
		if ed.config and ed.config.retriggers then
			 for h = 1, ed.config.retriggers do
			 	reps[#reps+1] = {seals = {
			 		message = localize("k_again_ex"),
			 		card = card
			 	}}
			end
			--effect.seals = {
			--	message = localize("k_again_ex"),
			--	card = card,
			--	repetitions = eval.jokers.repetitions
			--}
		end
		if ed.calculate and type(ed.calculate) == 'function' then
			local check = ed:calculate(card, {retrigger_edition_check = true, cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = card, repetition = true})
			if check and type(check) == 'table' and next(check) then 
				for j = 1, check.repetitions do
					reps[#reps+1] = {seals = check}
				end
				--effect.seals = {
				--	message = check.message,
				--	card = check.card,
				--	repetitions = check.repetitions
				--}
			end
		end
	end


end

function score_hypnotic_card(self, card, context, effect)
	
	--calculate the hand effects
	local effects = {eval_card(card, {cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, poker_hand = text})}
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
			effects[#effects+1] = eval_card(card, {cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, poker_hand = text, extra_enhancement = true})
		end
	end
	effects[#effects+1] = post_effect
	card.ability = old_ability
	card.config.center = old_center
	card.config.center_key = old_center_key
	card:set_sprites(old_center)
	for k=1, #G.jokers.cards do
		--calculate the joker individual card effects
		local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = card, individual = true,
		callback = function(card, eval, retrigger)
			if eval then 
				table.insert(effects, eval)
				effects[#effects].from_retrigger = retrigger
			end
		end, no_retrigger_anim = true})

	end
	card.lucky_trigger = nil


	for ii = 1, #effects do
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
		
		--If x_mult added, do mult add event and mult the mult to the total
		if effects[ii].x_mult then 
			if effects[ii].card then juice_card(effects[ii].card) end
			mult = mod_mult(mult*effects[ii].x_mult)
			update_hand_text({delay = 0}, {mult = mult})
			card_eval_status_text(card, 'x_mult', effects[ii].x_mult, percent)
			if next(find_joker("cry-Exponentia")) then
				for _, v in pairs(find_joker("cry-Exponentia")) do
					local old = v.ability.extra.Emult
					v.ability.extra.Emult = v.ability.extra.Emult + v.ability.extra.Emult_mod
					card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_powmult',vars={number_format(to_big(v.ability.extra.Emult))}}})
					exponentia_scale_mod(v, v.ability.extra.Emult_mod, old, v.ability.extra.Emult)
				end
			end
		end

		if effects[ii].x_chips then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			hand_chips = mod_chips(hand_chips*effects[ii].x_chips)
			update_hand_text({delay = 0}, {chips = hand_chips})
			card_eval_status_text(card, 'x_chips', effects[ii].x_chips, percent)
		end
		if effects[ii].e_chips then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			hand_chips = mod_chips(hand_chips^effects[ii].e_chips)
			update_hand_text({delay = 0}, {chips = hand_chips})
			card_eval_status_text(card, 'e_chips', effects[ii].e_chips, percent)
		end
		if effects[ii].ee_chips then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			hand_chips = mod_chips(hand_chips:arrow(2, effects[ii].ee_chips))
			update_hand_text({delay = 0}, {chips = hand_chips})
			card_eval_status_text(card, 'ee_chips', effects[ii].ee_chips, percent)
		end
		if effects[ii].eee_chips then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			hand_chips = mod_chips(hand_chips:arrow(3, effects[ii].eee_chips))
			update_hand_text({delay = 0}, {chips = hand_chips})
			card_eval_status_text(card, 'eee_chips', effects[ii].eee_chips, percent)
		end
		if effects[ii].hyper_chips and type(effects[ii].hyper_chips) == 'table' then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			hand_chips = mod_chips(hand_chips:arrow(effects[ii].hyper_chips[1], effects[ii].hyper_chips[2]))
			update_hand_text({delay = 0}, {chips = hand_chips})
			card_eval_status_text(card, 'hyper_chips', effects[ii].hyper_chips, percent)
		end
		if effects[ii].e_mult then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			mult = mod_mult(mult^effects[ii].e_mult)
			update_hand_text({delay = 0}, {mult = mult})
			card_eval_status_text(card, 'e_mult', effects[ii].e_mult, percent)
		end
		if effects[ii].ee_mult then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			mult = mod_mult(mult:arrow(2, effects[ii].ee_mult))
			update_hand_text({delay = 0}, {mult = mult})
			card_eval_status_text(card, 'ee_mult', effects[ii].ee_mult, percent)
		end
		if effects[ii].eee_mult then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			mult = mod_mult(mult:arrow(3, effects[ii].eee_mult))
			update_hand_text({delay = 0}, {mult = mult})
			card_eval_status_text(card, 'eee_mult', effects[ii].eee_mult, percent)
		end
		if effects[ii].hyper_mult and type(effects[ii].hyper_mult) == 'table' then
			mod_percent = true
			if effects[ii].card then juice_card(effects[ii].card) end
			mult = mod_mult(mult:arrow(effects[ii].hyper_mult[1], effects[ii].hyper_mult[2]))
			update_hand_text({delay = 0}, {mult = mult})
			card_eval_status_text(card, 'hyper_mult', effects[ii].hyper_mult, percent)
		end
		
		--calculate the card edition effects
		if effects[ii].edition then
			if effects[ii].edition.chip_mod then
				hand_chips = mod_chips(hand_chips + effects[ii].edition.chip_mod)
				local key_switch = (effects[ii].edition.chip_mod > 0 and 'a_chips' or 'a_chips_minus')
				card_eval_status_text(card, 'extra', nil, percent, nil, {
					message = localize{type='variable', key=key_switch, vars={math.abs(effects[ii].edition.chip_mod)}},
					chip_mod = true,
					colour = G.C.DARK_EDITION,
					edition = true
				})
				update_hand_text({delay = 0}, {chips = hand_chips})
			end
			if effects[ii].edition.mult_mod then
				mult = mult + effects[ii].edition.mult_mod
				card_eval_status_text(card, 'extra', nil, percent, nil, {
					message = localize{type='variable', key='a_mult', vars={effects[ii].edition.mult_mod}},
					mult_mod = true,
					colour = G.C.DARK_EDITION,
					edition = true
				})
				update_hand_text({delay = 0}, {mult = mult})
			end
			if effects[ii].edition.x_mult_mod then
				mult = mult * effects[ii].edition.x_mult_mod
				card_eval_status_text(card, 'extra', nil, percent, nil, {
					message = localize{type='variable', key='a_xmult', vars={effects[ii].edition.x_mult_mod}},
					x_mult_mod = true,
					colour = G.C.DARK_EDITION,
					edition = true
				})
				update_hand_text({delay = 0}, {mult = mult})
			end
			if card and card.edition then
				local trg = card
				local edi = trg.edition
				if edi.x_chips then
					hand_chips = mod_chips(hand_chips * edi.x_chips)
					update_hand_text({delay = 0}, {chips = hand_chips})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = 'X'.. edi.x_chips ..' Chips',
					edition = true,
					x_chips = true})
				end
				if edi.e_chips then
					hand_chips = mod_chips(hand_chips ^ edi.e_chips)
					update_hand_text({delay = 0}, {chips = hand_chips})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = '^'.. edi.e_chips ..' Chips',
					edition = true,
					e_chips = true})
				end
				if edi.ee_chips then
					hand_chips = mod_chips(hand_chips:arrow(2, edi.ee_chips))
					update_hand_text({delay = 0}, {chips = hand_chips})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = '^^'.. edi.ee_chips ..' Chips',
					edition = true,
					ee_chips = true})
				end
				if edi.eee_chips then
					hand_chips = mod_chips(hand_chips:arrow(3, edi.eee_chips))
					update_hand_text({delay = 0}, {chips = hand_chips})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = '^^^'.. edi.eee_chips ..' Chips',
					edition = true,
					eee_chips = true})
				end
				if edi.hyper_chips and type(edi.hyper_chips) == 'table' then
					hand_chips = mod_chips(hand_chips:arrow(edi.hyper_chips[1], edi.hyper_chips[2]))
					update_hand_text({delay = 0}, {chips = hand_chips})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = (edi.hyper_chips[1] > 5 and ('{' .. edi.hyper_chips[1] .. '}') or string.rep('^', edi.hyper_chips[1])) .. edi.hyper_chips[2] ..' Chips',
					edition = true,
					eee_chips = true})
				end
				if edi.e_mult then
					mult = mod_mult(mult ^ edi.e_mult)
					update_hand_text({delay = 0}, {mult = mult})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = '^'.. edi.e_mult ..' Mult',
					edition = true,
					e_mult = true})
				end
				if edi.ee_mult then
					mult = mod_mult(mult:arrow(2, edi.ee_mult))
					update_hand_text({delay = 0}, {mult = mult})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = '^^'.. edi.ee_mult ..' Mult',
					edition = true,
					ee_mult = true})
				end
				if edi.eee_mult then
					mult = mod_mult(mult:arrow(3, edi.eee_mult))
					update_hand_text({delay = 0}, {mult = mult})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = '^^^'.. edi.eee_mult ..' Mult',
					edition = true,
					eee_mult = true})
				end
				if edi.hyper_mult and type(edi.hyper_mult) == 'table' then
					mult = mod_mult(mult:arrow(edi.hyper_mult[1], edi.hyper_mult[2]))
					update_hand_text({delay = 0}, {mult = mult})
					card_eval_status_text(trg, 'extra', nil, percent, nil,
					{message = (edi.hyper_mult[1] > 5 and ('{' .. edi.hyper_mult[1] .. '}') or string.rep('^', edi.hyper_mult[1])) .. edi.hyper_mult[2] ..' Mult',
					edition = true,
					hyper_mult = true})
				end
			end
			if effects[ii].edition.p_dollars_mod then
				if effects[ii].card then juice_card(effects[ii].card) end
				ease_dollars(effects[ii].edition.p_dollars_mod)
				card_eval_status_text(card, 'dollars', effects[ii].edition.p_dollars_mod, percent)
			end
			if not effects[ii].edition then
				hand_chips = mod_chips(hand_chips + (effects[ii].edition.chip_mod or 0))
				mult = mult + (effects[ii].edition.mult_mod or 0)
				mult = mod_mult(mult*(effects[ii].edition.x_mult_mod or 1))
				update_hand_text({delay = 0}, {
					chips = effects[ii].edition.chip_mod and hand_chips or nil,
					mult = (effects[ii].edition.mult_mod or effects[ii].edition.x_mult_mod) and mult or nil,
				})
				card_eval_status_text(card, 'extra', nil, percent, nil, {
					message = (effects[ii].edition.chip_mod and localize{type='variable',key='a_chips',vars={effects[ii].edition.chip_mod}}) or
							(effects[ii].edition.mult_mod and localize{type='variable',key='a_mult',vars={effects[ii].edition.mult_mod}}) or
							(effects[ii].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={effects[ii].edition.x_mult_mod}}),
					chip_mod =  effects[ii].edition.chip_mod,
					mult_mod =  effects[ii].edition.mult_mod,
					x_mult_mod =  effects[ii].edition.x_mult_mod,
					colour = G.C.DARK_EDITION,
					edition = true
				})
			end
			if (effects and effects[ii] and effects[ii].edition and effects[ii].edition.x_mult_mod or edition_effects and edition_effects.jokers and edition_effects.jokers.x_mult_mod) and next(find_joker("cry-Exponentia")) then
				for _, v in pairs(find_joker("cry-Exponentia")) do
					local old = v.ability.extra.Emult
					v.ability.extra.Emult = v.ability.extra.Emult + v.ability.extra.Emult_mod
					card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_powmult',vars={number_format(to_big(v.ability.extra.Emult))}}})
					exponentia_scale_mod(v, v.ability.extra.Emult_mod, old, v.ability.extra.Emult)
				end
			end
		end
		if effects[ii].from_retrigger then
			card_eval_status_text(effects[ii].from_retrigger.card, 'jokers', nil, nil, nil, effects[ii].from_retrigger)
		end
	end 
end

return enhancement