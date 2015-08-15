package me.shunia.smedia.core.video
{
	/**
	 * Config keys defined for video.
	 * All values for keys define should be basic-type-value to avoid complex operation.
	 *  
	 * @author qingfenghuang
	 */	
	public class VideoConfProps
	{
		
		/**
		 * File url to play. 
		 */		
		public static const URL:String = "url";
		/**
		 * true/false 
		 */		
		public static const AUTO_PLAY:String = "autoplay";
		/**
		 * Seconds to play after buffered,default is 3. 
		 */		
		public static const BUFFER_TIME:String = "bufferTime";
		/**
		 * Use hardware decode or not,can not change when playing. true/false.
		 * Set to true may cause problem when playing. 
		 */		
		public static const HARDWARE_ACCELARATE:String = "hardware_accelarate";
		/**
		 * 1 ~ 100 
		 */		
		public static const VOLUME:String = "volume";
		/**
		 * 0 ~ screen-height 
		 */		
		public static const HEIGHT:String = "height";
		/**
		 * 0 ~ screen-width 
		 */		
		public static const WIDTH:String = "width";
		/**
		 * When resizing, keep video's scale ratio or not. true/false 
		 */		
		public static const MAINTAIN_ASPECT_RATIO:String = "maintainAspectRatio";
		/**
		 * Use stage video to render video or not.
		 * Stage video is preffered in mobile applications.
		 * But if available,it is also recommended in web browser. 
		 */		
		public static const USER_STAGE_VIDEO:String = "use_stage_video";
		
	}
}