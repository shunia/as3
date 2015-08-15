package me.shunia.smedia.core.audio
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import me.shunia.smedia.core.BaseMedia;
	
	public class AudioMedia extends BaseMedia
	{
		
		protected var _sound:Sound = null;
		protected var _soundTransform:SoundTransform = null;
		protected var _soundChannel:SoundChannel = null;
		
		public function AudioMedia()
		{
			super();
		}
		
		protected function startLoad():void {
			dispose();
			
			var req:URLRequest = new URLRequest();
			var context:SoundLoaderContext = new SoundLoaderContext(3, false);
			_sound = new Sound();
			_sound.addEventListener(Event.ID3, onID3);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_sound.addEventListener(Event.COMPLETE, onComplete);
			_sound.load(req, context);
			_soundTransform = new SoundTransform(100 / 100);
			_soundChannel = _sound.play(0, 1, _soundTransform);
			
			if (!_isPlaying) {
				pause();
			}
		}
		
		protected function onComplete(event:Event):void {
			trace("[audio]", "File loaded ->" + "");
		}
		
		protected function onProgress(event:ProgressEvent):void {
//			_info.bytesLoaded = event.bytesLoaded;
//			_info.bytesTotal = event.bytesTotal;
//			Debugger.log(Debugger.INFO, "[audio]", "File progress ->" + event.bytesLoaded / event.bytesTotal);
		}
		
		protected function onError(event:IOErrorEvent):void {
			trace("[audio]", "File load fail ->" + "");
		}
		
		protected function onID3(event:Event):void {
			trace("[audio]", "File ID3 info ok!");
		}
		
		override public function play():void {
			super.play();
			if (_sound) {
//				_sound.play(_info.timePlayed);
			}
		}
		
		override public function pause():void {
			super.pause();
			if (_soundChannel) {
//				_info.timePlayed = _soundChannel.position;
				_soundChannel.stop();
			}
		}
		
		public function set volume(value:int):void {
			if (_soundTransform) {
				_soundTransform.volume = value;
			}
			if (_soundChannel) {
				_soundChannel.soundTransform = _soundTransform;
			}
		}
		
		override public function dispose():void {
			if (_sound) {
				_sound.removeEventListener(Event.ID3, onID3);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				_sound.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				_sound.removeEventListener(Event.COMPLETE, onComplete);
				_sound.close();
				_sound = null;
			}
		}
		
	}
}