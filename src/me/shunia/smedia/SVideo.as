package me.shunia.smedia
{
	import me.shunia.smedia.core.MediaManager;
	import me.shunia.smedia.core.interfaces.IMedia;
	import me.shunia.smedia.core.video.VideoMedia;

	public class SVideo extends MediaManager
	{
		
		private static var _s:SVideo = null;
		
		public function SVideo(singletonEnforcer:SingletonEnforcer)
		{
			if (singletonEnforcer) {
				super(VideoMedia);
			} else {
				throw new Error("Can not initialize!");
			}
		}
		
		public static function g(mediaName:String = null):IMedia {
			if (_s == null) _s = new SVideo(new SingletonEnforcer());
			return _s.create(mediaName);
		}
		
	}
}

class SingletonEnforcer {
	
}