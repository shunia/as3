package me.shunia.smedia
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import me.shunia.smedia.core.interfaces.ISMedia;
	import me.shunia.smedia.ui.ISMediaUI;
	
	public class SVideoPlayer extends Sprite
	{
		
		// original stream url for playing
		protected var _streamURL:String = null;
		// using percent for width and height calculation
		protected var _usingPercentWidthAndHeight:Boolean = true;
		// default full width and full height
		protected var _percentWidth:Number = 1;
		protected var _percentHeight:Number = 1;
		// default video original width and height
		protected var _width:int = -1;
		protected var _height:int = -1;
		// use auto resize or not when stage resizing
		protected var _autoResize:Boolean = false;
		// media instance
		protected var _media:ISMedia = null;
		// ui instance
		protected var _ui:ISMediaUI = null;
		
		public function SVideoPlayer(streamURL:String) {
			super();
			// set all data ready
			_streamURL = streamURL;
			// init media and ui instance
			init();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			// listen for stage resize
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onResize(event:Event):void {
			if (!_autoResize) return;
			if (!_usingPercentWidthAndHeight) return;
			if (!_media || !_media.display) return;
			
			var resizable:Boolean = false;
			
			var sw:int = stage.stageWidth;
			var sh:int = stage.stageHeight;
			var cw:int = _media.display.width;
			var ch:int = _media.display.height;
			var rw:Number = sw * _percentWidth;
			var rh:Number = sh * _percentHeight;
			
			if (Math.floor(rw) != cw && Math.ceil(rw) != cw) resizable = true;
			if (!resizable && Math.floor(rh) != ch && Math.ceil(rh) != ch) resizable = true;
			
			if (resizable) {
				_media.display.width = Math.floor(rw);
				_media.display.height = Math.floor(rh);
			}
		}
		
		protected function init():void {
			
		}
	}
}