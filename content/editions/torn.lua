local edition = {
	name = "Torn",
	key = "torn",
	shader = "torn",
	shader_debuff = "torn_debuff",
	--atlas = "Joker",
	--pos = {x=0,y=0},
	discovered = true,
	disable_shadow = true,
	disable_base_shader = true,
	extra_cost = "2",
	in_shop = true,
	weight = 3,
	config = {
		mult = 20
	},
	loc_txt = {
		name = "Torn",
        label = "Torn",
		text = {"{C:mult}+#1#{} Mult if played",
			"hand contains",
			"{C:attention}3{} or fewer cards"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {self.config.mult}
		}
	end,

	calculate = function(self, card, context, effect)
		if context.edition_main and context.edition_val then
			if #G.play.cards <= 3 then
				context.edition_val.mult_mod = self.config.mult
				--context.edition_val.chip_mod = 5
			else
				context.edition_val.mult_mod = nil
			end
		end
	end
}

return edition