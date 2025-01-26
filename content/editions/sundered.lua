local edition = {
	name = "Sundered",
	key = "sundered",
	shader = "sundered",
	shader_debuff = "sundered_debuff",
	--atlas = "Joker",
	--pos = {x=0,y=0},
	discovered = true,
	disable_shadow = true,
	disable_base_shader = true,
	extra_cost = "2",
	in_shop = true,
	weight = 3,
	config = {
		chips = 100
	},
	loc_txt = {
		name = "Sundered",
        label = "Sundered",
		text = {"{C:chips}+#1#{} Chips if played",
			"hand contains",
			"{C:attention}3{} or fewer cards"}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {self.config.chips}
		}
	end,

	calculate = function(self, card, context, effect)
		if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
			if #G.play.cards <= 3 then
				return {
					chip_mod = card.edition.chips,
				}
			end
		end
	end
}

return edition