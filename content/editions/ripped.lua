local edition = {
	name = "Ripped",
	key = "ripped",
	shader = "ripped",
	shader_debuff = "ripped_debuff",
	--atlas = "Joker",
	--pos = {x=0,y=0},
	discovered = true,
	disable_shadow = true,
	disable_base_shader = true,
	extra_cost = "4",
	in_shop = true,
	weight = 2,
	config = {
		xmult = 2
	},
	loc_txt = {
		name = "Ripped",
        label = "Ripped",
		text = {"{X:mult,C:white}X#1#{} Mult if played",
			"hand contains",
			"{C:attention}2{} or fewer cards"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {self.config.xmult}
		}
	end,

	calculate = function(self, card, context, effect)
		if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
			if #G.play.cards <= 2 then
				return {
					x_mult_mod = card.edition.xmult,
				}
			end
		end
	end
}

return edition