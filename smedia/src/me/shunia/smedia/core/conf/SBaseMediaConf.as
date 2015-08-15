package me.shunia.smedia.core.conf
{
	import me.shunia.smedia.core.interfaces.ISMediaConf;
	
	public class SBaseMediaConf implements ISMediaConf
	{
		
		protected var _autoPlay:Boolean = false;
		protected var _url:String = null;
		protected var _bufferTime:int = 1;
		
		public function SBaseMediaConf(url:String = null)
		{
			this.url = url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get url():String
		{
			return _url;
		}

		public function get bufferTime():int
		{
			return _bufferTime;
		}

		public function set bufferTime(value:int):void
		{
			_bufferTime = value;
		}

		/**
		 * Whether auto play after buffer has been fullfilled or not. 
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		/**
		 * @private
		 */
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
		}


	}
}