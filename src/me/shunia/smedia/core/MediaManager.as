package me.shunia.smedia.core
{
	import flash.utils.Dictionary;
	
	import me.shunia.smedia.core.interfaces.IMedia;
	import me.shunia.smedia.core.interfaces.IMediaManager;

	public class MediaManager implements IMediaManager
	{
		
		protected var _increId:int = -1;
		protected var _medias:Dictionary = null;
		protected var _mediaCls:Class = null;
		
		public function MediaManager(mediaCls:Class)
		{
			this._mediaCls = mediaCls;
			_medias = new Dictionary();
		}
		
		public function create(mediaName:String = null):IMedia
		{
			if (mediaName && _medias.hasOwnProperty(mediaName)) 
				return null;
			if (!_mediaCls) 
				return null;
			
			var media:IMedia = new _mediaCls() as IMedia;
			if (media) {
				if (!mediaName) mediaName = "__media__" + _increId ++;
				_medias[mediaName] = media;
			}
			return media;
		}
		
//		protected function parseConf(conf:IMediaConf):void {
//			var url:String = conf.url;
//			var relative:Boolean = url.substr(0, 7).indexOf(":/") == -1;
//			var protocol:String = url.split(":/")[0];
//			if (protocol && !relative) {
//				if (["http", "https", "file", "rtmp", "smb", "ftp"].indexOf(protocol) != -1) {
//					//network path
//				} else {
//					//local file system path
//					conf.url = "file:///" + url;
//				}
//			} else {
//				//relative path
//			}
//		}
		
	}
}