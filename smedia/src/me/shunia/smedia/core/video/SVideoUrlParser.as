package me.shunia.smedia.core.video
{
	import me.shunia.slib.util.PathUtil;

	public class SVideoUrlParser
	{
		
		private var _connection:String = null;
		private var _streamName:String = null;
		
		public function SVideoUrlParser(url:String)
		{
			parse(url);
		}
		
		protected function parse(url:String):void {
			if (url) {
				var isRtmp:Boolean = PathUtil.isRtmp(url);
				if (isRtmp) {
					var lastSplash:int = url.lastIndexOf("/");
					if (lastSplash != 0 && lastSplash != url.length - 1) {
						_connection = url.substr(0, lastSplash);
						_streamName = url.substr(lastSplash + 1, url.length);
					}
				} else {
					_connection = null;
					_streamName = url;
				}
			}
		}

		public function get connection():String {
			return _connection;
		}

		public function get streamName():String {
			return _streamName;
		}

		
	}
}