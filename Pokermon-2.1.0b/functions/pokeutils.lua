pseudorandom_multi = function(args)
  --Args: array(table), amt(num), seed(string), add_con(function), mod_func(function)
  local elements = {}
  local result = {}
  if args.array then
    for i = 1, #args.array do
      if not args.add_con or args.add_con(args.array[i]) then
        elements[#elements+1] = args.array[i]
      end
    end
    pseudoshuffle(elements, args.seed and pseudoseed(args.seed) or pseudoseed('default'))
    local amt = args.amt and math.min(#elements, args.amt) or #elements
    for j = 1, amt do
      if args.mod_func then
        args.mod_func(elements[j])
      end
      result[#result+1] = elements[j]
    end
  end
  return result
end

juice_flip = function(card, second)
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true end }))
  for i=1, #G.hand.highlighted do
      local percent = nil
      if second then
        percent = base_percent + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
      else
        percent = base_percent - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
      end
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound(sound, percent, extra);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true      end }))
  end
  delay(0.2)
end

juice_flip_hand = function(card, second)
  local sound = 'card1'
  local base_percent = 1.15
  local extra = nil
  if second then sound = 'tarot2' end
  if second then base_percent = 0.85 end
  if second then extra = .6 end
  G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true end }))
  for i=1, #G.hand.cards do
      local percent = nil
      if second then
        percent = base_percent + (i-0.999)/(#G.hand.cards-0.998)*0.3
      else
        percent = base_percent - (i-0.999)/(#G.hand.cards-0.998)*0.3
      end
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound(sound, percent, extra);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
  end
  delay(0.2)
end

juice_flip_single = function(card, index)
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.4,
      func = function()
          play_sound('tarot1')
          card:juice_up(0.3, 0.5)
          return true
      end
  }))
  local percent = 1.15 - (index - 0.999) / (#G.hand.cards - 0.998) * 0.3
  G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.15,
      func = function()
          card:flip(); play_sound('card1', percent); card:juice_up(0.3, 0.3); return true
      end
  }))
end

poke_remove_card = function(target, card)
      if target.ability.name == 'Glass Card' then 
          target.shattered = true
      else 
          target.destroyed = true
      end 
      G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.2,
          func = function() 
              if target.ability.name == 'Glass Card' then 
                  target:shatter()
              else
                  target:start_dissolve()
              end
          return true end }))
      delay(0.3)
      for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = {target}})
      end
      card:juice_up()
end