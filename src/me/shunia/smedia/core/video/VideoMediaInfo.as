package me.shunia.smedia.core.video
{
	import flash.utils.Dictionary;
	
	import me.shunia.smedia.core.MediaInfo;
	import me.shunia.smedia.core.interfaces.IMediaResponse;
	
	public class VideoMediaInfo extends MediaInfo
	{
		public function VideoMediaInfo(response:IMediaResponse)
		{
			super(response);
		}
		
		public function init():void {
			_props = new Dictionary();
		}
		
	}
}