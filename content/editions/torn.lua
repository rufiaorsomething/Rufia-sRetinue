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
		if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
			if #G.play.cards <= 3 then
				return {
					mult_mod = card.edition.mult,
				}
			end
		end
	end
}

return edition