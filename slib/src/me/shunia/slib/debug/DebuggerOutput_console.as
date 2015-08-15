package me.shunia.slib.debug
{
	import me.shunia.slib.util.JSBridge;

	public class DebuggerOutput_console implements IDebuggerOutput
	{
		
		private var _logs:Array = [];
		
		public function DebuggerOutput_console()
		{
		}
		
		public function output(info:String):void
		{
			JSBridge.addCall("log", info, "console");
		}
	}
}