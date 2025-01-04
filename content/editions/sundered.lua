local edition = {
	name = "Sundered",
	key = "sundered",
	shader = "sundered",
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
		if context.edition_main and context.edition_val then
			if #G.play.cards <= 3 then
				context.edition_val.chip_mod = self.config.chips
				--context.edition_val.chip_mod = 5
			else
				context.edition_val.chip_mod = nil
			end
		end
	end
}

return edition