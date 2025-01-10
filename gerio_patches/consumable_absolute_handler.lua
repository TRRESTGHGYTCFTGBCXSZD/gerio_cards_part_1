if card.ability.unbreakable then
	dont_dissolve = true
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			card.T.x = nil
			card.T.y = nil
			card:add_to_deck()
			G.consumeables:emplace(card)
			return true
		end,
	}))
end

if card.ability.unbreakable then
	--dont_dissolve = true
	card2 = copy_card(card, nil, nil, area)
	card2:add_to_deck()
	area:emplace(card2)
	card.ability.unbreakable = nil -- this is workaround
	--[[G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			G.CONTROLLER.locks.use = false
			card:add_to_deck()
			area:emplace(card)
			return true
		end,
	}))]]
end

if card.ability.consumeable and card.ability.gerio_unbreakable then
	local card2 = copy_card(card, nil, nil, area)
	card2.ability.gerio_unbreakable = "bypass"
	card = card2
end