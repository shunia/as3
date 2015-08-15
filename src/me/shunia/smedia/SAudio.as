package me.shunia.smedia
{
	import me.shunia.smedia.core.MediaManager;
	import me.shunia.smedia.core.audio.AudioMedia;
	import me.shunia.smedia.core.interfaces.IMedia;

	public class SAudio extends MediaManager
	{
		
		private static var _s:SAudio = null;
		
		public function SAudio(singletonEnforcer:SingletonEnforcer)
		{
			if (singletonEnforcer) {
				super(AudioMedia);
			} else {
				throw new Error("Can not initialize!");
			}
		}
		
		public static function g(mediaName:String = null):IMedia {
			if (_s == null) _s = new SAudio(new SingletonEnforcer());
			return _s.create(mediaName);
		}
		
	}
}

class SingletonEnforcer {
	
}