local joker = {
	name = "rufia-playground rocker",
	pos = {x = 0, y = 0},
	--soul_pos = { x = 3, y = 3 },
	rarity = 1,
	cost = 4,
	discovered = true,
	config = {
		extra = {
			xmult = 2,
			odds = 2,
			result
		}
	},
	loc_txt = {
		name = "Playground Rocker?",
		text = {"{C:green}#1# in #2#{} chance for {X:mult,C:white} X#2# {} Mult",
			"Otherwise, {C:attention}destroy{} a random adjacent Joker", "after each hand played",
			"{C:inactive}(result determined permanently upon pickup)"}
	},
	loc_vars = function(self, info_queue, card)
		return { 
			vars = {
				"" .. (G.GAME and G.GAME.probabilities.normal or 1),
				card.ability.extra.odds,
				card.ability.extra.xmult
			} 
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)	
	-- if context.setting_blind and not self.getting_sliced
	-- and not context.blueprint and not context.blind.boss then
	-- 	card.ability.chips = card.ability.chips - card.ability.penalty
	-- end

	-- if context.cardarea == G.jokers and context.joker_main then
	-- 	return {
	-- 		message = localize{type='variable',key='a_chips',vars=card.ability.chips},
	-- 		chips_mod = card.ability.chips
	-- 	}
	-- end
end


return joker