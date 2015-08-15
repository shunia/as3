package me.shunia.smedia.core
{
	import me.shunia.smedia.core.audio.SAudio;
	import me.shunia.smedia.core.conf.SAudioConf;
	import me.shunia.smedia.core.interfaces.ISMedia;
	import me.shunia.smedia.core.interfaces.ISMediaConf;

	public class SAudioManager extends SBaseMediaManager
	{
		public function SAudioManager()
		{
			super();
		}
		
		override protected function create(conf:ISMediaConf):ISMedia {
			if (!(conf is SAudioConf)) throw new Error("Wrong type of media config!");
			
			var media:ISMedia = null;
			if (conf) {
				media = createAudioMedia(conf);
			}
			return media;
		}
		
		protected function createAudioMedia(conf:ISMediaConf):SAudio {
			var audio:SAudio = new SAudio();
			audio.url = conf.url;
			return audio;
		}
		
	}
}