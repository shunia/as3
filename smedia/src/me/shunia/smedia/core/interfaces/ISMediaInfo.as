package me.shunia.smedia.core.interfaces
{
	public interface ISMediaInfo
	{
		
		/**
		 * Indicates whether the media is playing of not.
		 *  
		 * @param value
		 */		
		function set isPlaying(value:Boolean):void;
		function get isPlaying():Boolean;
		/**
		 * Time loaded before actually start playing.
		 *  
		 * @param value
		 */		
		function set bufferTime(value:int):void;
		function get bufferTime():int;
		/**
		 * Resource url actually being loading.
		 * 
		 * @param value
		 */		
		function set url(value:String):void;
		function get url():String;
		/**
		 * Time ellapsed after file or stream actually playing.
		 *  
		 * @return 
		 */		
		function get timePlayed():Number;
		function set timePlayed(value:Number):void;
		/**
		 * Total time of playing file or stream.
		 * Live stream has no timeTotal. 
		 * @return 
		 */		
		function get timeTotal():Number;
		function set timeTotal(value:Number):void;
		/**
		 * Bytes loaded after start playing.
		 * 
		 * @return 
		 */		
		function get byteLoaded():Number;
		function set byteLoaded(value:Number):void;
		/**
		 * Total bytes of playing file.
		 * Live stream has no bytesTotal.
		 *  
		 * @return 
		 */		
		function get bytesTotal():Number;
		function set bytesTotal(value:Number):void;
		
	}
}