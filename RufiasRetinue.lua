--- STEAMODDED HEADER
--- MOD_NAME: Rufia's Retinue
--- MOD_ID: RufiasRetinue
--- PREFIX: RufiasRetinue
--- MOD_AUTHOR: [Rufia]
--- MOD_DESCRIPTION: You're off the edge of the map, here there be monsters
--- LOADER_VERSION_GEQ: 1.0.0
--- VERSION: 0.1
--- BADGE_COLOR: FFFFFF

local atlas_key = 'RUFIAS_RETINUE_ATLAS_KEY' -- Format: PREFIX_KEY
-- See end of file for notes
local atlas_path = 'imagename.png' -- Filename for the image in the asset folder
local atlas_path_hc = nil -- Filename for the high-contrast version of the texture, if existing

local suits = {'hearts', 'clubs', 'diamonds', 'spades'} -- Which suits to replace
local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",} -- Which ranks to replace

local description = 'Suture' -- English-language description, also used as default


-----------------------------------------------------------
local skin_suture_key = 'DECKSKIN_SUTURE_KEY'
local skin_suture_path = 'imagename.png'
local skin_suture_path_hc = 'imagename_hc.png'

local skin_suture_suits = {'clubs'}
local skin_suture_description = 'Suture playthings' -- English-language description, also used as default
-----------------------------------------------------------


-----------------------------------------------------------
local skin_qot_key = 'DECKSKIN_QOT_KEY'
local skin_qot_path = 'imagename.png'
local skin_qot_path_hc = 'imagename_hc.png'

local skin_qot_suits = {'hearts'}
local skin_qot_description = 'The Queen of Tarts' -- English-language description, also used as default
-----------------------------------------------------------


-----------------------------------------------------------
local skin_matthias_key = 'DECKSKIN_MATTHIAS_KEY'
local skin_matthias_path = 'imagename.png'
local skin_matthias_path_hc = 'imagename_hc.png'

local skin_matthias_suits = {'diamonds'}
local skin_matthias_description = 'Perpetually unsatisfied god of Sculpture' -- English-language description, also used as default
-----------------------------------------------------------


-----------------------------------------------------------
local skin_karabas_key = 'DECKSKIN_KARABAS_KEY'
local skin_karabas_path = 'imagename.png'
local skin_karabas_path_hc = 'imagename_hc.png'

local skin_karabas_suits = {'spades'}
local skin_karabas_description = 'Perfection Incarnate' -- English-language description, also used as default
-----------------------------------------------------------


-----------------------------------------------------------
local skin_god_complex_key = 'DECKSKIN_GOD_COMPLEX_KEY'
local skin_god_complex_path = 'imagename.png'
local skin_god_complex_path_hc = 'imagename_hc.png'

local skin_god_complex_suits = {'hearts', 'clubs', 'diamonds', 'spades'} -- Which suits to replace
local skin_god_complex_description = 'The Gangs all here' -- English-language description, also used as default
-----------------------------------------------------------



-----------------------------------------------------------
SMODS.Atlas{  
    key = 'rr_modifications',
    px = 71,
    py = 95,
    path = 'rr_modifications.png',
    prefix_config = {key = false}, -- See end of file for notes
}


local confection = {
    object_type = "Enhancement",
    key = "confection",
    atlas = 'rr_modifications',
    pos = { x = 0, y = 0},
    config = {}
}

SMODS.Enhancement {
    name = "confection",
    key = "confection",
    atlas = 'rr_modifications',
    pos = {x = 0, y = 0},
    loc_txt = {
        -- Badge name (displayed on card description when seal is applied)
        label = 'Confection',
        -- Tooltip description
        description = {
            name = 'Null',
            text = {
                "When scored, permanently increase the chips of cards held in hand by this card's chips, then destroy this card"
            }
        },
    },

    calculate = function(self, card, context, effect)
        
    end,
}
SMODS.Enhancement {
    name = "null",
    key = "null",
    atlas = 'rr_modifications',
    pos = {x = 1, y = 0},
    loc_txt = {
        -- Badge name (displayed on card description when seal is applied)
        label = 'Null',
        -- Tooltip description
        description = {
            name = 'Null',
            text = {
                "No rank or suit",
                "When scored, 1 in 2 chance to upgrade the level of played poker hand",
                "Card always scores"
            }
        },
    },

    calculate = function(self, card, context, effect)
        
    end,
}


local echo = {
	object_type = "Enhancement",
	key = "echo",
	atlas = "cry_misc",
	pos = { x = 2, y = 0 },
	config = { retriggers = 2, extra = 2 },
	loc_vars = function(self, info_queue)
		return { vars = { self.config.retriggers, G.GAME.probabilities.normal, self.config.extra } }
	end,
}
-----------------------------------------------------------





-----------------------------------------------------------
-- You should only need to change things above this line --
-----------------------------------------------------------

SMODS.Atlas{  
    key = atlas_key,
    px = 71,
    py = 95,
    path = atlas_path,
    prefix_config = {key = false}, -- See end of file for notes
}

if atlas_path_hc then
    SMODS.Atlas{  
        key = atlas_key..'_hc',
        px = 71,
        py = 95,
        path = atlas_path_hc,
        prefix_config = {key = false}, -- See end of file for notes
    }
end

for _, suit in ipairs(suits) do
    SMODS.DeckSkin{
        key = suit.."_skin",
        suit = suit:gsub("^%l", string.upper),
        ranks = ranks,
        lc_atlas = atlas_key,
        hc_atlas = (atlas_path_hc and atlas_key..'_hc') or atlas_key,
        loc_txt = {
            ['en-us'] = description
        },
        posStyle = 'deck'
    }
end

-- Notes:

-- The current version of Steamodded has a bug with prefixes in mods including `DeckSkin`s.
-- By manually including the prefix in the atlas' key, this should keep the mod functional
-- even after this bug is fixed.
