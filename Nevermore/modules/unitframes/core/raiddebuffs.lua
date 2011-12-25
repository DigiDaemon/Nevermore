-----------------------------------------------------------------------------
-- oUF_RaidDebuffs spells
-----------------------------------------------------------------------------
do
    local _, ns = ...
    
    local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

    if not ORD then return end
    
    ORD.ShowDispelableDebuff = true
    ORD.FilterDispellableDebuff = true
    ORD.MatchBySpellName = false

    debuffids = {
    -- Other debuff
        67479, -- Impale
        
        --CATA DEBUFFS
    --Baradin Hold
        95173, -- Consuming Darkness
        
    --Blackwing Descent
        --Magmaw
        91911, -- Constricting Chains
        94679, -- Parasitic Infection
        94617, -- Mangle
        
        --Omintron Defense System
        79835, --Poison Soaked Shell	
        91433, --Lightning Conductor
        91521, --Incineration Security Measure
        
        --Maloriak
        77699, -- Flash Freeze
        77760, -- Biting Chill
        
        --Atramedes
        92423, -- Searing Flame
        92485, -- Roaring Flame
        92407, -- Sonic Breath
        
        --Chimaeron
        82881, -- Break
        89084, -- Low Health
        
        --Nefarian
        
    --The Bastion of Twilight
        --Valiona & Theralion
        92878, -- Blackout
        86840, -- Devouring Flames
        95639, -- Engulfing Magic
        
        --Halfus Wyrmbreaker
        39171, -- Malevolent Strikes
        
        --Twilight Ascendant Council
        92511, -- Hydro Lance
        82762, -- Waterlogged
        92505, -- Frozen
        92518, -- Flame Torrent
        83099, -- Lightning Rod
        92075, -- Gravity Core
        92488, -- Gravity Crush
        
        --Cho'gall
        86028, -- Cho's Blast
        86029, -- Gall's Blast
        
    --Throne of the Four Winds
        --Conclave of Wind
            --Nezir <Lord of the North Wind>
            93131, --Ice Patch
            --Anshal <Lord of the West Wind>
            86206, --Soothing Breeze
            93122, --Toxic Spores
            --Rohash <Lord of the East Wind>
            93058, --Slicing Gale 
        --Al'Akir
        93260, -- Ice Storm
        93295, -- Lightning Rod
    }
    
    ORD:RegisterDebuffs(debuffids)
end