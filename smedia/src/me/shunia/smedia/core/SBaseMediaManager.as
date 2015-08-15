package me.shunia.smedia.core
{
	import me.shunia.smedia.core.interfaces.ISMedia;
	import me.shunia.smedia.core.interfaces.ISMediaConf;
	import me.shunia.smedia.core.interfaces.ISMediaManager;

	public class SBaseMediaManager implements ISMediaManager
	{
		
		public function SBaseMediaManager()
		{
			
		}
		
		public function createMedia(mediaConf:ISMediaConf):ISMedia
		{
			if (!mediaConf) return null;
			
//			parseConf(mediaConf);
			
			return create(mediaConf);
		}
		
		protected function parseConf(conf:ISMediaConf):void {
			var url:String = conf.url;
			var relative:Boolean = url.substr(0, 7).indexOf(":/") == -1;
			var protocol:String = url.split(":/")[0];
			if (protocol && !relative) {
				if (["http", "https", "file", "rtmp", "smb", "ftp"].indexOf(protocol) != -1) {
					//network path
				} else {
					//local file system path
					conf.url = "file:///" + url;
				}
			} else {
				//relative path
			}
		}
		
		protected function create(conf:ISMediaConf):ISMedia {
			return null;
		}
		
	}
}