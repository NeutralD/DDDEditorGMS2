/// @param UIThing

var selection = ui_list_selection(argument0.root.el_list);

if (selection != noone) {
    // no alphabetize
    if (Stuff.fmod_sound != noone) {
        FMODGMS_Chan_StopChannel(Stuff.fmod_channel);
    }
    
    Stuff.fmod_sound = Stuff.all_se[| selection].fmod;
    FMODGMS_Snd_PlaySound(Stuff.fmod_sound, Stuff.fmod_channel);
}