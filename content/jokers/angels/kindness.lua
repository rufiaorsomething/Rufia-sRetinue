local joker = {
	key = "kindness",
	pos = {x = 0, y = 4},
	--soul_pos = { x = 1, y = 6 },
	rarity = 2,
	cost = 6,
	discovered = true,
	config = {
		extra = {
			blind_reduction = 0.01,
			scaling = 0.01,
		}
	},
	-- loc_txt = {
	-- 	name = "Archangel Humility",
	-- 	text = {"Each scored {C:attention}2{} gives {X:dark_edition,C:white} /#2# {} Blind Size", "for each {C:attention}unenhanced{} card in your {C:attention}full deck{}",
	-- 			"{C:inactive}(Currently {X:dark_edition,C:white} /#1# {C:inactive} Blind Size)"}
	-- },
	loc_txt = {
		name = "Archangel Kindness",
		text = {"{X:dark_edition,C:white} #1#√ {} Blind Size on last hand of round",
			"Gains by {X:dark_edition,C:white} #2#√ {} for each last hand played"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.blind_reduction,
				card.ability.extra.scaling,
			}
		}
	end,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
}

joker.calculate = function(self, card, context)
	
end

return joker