package me.shunia.smedia.core.interfaces
{
	import flash.display.DisplayObject;

	public interface IMedia
	{
		/**
		 * Only if available.
		 *  
		 * @return Media display object for users to be seen
		 */		
		function get display():DisplayObject;
		/**
		 * Almost all media info that can be grabed by play.
		 *  
		 * @return Full media Info.
		 */		
		function get info():IMediaInfo;
		/**
		 * Configuration of this media element.
		 *  
		 * @return 
		 */		
		function get conf():IMediaConf;
		
		function play():void;
		function pause():void;
		/**
		 * Seek for 'time' seconds.
		 *  
		 * @param time
		 */		
		function seek(time:int):void;
		function stop():void;
		function dispose():void;
		
	}
}