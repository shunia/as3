package me.shunia.smedia.core
{
	import me.shunia.smedia.core.conf.SVideoConf;
	import me.shunia.smedia.core.interfaces.ISMedia;
	import me.shunia.smedia.core.interfaces.ISMediaConf;
	import me.shunia.smedia.core.video.SVideo;

	public class SVideoManager extends SBaseMediaManager
	{
		public function SVideoManager()
		{
			super();
		}
		
		override protected function create(conf:ISMediaConf):ISMedia {
			if (!(conf is SVideoConf)) throw new Error("Wrong type of media config!");
			
			var media:ISMedia = null;
			if (conf) {
				media = createVideoMedia(conf);
			}
			return media;
		}
		
		protected function createVideoMedia(conf:ISMediaConf):SVideo {
			var c:SVideoConf = conf as SVideoConf;
			var v:SVideo = new SVideo();
			
			v.url = conf.url;
			v.useHardwareAccelerate = c.useHardwareAccelerate;
			v.display.width = c.width;
			v.display.height = c.height;
			
			return v;
		}
	}
}