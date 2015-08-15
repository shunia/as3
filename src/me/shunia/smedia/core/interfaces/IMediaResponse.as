package me.shunia.smedia.core.interfaces
{
	public interface IMediaResponse
	{
		
		function listen(type:String, callback:Function):void;
		function remove(type:String, callback:Function = null):void;
		
	}
}