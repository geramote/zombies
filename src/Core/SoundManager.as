package  Core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
////	import flash.net.SharedObject;
	
	public class SoundManager extends EventDispatcher
	{
		
		public static const ON_SOUND_FINISHED: String = "ON_SOUND_FINISHED";
		
		// CONTROL
		private static var _instance:SoundManager;
		private static var _allowInstance:Boolean;
		
		private var _globalVolume:Number = .8;
		private var _musixVolume:Number = .6;
		private var _soundChannelMusic:SoundChannel;
		private var _soundCurrentMusic:Sound;
		private var _musicPos:Number;
		private var _musicPause:Boolean = false;
		private var _soundtransform:SoundTransform;
		private var _soundtransformMusic:SoundTransform;
		
		private var _musicEnabled:Boolean = true;
		
		private var sndMissing: Boolean = false;
		//saveload
		
		private static var soundLoaded:Boolean = false;
	////	private static var so:SharedObject = SharedObject.getLocal("TikislabBrainDrain1Sound");
		
		// singleton instance of SoundManager
		public static function get inst():SoundManager 
		{
			if (SoundManager._instance == null)
			{
				SoundManager._allowInstance = true;
				SoundManager._instance = new SoundManager();
				SoundManager._allowInstance = false;
			}
			
			return SoundManager._instance;
		}
		
		public function SoundManager()
		{
			_soundtransform = new SoundTransform(_globalVolume, 0);
			_soundtransformMusic = new SoundTransform(_musixVolume, 0);
				
			if (!SoundManager._allowInstance)
			{
				throw new Error("Error: Use SoundManager.inst() instead of the new keyword.");
			}
		}		
		//fx
		
		public function play(sndClass:Class, needLoop: Boolean = false):SoundChannel {
			if (sndMissing) {return null;}
			
			if (sndClass != null) {
				_soundCurrentMusic = new sndClass();
				_soundChannelMusic = _soundCurrentMusic.play(0, 0, _soundtransform);
				
				if (needLoop)
				{
					_soundChannelMusic.addEventListener(Event.SOUND_COMPLETE, handleMusicEnd, false, 0, true);
				}
				
				sndMissing = (_soundChannelMusic == null);
			} else {
				return null;
			}
			return _soundChannelMusic;
		}
		
		public function stopNow()
		{
			if (sndMissing) {return;}
			if (_soundChannelMusic == null) return;
			
			var soundtransform: SoundTransform = new SoundTransform(0, 0);
			_soundChannelMusic.soundTransform = soundtransform;
			
			_soundChannelMusic.stop();
			
			try {
				_soundCurrentMusic.close();
			} catch (e:Error) { }					
		}		

		//gettersetter
		public function get volume():Number {
			return _globalVolume;
		}
		
		public function set volume(value:Number) {
			
			if (value >= 0 && value <= 1) {
				_globalVolume = value;
				if (sndMissing) {return;}
				_soundtransform.volume = _globalVolume;				
			}
		}
		
		
		private function handleMusicEnd(e:Event) {
			dispatchEvent(new Event(ON_SOUND_FINISHED));
		}		

	}
	
}