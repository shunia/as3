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
	
	import me.shunia.slib.context.Context;
	import me.shunia.slib.debug.LogLevel;
	import me.shunia.smedia.core.SBaseMedia;
	import me.shunia.smedia.core.interfaces.ISMediaInfo;
	
	public class SAudio extends SBaseMedia
	{
		
		protected var _sound:Sound = null;
		protected var _soundTransform:SoundTransform = null;
		protected var _soundChannel:SoundChannel = null;
		
		public function SAudio()
		{
			super();
		}
		
		override protected function initMediaInfo():ISMediaInfo {
			var audioInfo:SAudioInfo = new SAudioInfo();
			audioInfo.bufferTime = _bufferTime;
			return audioInfo;
		}
		
		override protected function startLoad():void {
			super.startLoad();
			
			dispose();
			
			var req:URLRequest = new URLRequest(_url);
			var context:SoundLoaderContext = new SoundLoaderContext(_bufferTime, false);
			_sound = new Sound();
			_sound.addEventListener(Event.ID3, onID3);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_sound.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_sound.addEventListener(Event.COMPLETE, onComplete);
			_sound.load(req, context);
			_soundTransform = new SoundTransform(_volume / 100);
			_soundChannel = _sound.play(0, 1, _soundTransform);
			
			if (!_isPlaying) {
				pause();
			}
		}
		
		protected function onComplete(event:Event):void {
			Context.log(LogLevel.INFO, "[audio]", "File loaded ->" + _url);
		}
		
		protected function onProgress(event:ProgressEvent):void {
			_info.byteLoaded = event.bytesLoaded;
			_info.bytesTotal = event.bytesTotal;
//			Context.log(Debugger.INFO, "[audio]", "File progress ->" + event.bytesLoaded / event.bytesTotal);
		}
		
		protected function onError(event:IOErrorEvent):void {
			Context.log(LogLevel.ERROR, "[audio]", "File load fail ->" + _url);
		}
		
		protected function onID3(event:Event):void {
			Context.log(LogLevel.INFO, "[audio]", "File ID3 info ok!");
		}
		
		override public function play():void {
			super.play();
			if (_sound) {
				_sound.play(_info.timePlayed);
			}
		}
		
		override public function pause():void {
			super.pause();
			if (_soundChannel) {
				_info.timePlayed = _soundChannel.position;
				_soundChannel.stop();
			}
		}
		
		override public function set volume(value:int):void {
			super.volume = value;
			if (_soundTransform) {
				_soundTransform.volume = _volume;
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