/// @param UIButton

var button = argument0;

if (Stuff.fmod_sound) {
    FMODGMS_Chan_ResumeChannel(Stuff.fmod_channel);
    Stuff.fmod_paused = false;
}