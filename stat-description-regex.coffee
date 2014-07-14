###
description
    1 {number of mods on this stat 1-2} fishing_hook_type {mod name}
    4 {number of descriptions 1-4}
        1 {index of desc} "Karui Stone Hook" {desc text}
        2 {index of desc} "Ezomite Shell Hook" {desc text}
        3 {index of desc} "Vaal Soul Hook" {desc text}
        4 {index of desc} "Eternal Iron Hook" {desc text}

        index is only used for fishing rods. Should we ignore or support if something changes in the future?
        Everything else uses '1|#' or '#' syntax. example: 1|# "Projectiles do not Chain"

---

description
    1 base_arrow_pierce_%
    3
        100|# "Arrows always Pierce" {if value is 100% or anything(#)}
        1|99 "%1%%% chance of Arrows Piercing" {if value is 1-99}
        #|-1 "%1%%% chance of Arrows Piercing" negate 1 {if value is anything? or negative. Not sure about 'negate 1'}

        Usage of '#' is not completely clear
        '#' might be required when value is a % and only needs to match 1 number

        %1%%% is placeholder for value
        Maybe: index of value is surrounded by %. %% is replaced with %. This looks correct
        %1$+d looks like it does the same as %1%. Maybe some conversion happens?
---

description
    1 movement_velocity_+%_when_on_full_life
    2
        1|# "%1%%% increased Movement Speed when on Full Life" {value is positive so use 'increased/more'}
        #|-1 "%1%%% reduced Movement Speed when on Full Life" negate 1 {value is negative so use 'reduced/less'}

---

description
    2 attack_minimum_added_lightning_damage_with_wand attack_maximum_added_lightning_damage_with_wand
    3
        # 0 "Adds %1% minimum Lightning Damage to attacks with Wands" {No idea about these ones}
        0 # "Adds %2% maximum Lightning Damage to attacks with Wands" {^}
        # # "Adds %1%-%2% Lightning Damage to attacks with Wands"     {^}

        %1% is value 1, %2% is value 2

---

description
    1 number_of_additional_totems_allowed
    2
        1 "Can summon up to %1% additional totem" {value is single so we use singular name}
        # "Can summon up to %1% additional totems" {value is anything other than 1 so we use plural}

---

description
	2 minimum_physical_damage_to_reflect_to_self_on_attack maximum_physical_damage_to_return_to_melee_attacker
	2
		1|# 0 "Reflects %1% Physical Damage to you from your Attacks"
		0|# 1|# "Reflects %1%-%2% Physical Damage to you from your Attacks"

        Not sure about this syntax. Only used by reflect on block

---
Are these mixed up?

description
	2 minimum_physical_damage_to_reflect_to_self_on_attack maximum_physical_damage_to_return_to_melee_attacker
	2
		1|# 0 "Reflects %1% Physical Damage to you from your Attacks"
		0|# 1|# "Reflects %1%-%2% Physical Damage to you from your Attacks"

description
	2 minimum_physical_damage_to_return_to_melee_attacker maximum_physical_damage_to_reflect_to_self_on_attack
	2
		1|# 0 "Reflects %1% Physical Damage to Melee Attackers"
		0|# 1|# "Reflects %1%-%2% Physical Damage to Melee Attackers"

---
###

###
--->
description
    1 number_of_additional_totems_allowed
    2
        1 "Can summon up to %1% additional totem"
        # "Can summon up to %1% additional totems"
<--- stat

--->
1|# "%1%%% increased Movement Speed when on Full Life"
<--- description
###

stats = module.exports.stats = [
    """
	description
		1 local_energy_shield_+%
		2
			1|# "%1%%% increased Energy Shield"
			#|-1 "%1%%% reduced Energy Shield" negate 1

    """

    """
	description
		2 minimum_physical_damage_to_reflect_to_self_on_attack maximum_physical_damage_to_return_to_melee_attacker
		2
			1|# 0 "Reflects %1% Physical Damage to you from your Attacks"
			0|# 1|# "Reflects %1%-%2% Physical Damage to you from your Attacks"

    """

    """
	description
		1 shocks_reflected_to_self
		1
			# "Your Shocks are reflected back to you"

    """

    """
	description
		1 fishing_hook_type
		4
			1 "Karui Stone Hook"
			2 "Ezomite Shell Hook"
			3 "Vaal Soul Hook"
			4 "Eternal Iron Hook"

    """
]


# Escape spaces because coffee doesn't parse them correctly. Should we only catch inside quotes and then the rest in another group (for negate 1)?
# match[0] is {number of mods on this stat 1-2}
# match[1] is {name of mod(s)}
# match[2] is {number of descriptions}
# match[3] is {description 1}
# match[4] is {optional description 2}
# match[5] is {optional description 3}
# match[6] is {optional description 4}
statPattern = ///
^description[\ \t]*\n   # Match 'description' on first line and then space or tab (error by GGG)
\t([0-9])\ (.*)\n       # Match tab then catch the number, skip space and catch content until newline
\t([0-9])\t*?\n         # Match tab then catch the number then match any tabs (error by GGG)
\t*(.*)\n?              # Match any tabs then catch content until newline
\t*(.*)\n?              # Optionally match any tabs then catch content until newline (find a way to avoid duplication using {1,3})
\t*(.*)\n?              # ^
\t*(.*)\n?              # ^
///

# match[0] is {value tester}
# match[1] is {description text}
# match[2] is {optional modifier}
descPattern = ///
	(.*)\ \"(.*)\"   # Capture value tester then capture content inside quotes
	(?:\ (.*))?      # Optionally catch any modifiers
///

desc1 = "0|# 1|# \"Reflects %1%-%2% Physical Damage to you from your Attacks\""
desc2 = "#|-1 \"%1%%% reduced Energy Shield\" negate 1"

match = descPattern.exec desc2
match.shift()
for m, i in match
    console.log "#{i} {#{m}}"


#match = statPattern.exec stats[3]

#match.shift() # Remove first item. It is always the entire match

#for m, i in match

    #console.log "#{i} {#{m}}"
