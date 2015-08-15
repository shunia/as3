package me.shunia.smedia.core.conf
{
	public class SVideoConf extends SBaseMediaConf
	{
		
		protected var _width:int = 640;
		protected var _height:int = 480;
		protected var _useHardwareAccelerate:Boolean = false;
		
		public function SVideoConf(url:String = null, width:int = 640, height:int = 480, useHardwareAccelerate:Boolean = false)
		{
			super(url);
			
			_width = width;
			_height = height;
			_useHardwareAccelerate = useHardwareAccelerate;
		}

		public function get useHardwareAccelerate():Boolean
		{
			return _useHardwareAccelerate;
		}

		public function set useHardwareAccelerate(value:Boolean):void
		{
			_useHardwareAccelerate = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

	}
}