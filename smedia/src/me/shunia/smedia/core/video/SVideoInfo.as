package me.shunia.smedia.core.video
{
	import me.shunia.smedia.core.SMediaInfo;
	import me.shunia.smedia.core.interfaces.ISVideoResponse;
	
	public class SVideoInfo extends SMediaInfo
	{
		
		protected var _response:ISVideoResponse = null;
		protected var _videoFps:int = 30;
		protected var _videoCurrentFps:int = 0;
		protected var _timeLoaded:Number = 0;
		
		public function SVideoInfo()
		{
			super();
		}
		
		/**
		 * 视频回调逻辑 
		 */
		public function get response():ISVideoResponse {
			return _response;
		}

		/**
		 * @private
		 */
		public function set response(value:ISVideoResponse):void {
			_response = value;
		}

		/**
		 * 视频的原生fps 
		 */
		public function get videoFps():int
		{
			return _videoFps;
		}

		/**
		 * @private
		 */
		public function set videoFps(value:int):void
		{
			_videoFps = value;
		}

		/**
		 * 视频当前fps 
		 */
		public function get videoCurrentFps():int
		{
			return _videoCurrentFps;
		}

		/**
		 * @private
		 */
		public function set videoCurrentFps(value:int):void
		{
			_videoCurrentFps = value;
		}

		/**
		 * Video time that has been buffered. 
		 */
		public function get timeLoaded():Number
		{
			return _timeLoaded;
		}

		/**
		 * @private
		 */
		public function set timeLoaded(value:Number):void
		{
			_timeLoaded = value;
		}


	}
}