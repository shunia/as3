package me.shunia.smedia.core.interfaces
{
	import flash.display.DisplayObject;

	public interface ISMedia
	{
		/**
		 * Only if available.
		 *  
		 * @return Media display object for users to be seen
		 */		
		function get display():DisplayObject;
		/**
		 * Time loaded before could start playing.
		 * 
		 * @param value
		 */		
		function set bufferTime(value:int):void;
		/**
		 * Path to the media file or media resource.
		 *  
		 * @param value
		 */		
		function set url(value:String):void;
		
		function play():void;
		function pause():void;
		function seek(time:int):void;
		function stop():void;
		function dispose():void;
		
		/**
		 * Volume from 0 ~ 100
		 *  
		 * @param value
		 */		
		function set volume(value:int):void;
		function get volume():int;
		/**
		 * Almost all media info that can be grabed by play.
		 *  
		 * @return Full media Info.
		 */		
		function get info():ISMediaInfo;
		
	}
}