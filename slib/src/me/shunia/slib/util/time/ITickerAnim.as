package me.shunia.slib.util.time
{
	public interface ITickerAnim
	{
		
		function set onComplete(value:Function):void;
		function set onUpdate(value:Function):void;
		function set ease(value:Function):void;
		
		function addProp(prop:String, value:*):ITickerAnim;
		function dispose():void;
		
	}
}