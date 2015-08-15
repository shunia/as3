package me.shunia.smedia.core.interfaces
{
	public interface IMediaInfo
	{
		
		function setProp(key:String, value:*):IMediaInfo;
		function getProp(key:String):*;
		
		function onStatus(status:String, callback:Function):void;
		function offStatus(status:String, callback:Function):void;
		
	}
}