$imported = {} if $imported.nil?
$imported["FMOD"] = true

# =================================================================================
# FMOD Studio API interface for RPG Maker VX Ace
# ---------------------------------------------------------------------------------
# by: Jay Kozatt
# ---------------------------------------------------------------------------------
# This is just an interface for FMOD Studio API, intended to be used within an 
# RPG Maker VX Ace project. Initially developed for personal use within one of 
# my gamedev projects, and therefore, does not implement all API function calls.
# Just enough for me to operate, and probably for you.
#
# This is not a script for beginners by any means. It is quite complex to use, and 
# there's not much I can do about it.
#
# ---------------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------------
# Initial setup is easy. Just insert the code under the "Materials" section within 
# your project, and create (if it doesn't exist) a folder named "System" within 
# the root of your project folder, where you must drop the "fmod.dll" and 
# "fmodstudio.dll" provided by the FMOD Studio Webpage (http://www.fmod.com) 
#
# Additionally, you must make sure to create a route "Audio/Banks/Desktop" within 
# your project, where you'll house your "sound banks", built with the FMOD Studio 
# tool. This is were all 3 files (Master Bank.bank, Master Bank.string.back, 
# SFX.bank) produced by the tool, must be kept.
#
# ---------------------------------------------------------------------------------
# Instructions for use
# ---------------------------------------------------------------------------------
# Game_Character has an array exposed by the method "fmod_sounds" where you can
# add sound event instances. For this, you must first create a descriptor of this
# sound event by calling:
#
#   descriptor = $fmod.system.getEvent(path)
#
# This event path follows a FMOD's syntax "event:/path" where said path reflects
# the one structured in the FMOD Studio tool while creating the sound bank. The
# getEvent method returns an event descriptor that you can 
#
# After this, one must create an instance of this sound effect by calling:
#
#   effect = descriptor.createInstance()
# 
# And now we can add said effect to the "fmod_sounds" array possessed by the
# Game_Character class. This will make sure to update the sound effect with the
# characters positional and velocity data.
#
# With that out of the way, you're free the call the "start" method to play 
# the sound effect, like this:
#
#   effect.start()
#
# Also, if your sound event has additional parameters, you may set them by calling:
#
#   effect.setParameterValue(parameter, value)
#
# Where "parameter" is the name of the parameter, as a string, and "value" is the
# numeric value for said parameter that you wish to set.
#
# For any additional functionality, I strongly recommend reading FMOD Studio API's
# documentation, that can be adquired on FMOD's webpage. It has all the information
# needed to use any other function included and implemented within this interface.
#
# =================================================================================
# MIT License
#
# Copyright (c) 2020 Jonathan Reyes (alias "Jay Kozatt")
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =================================================================================

# ==============================================================
# * FMod Module.
# -------------------------------------------------------------- 
#   EDITING ANYTHING BELOW CAN BREAK THE CODE
# --------------------------------------------------------------
#   Handles both LowLevel and Studio API and 
#   loading banks.
# ==============================================================
class FMod
  # CHANNELMASK
  CHANNELMASK_FRONT_LEFT = 0x00000001
  CHANNELMASK_FRONT_RIGHT = 0x00000002
  CHANNELMASK_FRONT_CENTER = 0x00000004
  CHANNELMASK_LOW_FREQUENCY = 0x00000008
  CHANNELMASK_SURROUND_LEFT = 0x00000010
  CHANNELMASK_SURROUND_RIGHT = 0x00000020
  CHANNELMASK_BACK_LEFT = 0x00000040
  CHANNELMASK_BACK_RIGHT = 0x00000080
  CHANNELMASK_BACK_CENTER = 0x00000100
  CHANNELMASK_MONO = (CHANNELMASK_FRONT_LEFT)
  CHANNELMASK_STEREO = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT)
  CHANNELMASK_LRC = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_FRONT_CENTER)
  CHANNELMASK_QUAD = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_SURROUND_LEFT | CHANNELMASK_SURROUND_RIGHT)
  CHANNELMASK_SURROUND = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_FRONT_CENTER | CHANNELMASK_SURROUND_LEFT | CHANNELMASK_SURROUND_RIGHT)
  CHANNELMASK_5POINT1 = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_FRONT_CENTER | CHANNELMASK_LOW_FREQUENCY | CHANNELMASK_SURROUND_LEFT | CHANNELMASK_SURROUND_RIGHT)
  CHANNELMASK_5POINT1_REARS = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_FRONT_CENTER | CHANNELMASK_LOW_FREQUENCY | CHANNELMASK_BACK_LEFT | CHANNELMASK_BACK_RIGHT)
  CHANNELMASK_7POINT0 = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_FRONT_CENTER | CHANNELMASK_SURROUND_LEFT | CHANNELMASK_SURROUND_RIGHT | CHANNELMASK_BACK_LEFT | CHANNELMASK_BACK_RIGHT)
  CHANNELMASK_7POINT1 = (CHANNELMASK_FRONT_LEFT | CHANNELMASK_FRONT_RIGHT | CHANNELMASK_FRONT_CENTER | CHANNELMASK_LOW_FREQUENCY | CHANNELMASK_SURROUND_LEFT | CHANNELMASK_SURROUND_RIGHT | CHANNELMASK_BACK_LEFT | CHANNELMASK_BACK_RIGHT)
  
  # CODEC_WAVEFORMAT_VERSION
  CODEC_WAVEFORMAT_VERSION = 3
  
  # DEBUG_FLAGS
  DEBUG_LEVEL_NONE = 0x00000000
  DEBUG_LEVEL_ERROR = 0x00000001
  DEBUG_LEVEL_WARNING = 0x00000002
  DEBUG_LEVEL_LOG = 0x00000004
  DEBUG_TYPE_MEMORY = 0x00000100
  DEBUG_TYPE_FILE = 0x00000200
  DEBUG_TYPE_CODEC = 0x00000400
  DEBUG_TYPE_TRACE = 0x00000800
  DEBUG_DISPLAY_TIMESTAMPS = 0x00010000
  DEBUG_DISPLAY_LINENUMBERS = 0x00020000
  DEBUG_DISPLAY_THREAD = 0x00040000
  
  # DRIVER_STATE
  DRIVER_STATE_CONNECTED = 0x00000001
  DRIVER_STATE_DEFAULT = 0x00000002
  
  # DSP_GETPARAM_VALUESTR_LENGTH
  DSP_GETPARAM_VALUESTR_LENGTH = 32

  # INITFLAGS
  INIT_NORMAL = 0x00000000
  INIT_STREAM_FROM_UPDATE = 0x00000001
  INIT_MIX_FROM_UPDATE = 0x00000002
  INITFMOD_3D_RIGHTHANDED = 0x00000004
  INIT_CHANNEL_LOWPASS = 0x00000100
  INIT_CHANNEL_DISTANCEFILTER = 0x00000200
  INIT_PROFILE_ENABLE = 0x00010000
  INIT_VOL0_BECOMES_VIRTUAL = 0x00020000
  INIT_GEOMETRY_USECLOSEST = 0x00040000
  INIT_PREFER_DOLBY_DOWNMIX = 0x00080000
  INIT_THREAD_UNSAFE = 0x00100000
  INIT_PROFILE_METER_ALL = 0x00200000
  INIT_DISABLE_SRS_HIGHPASSFILTER = 0x00400000
  
  # MAX_CHANNEL_WIDTH
  MAX_CHANNEL_WIDTH = 32
  
  # MAX_LISTENERS
  MAX_LISTENERS = 8
  
  # MAX_SYSTEMS
  MAX_SYSTEMS = 8
  
  # MEMORY_TYPE
  MEMORY_NORMAL = 0x00000000
  MEMORY_STREAM_FILE = 0x00000001
  MEMORY_STREAM_DECODE = 0x00000002
  MEMORY_SAMPLEDATA = 0x00000004
  MEMORY_DSP_BUFFER = 0x00000008
  MEMORY_PLUGIN = 0x00000010
  MEMORY_XBOX360_PHYSICAL = 0x00100000
  MEMORY_PERSISTENT = 0x00200000
  MEMORY_SECONDARY = 0x00400000
  MEMORY_ALL = 0xFFFFFFFF

  # MODE
  DEFAULT = 0x00000000
  LOOP_OFF = 0x00000001
  LOOP_NORMAL = 0x00000002
  LOOP_BIDI = 0x00000004
  FMOD_2D = 0x00000008
  FMOD_3D = 0x00000010
  CREATESTREAM = 0x00000080
  CREATESAMPLE = 0x00000100
  CREATECOMPRESSEDSAMPLE = 0x00000200
  OPENUSER = 0x00000400
  OPENMEMORY = 0x00000800
  OPENMEMORY_POINT = 0x10000000
  OPENRAW = 0x00001000
  OPENONLY = 0x00002000
  ACCURATETIME = 0x00004000
  MPEGSEARCH = 0x00008000
  NONBLOCKING = 0x00010000
  UNIQUE = 0x00020000
  FMOD_3D_HEADRELATIVE = 0x00040000
  FMOD_3D_WORLDRELATIVE = 0x00080000
  FMOD_3D_INVERSEROLLOFF = 0x00100000
  FMOD_3D_LINEARROLLOFF = 0x00200000
  FMOD_3D_LINEARSQUAREROLLOFF = 0x00400000
  FMOD_3D_INVERSETAPEREDROLLOFF = 0x00800000
  FMOD_3D_CUSTOMROLLOFF = 0x04000000
  FMOD_3D_IGNOREGEOMETRY = 0x40000000
  IGNORETAGS = 0x02000000
  LOWMEM = 0x08000000
  LOADSECONDARYRAM = 0x20000000
  VIRTUAL_PLAYFROMSTART = 0x80000000

  # PORT_INDEX
  PORT_INDEX_NONE = 0xFFFFFFFFFFFFFFFF

  # REVERB_MAXINSTANCES
  REVERB_MAXINSTANCES = 4

  # REVERB_PRESETS
  PRESET_OFF = [  1000,    7,  11, 5000, 100, 100, 100, 250, 0,    20,  96, -80.0 ]
  PRESET_GENERIC = [  1500,    7,  11, 5000,  83, 100, 100, 250, 0, 14500,  96,  -8.0 ]
  PRESET_PADDEDCELL = [   170,    1,   2, 5000,  10, 100, 100, 250, 0,   160,  84,  -7.8 ]
  PRESET_ROOM = [   400,    2,   3, 5000,  83, 100, 100, 250, 0,  6050,  88,  -9.4 ]
  PRESET_BATHROOM = [  1500,    7,  11, 5000,  54, 100,  60, 250, 0,  2900,  83,   0.5 ]
  PRESET_LIVINGROOM = [   500,    3,   4, 5000,  10, 100, 100, 250, 0,   160,  58, -19.0 ]
  PRESET_STONEROOM = [  2300,   12,  17, 5000,  64, 100, 100, 250, 0,  7800,  71,  -8.5 ]
  PRESET_AUDITORIUM = [  4300,   20,  30, 5000,  59, 100, 100, 250, 0,  5850,  64, -11.7 ]
  PRESET_CONCERTHALL = [  3900,   20,  29, 5000,  70, 100, 100, 250, 0,  5650,  80,  -9.8 ]
  PRESET_CAVE = [  2900,   15,  22, 5000, 100, 100, 100, 250, 0, 20000,  59, -11.3 ]
  PRESET_ARENA = [  7200,   20,  30, 5000,  33, 100, 100, 250, 0,  4500,  80,  -9.6 ]
  PRESET_HANGAR = [ 10000,   20,  30, 5000,  23, 100, 100, 250, 0,  3400,  72,  -7.4 ]
  PRESET_CARPETTEDHALLWAY = [   300,    2,  30, 5000,  10, 100, 100, 250, 0,   500,  56, -24.0 ]
  PRESET_HALLWAY = [  1500,    7,  11, 5000,  59, 100, 100, 250, 0,  7800,  87,  -5.5 ]
  PRESET_STONECORRIDOR = [   270,   13,  20, 5000,  79, 100, 100, 250, 0,  9000,  86,  -6.0 ]
  PRESET_ALLEY = [  1500,    7,  11, 5000,  86, 100, 100, 250, 0,  8300,  80,  -9.8 ]
  PRESET_FOREST = [  1500,  162,  88, 5000,  54,  79, 100, 250, 0,   760,  94, -12.3 ]
  PRESET_CITY = [  1500,    7,  11, 5000,  67,  50, 100, 250, 0,  4050,  66, -26.0 ]
  PRESET_MOUNTAINS = [  1500,  300, 100, 5000,  21,  27, 100, 250, 0,  1220,  82, -24.0 ]
  PRESET_QUARRY = [  1500,   61,  25, 5000,  83, 100, 100, 250, 0,  3400, 100,  -5.0 ]
  PRESET_PLAIN = [  1500,  179, 100, 5000,  50,  21, 100, 250, 0,  1670,  65, -28.0 ]
  PRESET_PARKINGLOT = [  1700,    8,  12, 5000, 100, 100, 100, 250, 0, 20000,  56, -19.5 ]
  PRESET_SEWERPIPE = [  2800,   14,  21, 5000,  14,  80,  60, 250, 0,  3400,  66,   1.2 ]
  PRESET_UNDERWATER = [  1500,    7,  11, 5000,  10, 100, 100, 250, 0,   500,  92,   7.0 ]

  # SYSTEM_CALLBACK_TYPE
  SYSTEM_CALLBACK_DEVICELISTCHANGED = 0x00000001
  SYSTEM_CALLBACK_DEVICELOST = 0x00000002
  SYSTEM_CALLBACK_MEMORYALLOCATIONFAILED = 0x00000004
  SYSTEM_CALLBACK_THREADCREATED = 0x00000008
  SYSTEM_CALLBACK_BADDSPCONNECTION = 0x00000010
  SYSTEM_CALLBACK_PREMIX = 0x00000020
  SYSTEM_CALLBACK_POSTMIX = 0x00000040
  SYSTEM_CALLBACK_ERROR = 0x00000080
  SYSTEM_CALLBACK_MIDMIX = 0x00000100
  SYSTEM_CALLBACK_THREADDESTROYED = 0x00000200
  SYSTEM_CALLBACK_PREUPDATE = 0x00000400
  SYSTEM_CALLBACK_POSTUPDATE = 0x00000800
  SYSTEM_CALLBACK_RECORDLISTCHANGED = 0x00001000
  SYSTEM_CALLBACK_ALL = 0xFFFFFFFF

  # TIMEUNIT
  TIMEUNIT_MS = 0x00000001
  TIMEUNIT_PCM = 0x00000002
  TIMEUNIT_PCMBYTES = 0x00000004
  TIMEUNIT_RAWBYTES = 0x00000008
  TIMEUNIT_PCMFRACTION = 0x00000010
  TIMEUNIT_MODORDER = 0x00000100
  TIMEUNIT_MODROW = 0x00000200
  TIMEUNIT_MODPATTERN = 0x00000400
  
  ##### ENUMERATIONS #####
  
  # # CHANNELCONTROL_CALLBACK_TYPE
  # CHANNELCONTROL_CALLBACK_END = 0
  # CHANNELCONTROL_CALLBACK_VIRTUALVOICE = 1
  # CHANNELCONTROL_CALLBACK_SYNCPOINT = 2
  # CHANNELCONTROL_CALLBACK_OCCLUSION = 3
  # CHANNELCONTROL_CALLBACK_MAX = 4
  
  # # CHANNELCONTROL_DSP_INDEX
  # CHANNELCONTROL_DSP_HEAD = 0
  # CHANNELCONTROL_DSP_FADER = 1
  # CHANNELCONTROL_DSP_TAIL = 2
  
  # # CHANNELCONTROL_TYPE
  # CHANNELCONTROL_CHANNEL = 0
  # CHANNELCONTROL_CHANNELGROUP = 1
  
  # # CHANNELORDER
  # CHANNELORDER_DEFAULT = 0
  # CHANNELORDER_WAVEFORMAT = 1
  # CHANNELORDER_PROTOOLS = 2
  # CHANNELORDER_ALLMONO = 3
  # CHANNELORDER_ALLSTEREO = 4
  # CHANNELORDER_ALSA = 5
  # CHANNELORDER_MAX = 6
  
  # # DEBUG_MODE
  # DEBUG_MODE_TTY = 0
  # DEBUG_MODE_FILE = 1
  # DEBUG_MODE_CALLBACK = 2
  
  # # DSPCONNECTION_TYPE
  # DSPCONNECTION_TYPE_STANDARD = 0
  # DSPCONNECTION_TYPE_SIDECHAIN = 1
  # DSPCONNECTION_TYPE_SEND = 2
  # DSPCONNECTION_TYPE_SEND_SIDECHAIN = 3
  # DSPCONNECTION_TYPE_MAX = 4
  
  # # DSP_CHANNELMIX
  # DSP_CHANNELMIX_OUTPUTGROUPING = 0
  # DSP_CHANNELMIX_GAIN_CH0 = 0
  # DSP_CHANNELMIX_GAIN_CH1 = 0
  # DSP_CHANNELMIX_GAIN_CH2 = 0
  # DSP_CHANNELMIX_GAIN_CH3 = 0
  # DSP_CHANNELMIX_GAIN_CH4 = 0
  # DSP_CHANNELMIX_GAIN_CH5 = 0
  # DSP_CHANNELMIX_GAIN_CH6 = 0
  # DSP_CHANNELMIX_GAIN_CH7 = 0
  # DSP_CHANNELMIX_GAIN_CH8 = 0
  # DSP_CHANNELMIX_GAIN_CH9 = 0
  # DSP_CHANNELMIX_GAIN_CH10 = 0
  # DSP_CHANNELMIX_GAIN_CH11 = 0
  # DSP_CHANNELMIX_GAIN_CH12 = 0
  # DSP_CHANNELMIX_GAIN_CH13 = 0
  # DSP_CHANNELMIX_GAIN_CH14 = 0
  # DSP_CHANNELMIX_GAIN_CH15 = 0
  # DSP_CHANNELMIX_GAIN_CH16 = 0
  # DSP_CHANNELMIX_GAIN_CH17 = 0
  # DSP_CHANNELMIX_GAIN_CH18 = 0
  # DSP_CHANNELMIX_GAIN_CH19 = 0
  # DSP_CHANNELMIX_GAIN_CH20 = 0
  # DSP_CHANNELMIX_GAIN_CH21 = 0
  # DSP_CHANNELMIX_GAIN_CH22 = 0
  # DSP_CHANNELMIX_GAIN_CH23 = 0
  # DSP_CHANNELMIX_GAIN_CH24 = 0
  # DSP_CHANNELMIX_GAIN_CH25 = 0
  # DSP_CHANNELMIX_GAIN_CH26 = 0
  # DSP_CHANNELMIX_GAIN_CH27 = 0
  # DSP_CHANNELMIX_GAIN_CH28 = 0
  # DSP_CHANNELMIX_GAIN_CH29 = 0
  # DSP_CHANNELMIX_GAIN_CH30 = 0
  # DSP_CHANNELMIX_GAIN_CH31 = 0
  
  # # DSP_CHANNELMIX_OUTPUT
  # DSP_CHANNELMIX_OUTPUT_DEFAULT = 0
  # DSP_CHANNELMIX_OUTPUT_ALLMONO = 1
  # DSP_CHANNELMIX_OUTPUT_ALLSTEREO = 2
  # DSP_CHANNELMIX_OUTPUT_ALLQUAD = 3
  # DSP_CHANNELMIX_OUTPUT_ALL5POINT1 = 4
  # DSP_CHANNELMIX_OUTPUT_ALL7POINT1 = 5
  # DSP_CHANNELMIX_OUTPUT_ALLLFE = 6
  
  # # DSP_CHORUS
  # DSP_CHORUS_MIX = 0
  # DSP_CHORUS_RATE = 1
  # DSP_CHORUS_DEPTH = 2

  # # DSP_COMPRESSOR
  # DSP_COMPRESSOR_THRESHOLD = 0
  # DSP_COMPRESSOR_RATIO = 1
  # DSP_COMPRESSOR_ATTACK = 2
  # DSP_COMPRESSOR_RELEASE = 3
  # DSP_COMPRESSOR_GAINMAKEUP = 4
  # DSP_COMPRESSOR_USESIDECHAIN = 5
  # DSP_COMPRESSOR_LINKED = 6
  
  # # DSP_CONVOLUTION_REVERB
  # DSP_CONVOLUTION_REVERB_PARAM_IR = 0
  # DSP_CONVOLUTION_REVERB_PARAM_WET = 0
  # DSP_CONVOLUTION_REVERB_PARAM_DRY = 0
  # DSP_CONVOLUTION_REVERB_PARAM_LINKED = true
  
  # # DSP_DELAY
  # DSP_DELAY_CH0 = 0
  # DSP_DELAY_CH1 = 0
  # DSP_DELAY_CH2 = 0
  # DSP_DELAY_CH3 = 0
  # DSP_DELAY_CH4 = 0
  # DSP_DELAY_CH5 = 0
  # DSP_DELAY_CH6 = 0
  # DSP_DELAY_CH7 = 0
  # DSP_DELAY_CH8 = 0
  # DSP_DELAY_CH9 = 0
  # DSP_DELAY_CH10 = 0
  # DSP_DELAY_CH11 = 0
  # DSP_DELAY_CH12 = 0
  # DSP_DELAY_CH13 = 0
  # DSP_DELAY_CH14 = 0
  # DSP_DELAY_CH15 = 0
  # DSP_DELAY_MAXDELAY = 10
  
  # # DSP_DISTORTION
  # DSP_DISTORTION_LEVEL = 0.5
  
  SPEAKERMODE_DEFAULT = 0
  SPEAKERMODE_RAW = 1
  SPEAKERMODE_MONO = 2
  SPEAKERMODE_STEREO = 3
  SPEAKERMODE_QUAD = 4
  SPEAKERMODE_SURROUND = 5
  SPEAKERMODE_5POINT1 = 6
  SPEAKERMODE_7POINT1 = 7
  SPEAKERMODE_MAX = 8
  SPEAKERMODE_FORCEINT = 9

  
  # I gave up here with the enums
  
  RESULT = [
    :OK,
    :ERR_BADCOMMAND,
    :ERR_CHANNEL_ALLOC,
    :ERR_CHANNEL_STOLEN,
    :ERR_DMA,
    :ERR_DSP_CONNECTION,
    :ERR_DSP_DONTPROCESS,
    :ERR_DSP_FORMAT,
    :ERR_DSP_INUSE,
    :ERR_DSP_NOTFOUND,
    :ERR_DSP_RESERVED,
    :ERR_DSP_SILENCE,
    :ERR_DSP_TYPE,
    :ERR_FILE_BAD,
    :ERR_FILE_COULDNOTSEEK,
    :ERR_FILE_DISKEJECTED,
    :ERR_FILE_EOF,
    :ERR_FILE_ENDOFDATA,
    :ERR_FILE_NOTFOUND,
    :ERR_FORMAT,
    :ERR_HEADER_MISMATCH,
    :ERR_HTTP,
    :ERR_HTTP_ACCESS,
    :ERR_HTTP_PROXY_AUTH,
    :ERR_HTTP_SERVER_ERROR,
    :ERR_HTTP_TIMEOUT,
    :ERR_INITIALIZATION,
    :ERR_INITIALIZED,
    :ERR_INTERNAL,
    :ERR_INVALID_FLOAT,
    :ERR_INVALID_HANDLE,
    :ERR_INVALID_PARAM,
    :ERR_INVALID_POSITION,
    :ERR_INVALID_SPEAKER,
    :ERR_INVALID_SYNCPOINT,
    :ERR_INVALID_THREAD,
    :ERR_INVALID_VECTOR,
    :ERR_MAXAUDIBLE,
    :ERR_MEMORY,
    :ERR_MEMORY_CANTPOINT,
    :ERR_NEEDS3D,
    :ERR_NEEDSHARDWARE,
    :ERR_NET_CONNECT,
    :ERR_NET_SOCKET_ERROR,
    :ERR_NET_URL,
    :ERR_NET_WOULD_BLOCK,
    :ERR_NOTREADY,
    :ERR_OUTPUT_ALLOCATED,
    :ERR_OUTPUT_CREATEBUFFER,
    :ERR_OUTPUT_DRIVERCALL,
    :ERR_OUTPUT_FORMAT,
    :ERR_OUTPUT_INIT,
    :ERR_OUTPUT_NODRIVERS,
    :ERR_PLUGIN,
    :ERR_PLUGIN_MISSING,
    :ERR_PLUGIN_RESOURCE,
    :ERR_PLUGIN_VERSION,
    :ERR_RECORD,
    :ERR_REVERB_CHANNELGROUP,
    :ERR_REVERB_INSTANCE,
    :ERR_SUBSOUNDS,
    :ERR_SUBSOUND_ALLOCATED,
    :ERR_SUBSOUND_CANTMOVE,
    :ERR_TAGNOTFOUND,
    :ERR_TOOMANYCHANNELS,
    :ERR_TRUNCATED,
    :ERR_UNIMPLEMENTED,
    :ERR_UNINITIALIZED,
    :ERR_UNSUPPORTED,
    :ERR_VERSION,
    :ERR_EVENT_ALREADY_LOADED,
    :ERR_EVENT_LIVEUPDATE_BUSY,
    :ERR_EVENT_LIVEUPDATE_MISMATCH,
    :ERR_EVENT_LIVEUPDATE_TIMEOUT,
    :ERR_EVENT_NOTFOUND,
    :ERR_STUDIO_UNINITIALIZED,
    :ERR_STUDIO_NOT_LOADED,
    :ERR_INVALID_STRING,
    :ERR_ALREADY_LOCKED,
    :ERR_NOT_LOCKED,
    :ERR_RECORD_DISCONNECTED,
    :ERR_TOOMANYSAMPLES
  ]

  # Structs
  FMOD_3D_ATTRIBUTES = Struct.new(
    :position, 
    :velocity, 
    :forward,
    :up
  )
  ADVANCEDSETTINGS = Struct.new(
    :cbSize,
    :maxMPEGCodecs,
    :maxADPCMCodecs,
    :maxXMACodecs,
    :maxVorbisCodecs,
    :maxAT9Codecs,
    :maxFADPCMCodecs,
    :maxPCMCodecs,
    :ASIONumChannels,
    :ASIOChannelList,
    :ASIOSpeakerList,
    :HRTFMinAngle,
    :HRTFMaxAngle,
    :HRTFFreq,
    :vol0virtualvol,
    :defaultDecodeBufferSize,
    :profilePort,
    :geometryMaxFadeTime,
    :distanceFilterCenterFreq,
    :verb3Dinstance,
    :PBufferPoolSize,
    :stackSizeStream,
    :stackSizeNonBlocking,
    :stackSizeMixer,
    :resamplerMethod,
    :commandQueueSize,
    :randomSeed
  )
  ASYNCREADINFO = Struct.new(
    :handle,
    :offset,
    :sizebytes,
    :priority,
    :userdata,
    :buffer,
    :bytesread,
    :done
  )
  CODEC_DESCRIPTION = Struct.new(
    :name,
    :version,
    :defaultasstream,
    :timeunits,
    :open,
    :close,
    :read,
    :getlength,
    :setposition,
    :getposition,
    :soundcreate,
    :getwaveformat,
  )
  CODEC_STATE = Struct.new(
    :numsubsounds,
    :waveformat,
    :plugindata,
    :filehandle,
    :filesize,
    :fileread,
    :fileseek,
    :metadata,
    :waveformatversion,
  )
  CODEC_WAVEFORMAT = Struct.new(
    :name,
    :format,
    :channels,
    :frequency,
    :lengthbytes,
    :lengthpcm,
    :pcmblocksize,
    :loopstart,
    :loopend,
    :mode,
    :channelmask,
    :channelorder,
    :peakvolume,
  )
  COMPLEX = Struct.new(
    :real,
    :imag,
  )
  CREATESOUNDEXINFO = Struct.new(
    :cbsize,
    :length,
    :fileoffset,
    :numchannels,
    :defaultfrequency,
    :format,
    :decodebuffersize,
    :initialsubsound,
    :numsubsounds,
    :inclusionlist,
    :inclusionlistnum,
    :pcmreadcallback,
    :pcmsetposcallback,
    :nonblockcallback,
    :dlsname,
    :encryptionkey,
    :maxpolyphony,
    :userdata,
    :suggestedsoundtype,
    :fileuseropen,
    :fileuserclose,
    :fileuserread,
    :fileuserseek,
    :fileuserasyncread,
    :fileuserasynccancel,
    :fileuserdata,
    :filebuffersize,
    :channelorder,
    :channelmask,
    :initialsoundgroup,
    :initialseekposition,
    :initialseekpostype,
    :ignoresetfilesystem,
    :audioqueuepolicy,
    :minmidigranularity,
    :nonblockthreadid,
    :fsbguid,
  )
  DSP_BUFFER_ARRAY = Struct.new(
    :numbuffers,
    :buffernumchannels,
    :bufferchannelmask,
    :buffers,
    :speakermode,
  )
  DSP_DESCRIPTION = Struct.new(
    :pluginsdkversion,
    :name,
    :version,
    :numinputbuffers,
    :numoutputbuffers,
    :create,
    :release,
    :reset,
    :read,
    :process,
    :setposition,
    :numparameters,
    :paramdesc,
    :setparameterfloat,
    :setparameterint,
    :setparameterbool,
    :setparameterdata,
    :getparameterfloat,
    :getparameterint,
    :getparameterbool,
    :getparameterdata,
    :shouldiprocess,
    :userdata,
    :sys_register,
    :sys_deregister,
    :sys_mix,  
  )
  DSP_METERING_INFO = Struct.new(
    :numsamples,
    :peaklevel,
    :rmslevel,
    :numchannels,
  )
  DSP_PARAMETERFMOD_3DATTRIBUTES = Struct.new(
    :relative,
    :absolute,
  )
  DSP_PARAMETERFMOD_3DATTRIBUTES_MULTI = Struct.new(
    :numlisteners,
    :relative,
    :weight,
    :absolute,
  )
  DSP_PARAMETER_DESC = Struct.new(
    :type,
    :name,
    :label,
    :description,
    :floatdesc,
    :intdesc,
    :booldesc,
    :datadesc,
  )
  DSP_PARAMETER_DESC_BOOL = Struct.new(
    :defaultval,
    :valuenames,
  )
  DSP_PARAMETER_DESC_DATA = Struct.new(
    :datatype,
  )
  DSP_PARAMETER_DESC_FLOAT = Struct.new(
    :min,
    :max,
    :defaultval,
    :mapping,
  )
  DSP_PARAMETER_DESC_INT = Struct.new(
    :min,
    :max,
    :defaultval,
    :goestoinf,
    :valuenames,
  )
  DSP_PARAMETER_FFT = Struct.new(
    :length,
    :numchannels,
    :spectrum,
  )
  DSP_PARAMETER_FLOAT_MAPPING = Struct.new(
    :type,
    :piecewiselinearmapping,
  )
  DSP_PARAMETER_FLOAT_MAPPING_PIECEWISE_LINEAR = Struct.new(
    :numpoints,
    :pointparamvalues,
    :pointpositions,
  )
  DSP_PARAMETER_OVERALLGAIN = Struct.new(
    :linear_gain,
    :linear_gain_additive,
  )
  DSP_PARAMETER_SIDECHAIN = Struct.new(
    :sidechainenabled,
  )
  DSP_STATE = Struct.new(
    :instance,
    :plugindata,
    :channelmask,
    :source_speakermode,
    :sidechaindata,
    :sidechainchannels,
    :functions,
    :systemobject,
  )
  DSP_STATE_DFT_FUNCTIONS = Struct.new(
    :fftreal,
    :inversefftreal,
  )
  DSP_STATE_FUNCTIONS = Struct.new(
    :alloc,
    :realloc,
    :free,
    :getsamplerate,
    :getblocksize,
    :dft,
    :pan,
    :getspeakermode,
    :getclock,
    :getlistenerattributes,
    :log,
    :getuserdata,
  )
  DSP_STATE_PAN_FUNCTIONS = Struct.new(
    :summonomatrix,
    :sumstereomatrix,
    :sumsurroundmatrix,
    :summonotosurroundmatrix,
    :sumstereotosurroundmatrix,
    :getrolloffgain,
  )
  ERRORCALLBACK_INFO = Struct.new(
    :result,
    :instancetype,
    :instance,
    :functionname,
    :functionparams,
  )
  GUID = Struct.new(
    :Data1,
    :Data2,
    :Data3,
    :Data4,
  )
  OUTPUT_DESCRIPTION = Struct.new(
    :apiversion,
    :name,
    :version,
    :polling,
    :getnumdrivers,
    :getdriverinfo,
    :init,
    :start,
    :stop,
    :close,
    :update,
    :gethandle,
    :getposition,
    :lock,
    :unlock,
    :mixer,
    :object3dgetinfo,
    :object3dalloc,
    :object3dfree,
    :object3dupdate,
    :openport,
    :closeport,
  )
  OUTPUT_OBJECT3DINFO = Struct.new(
    :buffer,
    :bufferlength,
    :position,
    :gain,
    :spread,
    :priority,
  )
  OUTPUT_STATE = Struct.new(
    :plugindata,
    :readfrommixer,
    :alloc,
    :free,
    :log,
    :copyport,
    :requestreset,
  )
  PLUGINLIST = Struct.new(
    :type,
    :description,
  )
  REVERB_PROPERTIES = Struct.new(
    :DecayTime,
    :EarlyDelay,
    :LateDelay,
    :HFReference,
    :HFDecayRatio,
    :Diffusion,
    :Density,
    :LowShelfFrequency,
    :LowShelfGain,
    :HighCut,
    :EarlyLateMix,
    :WetLevel,
  )
  TAG = Struct.new(
    :type,
    :datatype,
    :name,
    :data,
    :datalen,
    :updated,
  )
  VECTOR = Struct.new(
    :x,
    :y,
    :z,
  )

  attr_reader :system, :masterBank, :stringsBank
  # Bind and initialize the FMOD Studio API
  def initialize
    # Create the DLL handlers
    @@lowDLL = DLL.new('System/fmod.dll')
    @@studioDLL = DLL.new('System/fmodstudio.dll')
    
    # Import the functions from each DLL
    loadLowDLL()
    loadStudioDLL()
    
    handle = Studio::System.create()
    @system = Studio::System.new(handle)
    @masterBank = @system.loadBankFile("Master Bank.bank")
    @stringsBank = @system.loadBankFile("Master Bank.strings.bank")
    @sfxBank = @system.loadBankFile("SFX.bank")
  end
  
  #--------------------------------------------------------------------------
  # * Load the LowLevel API functions
  #--------------------------------------------------------------------------
  def loadLowDLL()
    # System
    @@lowDLL.import("System_AttachChannelGroupToPort", "lllpl")
    @@lowDLL.import("System_AttachFileSystem", "lllll")
    @@lowDLL.import("System_Close", "l")
    @@lowDLL.import("System_Create", "p")
    @@lowDLL.import("System_CreateChannelGroup", "llp")
    @@lowDLL.import("System_CreateDSP", "llp")
    @@lowDLL.import("System_CreateDSPByPlugin", "llp")
    @@lowDLL.import("System_CreateDSPByType", "llp")
    @@lowDLL.import("System_CreateGeometry", "lllp")
    @@lowDLL.import("System_CreateReverb3D", "lp")
    @@lowDLL.import("System_CreateSound", "llllp")
    @@lowDLL.import("System_CreateSoundGroup", "llp")
    @@lowDLL.import("System_CreateStream", "llllp")
    @@lowDLL.import("System_DetachChannelGroupFromPort", "ll")
    @@lowDLL.import("System_Get3DListenerAttributes", "llllll")
    @@lowDLL.import("System_Get3DNumListeners", "ll")
    @@lowDLL.import("System_Get3DSettings", "llll")
    @@lowDLL.import("System_GetAdvancedSettings", "ll")
    @@lowDLL.import("System_GetCPUUsage", "lllll")
    @@lowDLL.import("System_GetChannel", "llp")
    @@lowDLL.import("System_GetChannelsPlaying", "lll")
    @@lowDLL.import("System_GetDSPBufferSize", "lll")
    @@lowDLL.import("System_GetDSPInfoByPlugin", "llp")
    @@lowDLL.import("System_GetDefaultMixMatrix", "lllll")
    @@lowDLL.import("System_GetDriver", "ll")
    @@lowDLL.import("System_GetDriverInfo", "llllllll")
    @@lowDLL.import("System_GetFileUsage", "llll")
    @@lowDLL.import("System_GetGeometryOcclusion", "lllll")
    @@lowDLL.import("System_GetGeometrySettings", "ll")
    @@lowDLL.import("System_GetMasterChannelGroup", "lp")
    @@lowDLL.import("System_GetMasterSoundGroup", "lp")
    @@lowDLL.import("System_GetNestedPlugin", "llll")
    @@lowDLL.import("System_GetNetworkProxy", "lll")
    @@lowDLL.import("System_GetNetworkTimeout", "ll")
    @@lowDLL.import("System_GetNumDrivers", "ll")
    @@lowDLL.import("System_GetNumNestedPlugins", "lll")
    @@lowDLL.import("System_GetNumPlugins", "lll")
    @@lowDLL.import("System_GetOutput", "ll")
    @@lowDLL.import("System_GetOutputByPlugin", "ll")
    @@lowDLL.import("System_GetOutputHandle", "lp")
    @@lowDLL.import("System_GetPluginHandle", "llll")
    @@lowDLL.import("System_GetPluginInfo", "llllll")
    @@lowDLL.import("System_GetRecordDriverInfo", "lllllllll")
    @@lowDLL.import("System_GetRecordNumDrivers", "lll")
    @@lowDLL.import("System_GetRecordPosition", "lll")
    @@lowDLL.import("System_GetReverbProperties", "lll")
    @@lowDLL.import("System_GetSoftwareChannels", "ll")
    @@lowDLL.import("System_GetSoftwareFormat", "llll")
    @@lowDLL.import("System_GetSoundRAM", "llll")
    @@lowDLL.import("System_GetSpeakerModeChannels", "lll")
    @@lowDLL.import("System_GetSpeakerPosition", "lllll")
    @@lowDLL.import("System_GetStreamBufferSize", "lll")
    @@lowDLL.import("System_GetUserData", "lp")
    @@lowDLL.import("System_GetVersion", "ll")
    @@lowDLL.import("System_Init", "llll")
    @@lowDLL.import("System_IsRecording", "lll")
    @@lowDLL.import("System_LoadGeometry", "lllp")
    @@lowDLL.import("System_LoadPlugin", "llll")
    @@lowDLL.import("System_LockDSP", "l")
    @@lowDLL.import("System_MixerResume", "l")
    @@lowDLL.import("System_MixerSuspend", "l")
    @@lowDLL.import("System_PlayDSP", "llllp")
    @@lowDLL.import("System_PlaySound", "llllp")
    @@lowDLL.import("System_RecordStart", "llll")
    @@lowDLL.import("System_RecordStop", "ll")
    @@lowDLL.import("System_RegisterCodec", "llll")
    @@lowDLL.import("System_RegisterDSP", "lll")
    @@lowDLL.import("System_RegisterOutput", "lll")
    @@lowDLL.import("System_Release", "l")
    @@lowDLL.import("System_Set3DListenerAttributes", "llllll")
    @@lowDLL.import("System_Set3DNumListeners", "ll")
    @@lowDLL.import("System_Set3DRolloffCallback", "ll")
    @@lowDLL.import("System_Set3DSettings", "llll")
    @@lowDLL.import("System_SetAdvancedSettings", "ll")
    @@lowDLL.import("System_SetCallback", "lll")
    @@lowDLL.import("System_SetDSPBufferSize", "lll")
    @@lowDLL.import("System_SetDriver", "ll")
    @@lowDLL.import("System_SetFileSystem", "llllllll")
    @@lowDLL.import("System_SetGeometrySettings", "ll")
    @@lowDLL.import("System_SetNetworkProxy", "ll")
    @@lowDLL.import("System_SetNetworkTimeout", "ll")
    @@lowDLL.import("System_SetOutput", "ll")
    @@lowDLL.import("System_SetOutputByPlugin", "ll")
    @@lowDLL.import("System_SetPluginPath", "ll")
    @@lowDLL.import("System_SetReverbProperties", "lll")
    @@lowDLL.import("System_SetSoftwareChannels", "ll")
    @@lowDLL.import("System_SetSoftwareFormat", "llll")
    @@lowDLL.import("System_SetSpeakerPosition", "lllll")
    @@lowDLL.import("System_SetStreamBufferSize", "lll")
    @@lowDLL.import("System_SetUserData", "ll")
    @@lowDLL.import("System_UnloadPlugin", "ll")
    @@lowDLL.import("System_UnlockDSP", "l")
    @@lowDLL.import("System_Update", "l")
    
    # Sound
    @@lowDLL.import("Sound_AddSyncPoint", "llllp")
    @@lowDLL.import("Sound_DeleteSyncPoint", "ll")
    @@lowDLL.import("Sound_Get3DConeSettings", "llll")
    @@lowDLL.import("Sound_Get3DCustomRolloff", "lpl")
    @@lowDLL.import("Sound_Get3DMinMaxDistance", "lll")
    @@lowDLL.import("Sound_GetDefaults", "lll")
    @@lowDLL.import("Sound_GetFormat", "lllll")
    @@lowDLL.import("Sound_GetLength", "lll")
    @@lowDLL.import("Sound_GetLoopCount", "ll")
    @@lowDLL.import("Sound_GetLoopPoints", "lllll")
    @@lowDLL.import("Sound_GetMode", "ll")
    @@lowDLL.import("Sound_GetMusicChannelVolume", "lll")
    @@lowDLL.import("Sound_GetMusicNumChannels", "ll")
    @@lowDLL.import("Sound_GetMusicSpeed", "ll")
    @@lowDLL.import("Sound_GetName", "lll")
    @@lowDLL.import("Sound_GetNumSubSounds", "ll")
    @@lowDLL.import("Sound_GetNumSyncPoints", "ll")
    @@lowDLL.import("Sound_GetNumTags", "lll")
    @@lowDLL.import("Sound_GetOpenState", "lllll")
    @@lowDLL.import("Sound_GetSoundGroup", "lp")
    @@lowDLL.import("Sound_GetSubSound", "llp")
    @@lowDLL.import("Sound_GetSubSoundParent", "lp")
    @@lowDLL.import("Sound_GetSyncPoint", "llp")
    @@lowDLL.import("Sound_GetSyncPointInfo", "llllll")
    @@lowDLL.import("Sound_GetSystemObject", "lp")
    @@lowDLL.import("Sound_GetTag", "llll")
    @@lowDLL.import("Sound_GetUserData", "lp")
    @@lowDLL.import("Sound_Lock", "lllppll")
    @@lowDLL.import("Sound_ReadData", "llll")
    @@lowDLL.import("Sound_Release", "l")
    @@lowDLL.import("Sound_SeekData", "ll")
    @@lowDLL.import("Sound_Set3DConeSettings", "llll")
    @@lowDLL.import("Sound_Set3DCustomRolloff", "lll")
    @@lowDLL.import("Sound_Set3DMinMaxDistance", "lll")
    @@lowDLL.import("Sound_SetDefaults", "lll")
    @@lowDLL.import("Sound_SetLoopCount", "ll")
    @@lowDLL.import("Sound_SetLoopPoints", "lllll")
    @@lowDLL.import("Sound_SetMode", "ll")
    @@lowDLL.import("Sound_SetMusicChannelVolume", "lll")
    @@lowDLL.import("Sound_SetMusicSpeed", "ll")
    @@lowDLL.import("Sound_SetSoundGroup", "ll")
    @@lowDLL.import("Sound_SetUserData", "ll")
    @@lowDLL.import("Sound_Unlock", "lllll")
    
    # Channel
    @@lowDLL.import("Channel_AddDSP", "lll")
    @@lowDLL.import("Channel_AddFadePoint", "lll")
    @@lowDLL.import("Channel_Get3DAttributes", "llll")
    @@lowDLL.import("Channel_Get3DConeOrientation", "ll")
    @@lowDLL.import("Channel_Get3DConeSettings", "llll")
    @@lowDLL.import("Channel_Get3DCustomRolloff", "lpl")
    @@lowDLL.import("Channel_Get3DDistanceFilter", "llll")
    @@lowDLL.import("Channel_Get3DDopplerLevel", "ll")
    @@lowDLL.import("Channel_Get3DLevel", "ll")
    @@lowDLL.import("Channel_Get3DMinMaxDistance", "lll")
    @@lowDLL.import("Channel_Get3DOcclusion", "lll")
    @@lowDLL.import("Channel_Get3DSpread", "ll")
    @@lowDLL.import("Channel_GetAudibility", "ll")
    @@lowDLL.import("Channel_GetChannelGroup", "lp")
    @@lowDLL.import("Channel_GetCurrentSound", "lp")
    @@lowDLL.import("Channel_GetDSP", "llp")
    @@lowDLL.import("Channel_GetDSPClock", "lll")
    @@lowDLL.import("Channel_GetDSPIndex", "lll")
    @@lowDLL.import("Channel_GetDelay", "llll")
    @@lowDLL.import("Channel_GetFadePoints", "llll")
    @@lowDLL.import("Channel_GetFrequency", "ll")
    @@lowDLL.import("Channel_GetIndex", "ll")
    @@lowDLL.import("Channel_GetLoopCount", "ll")
    @@lowDLL.import("Channel_GetLoopPoints", "lllll")
    @@lowDLL.import("Channel_GetLowPassGain", "ll")
    @@lowDLL.import("Channel_GetMixMatrix", "lllll")
    @@lowDLL.import("Channel_GetMode", "ll")
    @@lowDLL.import("Channel_GetMute", "ll")
    @@lowDLL.import("Channel_GetNumDSPs", "ll")
    @@lowDLL.import("Channel_GetPaused", "ll")
    @@lowDLL.import("Channel_GetPitch", "ll")
    @@lowDLL.import("Channel_GetPosition", "lll")
    @@lowDLL.import("Channel_GetPriority", "ll")
    @@lowDLL.import("Channel_GetReverbProperties", "lll")
    @@lowDLL.import("Channel_GetSystemObject", "lp")
    @@lowDLL.import("Channel_GetUserData", "lp")
    @@lowDLL.import("Channel_GetVolume", "ll")
    @@lowDLL.import("Channel_GetVolumeRamp", "ll")
    @@lowDLL.import("Channel_IsPlaying", "ll")
    @@lowDLL.import("Channel_IsVirtual", "ll")
    @@lowDLL.import("Channel_RemoveDSP", "ll")
    @@lowDLL.import("Channel_RemoveFadePoints", "lll")
    @@lowDLL.import("Channel_Set3DAttributes", "llll")
    @@lowDLL.import("Channel_Set3DConeOrientation", "ll")
    @@lowDLL.import("Channel_Set3DConeSettings", "llll")
    @@lowDLL.import("Channel_Set3DCustomRolloff", "lll")
    @@lowDLL.import("Channel_Set3DDistanceFilter", "llll")
    @@lowDLL.import("Channel_Set3DDopplerLevel", "ll")
    @@lowDLL.import("Channel_Set3DLevel", "ll")
    @@lowDLL.import("Channel_Set3DMinMaxDistance", "lll")
    @@lowDLL.import("Channel_Set3DOcclusion", "lll")
    @@lowDLL.import("Channel_Set3DSpread", "ll")
    @@lowDLL.import("Channel_SetCallback", "ll")
    @@lowDLL.import("Channel_SetChannelGroup", "ll")
    @@lowDLL.import("Channel_SetDSPIndex", "lll")
    @@lowDLL.import("Channel_SetDelay", "llll")
    @@lowDLL.import("Channel_SetFadePointRamp", "lll")
    @@lowDLL.import("Channel_SetFrequency", "ll")
    @@lowDLL.import("Channel_SetLoopCount", "ll")
    @@lowDLL.import("Channel_SetLoopPoints", "lllll")
    @@lowDLL.import("Channel_SetLowPassGain", "ll")
    @@lowDLL.import("Channel_SetMixLevelsInput", "lll")
    @@lowDLL.import("Channel_SetMixLevelsOutput", "lllllllll")
    @@lowDLL.import("Channel_SetMixMatrix", "lllll")
    @@lowDLL.import("Channel_SetMode", "ll")
    @@lowDLL.import("Channel_SetMute", "ll")
    @@lowDLL.import("Channel_SetPan", "ll")
    @@lowDLL.import("Channel_SetPaused", "ll")
    @@lowDLL.import("Channel_SetPitch", "ll")
    @@lowDLL.import("Channel_SetPosition", "lll")
    @@lowDLL.import("Channel_SetPriority", "ll")
    @@lowDLL.import("Channel_SetReverbProperties", "lll")
    @@lowDLL.import("Channel_SetUserData", "ll")
    @@lowDLL.import("Channel_SetVolume", "ll")
    @@lowDLL.import("Channel_SetVolumeRamp", "ll")
    @@lowDLL.import("Channel_Stop", "l")
    
    # ChannelGroup
    @@lowDLL.import("ChannelGroup_AddDSP", "lll")
    @@lowDLL.import("ChannelGroup_AddFadePoint", "lll")
    @@lowDLL.import("ChannelGroup_AddGroup", "lllp")
    @@lowDLL.import("ChannelGroup_Get3DAttributes", "llll")
    @@lowDLL.import("ChannelGroup_Get3DConeOrientation", "ll")
    @@lowDLL.import("ChannelGroup_Get3DConeSettings", "llll")
    @@lowDLL.import("ChannelGroup_Get3DCustomRolloff", "lpl")
    @@lowDLL.import("ChannelGroup_Get3DDistanceFilter", "llll")
    @@lowDLL.import("ChannelGroup_Get3DDopplerLevel", "ll")
    @@lowDLL.import("ChannelGroup_Get3DLevel", "ll")
    @@lowDLL.import("ChannelGroup_Get3DMinMaxDistance", "lll")
    @@lowDLL.import("ChannelGroup_Get3DOcclusion", "lll")
    @@lowDLL.import("ChannelGroup_Get3DSpread", "ll")
    @@lowDLL.import("ChannelGroup_GetAudibility", "ll")
    @@lowDLL.import("ChannelGroup_GetChannel", "llp")
    @@lowDLL.import("ChannelGroup_GetDSP", "llp")
    @@lowDLL.import("ChannelGroup_GetDSPClock", "lll")
    @@lowDLL.import("ChannelGroup_GetDSPIndex", "lll")
    @@lowDLL.import("ChannelGroup_GetDelay", "llll")
    @@lowDLL.import("ChannelGroup_GetFadePoints", "llll")
    @@lowDLL.import("ChannelGroup_GetGroup", "llp")
    @@lowDLL.import("ChannelGroup_GetLowPassGain", "ll")
    @@lowDLL.import("ChannelGroup_GetMixMatrix", "llll")
    @@lowDLL.import("ChannelGroup_GetMode", "ll")
    @@lowDLL.import("ChannelGroup_GetMute", "ll")
    @@lowDLL.import("ChannelGroup_GetName", "lll")
    @@lowDLL.import("ChannelGroup_GetNumChannels", "ll")
    @@lowDLL.import("ChannelGroup_GetNumDSPs", "ll")
    @@lowDLL.import("ChannelGroup_GetNumGroups", "ll")
    @@lowDLL.import("ChannelGroup_GetParentGroup", "lp")
    @@lowDLL.import("ChannelGroup_GetPaused", "ll")
    @@lowDLL.import("ChannelGroup_GetPitch", "ll")
    @@lowDLL.import("ChannelGroup_GetReverbProperties", "lll")
    @@lowDLL.import("ChannelGroup_GetSystemObject", "lp")
    @@lowDLL.import("ChannelGroup_GetUserData", "lp")
    @@lowDLL.import("ChannelGroup_GetVolume", "ll")
    @@lowDLL.import("ChannelGroup_GetVolumeRamp", "ll")
    @@lowDLL.import("ChannelGroup_IsPlaying", "ll")
    @@lowDLL.import("ChannelGroup_Release", "l")
    @@lowDLL.import("ChannelGroup_RemoveDSP", "ll")
    @@lowDLL.import("ChannelGroup_RemoveFadePoints", "lll")
    @@lowDLL.import("ChannelGroup_Set3DAttributes", "llll")
    @@lowDLL.import("ChannelGroup_Set3DConeOrientation", "ll")
    @@lowDLL.import("ChannelGroup_Set3DConeSettings", "llll")
    @@lowDLL.import("ChannelGroup_Set3DCustomRolloff", "lll")
    @@lowDLL.import("ChannelGroup_Set3DDistanceFilter", "llll")
    @@lowDLL.import("ChannelGroup_Set3DDopplerLevel", "ll")
    @@lowDLL.import("ChannelGroup_Set3DLevel", "ll")
    @@lowDLL.import("ChannelGroup_Set3DMinMaxDistance", "lll")
    @@lowDLL.import("ChannelGroup_Set3DOcclusion", "lll")
    @@lowDLL.import("ChannelGroup_Set3DSpread", "ll")
    @@lowDLL.import("ChannelGroup_SetCallback", "ll")
    @@lowDLL.import("ChannelGroup_SetDSPIndex", "lll")
    @@lowDLL.import("ChannelGroup_SetDelay", "llll")
    @@lowDLL.import("ChannelGroup_SetFadePointRamp", "lll")
    @@lowDLL.import("ChannelGroup_SetLowPassGain", "ll")
    @@lowDLL.import("ChannelGroup_SetMixLevelsInput", "lll")
    @@lowDLL.import("ChannelGroup_SetMixLevelsOutput", "lllllllll")
    @@lowDLL.import("ChannelGroup_SetMixMatrix", "lllll")
    @@lowDLL.import("ChannelGroup_SetMode", "ll")
    @@lowDLL.import("ChannelGroup_SetMute", "ll")
    @@lowDLL.import("ChannelGroup_SetPan", "ll")
    @@lowDLL.import("ChannelGroup_SetPaused", "ll")
    @@lowDLL.import("ChannelGroup_SetPitch", "ll")
    @@lowDLL.import("ChannelGroup_SetReverbProperties", "lll")
    @@lowDLL.import("ChannelGroup_SetUserData", "ll")
    @@lowDLL.import("ChannelGroup_SetVolume", "ll")
    @@lowDLL.import("ChannelGroup_SetVolumeRamp", "ll")
    @@lowDLL.import("ChannelGroup_Stop", "l")
    
    # SoundGroup
    @@lowDLL.import("SoundGroup_GetMaxAudible", "ll")
    @@lowDLL.import("SoundGroup_GetMaxAudibleBehavior", "ll")
    @@lowDLL.import("SoundGroup_GetMuteFadeSpeed", "ll")
    @@lowDLL.import("SoundGroup_GetName", "lll")
    @@lowDLL.import("SoundGroup_GetNumPlaying", "ll")
    @@lowDLL.import("SoundGroup_GetNumSounds", "ll")
    @@lowDLL.import("SoundGroup_GetSound", "llp")
    @@lowDLL.import("SoundGroup_GetSystemObject", "lp")
    @@lowDLL.import("SoundGroup_GetUserData", "lp")
    @@lowDLL.import("SoundGroup_GetVolume", "ll")
    @@lowDLL.import("SoundGroup_Release", "l")
    @@lowDLL.import("SoundGroup_SetMaxAudible", "ll")
    @@lowDLL.import("SoundGroup_SetMaxAudibleBehavior", "ll")
    @@lowDLL.import("SoundGroup_SetMuteFadeSpeed", "ll")
    @@lowDLL.import("SoundGroup_SetUserData", "ll")
    @@lowDLL.import("SoundGroup_SetVolume", "ll")
    @@lowDLL.import("SoundGroup_Stop", "l")
    
    # DSP
    @@lowDLL.import("DSP_AddInput", "llpl")
    @@lowDLL.import("DSP_DisconnectAll", "lll")
    @@lowDLL.import("DSP_DisconnectFrom", "lll")
    @@lowDLL.import("DSP_GetActive", "ll")
    @@lowDLL.import("DSP_GetBypass", "ll")
    @@lowDLL.import("DSP_GetChannelFormat", "llll")
    @@lowDLL.import("DSP_GetDataParameterIndex", "lll")
    @@lowDLL.import("DSP_GetIdle", "ll")
    @@lowDLL.import("DSP_GetInfo", "llllll")
    @@lowDLL.import("DSP_GetInput", "llpp")
    @@lowDLL.import("DSP_GetMeteringEnabled", "lll")
    @@lowDLL.import("DSP_GetMeteringInfo", "lll")
    @@lowDLL.import("DSP_GetNumInputs", "ll")
    @@lowDLL.import("DSP_GetNumOutputs", "ll")
    @@lowDLL.import("DSP_GetNumParameters", "ll")
    @@lowDLL.import("DSP_GetOutput", "llpp")
    @@lowDLL.import("DSP_GetOutputChannelFormat", "lllllll")
    @@lowDLL.import("DSP_GetParameterBool", "lllll")
    @@lowDLL.import("DSP_GetParameterData", "llplll")
    @@lowDLL.import("DSP_GetParameterFloat", "lllll")
    @@lowDLL.import("DSP_GetParameterInfo", "llp")
    @@lowDLL.import("DSP_GetParameterInt", "lllll")
    @@lowDLL.import("DSP_GetSystemObject", "lp")
    @@lowDLL.import("DSP_GetType", "ll")
    @@lowDLL.import("DSP_GetUserData", "lp")
    @@lowDLL.import("DSP_GetWetDryMix", "llll")
    @@lowDLL.import("DSP_Release", "l")
    @@lowDLL.import("DSP_Reset", "l")
    @@lowDLL.import("DSP_SetActive", "ll")
    @@lowDLL.import("DSP_SetBypass", "ll")
    @@lowDLL.import("DSP_SetChannelFormat", "llll")
    @@lowDLL.import("DSP_SetMeteringEnabled", "lll")
    @@lowDLL.import("DSP_SetParameterBool", "lll")
    @@lowDLL.import("DSP_SetParameterData", "llll")
    @@lowDLL.import("DSP_SetParameterFloat", "lll")
    @@lowDLL.import("DSP_SetParameterInt", "lll")
    @@lowDLL.import("DSP_SetUserData", "ll")
    @@lowDLL.import("DSP_SetWetDryMix", "llll")
    @@lowDLL.import("DSP_ShowConfigDialog", "lll")
    
    # DSPConnection
    @@lowDLL.import("DSPConnection_GetInput", "lp")
    @@lowDLL.import("DSPConnection_GetMix", "ll")
    @@lowDLL.import("DSPConnection_GetMixMatrix", "lllll")
    @@lowDLL.import("DSPConnection_GetOutput", "lp")
    @@lowDLL.import("DSPConnection_GetType", "ll")
    @@lowDLL.import("DSPConnection_GetUserData", "lp")
    @@lowDLL.import("DSPConnection_SetMix", "ll")
    @@lowDLL.import("DSPConnection_SetMixMatrix", "lllll")
    @@lowDLL.import("DSPConnection_SetUserData", "ll")
    
    # Geometry
    @@lowDLL.import("Geometry_AddPolygon", "lllllll")
    @@lowDLL.import("Geometry_GetActive", "ll")
    @@lowDLL.import("Geometry_GetMaxPolygons", "lll")
    @@lowDLL.import("Geometry_GetNumPolygons", "ll")
    @@lowDLL.import("Geometry_GetPolygonAttributes", "lllll")
    @@lowDLL.import("Geometry_GetPolygonNumVertices", "lll")
    @@lowDLL.import("Geometry_GetPolygonVertex", "llll")
    @@lowDLL.import("Geometry_GetPosition", "ll")
    @@lowDLL.import("Geometry_GetRotation", "lll")
    @@lowDLL.import("Geometry_GetScale", "ll")
    @@lowDLL.import("Geometry_GetUserData", "lp")
    @@lowDLL.import("Geometry_Release", "l")
    @@lowDLL.import("Geometry_Save", "lll")
    @@lowDLL.import("Geometry_SetActive", "ll")
    @@lowDLL.import("Geometry_SetPolygonAttributes", "lllll")
    @@lowDLL.import("Geometry_SetPolygonVertex", "llll")
    @@lowDLL.import("Geometry_SetPosition", "ll")
    @@lowDLL.import("Geometry_SetRotation", "lll")
    @@lowDLL.import("Geometry_SetScale", "ll")
    @@lowDLL.import("Geometry_SetUserData", "ll")
    
    # Reverb3D
    @@lowDLL.import("Reverb3D_Get3DAttributes", "llll")
    @@lowDLL.import("Reverb3D_GetActive", "ll")
    @@lowDLL.import("Reverb3D_GetProperties", "ll")
    @@lowDLL.import("Reverb3D_GetUserData", "lp")
    @@lowDLL.import("Reverb3D_Release", "l")
    @@lowDLL.import("Reverb3D_Set3DAttributes", "llll")
    @@lowDLL.import("Reverb3D_SetActive", "ll")
    @@lowDLL.import("Reverb3D_SetProperties", "ll")
    @@lowDLL.import("Reverb3D_SetUserData", "ll")
    
    # Debugging functions
    # @@lowDLL.import("Debug_Initialize", "llll")
    # @@lowDLL.import("File_GetDiskBusy", "l")
    # @@lowDLL.import("File_SetDiskBusy", "l")
    # @@lowDLL.import("Memory_GetStats", "lll")
    # @@lowDLL.import("Memory_Initialize", "llllll")
  end
  
  #--------------------------------------------------------------------------
  # * Load the LowLevel API functions
  #--------------------------------------------------------------------------
  def loadStudioDLL()
    # System
    @@studioDLL.import("Studio_System_Create",                            "pl")
    @@studioDLL.import("Studio_System_FlushCommands",                     "l")
    @@studioDLL.import("Studio_System_FlushSampleLoading",                "l")
    @@studioDLL.import("Studio_System_GetAdvancedSettings",               "lp")
    @@studioDLL.import("Studio_System_GetBank",                           "lpp")
    @@studioDLL.import("Studio_System_GetBankByID",                       "lpp")
    @@studioDLL.import("Studio_System_GetBankCount",                      "lp")
    @@studioDLL.import("Studio_System_GetBankList",                       "lplp")
    @@studioDLL.import("Studio_System_GetBufferUsage",                    "lp")
    @@studioDLL.import("Studio_System_GetBus",                            "lpp")
    @@studioDLL.import("Studio_System_GetBusByID",                        "lpp")
    @@studioDLL.import("Studio_System_GetCPUUsage",                       "lp")
    @@studioDLL.import("Studio_System_GetEvent",                          "lpp")
    @@studioDLL.import("Studio_System_GetEventByID",                      "lpp")
    @@studioDLL.import("Studio_System_GetListenerAttributes",             "llp")
    @@studioDLL.import("Studio_System_GetListenerWeight",                 "llp")
    @@studioDLL.import("Studio_System_GetLowLevelSystem",                 "lp")
    @@studioDLL.import("Studio_System_GetNumListeners",                   "lp")
    @@studioDLL.import("Studio_System_GetSoundInfo",                      "lpp")
    @@studioDLL.import("Studio_System_GetUserData",                       "lp")
    @@studioDLL.import("Studio_System_GetVCA",                            "lpp")
    @@studioDLL.import("Studio_System_GetVCAByID",                        "lpp")
    @@studioDLL.import("Studio_System_Initialize",                        "llllp")
    @@studioDLL.import("Studio_System_LoadBankCustom",                    "lplp")
    @@studioDLL.import("Studio_System_LoadBankFile",                      "lplp")
    @@studioDLL.import("Studio_System_LoadBankMemory",                    "lplllp")
    @@studioDLL.import("Studio_System_LoadCommandReplay",                 "lpl")
    @@studioDLL.import("Studio_System_LookupID",                          "lpp")
    @@studioDLL.import("Studio_System_LookupPath",                        "lpplp")
    @@studioDLL.import("Studio_System_RegisterPlugin",                    "lp")
    @@studioDLL.import("Studio_System_Release",                           "l")
    @@studioDLL.import("Studio_System_ResetBufferUsage",                  "l")
    @@studioDLL.import("Studio_System_SetAdvancedSettings",               "lp")
    @@studioDLL.import("Studio_System_SetCallback",                       "lll")
    @@studioDLL.import("Studio_System_SetListenerAttributes",             "llp")
    @@studioDLL.import("Studio_System_SetListenerWeight",                 "llp")
    @@studioDLL.import("Studio_System_SetNumListeners",                   "ll")
    @@studioDLL.import("Studio_System_SetUserData",                       "lp")
    @@studioDLL.import("Studio_System_StartCommandCapture",               "lpl")
    @@studioDLL.import("Studio_System_StopCommandCapture",                "l")
    @@studioDLL.import("Studio_System_UnloadAll",                         "l")
    @@studioDLL.import("Studio_System_UnregisterPlugin",                  "lp")
    @@studioDLL.import("Studio_System_Update",                            "l")
    
    # EventDescription
    @@studioDLL.import("Studio_EventDescription_CreateInstance",          "pp")
    @@studioDLL.import("Studio_EventDescription_GetID",                   "lp")
    @@studioDLL.import("Studio_EventDescription_GetInstanceCount",        "lp")
    @@studioDLL.import("Studio_EventDescription_GetInstanceList",         "lplp")
    @@studioDLL.import("Studio_EventDescription_GetLength",               "lp")
    @@studioDLL.import("Studio_EventDescription_GetMaximumDistance",      "lp")
    @@studioDLL.import("Studio_EventDescription_GetMinimumDistance",      "lp")
    @@studioDLL.import("Studio_EventDescription_GetParameter",            "lpp")
    @@studioDLL.import("Studio_EventDescription_GetParameterByIndex",     "llp")
    @@studioDLL.import("Studio_EventDescription_GetParameterCount",       "lp")
    @@studioDLL.import("Studio_EventDescription_GetPath",                 "lplp")
    @@studioDLL.import("Studio_EventDescription_GetSampleLoadingState",   "lp")
    @@studioDLL.import("Studio_EventDescription_GetSoundSize",            "lp")
    @@studioDLL.import("Studio_EventDescription_GetUserData",             "lp")
    @@studioDLL.import("Studio_EventDescription_GetUserProperty",         "lpp")
    @@studioDLL.import("Studio_EventDescription_GetUserPropertyByIndex",  "llp")
    @@studioDLL.import("Studio_EventDescription_GetUserPropertyCount",    "lp")
    @@studioDLL.import("Studio_EventDescription_HasCue",                  "lp")
    @@studioDLL.import("Studio_EventDescription_Is3D",                    "lp")
    @@studioDLL.import("Studio_EventDescription_IsOneshot",               "lp")
    @@studioDLL.import("Studio_EventDescription_IsSnapshot",              "lp")
    @@studioDLL.import("Studio_EventDescription_IsStream",                "lp")
    @@studioDLL.import("Studio_EventDescription_LoadSampleData",          "l")
    @@studioDLL.import("Studio_EventDescription_ReleaseAllInstances",     "l")
    @@studioDLL.import("Studio_EventDescription_SetCallback",             "lll")
    @@studioDLL.import("Studio_EventDescription_SetUserData",             "lp")
    @@studioDLL.import("Studio_EventDescription_UnloadSampleData",        "l")
    
    # EventInstance
    @@studioDLL.import("Studio_EventInstance_Get3DAttributes",            "lp")
    @@studioDLL.import("Studio_EventInstance_GetChannelGroup",            "lp")
    @@studioDLL.import("Studio_EventInstance_GetDescription",             "lp")
    @@studioDLL.import("Studio_EventInstance_GetListenerMask",            "lp")
    @@studioDLL.import("Studio_EventInstance_GetParameter",               "lpp")
    @@studioDLL.import("Studio_EventInstance_GetParameterByIndex",        "llp")
    @@studioDLL.import("Studio_EventInstance_GetParameterCount",          "lp")
    @@studioDLL.import("Studio_EventInstance_GetParameterValue",          "lppp")
    @@studioDLL.import("Studio_EventInstance_GetParameterValueByIndex",   "llpp")
    @@studioDLL.import("Studio_EventInstance_GetPaused",                  "lp")
    @@studioDLL.import("Studio_EventInstance_GetPitch",                   "lpp")
    @@studioDLL.import("Studio_EventInstance_GetPlaybackState",           "lp")
    @@studioDLL.import("Studio_EventInstance_GetProperty",                "llp")
    @@studioDLL.import("Studio_EventInstance_GetReverbLevel",             "llp")
    @@studioDLL.import("Studio_EventInstance_GetTimelinePosition",        "lp")
    @@studioDLL.import("Studio_EventInstance_GetUserData",                "lp")
    @@studioDLL.import("Studio_EventInstance_GetVolume",                  "lpp")
    @@studioDLL.import("Studio_EventInstance_IsVirtual",                  "lp")
    @@studioDLL.import("Studio_EventInstance_Release",                    "l")
    @@studioDLL.import("Studio_EventInstance_Set3DAttributes",            "lp")
    @@studioDLL.import("Studio_EventInstance_SetCallback",                "lll")
    @@studioDLL.import("Studio_EventInstance_SetListenerMask",            "ll")
    @@studioDLL.import("Studio_EventInstance_SetParameterValue",          "lpp")
    @@studioDLL.import("Studio_EventInstance_SetParameterValueByIndex",   "lll")
    @@studioDLL.import("Studio_EventInstance_SetParameterValuesByIndices","lppl")
    @@studioDLL.import("Studio_EventInstance_SetPaused",                  "ll")
    @@studioDLL.import("Studio_EventInstance_SetPitch",                   "ll")
    @@studioDLL.import("Studio_EventInstance_SetProperty",                "lll")
    @@studioDLL.import("Studio_EventInstance_SetReverbLevel",             "lll")
    @@studioDLL.import("Studio_EventInstance_SetTimelinePosition",        "ll")
    @@studioDLL.import("Studio_EventInstance_SetUserData",                "lp")
    @@studioDLL.import("Studio_EventInstance_SetVolume",                  "ll")
    @@studioDLL.import("Studio_EventInstance_Start",                      "l")
    @@studioDLL.import("Studio_EventInstance_Stop",                       "ll")
    @@studioDLL.import("Studio_EventInstance_TriggerCue",                 "l")
    
    # ParameterInstance
    @@studioDLL.import("Studio_ParameterInstance_GetDescription",         "lp")
    @@studioDLL.import("Studio_ParameterInstance_GetValue",               "lp")
    @@studioDLL.import("Studio_ParameterInstance_SetValue",               "ll")
    
    # Bus
    @@studioDLL.import("Studio_Bus_GetChannelGroup",                      "lp")
    @@studioDLL.import("Studio_Bus_GetID",                                "lp")
    @@studioDLL.import("Studio_Bus_GetMute",                              "lp")
    @@studioDLL.import("Studio_Bus_GetPath",                              "lplp")
    @@studioDLL.import("Studio_Bus_GetPaused",                            "lp")
    @@studioDLL.import("Studio_Bus_GetVolume",                            "lpp")
    @@studioDLL.import("Studio_Bus_LockChannelGroup",                     "l")
    @@studioDLL.import("Studio_Bus_SetMute",                              "ll")
    @@studioDLL.import("Studio_Bus_SetPaused",                            "ll")
    @@studioDLL.import("Studio_Bus_SetVolume",                            "ll")
    @@studioDLL.import("Studio_Bus_StopAllEvents",                        "ll")
    @@studioDLL.import("Studio_Bus_UnlockChannelGroup",                   "l")
    
    # VCA
    @@studioDLL.import("Studio_VCA_GetID",                                "lp")
    @@studioDLL.import("Studio_VCA_GetPath",                              "lplp")
    @@studioDLL.import("Studio_VCA_GetVolume",                            "lpp")
    @@studioDLL.import("Studio_VCA_SetVolume",                            "ll")
    
    # Bank
    @@studioDLL.import("Studio_Bank_GetBusCount",                         "lp")
    @@studioDLL.import("Studio_Bank_GetBusList",                          "lplp")
    @@studioDLL.import("Studio_Bank_GetEventCount",                       "lp")
    @@studioDLL.import("Studio_Bank_GetEventList",                        "lplp")
    @@studioDLL.import("Studio_Bank_GetID",                               "lp")
    @@studioDLL.import("Studio_Bank_GetLoadingState",                     "lp")
    @@studioDLL.import("Studio_Bank_GetPath",                             "lplp")
    @@studioDLL.import("Studio_Bank_GetSampleLoadingState",               "lp")
    @@studioDLL.import("Studio_Bank_GetStringCount",                      "lp")
    @@studioDLL.import("Studio_Bank_GetStringInfo",                       "llpplp")
    @@studioDLL.import("Studio_Bank_GetUserData",                         "lp")
    @@studioDLL.import("Studio_Bank_GetVCACount",                         "lp")
    @@studioDLL.import("Studio_Bank_GetVCAList",                          "lplp")
    @@studioDLL.import("Studio_Bank_LoadSampleData",                      "l")
    @@studioDLL.import("Studio_Bank_SetUserData",                         "lp")
    @@studioDLL.import("Studio_Bank_Unload",                              "l")
    @@studioDLL.import("Studio_Bank_UnloadSampleData",                    "l")
    
    # CommandReplay
    @@studioDLL.import("Studio_CommandReplay_GetCommandAtTime",           "llp")
    @@studioDLL.import("Studio_CommandReplay_GetCommandCount",            "lp")
    @@studioDLL.import("Studio_CommandReplay_GetCommandInfo",             "llp")
    @@studioDLL.import("Studio_CommandReplay_GetCommandString",           "llpl")
    @@studioDLL.import("Studio_CommandReplay_GetCurrentCommand",          "lpp")
    @@studioDLL.import("Studio_CommandReplay_GetLength",                  "lp")
    @@studioDLL.import("Studio_CommandReplay_GetPaused",                  "lp")
    @@studioDLL.import("Studio_CommandReplay_GetPlaybackState",           "lp")
    @@studioDLL.import("Studio_CommandReplay_GetSystem",                  "lp")
    @@studioDLL.import("Studio_CommandReplay_GetUserData",                "lp")
    @@studioDLL.import("Studio_CommandReplay_Release",                    "l")
    @@studioDLL.import("Studio_CommandReplay_SeekToCommand",              "ll")
    @@studioDLL.import("Studio_CommandReplay_SeekToTime",                 "ll")
    @@studioDLL.import("Studio_CommandReplay_SetBankPath",                "lp")
    @@studioDLL.import("Studio_CommandReplay_SetCreateInstanceCallback",  "ll")
    @@studioDLL.import("Studio_CommandReplay_SetFrameCallback",           "ll")
    @@studioDLL.import("Studio_CommandReplay_SetLoadBankCallback",        "ll")
    @@studioDLL.import("Studio_CommandReplay_SetPaused",                  "ll")
    @@studioDLL.import("Studio_CommandReplay_SetUserData",                "lp")
    @@studioDLL.import("Studio_CommandReplay_Start",                      "l")
    @@studioDLL.import("Studio_CommandReplay_Stop",                       "l")
    
    # Debugging Function?
    # @@studioDLL.import("Studio_ParseID", "")
  end
  
  def self.lowDLL()
    @@lowDLL
  end
  def self.studioDLL()
    @@studioDLL
  end
  
  #============================================================================
  # ** DLL
  #----------------------------------------------------------------------------
  #  A class that manages importing functions from the DLL
  #============================================================================
  class DLL
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_accessor :filename           # DLL file name for instance    
    attr_accessor :functions          # hash of functions imported (by name)
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     filename  : Name of the DLL
    #--------------------------------------------------------------------------
    def initialize(filename = 'System/fmod.dll')
      @filename = filename
      @functions = {}
      @handle = 0            # Handle to the DLL
      # Load specified library into the address space of game process
      w32_LL = Win32API.new('kernel32.dll', 'LoadLibrary', 'p', 'l')
      @handle = w32_LL.call(filename)
    end
    #--------------------------------------------------------------------------
    # * Create a Win32API Object And Add it to Hashtable
    #     name      : Function name
    #     args      : Argument types (p = pointer, l = int, v = void)
    #     returnType: Type of value returned by function
    #--------------------------------------------------------------------------
    def import(name, args = '', returnType = 'l')
      @functions[name] = Win32API.new(@filename, 'FMOD_' + name, args, returnType)
    end
    #--------------------------------------------------------------------------
    # * Get Function by Name
    #     key       : Function name
    #--------------------------------------------------------------------------
    def [](key)
      return @@functions[key]
    end
    #--------------------------------------------------------------------------
    # * Call a Function With Passed Arguments
    #     name      : Function name
    #     args      : Argument to function
    #--------------------------------------------------------------------------
    def invoke(name, *args)
      fn = @functions[name]
      raise "function not imported: #{name}" if fn.nil?
      # p [name] + args
      result = fn.call(*args)
      
      result = FMod::RESULT[result]
      # p [name,result]
      unless result == :OK
        raise "FMod Exception: #{result} when calling #{name}"
      end
      return FMod::RESULT.index result
    end
    #--------------------------------------------------------------------------
    # * Store Float as Binary Int Because Floats Can't be Passed Directly
    #     f         : Float to convert
    #--------------------------------------------------------------------------
    def self.convertFloat(f)
      # First pack the float in a string as a native binary float
      temp = [f].pack('f')
      # Then unpack the native binary float as an integer
      return unpackInt(temp)
    end
    #--------------------------------------------------------------------------
    # * Unpack Binary Data to Integer
    #     s         : String containing binary data
    #--------------------------------------------------------------------------
    def self.unpackInt(s)
      return s.unpack('l')[0]
    end
    #--------------------------------------------------------------------------
    # * Unpack Binary Data to Float
    #     s         : String containing binary data
    #--------------------------------------------------------------------------
    def self.unpackFloat(s)
      return s.unpack('f')[0]
    end
    #--------------------------------------------------------------------------
    # * Unpack Binary Data to Boolean
    #     s         : String containing binary data
    #--------------------------------------------------------------------------
    def self.unpackBool(s)
      return s.unpack('l')[0] != 0
    end
  end
  
  class System
    attr_reader :handle
    def initialize(handle)
      @dll = FMod.lowDLL()
      @handle = handle
    end
    def setSoftwareFormat(samplerate = 0, speakermode = FMOD::SPEAKERMODE_DEFAULT, numrawspeaker = 0)
      @dll.invoke("System_SetSoftwareFormat", @handle, samplerate, speakermode, numrawspeaker)
    end
  end
  
  #============================================================================
  # ** Studio
  #----------------------------------------------------------------------------
  #  A module containing all the Studio API functions and gizmos
  #============================================================================
  module Studio
    # COMMANDCAPTURE_FLAGS
    COMMANDCAPTURE_NORMAL = 0x00000000
    COMMANDCAPTURE_FILEFLUSH = 0x00000001
    COMMANDCAPTURE_SKIP_INITIAL_STATE = 0x00000002
    
    # COMMANDREPLAY_FLAGS
    COMMANDREPLAY_NORMAL = 0x00000000
    COMMANDREPLAY_SKIP_CLEANUP = 0x00000001
    COMMANDREPLAY_FAST_FORWARD = 0x00000002

    # EVENT_CALLBACK_TYPE
    EVENT_CALLBACK_CREATED = 0x00000001
    EVENT_CALLBACK_DESTROYED = 0x00000002
    EVENT_CALLBACK_STARTING = 0x00000004
    EVENT_CALLBACK_STARTED = 0x00000008
    EVENT_CALLBACK_RESTARTED = 0x00000010
    EVENT_CALLBACK_STOPPED = 0x00000020
    EVENT_CALLBACK_START_FAILED = 0x00000040
    EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND = 0x00000080
    EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND = 0x00000100
    EVENT_CALLBACK_PLUGIN_CREATED = 0x00000200
    EVENT_CALLBACK_PLUGIN_DESTROYED = 0x00000400
    EVENT_CALLBACK_TIMELINE_MARKER = 0x00000800
    EVENT_CALLBACK_TIMELINE_BEAT = 0x00001000
    EVENT_CALLBACK_SOUND_PLAYED = 0x00002000
    EVENT_CALLBACK_SOUND_STOPPED = 0x00004000
    EVENT_CALLBACK_ALL = 0xFFFFFFFF

    # INITFLAGS
    INIT_NORMAL = 0x00000000
    INIT_LIVEUPDATE = 0x00000001
    INIT_ALLOW_MISSING_PLUGINS = 0x00000002
    INIT_SYNCHRONOUS_UPDATE = 0x00000004
    INIT_DEFERRED_CALLBACKS = 0x00000008
    INIT_LOAD_FROM_UPDATE = 0x00000010
    
    # LOAD_BANK_FLAGS
    LOAD_BANK_NORMAL = 0x00000000
    LOAD_BANK_NONBLOCKING = 0x00000001
    LOAD_BANK_DECOMPRESS_SAMPLES = 0x00000002

    # LOAD_MEMORY_ALIGNMENT
    LOAD_MEMORY_ALIGNMENT = 32

    # SYSTEM_CALLBACK_TYPE
    SYSTEM_CALLBACK_PREUPDATE = 0x00000001
    SYSTEM_CALLBACK_POSTUPDATE = 0x00000002
    SYSTEM_CALLBACK_BANK_UNLOAD = 0x00000004
    SYSTEM_CALLBACK_ALL = 0xFFFFFFFF
    
    # Structs
    ADVANCEDSETTINGS = Struct.new(
      :cbsize,
      :commandqueuesize,
      :handleinitialsize,
      :studioupdateperiod,
      :idlesampledatapoolsize,
    )
    BANK_INFO = Struct.new(
      :size,
      :userdata,
      :userdatalength,
      :opencallback,
      :closecallback,
      :readcallback,
      :seekcallback,
    )
    BUFFER_INFO = Struct.new(
      :currentusage,
      :peakusage,
      :capacity,
      :stallcount,
      :stalltime,
    )
    BUFFER_USAGE = Struct.new(
      :studiocommandqueue,
      :studiohandle,
    )
    COMMAND_INFO = Struct.new(
      :commandname,
      :parentcommandindex,
      :framenumber,
      :frametime,
      :instancetype,
      :outputtype,
      :instancehandle,
      :outputhandle,
    )
    CPU_USAGE = Struct.new(
      :dspusage,
      :streamusage,
      :geometryusage,
      :updateusage,
      :studiousage,
    )
    PARAMETER_DESCRIPTION = Struct.new(
      :name,
      :index,
      :minimum,
      :maximum,
      :defaultvalue,
      :type,
    )
    PLUGIN_INSTANCE_PROPERTIES = Struct.new(
      :name,
      :dsp,
    )
    PROGRAMMER_SOUND_PROPERTIES = Struct. new(
      :name,
      :sound,
      :subsoundIndex,
    )
    SOUND_INFO = Struct.new(
      :name_or_data,
      :mode,
      :exinfo,
      :subsoundindex,
    )
    TIMELINE_BEAT_PROPERTIES = Struct.new(
      :bar,
      :beat,
      :position,
      :tempo,
      :timesignatureupper,
      :timesignaturelower,
    )
    TIMELINE_MARKER_PROPERTIES  = Struct.new(
      :name,
      :position,
    )
    USER_PROPERTY = Struct.new(
      :name,
      :type,
      :intvalue,
      :boolvalue,
      :floatvalue,
      :stringvalue,
    )
    
    
    class System
      attr_reader :handle, :loaded
      def initialize(handle, maxchannels = 100, 
                     studioflags = INIT_NORMAL,
                     flags = FMod::INIT_NORMAL, extradriverdata = 0)
        @dll = FMod.studioDLL()
        @handle = handle
        self.getLowLevelSystem().setSoftwareFormat(0, FMod::SPEAKERMODE_5POINT1, 0)
        @dll.invoke("Studio_System_Initialize", @handle, maxchannels, studioflags, flags, extradriverdata)
        @loaded = true
      end
      def self.create()
        handle = 0.chr * 4
        headerVersion = 0x00011007
        FMod.studioDLL.invoke("Studio_System_Create", handle, headerVersion)
        return handle.unpack("i")[0]
      end
      def update()
        @dll.invoke("Studio_System_Update", @handle)
      end
      def release()
        @dll.invoke("Studio_System_Release", @handle)
        @loaded = false
      end
      def flushCommands()
        @dll.invoke("Studio_System_FlushCommands", @handle)
      end
      def flushSampleLoading()
        @dll.invoke("Studio_System_FlushSampleLoading", @handle)
      end
      def getAdvancedSettings()
        settings = [20,0,0,0,0]
        temp = settings.pack("iIIii")
        @dll.invoke("Studio_System_GetAdvancedSettings", @handle, temp)
        return ADVANCEDSETTINGS.new(*temp.unpack("iIIii"))
      end
      def getBank(path)
        bank = 0.chr*4
        @dll.invoke("Studio_System_GetBank", @handle, path, bank)
        bank = bank.unpack("i")[0]
        return Bank.new(bank)
      end
      def getBankByID(guid)
        id = guid.to_a.pack("ISSP")
        bank = 0.chr*4
        @dll.invoke("Studio_System_GetBankByID", @handle, id, bank)
        bank = bank.unpack("i")[0]
        return Bank.new(bank)
      end
      def getBankCount()
        temp = [0].pack("i")
        @dll.invoke("Studio_System_GetBankCount", @handle, temp)
        return temp.unpack("i")[0]
      end
      def getBankList() ####### NEEDS TESTING! #######
        capacity = getBankCount()
        list = [0.chr*4*capacity].pack("P")
        count = 0.chr*4
        @dll.invoke("Studio_System_GetBankList", @handle, list, capacity, count)
        count = count.unpack("i")[0]
        banks = list.unpack("P")[0].unpack("a4"*count)
        banks.map! do |h|
          handle = h.unpack("i")[0]
          Bank.new(handle)
        end
        return banks
      end
      def getBufferUsage()
        temp = 0.chr*8
        @dll.invoke("Studio_System_GetBufferUsage", @handle, temp)
        usage = temp.unpack("P"*2).map! do |info|
          BUFFER_INFO.new(*info.unpack("iiiif"))
        end
        return BUFFER_USAGE.new(*usage)
      end
      def getBus(path)
        bus = 0.chr*4
        @dll.invoke("Studio_System_GetBus", @handle, path, bus)
        bus = bus.unpack("i")[0]
        return Bus.new(bus.unpack("P")[0])
      end
      def getBusByID(guid)
        id = guid.to_a.pack("ISSP")
        bus = 0.chr*4
        @dll.invoke("Studio_System_GetBus", @handle, id, bus)
        bus = bus.unpack("i")[0]
        return Bus.new(bus.unpack("P")[0])
      end
      def getCPUUsage()
        temp = 0.chr*8
        @dll.invoke("Studio_System_GetCPUUsage", @handle, temp)
        usage = temp.unpack("P"*2).map! do |cpuinfo|
          cpuinfo.unpack("f"*5)
        end
        return CPU_USAGE.new(*usage)
      end
      def getEvent(path)
        event = 0.chr*4
        @dll.invoke("Studio_System_GetEvent", @handle, path, event)
        return EventDescription.new(event.unpack("i")[0])
      end
      def getEventByID(guid)
        id = guid.to_a.pack("ISSP")
        event = 0.chr*4
        @dll.invoke("Studio_System_GetEventByID", @handle, id, event)
        return EventDescription.new(event.unpack("i")[0])
      end
      def getListenerAtributes(listener)
        temp = 0.chr*4*3*4 # 4 vectors x 3 coordinates x 4 bytes each coord
        @dll.invoke("Studio_System_GetListenerAttributes", @handle, listener, temp)
        attributes = temp.unpack("a12"*4) # The size of VECTOR struct is 12 bytes
        attributes.map! do |v|
          FMod::VECTOR.new(*v.unpack("fff"))
        end
        return FMod::FMOD_3D_ATTRIBUTES.new(*attributes)
      end
      def getListenerWeight(listener)
        weight = 0.chr*4
        @dll.invoke("Studio_System_GetListenerWeight", @handle, listener, weight)
        return weight.unpack("f")[0]
      end
      def getLowLevelSystem()
        lowsystem = 0.chr*4
        @dll.invoke("Studio_System_GetLowLevelSystem", @handle, lowsystem)
        return FMod::System.new(lowsystem.unpack("i")[0]) # Won't dig into this class
      end
      def getNumListeners()
        numlisteners = 0.chr*4
        @dll.invoke("Studio_System_GetNumListeners", @handle, numlisteners)
        return numlisteners.unpack("i")[0]
      end
      def getSoundInfo(key)
        info = 0.chr*4*4
        @dll.invoke("Studio_System_GetSoundInfo", @handle, key, info)
        info = info.unpack("PPPi")
        info[1] = info[1].unpack("i")[0]
        info[2] = FMod::CREATESOUNDEXINFO.new(*info[2].unpack("iIIiiiIiiiiiiiPPiiiiiiiiiiiiiiIiiIIii"))
        return SOUND_INFO.new(*info)
      end
      def getUserData()
        userdata = 0.chr*4
        @dll.invoke("Studio_System_GetUserData", @handle, userdata)
        return userdata.unpack("P")[0]
      end
      def getVCA(path)
        vca = 0.chr*4
        @dll.invoke("Studio_System_GetVCA", @handle, path, vca)
        return VCA.new(vca.unpack("i")[0])
      end
      def getVCAByID(guid)
        id = guid.to_a.pack("ISSP")
        vca = 0.chr*4
        @dll.invoke("Studio_System_GetVCA", @handle, id, vca)
        return VCA.new(vca.unpack("i")[0])
      end
      def loadBankCustom(info, flags = LOAD_BANK_NORMAL)
        info = info.to_a
        info[0] = 4*7
        info = info.pack("i"*7)
        bank = (0.chr*4).pack("P")
        @dll.invoke("Studio_System_LoadBankCustom", @handle, info, flags, bank)
        return Bank.new(bank.unpack("P")[0])
      end
      def loadBankFile(filename, flags = LOAD_BANK_NORMAL)
        filename = "./Audio/Banks/Desktop/" + filename
        bank_handle = [0.chr*4].pack("P")
        @dll.invoke("Studio_System_LoadBankFile", @handle, filename, flags, bank_handle)
        return Bank.new(bank_handle.unpack("i")[0])
      end
      def loadBankMemory(buffer, flags = LOAD_BANK_NORMAL)
        length = buffer.length
        mode = 0
        bank_handle = (0.chr*4).pack("P")
        @dll.invoke("Studio_System_LoadBankMemory", @handle, buffer, length, mode, flags, bank_handle)
        return Bank.new(bank_handle.unpack("P")[0])
      end
      def loadCommandReplay(path, flags = COMMANDREPLAY_NORMAL)
        replay = 0.chr*4
        @dll.invoke("Studio_System_LoadCommandReplay", @handle, path, flags, replay)
        return CommandReplay.new(replay.unpack("P")[0])
      end
      def lookupID(path)
        id = [0,0,0,0.chr*8].pack("ISSP")
        @dll.invoke("Studio_System_LookupID", @handle, path, id)
        return FMod::GUID.new(*id.unpack("ISSP"))
      end
      def resetBufferUsage()
        @dll.invoke("Studio_System_ResetBufferUsage", @handle)
      end
      def setAdvancedSettings(settings)
        settings = settings.to_a.pack("iIIii")
        @dll.invoke("Studio_System_SetAdvancedSettings", @handle, settings)
      end
      def setCallback(callback, callbackmask)
        callback = callback.to_a.pack("PPPP")
        @dll.invoke("Studio_System_SetCallback", @handle, callback, callbackmask)
      end
      def setListenerAttributes(listener, attributes)
        attributes = attributes.to_a
        # p attributes
        attributes.map! do |vector|
          vector.to_a.pack("fff")
        end
        attributes = attributes.join
        @dll.invoke("Studio_System_SetListenerAttributes", @handle, listener, attributes)
      end
      def setListenerWeight(listener, weight)
        weight = [weight].pack("f")
        @dll.invoke("Studio_System_SetListenerWeight", @handle, listener, weight)
      end
      def setNumListeners(numlisteners)
        @dll.invoke("Studio_System_SetNumListeners", @handle, numlisteners)
      end
      def startCommandCapture(path, flags = COMMANDCAPTURE_NORMAL)
        @dll.invoke("Studio_System_StartCommandCapture", @handle, path, flags)
      end
      def stopCommandCapture()
        @dll.invoke("Studio_System_StopCommandCapture", @handle)
      end
      def unloadAll()
        @dll.invoke("Studio_System_UnloadAll", @handle)
      end
    end # System
    class EventDescription; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
      def createInstance()
        instance = 0.chr*4
        @dll.invoke("Studio_EventDescription_CreateInstance", @handle, instance)
        instance = instance.unpack("i")[0]
        return EventInstance.new(instance)
      end
      def getID()
        id = [0,0,0,0.chr*8].pack("ISSP")
        @dll.invoke("Studio_EventDescription_GetID", @handle, id)
        return GUID.new(*id.unpack("ISSP"))
      end
      def getInstanceCount()
        count = 0.chr*4
        @dll.invoke("Studio_Bank_GetInstanceCount", @handle, count)
        return count.unpack("i")[0]
      end
      def getInstanceList()
        count = 0.chr*4
        capacity = getBusCount()
        array = 0.chr*4*capacity
        @dll.invoke("Studio_Bank_GetInstanceList", @handle, array, capacity, count)
        count = count.unpack("i")[0]
        array = array.unpack("P"*count)
        array.map! do |ev|
          EventInstance.new(ev.unpack("i")[0])
        end
        return array
      end
      def getLength()
        length = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetLength", @handle, length)
        return length.unpack("i")[0]
      end
      def getMaximumDistance()
        distance = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetMaximumDistance", @handle, distance)
        return distance.unpack("f")[0]
      end
      def getMinimumDistance()
        distance = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetMinimumDistance", @handle, distance)
        return distance.unpack("f")[0]
      end
      def getParameter(name)
        parameter = [nil].pack("P")
        @dll.invoke("Studio_EventDescription_GetParameter", @handle, name, parameter)
        parameter = PARAMETER_DESCRIPTION.new(*parameter.unpack("PifffP"))
        return parameter
      end
      def getParameterByIndex(index)
        parameter = [nil].pack("P")
        @dll.invoke("Studio_EventDescription_GetParameterByIndex", @handle, index, parameter)
        parameter = PARAMETER_DESCRIPTION.new(*parameter.unpack("PifffP"))
        return parameter
      end
      def getParameterCount()
        count = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetParameterCount", @handle, count)
        return count.unpack("i")[0]
      end
      def getPath()
        path = 0.chr*256
        size = 256
        retrieved = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetPath", @handle, path, size, retrieved)
        retrieved = retrieved.unpack("i")[0]
        return path[0,retrieved]
      end
      def getSampleLoadingState()
        state = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetSampleLoadingState", @handle, state)
        return state.unpack("i")[0]
      end
      def getSoundSize()
        size = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetSoundSize", @handle, size)
        return size.unpack("f")[0]
      end
      def getUserData()
        userData = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetUserData", @handle, userData)
        return userData.unpack("P")[0]
      end
      def getUserProperty(name)
        property = 0.chr*4*6
        @dll.invoke("Studio_EventDescription_GetUserProperty", @handle, name, property)
        property = property.unpack("PPiPfP")
        return USER_PROPERTY.new(*property)
      end
      def getUserPropertyByIndex(index)
        property = 0.chr*4*6
        @dll.invoke("Studio_EventDescription_GetUserPropertyByIndex", @handle, index, property)
        property = property.unpack("PPiPfP")
        return USER_PROPERTY.new(*property)
      end
      def getUserPropertyCount()
        count = 0.chr*4
        @dll.invoke("Studio_EventDescription_GetUserPropertyCount", @handle, count)
        return count.unpack("i")[0]
      end
      def hasCue()
        cue = 0.chr*4
        @dll.invoke("Studio_EventDescription_HasCue", @handle, cue)
        return cue.unpack("i")[0] == 1
      end
      def is3D()
        is3D = 0.chr*4
        @dll.invoke("Studio_EventDescription_Is3D", @handle, is3D)
        return is3D.unpack("i")[0] == 1
      end
      def isOneshot()
        oneshot = 0.chr*4
        @dll.invoke("Studio_EventDescription_IsOneshot", @handle, oneshot)
        return oneshot.unpack("i")[0] == 1
      end
      def isSnapshot()
        snapshot = 0.chr*4
        @dll.invoke("Studio_EventDescription_IsSnapshot", @handle, isSnapshot)
        return snapshot.unpack("i")[0] == 1
      end
      def isStream()
        isStream = 0.chr*4
        @dll.invoke("Studio_EventDescription_Is3D", @handle, isStream)
        return isStream.unpack("i")[0] == 1
      end
      def loadSampleData()
        @dll.invoke("Studio_EventDescription_LoadSampleData", @handle)
      end
      def releaseAllInstances()
        @dll.invoke("Studio_EventDescription_ReleaseAllInstances", @handle)
      end
      def unloadSampleData()
        @dll.invoke("Studio_EventDescription_UnloadSampleData", @handle)
      end
      
    end
    class EventInstance; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
      def get3DAttributes()
        attributes = 0.chr*4*4
        @dll.invoke("Studio_EventInstance_Get3DAttributes", @handle, attributes)
        attributes = attributes.unpack("PPPP")
        return FMOD_3D_ATTRIBUTES.new(*attributes)
      end
      def getChannelGroup()
        group = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetChannelGroup", @handle, group)
        return ChannelGroup.new(group.unpack("i")[0])
      end
      def getDescription()
        description = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetDescription", @handle, description)
        return EventDescription.new(description.unpack("i")[0])
      end
      def getListenerMask()
        mask = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetListenerMask", @handle, mask)
        return mask.unpack("I")[0]
      end
      def getParameter(name)
        parameter = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetParameter", @handle, name, parameter)
        return ParameterInstance.new(parameter.unpack("i")[0])
      end
      def getParameterByIndex(index)
        parameter = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetParameterByIndex", @handle, index, parameter)
        return ParameterInstance.new(parameter.unpack("i")[0])
      end
      def getParameterCount(count)
        count = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetParameterCount", @handle, count)
        return count.unpack("i")[0]
      end
      def getParameterValue(name)
        value = 0.chr*4
        finalvalue = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetParameterValue", @handle, name, value, finalvalue)
        return [value.unpack("f")[0], finalvalue.unpack("f")[0]]
      end
      def getParameterValueByIndex(index)
        value = 0.chr*4
        finalvalue = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetParameterValueByIndex", @handle, index, value, finalvalue)
        return [value.unpack("f")[0], finalvalue.unpack("f")[0]]
      end
      def getPaused()
        paused = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetPaused", @handle, paused)
        return paused.unpack("i")[0] == 1
      end
      def getPitch()
        pitch = 0.chr*4
        finalpitch = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetPitch", @handle, pitch, finalpitch)
        return [pitch.unpack("f")[0], finalpitch.unpack("f")[0]]
      end
      def getPlaybackState()
        state = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetPlaybackState", @handle, state)
        return state.unpack("i")[0]
      end
      def getProperty(index)
        value = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetProperty", @handle, index, value)
        return value.unpack("f")[0]
      end
      def getReverbLevel(index)
        level = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetReverbLevel", @handle, index, level)
        return level.unpack("f")[0]
      end
      def getTimelinePosition()
        position = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetTimelinePosition", @handle, position)
        return position.unpack("i")[0]
      end
      def getUserData()
        userData = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetUserData", @handle, userData)
        return userData.unpack("P")[0]
      end
      def getVolume()
        volume = 0.chr*4
        finalvolume = 0.chr*4
        @dll.invoke("Studio_EventInstance_GetVolume", @handle, volume, finalvolume)
        return [volume.unpack("f")[0], finalvolume.unpack("f")[0]]
      end
      def isVirtual()
        virtualState = 0.chr*4
        @dll.invoke("Studio_EventInstance_IsVirtual", @handle, virtualState)
        return virtualState.unpack("i")[0] == 1
      end
      def release()
        @dll.invoke("Studio_EventInstance_Release", @handle)
      end
      def set3DAttributes(attributes)
        attributes = attributes.to_a
        attributes.map! do |vector|
          vector.to_a.pack("fff")
        end
        attributes = attributes.join
        @dll.invoke("Studio_EventInstance_Set3DAttributes", @handle, attributes)
      end
      def setListenerMask(mask)
        @dll.invoke("Studio_EventInstance_SetListenerMask", @handle, mask)
      end
      def setParameterValue(name, value)
        value = [value].pack("f")
        @dll.invoke("Studio_EventInstance_SetParameterValue", @handle, name, value)
      end
      def setParameterValueByIndex(index, value)
        value = [value].pack("f")
        @dll.invoke("Studio_EventInstance_SetParameterValueByIndex", @handle, index, value)
      end
      def setParameterValueByIndices(indices, values)
        count = indices.length
        indices = indices.pack("i"*count)
        values = values.pack("f"*count)
        @dll.invoke("Studio_EventInstance_SetParameterValue", @handle, indices, values, count)
      end
      def setPaused(paused)
        @dll.invoke("Studio_EventInstance_SetPaused", @handle, (paused ? 1 : 0))
      end
      def setPitch(pitch)
        pitch = [pitch].pack("f")
        @dll.invoke("Studio_EventInstance_SetPitch", @handle, pitch)
      end
      def setProperty(index, value)
        value = [value].pack("f")
        @dll.invoke("Studio_EventInstance_SetProperty", @handle, index, value)
      end
      def setReverbLevel(index, level)
        level = [level].pack("f")
        @dll.invoke("Studio_EventInstance_SetReverbLevel", @handle, index, level)
      end
      def setTimelinePosition(position)
        @dll.invoke("Studio_EventInstance_SetTimelinePosition", @handle, position)
      end
      def setVolume(volume)
        volume = [volume].pack("f")
        @dll.invoke("Studio_EventInstance_SetVolume", @handle, volume)
      end
      def start()
        @dll.invoke("Studio_EventInstance_Start", @handle)
      end
      def stop(mode)
        @dll.invoke("Studio_EventInstance_Stop", @handle, mode)
      end
      def triggerCue()
        @dll.invoke("Studio_EventInstance_TriggerCue", @handle)
      end
    end
    class ParameterInstance; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
    end
    class Bus; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
    end
    class VCA; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
    end
    class Bank; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
      def getBusCount()
        count = 0.chr*4
        @dll.invoke("Studio_Bank_GetBusCount", @handle, count)
        return count.unpack("i")[0]
      end
      def getBusList()
        count = 0.chr*4
        capacity = getBusCount()
        array = 0.chr*4*capacity
        @dll.invoke("Studio_Bank_GetBusList", @handle, array, capacity, count)
        count = count.unpack("i")[0]
        array = array.unpack("P"*count)
        array.map! do |b|
          Bus.new(b.unpack("i")[0])
        end
        return array
      end
      def getEventCount()
        count = 0.chr*4
        @dll.invoke("Studio_Bank_GetEventCount", @handle, count)
        return count.unpack("i")[0]
      end
      def getEventList()
        count = 0.chr*4
        capacity = getEventCount()
        array = 0.chr*4*capacity
        @dll.invoke("Studio_Bank_GetEventList", @handle, array, capacity, count)
        count = count.unpack("i")[0]
        array = array.unpack("P"*count)
        array.map! do |ev|
          EventDescription.new(ev.unpack("i")[0])
        end
        return array
      end
      def getID()
        id = [0,0,0,0.chr*8].pack("ISSP")
        @dll.invoke("Studio_Bank_GetID", @handle, id)
        return GUID.new(*id.unpack("ISSP"))
      end
      def getLoadingState()
        state = 0.chr*4
        @dll.invoke("Studio_Bank_GetLoadingState", @handle, state)
        return state.unpack("i")[0]
      end
      def getPath()
        path = 0.chr*256
        size = 256
        retrieved = 0.chr*4
        @dll.invoke("Studio_Bank_GetPath", @handle, path, size, retrieved)
        retrieved = retrieved.unpack("i")[0]
        return path[0,retrieved]
      end
      def getSampleLoadingState()
        state = 0.chr*4
        @dll.invoke("Studio_Bank_GetSampleLoadingState", @handle, state)
        return state.unpack("i")[0]
      end
      def getStringCount()
        count = 0.chr*4
        @dll.invoke("Studio_Bank_GetStringCount", @handle, count)
        return count.unpack("i")[0]
      end
      def getStringInfo(index)
        id = [0,0,0,0.chr*8].pack("ISSP")
        path = 0.chr*256
        size = 256
        retrieved = 0.chr*4
        @dll.invoke("Studio_Bank_GetStringInfo", @handle, index, id, path, size, retrieved)
        retrieved = retrieved.unpack("i")[0]
        return [id.unpack("ISSP"), path[0,retrieved]]
      end
      def getUserData()
        userData = 0.chr*4
        @dll.invoke("Studio_Bank_GetUserData", @handle, userData)
        return userData.unpack("P")[0]
      end
      def getVCACount()
        count = 0.chr*4
        @dll.invoke("Studio_Bank_GetVCACount", @handle, count)
        return count.unpack("i")[0]
      end
      def getVCAList()
        count = 0.chr*4
        capacity = getVCACount()
        array = 0.chr*4*capacity
        @dll.invoke("Studio_Bank_GetVCAList", @handle, array, capacity, count)
        count = count.unpack("i")[0]
        array = array.unpack("P"*count)
        array.map! do |v|
          VCA.new(v.unpack("i")[0])
        end
        return array
      end
      def loadSampleData()
        @dll.invoke("Studio_Bank_LoadSampleData", @handle)
      end
      def setUserData(userData)
        @dll.invoke("Studio_Bank_SetUserData", @handle, userData)
      end
      def unload()
        @dll.invoke("Studio_Bank_Unload", @handle)
      end
      def unloadSampleData()
        @dll.invoke("Studio_Bank_UnloadSampleData", @handle)
      end
    end
    class CommandReplay; 
      attr_reader :handle
      def initialize(handle)
        @dll = FMod.studioDLL()
        @handle = handle
      end
    end
  end
end

$fmod = FMod.new()

# This makes sure FMod is updated every frame
class Scene_Base
  alias fmod_update update
  def update
    fmod_update
    sys = $fmod.system
    sys.update() if sys && sys.loaded()
  end
end

# Disposing of the FMod audio
class << SceneManager
  alias fmod_exit exit
  def exit
    fmod_exit
    $fmod.system.unloadAll()
    $fmod.system.release()
  end
end

# Setup FMod listener attributes
class Game_Player
  alias fmod_player_update update
  def update
    # Do normal game update
    fmod_player_update
    
    # Get position
    position = FMod::VECTOR.new(@real_x, @real_y, 0)
    
    # Calculate velocity
    vx,vy,vz = 0,0,0
    case @direction
    when 4 then vx = -distance_per_frame * 60
    when 6 then vx = distance_per_frame * 60
    when 8 then vy = -distance_per_frame * 60
    when 2 then vy = distance_per_frame * 60
    end if moving?
    velocity = FMod::VECTOR.new(vx, vy, vz)
    
    # Set 'forward' vector
    x,y,z = 0,-1,0
    forward = FMod::VECTOR.new(x,y,z)
    
    # Set constant 'up' vector
    up = FMod::VECTOR.new(0,0,1)
    
    # Update 3D listener attributes
    attributes = FMod::FMOD_3D_ATTRIBUTES.new(position, velocity, forward, up)
    $fmod.system.setListenerAttributes(0, attributes)
  end
end

class Game_Character
  attr_accessor :fmod_sounds, :is3D
  alias fmod_initialize initialize
  def initialize
    fmod_initialize
    @fmod_sounds = []
    @is3D = true
  end
  def position_vector
    FMod::VECTOR.new(real_x, real_y, 0)
  end
  
  def velocity_vector
    vx,vy,vz = 0,0,0
    case @direction
    when 4 then vx = -@event.distance_per_frame * 60
    when 6 then vx = @event.distance_per_frame * 60
    when 8 then vy = -@event.distance_per_frame * 60
    when 2 then vy = @event.distance_per_frame * 60
    end if @event.moving?
    return FMod::VECTOR.new(vx, vy, vz)
  end
  
  def forward_vector
    x,y,z = 0,0,0
    case @direction
    when 4 then x = -1
    when 6 then x = 1
    when 8 then y = -1
    when 2 then y = 1
    end
    return FMod::VECTOR.new(x,y,z)
  end
  
  def up_vector
    FMod::VECTOR.new(0,0,1)
  end
  
  alias fmod_update update
  def update
    fmod_update
    if !@fmod_sounds.empty? && @is3D then
      # Get 3D vector attributes
      position = position_vector
      velocity = velocity_vector
      forward = forward_vector
      up = up_vector
      # Update 3D listener attributes
      attributes = FMod::FMOD_3D_ATTRIBUTES.new(position, velocity, forward, up)
      @fmod_sounds.each do |sound|
        sound.set3DAttributes(attributes)
      end
    end
  end
end

