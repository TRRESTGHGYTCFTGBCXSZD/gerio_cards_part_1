

----------------------------------------------
------------MOD CODE -------------------------

--to play mista's voicelines, it requires the sound, with directly calling love sound
local mod_path = "" .. SMODS.current_mod.path

--local angry_mista = love.audio.newSource(mod_path.."audio/angry_mista.wav", "static")
SMODS.Sound{
	key="angry_mista",
	path="angry_mista.wav",
}

local vanilla_tarots = {
"c_fool",
"c_magician",
"c_high_priestess",
"c_empress",
"c_emperor",
"c_heirophant",
"c_lovers",
"c_chariot",
"c_justice",
"c_hermit",
"c_wheel_of_fortune",
"c_strength",
"c_hanged_man",
"c_death",
"c_temperance",
"c_devil",
"c_tower",
"c_star",
"c_moon",
"c_sun",
"c_judgement",
"c_world",
}

local exclude_popbob = {
["j_gerioc1_forkbomb"] = true,
}

local koichi = SMODS.current_mod
local settei = koichi.config

koichi.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 5, align = "cm", padding = 0.2, colour = G.C.BLACK}, nodes = {
        create_toggle({label = "Black Label?", ref_table = settei, ref_value = 'platinumpass', callback = function() SMODS.save_mod_config(koichi) end }),
        create_toggle({label = "Killer Death? (requires restart)", ref_table = settei, ref_value = 'death_really', callback = function() SMODS.save_mod_config(koichi) end }),
    }}
end

SMODS.Atlas {
	-- Key for code to find it with
	key = "geriolish_1",
	-- The name of the file, for the code to pull the atlas from
	path = "geriolish.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "gerio_cards",
	-- The name of the file, for the code to pull the atlas from
	path = "gerio_skin.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "edge_stickers",
	-- The name of the file, for the code to pull the atlas from
	path = "gerio_refurbished_stickers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

local function tabledump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. tabledump(v) .. ','
		end
		return s .. '} '
	else
		if type(o) == 'string' then
		return "\""..tostring(o).."\""
		else
		return tostring(o)
		end
	end
end

local function tabledump_beautified(o,deepness)
	if type(o) == 'table' then
		local s = '{\n'
		for _=1,deepness do
			s = s..'	'
		end
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. tabledump_beautified(v,deepness+1) .. ',\n'
			for _=1,deepness do
				s = s..'	'
			end
		end
		return s .. '}'
	else
		if type(o) == 'string' then
		return "\""..tostring(o).."\""
		else
		return tostring(o)
		end
	end
end

local tabledeepcopy = copy_table

--[[function(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[tabledeepcopy(orig_key)] = tabledeepcopy(orig_value)
		end
		setmetatable(copy, tabledeepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end]]

function copy_table(orig,looked_tables) -- original copy table dosen't detect cyclic references
	local orig_type = type(orig)
	if not looked_tables then looked_tables = {} end
	local copy
	if orig_type == 'table' and not looked_tables[orig] then
		copy = {}
		looked_tables[orig] = true
		for orig_key, orig_value in next, orig, nil do
			copy[copy_table(orig_key,looked_tables)] = copy_table(orig_value,looked_tables)
		end
		setmetatable(copy, copy_table(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

local function find_pointing_table(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[tabledeepcopy(orig_key)] = tabledeepcopy(orig_value)
		end
		setmetatable(copy, tabledeepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--[[SMODS.Suit{
	key = 'Mista',
	card_key = 'MISTA',
	hidden = false,
	lc_atlas = 'gerioc1_gerio_cards',
	hc_atlas = 'gerioc1_gerio_cards',

	lc_ui_atlas = 'ui_1',
	hc_ui_atlas = 'ui_2',

	pos = { x = 0, y = 4 },
	ui_pos = { x = 0, y = 0 },

	lc_colour = HEX('3b0082'),
	hc_colour = HEX('3b0082'),

	loc_txt = {
		['en-us'] = {
			singular = 'Mista',
			plural = 'Mista',
		}},
	in_pool = function(self, args) --Returns true if it's in the pool, false otherwise
			--Checks if it's initial deck spawning
			if args and args.initial_deck then
			return false
			end
			--Other cases for standard packs
			return false
	end

}]]

--handling absolutes
local function bypass_absolute_cond(card)
	if card.ability.gerio_unbreakable == "bypass" or (card.area and card.area.marked_for_removal) then
		return true
	end
	return false
end

local hooke = Card.start_dissolve
function Card:start_dissolve(...)
	if self.ability.gerio_unbreakable and (not bypass_absolute_cond(self)) then
		SMODS.eval_this(self, {
			message = localize('k_nope_ex')
		})
	else
		hooke(self,...)
	end
end
local hooke = Card.shatter
function Card:shatter(...)
	if self.ability.gerio_unbreakable and (not bypass_absolute_cond(self)) then
		SMODS.eval_this(self, {
			message = localize('k_nope_ex')
		})
	else
		hooke(self,...)
	end
end
local hooke = Card.explode
function Card:explode(...)
	if self.ability.gerio_unbreakable and (not bypass_absolute_cond(self)) then
		SMODS.eval_this(self, {
			message = localize('k_nope_ex')
		})
	else
		hooke(self,...)
	end
end
local hooke = Card.remove
function Card:remove(...)
	if self.ability.gerio_unbreakable and (not bypass_absolute_cond(self)) then
		SMODS.eval_this(self, {
			message = localize('k_nope_ex')
		})
		self:start_materialize()
	else
		hooke(self,...)
	end
end
local hooke = Card.can_sell_card
function Card:can_sell_card(...)
	if self.ability.gerio_unbreakable then
		return false
	else
		return hooke(self,...)
	end
end

--extra card codes
--[[local hooke = Card.redeem
function Card:redeem(...)
	if self.quick_redeem then
		if self.ability.set == "Voucher" then
			stop_use()
			if not self.config.center.discovered then
				discover_card(self.config.center)
			end
			if self.shop_voucher then G.GAME.current_round.voucher = nil end 
			ease_dollars(-self.cost)
			inc_career_stat('c_shop_dollars_spent', self.cost)
			inc_career_stat('c_vouchers_bought', 1)
			set_voucher_usage(self)
			check_for_unlock({type = 'run_redeem'})
			G.GAME.current_round.voucher = nil
			
			self:apply_to_run()
		end
	else
		hooke(self,...)
	end
end]]
local hooke = Card.get_id
function Card:get_id()
    if G.GAME.Hyperstoneia then
        return self.base.id
    end
    return hooke(self)
end
local hooke = eval_card
function eval_card(card, context)
	if not card or card.will_shatter then
		return
	end
    -- Store old probability for later reference
	local ggpn = G.GAME.probabilities.normal
	if card.ability.gerio_baseball then
		G.GAME.probabilities.normal = math.huge
	end
	local ret = hooke(card, context)
	if card.ability.gerio_baseball then
		G.GAME.probabilities.normal = ggpn
	end
	return ret
end
local hooke = Card.use_consumeable
function Card:use_consumeable(area, copier)
	local ggpn = G.GAME.probabilities.normal
	if self.ability.gerio_baseball then
		G.GAME.probabilities.normal = math.huge
	end
	local ret = hooke(self, area, copier)
	if self.ability.gerio_baseball then
		G.GAME.probabilities.normal = ggpn
	end
	return ret
end
local hooke = Card.set_edition
function Card:set_edition(edition, immediate, silent, ...)
	if self.gerio_forced_edition then
		edition = tabledeepcopy(self.gerio_forced_edition)
		setmetatable(edition,{
			__newindex = function() end
		})
	end
	hooke(self, edition, immediate, silent, ...)
end

SMODS.Sticker{
	key = 'gerio_unbreakable',
	prefix_config = { key = false },
	loc_vars = function(self, info_queue, card)
		if card.ability.consumeable then
		return { key = "gerio_unbreakable_consumable" }
		else
		return { key = "gerio_unbreakable" }
		end
	end,
	--[[loc_txt = {
		name = 'Absolute',
		text = {
				"Prevents from","Direct Removal Calls","SWEDEN"
		}
	},]]
	default_compat = true,
	atlas = "gerioc1_edge_stickers",
	pos = { x = 1, y = 0 },
	--[[compat_exceptions = {
		eternal_compat = false,
	},
	calculate = function(self, card, context)
		card:set_eternal(true)
		return true
	end,]]
	badge_colour = HEX("00BEE4"),
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
}

SMODS.Sticker{
	key = 'gerio_baseball',
	loc_vars = function(self, info_queue, card)
		return { key = "gerio_baseball" }
	end,
	--[[loc_txt = {
		name = 'Baseball',
		text = {
			"Infinity Percent Base Boost"
		}
	},]]
	default_compat = true,
	atlas = "gerioc1_edge_stickers",
	pos = { x = 2, y = 0 },
	badge_colour = HEX("EC97CD"),
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
}

SMODS.Sticker{
	key = 'gerio_negative',
	loc_txt = {
		name = 'Always Negative',
		text = {
			"This card's edition","is always negative,","can't change editions"
		}
	},
	default_compat = true,
	atlas = "gerioc1_edge_stickers",
	pos = { x = 2, y = 1 },
	badge_colour = HEX("000000"),
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
}

SMODS.Sticker:take_ownership("eternal", {
	atlas = "gerioc1_edge_stickers",
	pos = { x = 0, y = 0 },
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
})
SMODS.Sticker:take_ownership("perishable", {
	atlas = "gerioc1_edge_stickers",
	pos = { x = 0, y = 2 },
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
})
SMODS.Sticker:take_ownership("rental", {
	atlas = "gerioc1_edge_stickers",
	pos = { x = 1, y = 2 },
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
})
SMODS.Sticker:take_ownership("pinned", {
	atlas = "gerioc1_edge_stickers",
	pos = { x = 1, y = 1 },
	badge_colour = HEX("AAAAAA"),
	draw = function(self, card) --draw flat
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center)
	end,
})

SMODS.Shader {
    key = 'wobbly',
    path = 'wobbly.fs',
}

SMODS.Edition{
	key = 'gerio_mista',
	loc_txt = {
		name = 'MISTA',
		label = 'MISTA',
		text = {
			"FOUR IS UNLUCKY"
		}
	},
	-- Stop shadow from being rendered under the card
	disable_shadow = false,
	-- Stop extra layer from being rendered below the card.
	-- For edition that modify shape or transparency of the card.
	disable_base_shader = true,
	shader = "gerioc1_wobbly",
	discovered = true,
	unlocked = true,
	config = {},
	in_shop = false,
	weight = 0,
	extra_cost = 6,
	apply_to_float = true,
	sound = { sound = "gerioc1_angry_mista", per = 1, vol = 1 },
	loc_vars = function(self)
		return { vars = {} }
	end,
	on_apply = function(card)
		if not card.ability.extra then return end
		for g,_ in pairs(card.ability.extra) do
			if type(card.ability.extra[g]) == "number" then
				card.ability.extra[g] = 4
			end
		end
	end,
}

SMODS.DeckSkin{

	key = 'gerio_poker1',
	lc_atlas = 'gerioc1_gerio_cards',
	hc_atlas = 'gerioc1_gerio_cards',
	loc_txt = {
		["en-us"] = 'GerioSB Programmer Art',
	},
	suit = "Spades",
	ranks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"},
	posStyle = 'deck',

}
SMODS.DeckSkin{

	key = 'gerio_poker2',
	lc_atlas = 'gerioc1_gerio_cards',
	hc_atlas = 'gerioc1_gerio_cards',
	loc_txt = {
		["en-us"] = 'GerioSB Programmer Art',
	},
	suit = "Diamonds",
	ranks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"},
	posStyle = 'deck',

}
SMODS.DeckSkin{

	key = 'gerio_poker3',
	lc_atlas = 'gerioc1_gerio_cards',
	hc_atlas = 'gerioc1_gerio_cards',
	loc_txt = {
		["en-us"] = 'GerioSB Programmer Art',
	},
	suit = "Clubs",
	ranks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"},
	posStyle = 'deck',

}
SMODS.DeckSkin{

	key = 'gerio_poker4',
	lc_atlas = 'gerioc1_gerio_cards',
	hc_atlas = 'gerioc1_gerio_cards',
	loc_txt = {
		["en-us"] = 'GerioSB Programmer Art',
	},
	suit = "Hearts",
	ranks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"},
	posStyle = 'deck',

}

--[[G.P_CARDS["Mista"] = tabledeepcopy(G.P_CARDS["S_4"])
G.P_CARDS["Mista"]["suit"] = "Mista"
G.P_CARDS["Mista"]["pos"] = {["x"] = 2, ["y"] = 0}
G.P_CARDS["Mista"]["atlas"] = "gerioc1_geriolish_1"
G.P_CARDS["Mista"]["name"] = "Mista Four"
G.P_CARDS["Mista"]["value"] = "4"]]

--sendDebugMessage(tabledump(G.P_CARDS["Mista"]))

SMODS.Rarity{
	key = "unobtainium",
	loc_txt = {
		name = 'Unobtainium', -- used on rarity badge
	},
	pools = {}, -- you are not supposed to get this cards anyway
}

SMODS.Joker {
	key = 'mista',
	loc_txt = {
		name = 'Mista HATES THAT NUMBER',
		text = {
		"#1#"
		}
	},
	config = { extra = { mult = 4 } },
	rarity = "gerioc1_unobtainium",
	atlas = 'gerioc1_geriolish_1',
	pos = { x = 0, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
		-- Tells the joker what to do. In this case, it pulls the value of mult from the config, and tells the joker to use that variable as the "mult_mod".
		local chippi = card.ability.extra.mult^2
			if chippi >= math.huge then
			chippi = 1.79769313486231570814527423732E308
			SMODS.eval_this(card, {
				message = "Too High!",
				colour = G.C.RED,
				card = self
			})
			end
		return {
			chip_mod = chippi,
			Xmult_mod = card.ability.extra.mult,
			-- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
			-- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
			-- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.
			message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			-- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
		}
		end
		if context.individual and context.cardarea == G.play then
		-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
		if context.other_card:get_id() == 4 then
			-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("gerioc1_angry_mista")
					return true
				end,
			}))
			SMODS.eval_this(card, {
				message = localize("gerio_mista_four"),
				colour = G.C.RED,
				card = self
			})
			card.ability.extra.mult = card.ability.extra.mult * 4
			if card.ability.extra.mult >= math.huge then
			card.ability.extra.mult = 1.79769313486231570814527423732E308
			SMODS.eval_this(card, {
				message = localize("gerio_too_high"),
				colour = G.C.RED,
				card = self
			})
			end
			return {
			mult = card.ability.extra.mult,
			card = context.other_card
			}
		end
		end
	end,
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.mult
		if bonus > 0 then return bonus end
	end,
}

SMODS.Joker {
  key = 'forkbomb',
  loc_txt = {
    name = 'Fork Bomb',
    text = {
      "Creates the card of itself",
      "infinitely many times,",
      "eventually crashing the game.",
    }
  },
  config = { extra = { mult = 4 } },
  rarity = 2,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      -- Tells the joker what to do. In this case, it pulls the value of mult from the config, and tells the joker to use that variable as the "mult_mod".
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerio_forkbomb")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
      return {
        chip_mod = card.ability.extra.mult^2,
        Xmult_mod = card.ability.extra.mult,
        -- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
        -- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
        -- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        -- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
      }
    end
    if context.individual and context.cardarea == G.play then
      -- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerio_forkbomb")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
      if context.other_card:get_id() == 4 then
        -- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
        card.ability.extra.mult = card.ability.extra.mult * 4
		SMODS.eval_this(card, {
				message = "Mista!",
				colour = G.C.RED,
				card = self
			})
		return {
          mult = card.ability.extra.mult,
          card = context.other_card
        }
      end
    end
  end,
  calc_dollar_bonus = function(self, card)
    local bonus = card.ability.extra.mult
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerio_forkbomb")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
    if bonus > 0 then return bonus end
  end,
}

SMODS.Joker {
  key = 'geriolish',
  loc_txt = {
    name = "Joker2Joker",
    text = {
      "Where you did get","that thing from!?"
    }
  },
  --
  config = { extra = { mult = 4, namerand = "Gerio" } },
  rarity = "gerioc1_unobtainium",
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 1, y = 0 },
  cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.namerand } }
  end,
  --[[add_to_deck = function(self, card, from_debuff)
    G.jokers:change_size(1)
  end,--]]
	--remove_from_deck = function(self, card, from_debuff)
	--end,
  calculate = function(self, card, context)
    --card.ability.extra.namerand = (math.random() >= 0.5 and "G" or "9")..(math.random() >= 0.5 and "e" or "3")..(math.random() >= 0.5 and "r" or "R")..(math.random() >= 0.5 and "i" or "1")..(math.random() >= 0.5 and "o" or "0")
    if context.joker_main then
      -- Tells the joker what to do. In this case, it pulls the value of mult from the config, and tells the joker to use that variable as the "mult_mod".
        for k, v in ipairs(context.scoring_hand) do
            --if v:is_face() then 
                --faces[#faces+1] = v
                v:set_ability(G.P_CENTERS.m_wild, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                })) 
            --end
        end
      return {
        chip_mod = card.ability.extra.mult,
        Xmult_mod = card.ability.extra.mult,
        -- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
        -- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
        -- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        -- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
      }
    end
    if context.individual and context.cardarea == G.play then
      -- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
      if context.other_card:get_id() == 4 or true then
        -- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
        card.ability.extra.mult = 1.79769313486231570814527423732E308
		SMODS.eval_this(card, {
				message = "Mista!",
				colour = G.C.RED,
				card = self
			})
		return {
          mult = card.ability.extra.mult,
          card = context.other_card
        }
      end
    end
  end,
  calc_dollar_bonus = function(self, card)
    local bonus = card.ability.extra.mult
    if bonus > 0 then return bonus end
  end,
}

SMODS.Joker {
	key = 'permanentfreepass',
	loc_txt = {
		name = "Permanent Free Pass",
		text = {
		"Is... that a","{C:attention}PLATINUM CARD{}!?","{C:inactive}(Cannot be debuffed in any means){}","{C:inactive}(Potental {C:money}$#1#{C:inactive}){}"
		}
	},
	--
	config = { perishable_compat = false, extra = { scored_cash = 0, player_dead = false } },
	rarity = "gerioc1_unobtainium",
	atlas = 'gerioc1_geriolish_1',
	pos = { x = 0, y = 1 },
	cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.scored_cash, card.ability.extra.player_dead } }
	end,
	update = function(self, card, dt)
		SMODS.debuff_card(card, 'prevent_debuff', card)
	end,
	calculate = function(self, card, context)
		card.ability.perishable = false
		if context.individual and context.cardarea == G.play then
			card.ability.extra.scored_cash = card.ability.extra.scored_cash + context.other_card:get_id()
			return {
				message = localize('k_gold'),
				colour = G.C.MONEY,
				card = self
			}
		end
		if #G.deck.cards <= 0 then
			--for _ = #G.deck.cards,5,1 do
				--create_playing_card({front = G.P_CARDS.Mista}, G.hand)
			--end
			local yoncard = {}
			for _,h in pairs(G.discard.cards) do
				yoncard[#yoncard+1]=h
			end
			for _,h in pairs(yoncard) do
				G.deck:emplace(G.discard:remove_card(h))
			end
			return {
				--saved = true,
				colour = G.C.RED,
				message = "STOP DISCARDING, DUDE"
			}
		end
		if context.game_over then
			card.ability.extra.player_dead = true
			return {
				saved = true,
				colour = G.C.RED,
				message = localize("gerio_freepass_saved") -- "No way I lose this game!"
			}
		end
	end,
	calc_dollar_bonus = function(self, card)
		if card.ability.extra.player_dead then
			local bonus = card.ability.extra.scored_cash
			card.ability.extra.scored_cash = 0
			card.ability.extra.player_dead = false
			if bonus > 0 then return bonus end
		end
		card.ability.extra.scored_cash = 0
		card.ability.extra.player_dead = false
	end,
}

SMODS.Joker {
  key = 'discardplus',
  loc_txt = {
    name = "Discard+",
    text = {
      "DISCARD AS MUCH AS POSSIBLE"
    }
  },
  --
  config = { extra = { mult = 4 } },
  rarity = "gerioc1_unobtainium",
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.discard then
      G.E_MANAGER:add_event(Event({
          func = function()
              ease_discard(math.huge, nil, true)
              return true
          end
      })) 
      return false
    end
  end,
}

SMODS.Joker {
  key = 'disabler',
  loc_txt = {
    name = "Disabler",
    text = {
      "Debuffs the adjacent card","When the adjacent card","is Disabler, it cancels out"
    }
  },
  config = { extra = { tracked = {} } },
  rarity = 3,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
  update = function(self, card, dt)
	if not G.jokers then return end
	local left_joker = nil
	local right_joker = nil
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then left_joker = G.jokers.cards[i-1] right_joker = G.jokers.cards[i+1] end
	end
	if (left_joker and left_joker.ability.name == card.ability.name) or (right_joker and right_joker.ability.name == card.ability.name) then
		for i = 1, #G.jokers.cards do
			SMODS.debuff_card(G.jokers.cards[i], false, card)
		end
		return
	end
	if left_joker and left_joker ~= card then
		SMODS.debuff_card(left_joker, true, card)
	end
	if right_joker and right_joker ~= card then
		SMODS.debuff_card(right_joker, true, card)
	end
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] ~= left_joker and G.jokers.cards[i] ~=right_joker then
			SMODS.debuff_card(G.jokers.cards[i], false, card)
		end
	end
  end,
}

SMODS.Joker {
	key = 'hyperstoneia',
	loc_txt = {
		name = 'Hyperstoneia',
		text = {
		"{C:attention}Stone Cards{} have {C:attention}rank and suit{}","Each {C:attention}Stone Card{} gives {X:mult,C:white}x#1#{} and {X:mult,C:white}+#2#{} mult"
		}
	},
	add_to_deck = function(self, card, from_debuff)
		G.GAME.Hyperstoneia = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.Hyperstoneia = next(find_joker("gerio_hyperstoneia", true))
	end,
	config = { extra = { xmult = 2, mult = 6 } },
	rarity = 4,
	--atlas = 'gerioc1_geriolish_1',
	--[[set_sprites = function(self, card, front)
		card.children.center.atlas = G.ASSET_ATLAS["Joker"]
		card.children.center:set_sprite_pos(self.pos)
	end,]]
	pos = { x = 9, y = 0 },
	cost = 78,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.ability.effect == 'Stone Card' then --SERIOUSLY!? NO SMODS.get_enhancements() AND SMODS.has_enhancement()!?
				SMODS.eval_this(context.other_card, {
					Xmult_mod = card.ability.extra.xmult,
					message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
					colour = G.C.RED,
					card = context.other_card
				})
				return {
				mult = card.ability.extra.mult,
				card = context.other_card
				}
			end
		end
	end,
}

local hooke = SMODS.has_no_suit
function SMODS.has_no_suit(card)
	if card.ability.effect == 'Stone Card' and G.GAME.Hyperstoneia then
		return false
	end
	return hooke(card)
end
local hooke = SMODS.has_no_rank
function SMODS.has_no_rank(card)
	if card.ability.effect == 'Stone Card' and G.GAME.Hyperstoneia then
		return false
	end
	return hooke(card)
end

SMODS.Consumable {
  key = 'vaccumcleaner',
  set = 'Spectral',
  loc_txt = {
    name = 'Vaccum Cleaner',
    text = {
      "Removes random",
      "overfilled Jokers",
      "in Joker Pile.",
    }
  },
  config = { extra = { mult = 4 } },
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
	use = function(self, card, context, copier)
		local deletable_jokers = {}
		local deletable_jokers_count = 0
		local deleted_cards = 0
		local cardcount = #G.jokers.cards
		for k, v in pairs(G.jokers.cards) do
			if not v.ability.eternal then deletable_jokers[v] = v deletable_jokers_count = deletable_jokers_count + 1 end
		end
		local _first_dissolve = nil
		while cardcount > G.jokers.config.card_limit and deletable_jokers_count > 0 do
			local removing_joker = pseudorandom_element(deletable_jokers, pseudoseed('vaccum_cleaner'))
			deletable_jokers[removing_joker] = nil
			deletable_jokers_count = deletable_jokers_count - 1
			cardcount = cardcount - 1
			deleted_cards = deleted_cards - 1
			removing_joker:start_dissolve(nil, _first_dissolve)
			_first_dissolve = true
		end
		SMODS.eval_this(card, {
				message = deleted_cards .. " Jokers",
				colour = G.C.RED,
				card = self
			})
		return true
	end,
	can_use = function(self, card)
		local deletable_jokers_count = 0
		for k, v in pairs(G.jokers.cards) do
			if not v.ability.eternal then deletable_jokers_count = deletable_jokers_count + 1 end
		end
		return (#G.jokers.cards > G.jokers.config.card_limit and deletable_jokers_count > 0)
	end,
}

SMODS.Consumable {
  key = 'spectral_dumber',
  set = 'Spectral',
  loc_txt = {
    name = 'Spectral Pack Ticket',
    text = {
      "Use this card",
      "to get free",
      "Spectral Pack",
    }
  },
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		--[[G.E_MANAGER:add_event(Event({
			trigger = 'before',
			delay = 3,
			func = function()
				local key = 'p_spectral_normal_1'
				local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
				G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({config = {ref_table = card}})
				card:start_materialize()
				return true
			end
		})) ]]
		add_tag(Tag('tag_ethereal'))
		return true
	end,
	can_use = function(self, card)
		return not G.GAME.blind.disabled
	end,
}

SMODS.Consumable {
  key = 'joker_popbob',
  set = 'Spectral',
  loc_txt = {
    name = 'Joker popbob',
    text = {
      "Use this card to",
      "get every jokers",
      "(including modded ones)",
      "to your deck",
	  "{C:inactive}(Potentially dangerous){}",
    }
  },
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				for h,_ in pairs(G.P_CENTERS) do
					if not exclude_popbob[h] then
						if string.sub(h,1,1) == "j" then
							local card2 = create_card('Jokers', G.jokers,nil,nil,nil,nil, h)
							card2:set_edition({negative = true}, true)
							card2:add_to_deck()
							G.jokers:emplace(card2)
							card2:start_materialize()
						end
					end
				end
				return true
			end
		}))
		return true
	end,
	can_use = function(self, card)
		return not G.GAME.blind.disabled
	end,
}

SMODS.Consumable {
  key = 'consumable_popbob',
  set = 'Spectral',
  loc_txt = {
    name = 'Consumable popbob',
    text = {
      "Use this card to",
      "get every consumables",
      "(including modded ones)",
      "to your deck",
      "{C:inactive}(It's recommended to{}",
      "{C:inactive}select with controller){}",
    }
  },
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				for h,_ in pairs(G.P_CENTERS) do
					if not exclude_popbob[h] then
						if string.sub(h,1,1) == "c" then
							local card2 = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, h)
							card2:set_edition({negative = true}, true)
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card2:start_materialize()
						end
					end
				end
				return true
			end
		}))
		return true
	end,
	can_use = function(self, card)
		return not G.GAME.blind.disabled
	end,
}

SMODS.Consumable {
  key = 'voucher_popbob',
  set = 'Spectral',
  loc_txt = {
    name = 'Voucher popbob',
    text = {
      "Use this card to",
      "redeem every vouchers",
      "(including modded ones)",
    }
  },
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
			G.E_MANAGER:add_event(Event({
				func = function()
					local area
					if G.STATE == G.STATES.HAND_PLAYED then
						if not G.redeemed_vouchers_during_hand then
							G.redeemed_vouchers_during_hand =
								CardArea(G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, { type = "play", card_limit = 5 })
						end
						area = G.redeemed_vouchers_during_hand
					else
						area = G.play
					end
					for h,_ in pairs(G.P_CENTERS) do
						if not exclude_popbob[h] then
							if string.sub(h,1,1) == "v" then
								--[[local card2 = create_card("Voucher", area, nil, nil, nil, nil, h)
								card2.cost = 0
								card2:add_to_deck()
								area:emplace(card2)
								card2:start_materialize()
								card2.shop_voucher = false
								card2.quick_redeem = true
								local current_round_voucher = G.GAME.current_round.voucher
								card2:redeem()
								G.GAME.current_round.voucher = current_round_voucher
								G.E_MANAGER:add_event(Event({
									trigger = "after",
									delay = 0,
									func = function()
										card2:start_dissolve()
										return true
									end,
								}))]]
								G.GAME.used_vouchers[h] = true
								G.E_MANAGER:add_event(Event({
									trigger = "after",
									delay = 0,
									func = function()
										Card.apply_to_run(nil, G.P_CENTERS[h])
										return true
									end,
								}))
							end
						end
					end
					return true
				end
			}))
		return true
	end,
	can_use = function(self, card)
		return not G.GAME.blind.disabled
	end,
}

local suits = {"S","D","H","C"}

SMODS.Consumable {
  key = 'standard_popbob',
  set = 'Spectral',
  loc_txt = {
    name = 'Standard Set',
    text = {
      "Wait, is this bicycle?",
      "{C:inactive}(mod suits and ranks not included){}",
    }
  },
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
			G.E_MANAGER:add_event(Event({
				func = function()
					for _,suit in pairs(suits) do
						create_playing_card({front = G.P_CARDS[suit.."_A"]}, G.hand)
						create_playing_card({front = G.P_CARDS[suit.."_K"]}, G.hand)
						create_playing_card({front = G.P_CARDS[suit.."_Q"]}, G.hand)
						create_playing_card({front = G.P_CARDS[suit.."_J"]}, G.hand)
						create_playing_card({front = G.P_CARDS[suit.."_T"]}, G.hand)
						for rank = 9,2,-1 do
							create_playing_card({front = G.P_CARDS[suit.."_"..rank]}, G.hand)
						end
					end
					return true
				end
			}))
		return true
	end,
	can_use = function(self, card)
		return true
	end,
}
local locale = {
    name = 'Baseball in the Bag',
    text = {
      "INFINITY PERCENT TRIGGER LET'S GOOOO",
    }
  }
local pootis = {}

if SMODS.Mods["Cryptid"] then
	pootis[152152] = {type="name_text", key = "cry_rigged", set = "Other"}
	table.insert(locale.text, "{C:inactive}(higher trigger chance than #152152#){}")
end
if SMODS.Mods["SnowHolidayJokers"] then
	pootis[153153] = {type="name_text", key = "j_infinityDice", set = "Joker"}
	table.insert(locale.text, "{C:inactive}(higher trigger chance than #153153#){}")
end

SMODS.Consumable {
  key = 'baseball_sticker',
  set = 'Spectral',
  loc_txt = locale,
	loc_vars = function(self, info_queue, card)
		local putdispenserhere = {}
		for r,t in pairs(pootis) do
			putdispenserhere[r] = localize(t)
		end
		return { vars = putdispenserhere }
	end,
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 1 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		for _,h in pairs(G.hand.highlighted) do
			if h ~= card then
				h.ability.gerio_baseball = true
			end
		end
		for _,h in pairs(G.jokers.highlighted) do
			if h ~= card then
				h.ability.gerio_baseball = true
			end
		end
		for _,h in pairs(G.consumeables.highlighted) do
			if h ~= card then
				h.ability.gerio_baseball = true
			end
		end
		return true
	end,
	can_use = function(self, card)
		for _,h in pairs(G.hand.highlighted) do
			if h ~= card then
				return true
			end
		end
		for _,h in pairs(G.jokers.highlighted) do
			if h ~= card then
				return true
			end
		end
		for _,h in pairs(G.consumeables.highlighted) do
			if h ~= card then
				return true
			end
		end
		return false
	end,
}

SMODS.Consumable {
	key = 'blueprinter',
	set = 'Spectral',
	loc_txt = {
		name = 'Blueprinter',
		text = {
			"Use this card to",
			"get #1#",
			"to your deck",
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "j_blueprint", set = "Joker", vars = {} }
		return { vars = { localize{type="name_text", key = "j_blueprint", set = "Joker"} } }
	end,
	set_sprites = function(self, card, front)
		card.children.center.atlas = G.ASSET_ATLAS["Joker"]
		card.children.center:set_sprite_pos(self.pos)
	end,
	rarity = 4,
	--atlas = 'gerioc1_geriolish_1',
	pos = { x = 0, y = 3 },
	cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				local card2 = create_card('Jokers', G.jokers,nil,nil,nil,nil, "j_blueprint")
				card2:set_edition({negative = true}, true)
				card2:add_to_deck()
				G.jokers:emplace(card2)
				card2:start_materialize()
				return true
			end
		}))
		return true
	end,
	can_use = function(self, card)
		return true
	end,
}

SMODS.Consumable {
  key = 'mistafier',
  set = 'Spectral',
  loc_txt = {
    name = 'Mistafier',
    text = {
      "44444444444",
    }
  },
	loc_vars = function(self, info_queue, card)
		local putdispenserhere = {}
		for r,t in pairs(pootis) do
			putdispenserhere[r] = localize(t)
		end
		return { vars = putdispenserhere }
	end,
  rarity = 4,
  atlas = 'gerioc1_geriolish_1',
  pos = { x = 0, y = 0 },
  cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		for _,h in pairs(G.hand.highlighted) do
			if h ~= card then
				h:set_edition({gerioc1_gerio_mista = true}, true)
			end
		end
		for _,h in pairs(G.jokers.highlighted) do
			if h ~= card then
				h:set_edition({gerioc1_gerio_mista = true}, true)
			end
		end
		for _,h in pairs(G.consumeables.highlighted) do
			if h ~= card then
				h:set_edition({gerioc1_gerio_mista = true}, true)
			end
		end
		return true
	end,
	can_use = function(self, card)
		for _,h in pairs(G.hand.highlighted) do
			if h ~= card then
				return true
			end
		end
		for _,h in pairs(G.jokers.highlighted) do
			if h ~= card then
				return true
			end
		end
		for _,h in pairs(G.consumeables.highlighted) do
			if h ~= card then
				return true
			end
		end
		return false
	end,
}

SMODS.Consumable {
	key = 'pullerist',
	set = 'Spectral',
	loc_txt = {
		name = 'Puller',
		text = {
			"PULL YO DECK TO HANDO, EVEN DISCARD",
		}
	},
	rarity = 4,
	atlas = 'gerioc1_geriolish_1',
	pos = { x = 0, y = 1 },
	cost = 78,
	unlocked = true,
	discovered = true,
	use = function(self, card, context, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				local yoncard = {}
				for _,h in pairs(G.deck.cards) do
					yoncard[#yoncard+1]=h
				end
				for _,h in pairs(yoncard) do
					G.hand:emplace(G.deck:remove_card(h))
				end
				local yoncard = {}
				for _,h in pairs(G.discard.cards) do
					yoncard[#yoncard+1]=h
				end
				for _,h in pairs(yoncard) do
					G.hand:emplace(G.discard:remove_card(h))
				end
				return true
			end
		}))
		return true
	end,
	can_use = function(self, card)
		return true
	end,
}

if settei.death_really then
	SMODS.Consumable:take_ownership("death", {
		loc_vars = function(self, info_queue, card)
			return { key = "c_death_shine" }
		end,
		use = function(self, card, context, copier)
			G.E_MANAGER:add_event(Event({
				func = function()
					attention_text({
						text = localize('gerio_killerdeath_line1'),
						scale = 1,
						hold = 4,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Planet,
						align = (
							G.STATE == G.STATES.TAROT_PACK
							or G.STATE == G.STATES.SPECTRAL_PACK
							or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
						)
								and "tm"
							or "cm",
						offset = {
							x = 0,
							y = -1.5,
						},
						silent = true,
					})
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 1,
				func = function()
					attention_text({
						text = localize('gerio_killerdeath_line2'),
						scale = 1,
						hold = 3,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Planet,
						align = (
							G.STATE == G.STATES.TAROT_PACK
							or G.STATE == G.STATES.SPECTRAL_PACK
							or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
						)
								and "tm"
							or "cm",
						offset = {
							x = 0,
							y = -0.5,
						},
						silent = true,
					})
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 1,
				func = function()
					attention_text({
						text = localize('gerio_killerdeath_line3'),
						scale = 0.7,
						hold = 2,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Planet,
						align = (
							G.STATE == G.STATES.TAROT_PACK
							or G.STATE == G.STATES.SPECTRAL_PACK
							or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
						)
								and "tm"
							or "cm",
						offset = {
							x = 0,
							y = 0.5,
						},
						silent = true,
					})
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 1,
				func = function()
					attention_text({
						text = localize('gerio_killerdeath_line4'),
						scale = 1.3,
						hold = 1,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Planet,
						align = (
							G.STATE == G.STATES.TAROT_PACK
							or G.STATE == G.STATES.SPECTRAL_PACK
							or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
						)
								and "tm"
							or "cm",
						offset = {
							x = 0,
							y = 1.5,
						},
						silent = true,
					})
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 1,
				func = function()
					G.STATE = G.STATES.GAME_OVER G.STATE_COMPLETE = false
					return true
				end
			}))
			return true
		end,
		can_use = function(self, card)
			return true
		end,
	})
end


local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
	Backapply_to_runRef(arg_56_0)

	if settei.platinumpass then
		G.E_MANAGER:add_event(Event({
			func = function()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_permanentfreepass")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_discardplus")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				--[[for _ = 1,6,1 do
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_disabler")
				card.ability.gerio_unbreakable = true
				card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				end]]
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_hyperstoneia")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_vaccumcleaner")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_spectral_dumber")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_joker_popbob")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_consumable_popbob")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_voucher_popbob")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_standard_popbob")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_baseball_sticker")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_blueprinter")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_pullerist")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc1_mistafier")
				card.ability.gerio_unbreakable = true
				card.ability.gerio_negative = true
				card:update()
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				if SMODS.Mods["gerio_cards_part_2"] then
					card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc2_bamtris")
					card.ability.gerio_unbreakable = true
					card.ability.gerio_negative = true
					card:update()
					card:set_eternal(true)
					card:set_edition({negative = true}, true)
					card:add_to_deck()
					G.jokers:emplace(card)
					card:start_materialize()
					card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc2_tetra_blocker")
					card.ability.gerio_unbreakable = true
					card.ability.gerio_negative = true
					card:update()
					card:set_edition({negative = true}, true)
					card:add_to_deck()
					G.consumeables:emplace(card)
					card:start_materialize()
					card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_gerioc2_woot_bamtris")
					card.ability.gerio_unbreakable = true
					card.ability.gerio_negative = true
					card:update()
					card:set_edition({negative = true}, true)
					card:add_to_deck()
					G.consumeables:emplace(card)
					card:start_materialize()
				end

				return true
			end
		}))
	end

	if arg_56_0.effect.config.mista_hater then
		G.E_MANAGER:add_event(Event({
			func = function()
				for iter_57_0 = #G.playing_cards, 1, -1 do
					--sendDebugMessage(G.playing_cards[iter_57_0].base.id)
					--if G.playing_cards[iter_57_0].base.id ~= 4 then
						--local suit = string.sub(G.playing_cards[iter_57_0].base.suit, 1, 1) .. "_"
						--local rank = "4"

						--G.playing_cards[iter_57_0]:set_base(G.P_CARDS["Mista"])
						G.playing_cards[iter_57_0]:explode()
					--end
				end
				--sendDebugMessage(tabledump(G.P_CARDS["Mista"]))
				for _ = 1,16 do
					create_playing_card({front = G.P_CARDS.Mista}, G.deck)
				end
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_mista")
				card:set_eternal(true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()

				return true
			end
		}))
	end

	if arg_56_0.effect.config.absolutity then
		G.E_MANAGER:add_event(Event({
			func = function()
				for iter_57_0 = #G.playing_cards, 1, -1 do
					G.playing_cards[iter_57_0].ability.gerio_unbreakable = true
				end

				return true
			end
		}))
	end

	if arg_56_0.effect.config.forkbomb then
		G.E_MANAGER:add_event(Event({
			func = function()
				--sendDebugMessage(tabledump(G.P_CARDS["Mista"]))
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_forkbomb")
				card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()

				return true
			end
		}))
	end

	if arg_56_0.effect.config.geriogerio then
		G.E_MANAGER:add_event(Event({
			func = function()
				--sendDebugMessage(tabledump(G.P_CARDS["Mista"]))
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_geriolish")
				card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				for _ = 1,3,1 do
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_eris")
				--card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				end
				for _ = 1,40,1 do
				card = create_card('Consumeables', G.consumeables,nil,nil,nil,nil, "c_cryptid")
				--card:set_eternal(true)
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.consumeables:emplace(card)
				card:start_materialize()
				end
				for _ = 1,30,1 do
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_blueprint")
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				end
				for _ = 1,5,1 do
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_geriolish")
				card:set_edition({negative = true}, true)
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				end

				return true
			end
		}))
	end

	if arg_56_0.effect.config.pinpin then
		G.E_MANAGER:add_event(Event({
			func = function()
				--sendDebugMessage(tabledump(G.P_CARDS["Mista"]))
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_mista")
				card.pinned = true
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_geriolish")
				card.pinned = true
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_joker")
				card.pinned = true
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_mime")
				card.pinned = true
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_mista")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_geriolish")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_joker")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()
				card = create_card('Joker', G.jokers,nil,nil,nil,nil, "j_gerioc1_mime")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:start_materialize()

				return true
			end
		}))
	end
end

local loc_def = {}

loc_def["mista"] = {
	["name"]="Anti-Mista Deck",
	["text"]={
		[1]="{C:attention}MISTA{}",
		[2]="{C:attention}MISTA{}",
		[3]="{C:attention}MISTA{}"
	},
}

loc_def["forkbomb"] = {
	["name"]="Fork BOMB",
	["text"]={
		[1]="{C:attention}MISTA{}",
		[2]="{C:attention}MISTA{}",
		[3]="{C:attention}MISTA{}"
	},
}

loc_def["gerio"] = {
	["name"]="GERIOLISH",
	["text"]={
		[1]="{C:attention}MISTA{}",
		[2]="{C:attention}MISTA{}",
		[3]="{C:attention}MISTA{}"
	},
}

loc_def["PINPIN"] = {
	["name"]="PIN",
	["text"]={
		[1]="{C:attention}MISTA{}",
		[2]="{C:attention}MISTA{}",
		[3]="{C:attention}MISTA{}"
	},
}

loc_def["ABSOLUTE"] = {
	["name"]="THE ABSOLUTE DECK",
	["text"]={
		[1]="{C:attention}MISTA{}",
		[2]="{C:attention}MISTA{}",
		[3]="{C:attention}MISTA{}"
	},
}

--[[SMODS.Back{
key = "mista",
config = {mista_hater = true},
pos = {x = 0, y = 0},
loc_txt = loc_def["mista"],
["atlas"] = "gerioc1_geriolish_1"
}]]
SMODS.Back{
key = "forkbomb",
config = {forkbomb = true},
pos = {x = 0, y = 1},
loc_txt = loc_def["forkbomb"],
["atlas"] = "gerioc1_geriolish_1"
}
SMODS.Back{
key = "geriogerio",
config = {geriogerio = true},
pos = {x = 0, y = 1},
loc_txt = loc_def["gerio"],
["atlas"] = "gerioc1_geriolish_1"
}
SMODS.Back{
key = "pinpin",
config = {pinpin = true},
pos = {x = 0, y = 1},
loc_txt = loc_def["PINPIN"],
["atlas"] = "gerioc1_geriolish_1"
}
SMODS.Back{
key = "absolutity",
config = {absolutity = true},
pos = {x = 0, y = 1},
loc_txt = loc_def["ABSOLUTE"],
["atlas"] = "gerioc1_geriolish_1"
}

function SMODS.current_mod.process_loc_text()
    --G.localization.descriptions.Joker.j_geriogerio_1972_geriolish.name = (math.random() >= 0.5 and "G" or "9")..(math.random() >= 0.5 and "e" or "3")..(math.random() >= 0.5 and "r" or "R")..(math.random() >= 0.5 and "i" or "1")..(math.random() >= 0.5 and "o" or "0") .. " Joker"
end

----------------------------------------------
------------MOD CODE END----------------------