local edition = {
	name = "Ripped",
	key = "ripped",
	shader = "ripped",
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
		if context.edition_main and context.edition_val then
			if #G.play.cards <= 2 then
				context.edition_val.x_mult_mod  = self.config.xmult
				--context.edition_val.chip_mod = 5
			else
				context.edition_val.x_mult_mod  = nil
			end
		end
	end
}

return edition