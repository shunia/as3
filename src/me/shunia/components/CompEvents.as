package me.shunia.components
{
	import flash.events.Event;

	public class CompEvents extends Event
	{
		
		public static const CHANGE:String = "change";
		
		public var params:Array= null;
		
		public function CompEvents(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
	}
}