Shorthand provides the input adjustment portion of Ashitacast1.  To be specific:

-You may omit any symbols or spaces when typing spell names.
-You can type normal numerals in the place of roman numerals.
-You can type partial player, mob, or NPC names as your target.  The closest valid target containing your text in it's name will be used.
-You can omit target entirely and it'll be directed to <t> (or <me> in the case of self-target only spells).
-You can prefix any ability/spell/weaponskill/item name with // instead of typing the ingame prefix.
-When using // in a manner that matches both a pet command and a spell, the pet command will be used when any pet is active, otherwise the spell will be used.
-If you need to specify between a pet command and spell, use /ja or /ma.
-While PacketWS is enabled, you will be able to weaponskill disengaged.

-Please note that the impact, dispelga, and honor march commands do NOT allow you to cast the spells without the appropriate gear.
They will show the spell in your spell list, you must use ashitacast to ensure the associated item is on for precast.
If you try to cast them without the appropriate item in inventory or a wardrobe, shorthand will block the packet before it is sent to server.
If you have the item in inventory or wardrobe, but do not have ashitacast configured to equip it precast, the packet will be sent but the server won't allow the cast.
These should only be used in association with ashitacast for full functionality of those spells.

Commands
/shh export - Print a config XML with all abilities/spells/ws from the resources to Config/Shorthand-Empty.xml
/shh reload - Reload reference lists from your config XML.
/shh packetws [on/off] - When enabled, forces shorthand to generate packets for all weaponskills.
/shh impact [on/off] - When enabled, spell packets will be changed so that you always know impact.
/shh dispelga [on/off] - When enabled, spell packets will be changed so that you always know dispelga.
/shh honor [on/off] - When enabled, spell packets will be changed so that you always know honor march.
/raw [Command] - Sends a command that will be ignored by shorthand.
Example: /raw /ma "Blizzard III" <t>

Commands that will be parsed when using Shorthand:
/ra
/range
/shoot
/throw
/a
/attack
/ta
/target
/ma
/magic
/ja
/jobability
/pet
/ws
/weaponskill
/i (not a normal in-game command, short for /item)
/item (will only try to use usable items in inventory, example usage would be: /i echodrops)
// (can be used for any spell, ability, ws, or item)