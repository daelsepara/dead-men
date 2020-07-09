<CONSTANT SKILL-GLOSSARY <LTABLE SKILL-AGILITY SKILL-BRAWLING SKILL-CHARMS SKILL-CUNNING SKILL-FOLKLORE SKILL-MARKSMANSHIP SKILL-ROGUERY SKILL-SEAFARING SKILL-SPELLS SKILL-STREETWISE SKILL-SWORDPLAY SKILL-WILDERNESS-LORE>>
<CONSTANT CHARACTERS <LTABLE CHARACTER-ADVENTURER CHARACTER-BUCCANEER CHARACTER-CHANGELING CHARACTER-GYPSY CHARACTER-MARINER CHARACTER-SWASHBUCKLER CHARACTER-WARLOCK>>

<OBJECT SKILL-AGILITY
    (DESC "AGILITY")
    (LDESC "The ability to perform acrobatic feats, run, climb, balance and leap. A character with this skill is nimble and dexterous.")>

<OBJECT SKILL-BRAWLING
    (DESC "BRAWLING")
    (LDESC "Fisticuffs, wrestling holds, jabs and kicks, and the tricks of infighting. Not as effective as SWORDPLAY, but you do not need weapons - your own body is the weapon!")>

<OBJECT SKILL-CHARMS
    (DESC "CHARMS")
    (LDESC "The expert use of magical wards to protect you from danger. Also includes that most elusive of qualities. luck. YOu must possess a magic amulet to use this skill.")
    (REQUIRES MAGIC-AMULET)>

<OBJECT SKILL-CUNNING
    (DESC "CUNNING")
    (LDESC "The ability to think on your feet and devise clever schemes for getting out of trouble. Useful in countless situations.")>

<OBJECT SKILL-FOLKLORE
    (DESC "FOLKLORE")
    (LDESC "Knowledge of myth and legend, and how best to deal with supernatural menaces such as garlic against vampires, silver bullets against a werewolf, and so on.")>

<OBJECT SKILL-MARKSMANSHIP
    (DESC "MARKSMANSHIP")
    (LDESC "A long-range attack skill. You must possess a pistol to use this skill")
    (REQUIRES PISTOL)>

<OBJECT SKILL-ROGUERY
    (DESC "ROGUERY")
    (LDESC "The traditional repertoire of a thief's tricks: picking pockets, opening locks, and skulking unseen in the shadows.")>

<OBJECT SKILL-SEAFARING
    (DESC "SEAFARING")
    (LDESC "Knowing all about life at sea, including the ability to handle anything from a rowing boat right up to a large sailing ship.")>

<OBJECT SKILL-SPELLS
    (DESC "SPELLS")
    (LDESC "A range of magical effects encompassing illusions, elemental effects, commands, and summonings. You must possess a magic wand to use this skill.")
    (REQUIRES MAGIC-WAND)>

<OBJECT SKILL-STREETWISE
    (DESC "STREETWISE")
    (LDESC "With this skill you are never at a loss in towns and cities. What others see as the squalor and menace of narrow cobbed streets is home to you.")>

<OBJECT SKILL-SWORDPLAY
    (DESC "SWORDPLAY")
    (LDESC "The best fighting skill. You must possess a sword to use this skill.")
    (REQUIRES SWORD SHARKS-TOOTH-SWORD)>

<OBJECT SKILL-WILDERNESS-LORE
    (DESC "WILDERNESS LORE")
    (LDESC "A talent for survival in the wild - whether it be forest, desert, swamp or mountain peak.")>

<OBJECT CHARACTER-ADVENTURER
    (DESC "Adventurer")
    (SYNONYM ADVENTURER)
    (LDESC "You have explored haunted castles, ruined cities, dank crypts and desolate forests in your constant search for gold and glory. Now try your luck oon the high seas.")
    (SKILLS <LTABLE SKILL-FOLKLORE SKILL-ROGUERY SKILL-SEAFARING SKILL-SWORDPLAY>)
    (POSSESSIONS <LTABLE SWORD>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-BUCCANEER
    (DESC "Buccaneer")
    (SYNONYM BUCCANEER)
    (LDESC "You're a clever and resourceful pirate, loyal to your comrades and a deadly foe to anyone who crosses you.")
    (SKILLS <LTABLE SKILL-CUNNING SKILL-MARKSMANSHIP SKILL-SEAFARING SKILL-SWORDPLAY>)
    (POSSESSIONS <LTABLE PISTOL SWORD>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-CHANGELING
    (DESC "Changeling")
    (SYNONYM CHANGELING)
    (LDESC "Your origins are shrouded in mystery. A misfit in your own homeland, you wander far and wide in search of the truth.")
    (SKILLS <LTABLE SKILL-AGILITY SKILL-CUNNING SKILL-SPELLS SKILL-WILDERNESS-LORE>)
    (POSSESSIONS <LTABLE MAGIC-WAND>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-GYPSY
    (DESC "Gypsy")
    (SYNONYM GYPSY)
    (LDESC "Fleeing persecution in the Old World, you have come to the colonies of the New World to carve a new life of fame and fortune.")
    (SKILLS <LTABLE SKILL-BRAWLING SKILL-CHARMS SKILL-FOLKLORE SKILL-ROGUERY>)
    (POSSESSIONS <LTABLE MAGIC-AMULET>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-MARINER
    (DESC "Mariner")
    (SYNONYM MARINER)
    (LDESC "Born on the deck of a ship and raised with the salt breeze in your face, you have been toughened by the experience of a hundred ports and desert islands. No one can match your knowledge of the seven seas.")
    (SKILLS <LTABLE SKILL-AGILITY SKILL-SEAFARING SKILL-STREETWISE SKILL-WILDERNESS-LORE>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-SWASHBUCKLER
    (DESC "Swashbuckler")
    (SYNONYM SWASHBUCKLER)
    (LDESC "With your dashing good looks, gallant wit, aristocratic manners and flair for stylish derring-do, you're a hero to your friends and a real pain in the neck to your enemies!.")
    (SKILLS <LTABLE SKILL-AGILITY SKILL-CUNNING SKILL-STREETWISE SKILL-SWORDPLAY>)
    (POSSESSIONS <LTABLE SWORD>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-WARLOCK
    (DESC "Warlock")
    (SYNONYM WARLOCK)
    (LDESC "Your scholarly appeareance disguises the fact that you are one of the most powerful opponents a pirate captain could ever fear to face.")
    (SKILLS <LTABLE SKILL-CHARMS SKILL-MARKSMANSHIP SKILL-SPELLS SKILL-STREETWISE>)
    (POSSESSIONS <LTABLE MAGIC-AMULET PISTOL MAGIC-WAND>)
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT)>

<OBJECT CHARACTER-CUSTOM
    (DESC "Custom Character")
    (SYNONYM CHARACTER)
    (ADJECTIVE CUSTOM)
    (LDESC "Custom character with user selected skills.")
    (LIFE-POINTS 10)
    (MONEY 10)
    (FLAGS PERSONBIT NARTICLEBIT)>
