/// @param UIThing

var thing = argument0;

ini_open(DATA_INI);
ini_write_real("config", "color", Stuff.setting_color);
ini_write_real("config", "bezier", Stuff.setting_bezier_precision);
ini_write_real("config", "backups", Stuff.setting_backups);
ini_write_real("config", "autosave", Stuff.setting_autosave);
ini_write_real("config", "npc-speed", Stuff.setting_npc_animate_rate);
ini_write_real("config", "code-ext", Stuff.setting_code_extension);
ini_close();

script_execute(thing.root.commit, thing.root);