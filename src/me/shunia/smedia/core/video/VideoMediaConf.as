package me.shunia.smedia.core.video
{
	import flash.utils.Dictionary;
	
	import me.shunia.smedia.core.MediaConf;
	
	public class VideoMediaConf extends MediaConf
	{
		public function VideoMediaConf(onUpdate:Function)
		{
			super(onUpdate);
		}
		
		internal function init():void {
			_confs = new Dictionary();
			setProp(VideoConfProps.AUTO_PLAY, true).
				setProp(VideoConfProps.HARDWARE_ACCELARATE, true).
				setProp(VideoConfProps.MAINTAIN_ASPECT_RATIO, true).
				setProp(VideoConfProps.USER_STAGE_VIDEO, true).
				update();
		}
		
	}
}