package me.shunia.smedia.core.interfaces
{
	public interface ISVideoResponse
	{
		
		function listen(type:String, callback:Function):void;
		function remove(type:String, callback:Function = null):void;
		
		function clear():void;
		
	}
}