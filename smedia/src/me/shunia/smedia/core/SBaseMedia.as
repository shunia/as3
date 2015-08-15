package me.shunia.smedia.core
{
	import flash.display.DisplayObject;
	
	import me.shunia.smedia.core.interfaces.ISMedia;
	import me.shunia.smedia.core.interfaces.ISMediaInfo;
	
	public class SBaseMedia implements ISMedia
	{
		
		protected var _isPlaying:Boolean = false;
		protected var _bufferTime:int = 3;
		protected var _url:String = null;
		protected var _info:ISMediaInfo = null;
		protected var _volume:int = 50;
		
		public function SBaseMedia()
		{
			_info = initMediaInfo();
		}
		
		public function set bufferTime(value:int):void
		{
			_bufferTime = value;
			_info.bufferTime = _bufferTime;
		}
		
		protected function initMediaInfo():ISMediaInfo {
			return null;
		}
		
		public function set url(value:String):void {
			_url = value;
			_info.url = value;
			//auto load, for now
			startLoad();
		}
		
		protected function startLoad():void {
			
		}
		
		public function play():void
		{
			_isPlaying = true;
			_info.isPlaying = _isPlaying;
		}
		
		public function pause():void
		{
			_isPlaying = false;
			_info.isPlaying = _isPlaying;
		}
		
		public function seek(time:int):void
		{
		}
		
		public function stop():void
		{
			_isPlaying = false;
			_info.isPlaying = _isPlaying;
		}
		
		public function dispose():void
		{
			_bufferTime = 3;
			_isPlaying = false;
			_volume = 50;
			_info = initMediaInfo();
		}
		
		public function get info():ISMediaInfo
		{
			return _info;
		}
		
		public function set volume(value:int):void
		{
			_volume = value;
		}
		
		public function get volume():int
		{
			return _volume;
		}
		
		public function get display():DisplayObject
		{
			return null;
		}
		
	}
}