package me.shunia.smedia.core.video
{
	public class VideoUrlParser
	{
		
		private var _connection:String = null;
		private var _streamName:String = null;
		
		public function VideoUrlParser(url:String)
		{
			parse(url);
		}
		
		protected function parse(url:String):void {
			if (url) {
				if (startsWith(url, "rtmp")) {
					var lastSplash:int = url.lastIndexOf("/");
					if (lastSplash != 0 && lastSplash != url.length - 1) {
						_connection = url.substr(0, lastSplash);
						_streamName = url.substr(lastSplash + 1, url.length);
					}
				} else if (
					startsWith(url, "http://") || 
					startsWith(url, "https://") || 
					startsWith(url, "file://")) {
					_connection = null;
					_streamName = url;
				}
			}
		}
		
		protected function startsWith(str1:String, str2:String):Boolean {
			var len:int = str2.length;
			if (str1.substr(0, len) === str2) {
				return true;
			} else {
				return false;
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