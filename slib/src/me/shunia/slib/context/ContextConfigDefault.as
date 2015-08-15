package me.shunia.slib.context
{
	import flash.display.Stage;
	
	import me.shunia.slib.debug.Debugger;
	import me.shunia.slib.event.EventManager;
	import me.shunia.slib.util.time.Ticker;

	public class ContextConfigDefault implements IContextConfig
	{
		
		protected var _stage:Stage = null;
		
		public function ContextConfigDefault(stage:Stage)
		{
			_stage = stage;
			
			Ticker.init(_stage);
		}
		
		public function get log():Function {
			return Debugger.log;
		}
		
		public function get stage():Stage {
			return _stage;
		}
		
		public function get contexts():Array {
			return baseContext.concat(extentedContext);
		}
		
		protected function get baseContext():Array {
			return [
				{"name":"eventManager", "context":EventManager}
			];
		}
		
		protected function get extentedContext():Array {
			return [];
		}
		
	}
}