# FMOD Studio API interface for RPG Maker VX Ace
This is just an interface for FMOD Studio API, intended to be used within an RPG Maker VX Ace project. Initially developed for personal use within one of my gamedev projects, and therefore, does not implement all API function calls. Just enough for me to operate, and probably for you.

This is not a script for beginners by any means. It is quite complex to use, and  there's not much I can do about it.

# Setup
Initial setup is easy. Just insert the code under the "Materials" section within your project, and create (if it doesn't exist) a folder named "System" within the root of your project folder, where you must drop the "fmod.dll" and "fmodstudio.dll" provided by the FMOD Studio Webpage (http://www.fmod.com) 

Additionally, you must make sure to create a route "Audio/Banks/Desktop" within your project, where you'll house your "sound banks", built with the FMOD Studio tool. This is were all 3 files (Master Bank.bank, Master Bank.string.back, SFX.bank) produced by the tool, must be kept.

# Instructions for use
Game_Character has an array exposed by the method "fmod_sounds" where you can add sound event instances. For this, you must first create a descriptor of this sound event by calling:

> descriptor = $fmod.system.getEvent(path)

This event path follows a FMOD's syntax "event:/path" where said path reflects the one structured in the FMOD Studio tool while creating the sound bank. The getEvent method returns an event descriptor that you can 

After this, one must create an instance of this sound effect by calling:

> effect = descriptor.createInstance()

And now we can add said effect to the "fmod_sounds" array possessed by the Game_Character class. This will make sure to update the sound effect with the characters positional and velocity data.

With that out of the way, you're free the call the "start" method to play the sound effect, like this:

> effect.start()

Also, if your sound event has additional parameters, you may set them by calling:

> effect.setParameterValue(parameter, value)

Where "parameter" is the name of the parameter, as a string, and "value" is the numeric value for said parameter that you wish to set.

For any additional functionality, I strongly recommend reading FMOD Studio API's documentation, that can be adquired on FMOD's webpage. It has all the information needed to use any other function included and implemented within this interface.


# Disclaimer
This code was written around November 2018 - February 2019, and therefore it might not be compatible with current FMOD Studio API versions. 

For this sole reason, the API files, for which this interface was coded, have been included within this repository for the sake of convinience.

I do <b>NOT</b> own the FMOD Studio API (namely "fmod.dll" and "fmodstudio.dll").
