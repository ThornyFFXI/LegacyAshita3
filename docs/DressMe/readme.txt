Dressme automatically gathers your items for you.  You can use the following commands:

/dm gear [File] [Optional: Event Name]
-Starts automatic gearing
-If you have Ashitacast loaded, you can trigger this on your currently loaded XML by typing: /ac gear [Optional: Event Name]
-If your filename starts with \, it'll be added to ashita's directory.
-If your filename contains spaces, it must be encompassed in quotes(" ")
-If not, dressme will look in Config\Dressme\ for it.
-If you specify an event name, items included under matching event tags will be retrieved.
Example: /dm gear \Config\Ashitacast\Thorny_MNK.xml adl

/dm stop

/dm validate [File] [Optional: Event Name]
-Prints a list of what items in the file are not currently in your inventory or wardrobe
-If you have Ashitacast loaded, you can trigger this on your currently loaded XML by typing: /ac validate [Optional: Event Name]
-If your filename starts with \, it'll be added to ashita's directory.
-If not, dressme will look in Config\Dressme\ for it.
-If you specify an event name, items included under matching event tags will be checked.

/dm reload
-Reloads configuration XMLs.

/dm export [Optional: Filename]
-Exports your current inventory, safe, etc. to a profile in config/dressme.
-If filename isn't specified, while use CharName_Export.

Configuration structure is in the included "Settings Structure.xml" file.
You can decide where items should go when stored, and define global event lists.
Files should be stored in \Config\Dressme and named Settings.xml or Settings_Name.xml.
If a Settings_Name.xml file exists for the active character, it will be searched for a suitable location before the global Settings.xml is.

You can either use your existing ashitacast profiles through /ac gear, or create unique dressme profiles to handle item movement.
The structure for dressme profiles is displayed in the included "Profile Structure.xml" file.
The structure for ashitacast profiles is displayed in Ashitacast documentation.
If making dressme profiles, place them in the \config\dressme folder.