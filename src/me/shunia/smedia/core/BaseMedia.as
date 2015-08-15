package me.shunia.smedia.core
{
	import flash.display.DisplayObject;
	
	import me.shunia.smedia.core.interfaces.IMedia;
	import me.shunia.smedia.core.interfaces.IMediaConf;
	import me.shunia.smedia.core.interfaces.IMediaInfo;
	
	public class BaseMedia implements IMedia
	{
		
		protected var _isPlaying:Boolean = false;
		protected var _display:DisplayObject = null;
		protected var _info:IMediaInfo = null;
		protected var _conf:IMediaConf = null;
		
		public function BaseMedia()
		{
		}
		
		public function play():void
		{
			_isPlaying = true;
		}
		
		public function pause():void
		{
			_isPlaying = false;
		}
		
		public function seek(time:int):void
		{
		}
		
		public function stop():void
		{
			_isPlaying = false;
		}
		
		public function dispose():void
		{
			_isPlaying = false;
		}
		
		public function get info():IMediaInfo
		{
			return _info;
		}
		
		public function get conf():IMediaConf {
			return _conf;
		}
		
		public function get display():DisplayObject
		{
			return _display;
		}
		
	}
}