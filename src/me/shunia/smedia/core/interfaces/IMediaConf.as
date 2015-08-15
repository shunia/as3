package me.shunia.smedia.core.interfaces
{
	public interface IMediaConf
	{
		
		/**
		 * To set config key/value pairs for media update. 
		 *  
		 * @param key
		 * @param value
		 * @return 
		 */		
		function setProp(key:String, value:*):IMediaConf;
		/**
		 * To get current media config value by key.
		 *  
		 * @param key
		 * @return 
		 */		
		function getProp(key:String):*;
		/**
		 * Trigger media to acutally update. 
		 * Need to be called after set.
		 */		
		function update():void;
		
	}
}