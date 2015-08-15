package me.shunia.smedia.core
{
	import me.shunia.smedia.core.interfaces.ISMediaInfo;

	public class SMediaInfo implements ISMediaInfo
	{
		
		protected var _isPlaying:Boolean = false;
		protected var _bufferTime:int = 3;
		protected var _url:String = null;
		
		protected var _playedTime:Number = 0;
		protected var _totalTime:Number = 0;
		protected var _loadedBytes:Number = 0;
		protected var _totalBytes:Number = 0;
		
		public function SMediaInfo()
		{
		}
		
		public function set isPlaying(value:Boolean):void
		{
			_isPlaying = value;
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function set bufferTime(value:int):void
		{
			_bufferTime = value;
		}
		
		public function get bufferTime():int
		{
			return _bufferTime;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get url():String
		{
			return _url;
		}

		public function get timePlayed():Number
		{
			return _playedTime;
		}

		public function set timePlayed(value:Number):void
		{
			_playedTime = value;
		}

		public function get timeTotal():Number
		{
			return _totalTime;
		}

		public function set timeTotal(value:Number):void
		{
			_totalTime = value;
		}

		public function get byteLoaded():Number
		{
			return _loadedBytes;
		}

		public function set byteLoaded(value:Number):void
		{
			_loadedBytes = value;
		}

		public function get bytesTotal():Number
		{
			return _totalBytes;
		}

		public function set bytesTotal(value:Number):void
		{
			_totalBytes = value;
		}
		
	}
}