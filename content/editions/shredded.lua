local edition = {
	name = "Shredded",
	key = "shredded",
	shader = "shredded",
	shader_debuff = "shredded_debuff",
	--atlas = "Joker",
	--pos = {x=0,y=0},
	discovered = true,
	disable_shadow = true,
	disable_base_shader = true,
	extra_cost = "4",
	sound = {
		sound = "rufia_e_shredded",
		per = 1,
		vol = 0.75,
	},
	in_shop = true,
	weight = 2,
	config = {
		left_retriggers = 2
	},
	loc_txt = {
		name = "Shredded",
        label = "Shredded",
		text = {"Retrigger {C:attention}leftmost{} scoring",
			"card {C:attention}#1#{} additional times",
			"if played hand contains",
			"{C:attention}2{} or fewer cards"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {self.config.left_retriggers}
		}
	end,

	calculate = function(self, card, context, effect)
		--[[ if context.repetition and context.cardarea == G.play then
			if #G.play.cards <= 2 and context.other_card == G.play.cards[1] then
				return {
					message = localize("k_again_ex"),
					repetitions = self.config.left_retriggers,
					card = card,
				}
			end
			return {
				message = localize("k_again_ex"),
				repetitions = self.config.left_retriggers,
				card = card,
			}
		end ]]
	end
}

return edition