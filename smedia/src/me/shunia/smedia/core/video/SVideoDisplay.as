package me.shunia.smedia.core.video
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import me.shunia.slib.context.Context;
	import me.shunia.slib.debug.LogLevel;
	
	public class SVideoDisplay extends Sprite
	{
		
		protected static const DEFAULT_WIDTH:int = 640;
		protected static const DEFAULT_HEIGHT:int = 480;
		
		protected var _stream:NetStream = null;
		protected var _current:Object = null;
		protected var _video:Video = null;
		protected var _stageVideo:StageVideo = null;
		
		protected var _videoWidth:Number = 0;
		protected var _videoHeight:Number = 0;
		
		protected var _viewPort:Rectangle = null;
		
		protected var _useHardwareAccelerate:Boolean = false;
		
		public function SVideoDisplay()
		{
			super();
			_viewPort = new Rectangle(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			
			initVideo();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		protected function added(e:Object):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			initStageVideo();
		}
		
		protected function removed(e:Object):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		public function get useHardwareAccelerate():Boolean {
			return _useHardwareAccelerate;
		}

		public function set useHardwareAccelerate(value:Boolean):void {
			_useHardwareAccelerate = value;
			switchStream();
		}
		
		protected function initVideo():void {
			_video = new Video();
			_video.smoothing = true;
			addChildAt(_video, 0);
		}
		
		protected function initStageVideo():void {
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, function (e:StageVideoAvailabilityEvent):void {
				if (e.availability == StageVideoAvailability.AVAILABLE) {
					_stageVideo = stage.stageVideos.length > 0 ? stage.stageVideos[0] : null;
				} else {
					_stageVideo = null;
				}
				switchStream();
			});
		}
		
		protected function switchStream():void {
			if (!_stream) return;
			
			if (_useHardwareAccelerate) {
				if (_stageVideo) {
					attachToStageVideo();
				} else {
					attachToVideo();
				}
			} else {
				attachToVideo();
			}
		}
		
		protected function attachToStageVideo():void {
			if (_current == _stageVideo) return;
			if (_stageVideo == null) return;
			
			updateStageVideo();
			_stageVideo.attachNetStream(_stream);
			
			_current = _stageVideo;
			
			Context.log(LogLevel.INFO, "[video]", "Hardware accelerate mode enabled.");
			
			if (_video) {
				_video.visible = false;
				_video.attachNetStream(null);
			}
		}
		
		protected function attachToVideo():void {
			if (_current == _video) return;
			if (_video == null) return;
			
			updateVideo();
			_video.attachNetStream(_stream);
			_video.visible = true;
			
			_current = _video;
			
			Context.log(LogLevel.INFO, "[video]", "Hardware accelerate mode disabled.");
			
			if (_stageVideo) {
				_stageVideo.attachNetStream(null);
			}
		}
		
		protected function updateStageVideo():void {
			if (!_stageVideo) return;
			
			var actualRect:Rectangle = getProperViewPort();
			Context.log(LogLevel.INFO, "[video]", "Video region: " + actualRect.toString());
			
			if (actualRect.equals(_stageVideo.viewPort)) return;
			_stageVideo.viewPort = actualRect;
		}
		
		protected function updateVideo():void {
			if (!_video) return;
			
			var actualRect:Rectangle = getProperViewPort();
			Context.log(LogLevel.INFO, "[video]", "Video region: " + actualRect.toString());
//			if (_video.getRect(_video).equals(actualRect)) return;
			if (_video.x == actualRect.x && _video.y == actualRect.y && _video.width == actualRect.width && _video.height == actualRect.height) return;
			
			_video.x = actualRect.x;
			_video.y = actualRect.y;
			_video.width = actualRect.width;
			_video.height = actualRect.height;
		}
		
		protected function getProperViewPort():Rectangle {
			var result:Rectangle = _viewPort;
			if (result.width < 0 || result.height < 0) {
				result = result.clone();
				
				if (result.width < 0) {
					if (_videoWidth) {
						result.width = _videoWidth;
					} else {
						result.width = DEFAULT_WIDTH;
					}
				}
				if (result.height < 0) {
					if (_videoHeight) {
						result.height = _videoHeight;
					} else {
						result.height = DEFAULT_HEIGHT;
					}
				}
			}
			
			return result;
		}

		internal function attachNetStream(netStream:NetStream):void {
			_stream = netStream;
			switchStream();
		}
		
		public function set videoWidth(value:Number):void {
			_videoWidth = value;
			updateStageVideo();
			updateVideo();
		}
		
		public function get videoWidth():Number {
			return _videoWidth;
		}
		
		public function set videoHeight(value:Number):void {
			_videoHeight = value;
			updateStageVideo();
			updateVideo();
		}
		
		public function get videoHeight():Number {
			return _videoHeight;
		}
		
		internal function get video():Object {
			return _current;
		}
		
		override public function set x(value:Number):void {
			_viewPort.x = int(value);
			updateStageVideo();
			updateVideo();
		}
		
		override public function get x():Number {
			return _viewPort.x;
		}
		
		override public function set y(value:Number):void {
			_viewPort.y = int(value);
			updateStageVideo();
			updateVideo();
		}
		
		override public function get y():Number {
			return _viewPort.y;
		}
		
		override public function set width(value:Number):void {
			_viewPort.width = int(value);
			updateStageVideo();
			updateVideo();
		}
		
		override public function get width():Number {
			return _viewPort.width;
		}
		
		override public function set height(value:Number):void {
			_viewPort.height = int(value);
			updateStageVideo();
			updateVideo();
		}
		
		override public function get height():Number {
			return _viewPort.height;
		}
		
	}
}