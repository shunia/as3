package me.shunia.slib.context
{
	public interface IContextItem {
		
		function get contextName():String;
		function startUp(param:Object):void;
		
	}
}