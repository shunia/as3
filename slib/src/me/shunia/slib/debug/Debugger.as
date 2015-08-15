package me.shunia.slib.debug
{
	import flash.utils.getTimer;
	
	import me.shunia.slib.context.IContextItem;
	import me.shunia.slib.util.StringUtil;

	/**
	 * 消息输出控件.
	 * 支持log信息,可以往console里输出. 
	 * @author shunia-17173
	 */	
	public class Debugger implements IContextItem
	{
		
		public static const CONTEXT_NAME:String = "debugger";
		
		private static var _output:IDebuggerOutput = new DebuggerOutput_default();
		private static var _source:String = null;
		
		public function Debugger()
		{
		}
		
		public static function set output(value:IDebuggerOutput):void {
			_output = value;
		}
		
		public static function set source(value:String):void {
			_source = value;
		}
		
		public static function get consoleUI():Object
		{
			return _output;
		}
		
		/**
		 * 打印输出到flash控制台 
		 * @param info
		 */		
		public static function tracer(...info):void {
			delegateOutput(trace, info);
		}
		
		/**
		 * 打印输出到外部控制台.通过制定output(IDebuggerOutput)属性,可以将log信息指向
		 * 该output实例的output方法中.
		 * 从而通过实现不同的IDebuggerOutput实例,完成输出log到不同环境中的功能. 
		 * @param level
		 * @param logs
		 */		
		public static function log(level:int, ...logs):void {
			delegateOutput(_output.output, getLevelStr(level) + " " + paramsToString(logs));
		}
		
		private static function delegateOutput(delegate:Function, ...content):void {
			var s:String = "";
			if (StringUtil.isValid(_source)) {
				s = "[" + _source + "]";
			}
			delegate("[" + getTimeStr() + "]" + s + paramsToString(content));
		}
		
		private static function paramsToString(params:Array):String {
			var str:String = "";
			for (var i:int = 0; i < params.length; i ++) {
				var section:* = params[i];
				if (section) {
					var toString:String = null;
					try {
						toString = section["toString"]();
					} catch (e:*) {
						toString = String(section);
					}
					str += toString;
				}
			}
			return str;
		}
		
		public static function perf(level:int, ...perfs):void {
			
		}
		
		public static function track(...value):void {
			
		}
		
		private static function getTimeStr():String {
			var result:String = "";
			var mili:int = getTimer();
			result = StringUtil.fillStr(String(mili % 1000), "0", 3);
			var sec:int = mili / 1000 % 60;
			result = StringUtil.fillStr(String(sec), "0", 2) + ":" + result;
			var min:int = mili / 1000 / 60 % 60;
			result = StringUtil.fillStr(String(min), "0", 2) + ":" + result;
			var h:int = mili / 1000 / 60 / 60 % 24;
			result = StringUtil.fillStr(String(h), "0", 2) + ":" + result;
			return result;
		}
		
		private static function fillTimeStr(value:int):String {
			return value < 10 ? "0" + value : String(value);
		}
		
		private static function getLevelStr(level:int):String {
			var str:String;
			switch (level) {
				case LogLevel.INFO : 
					str = "[info]";
					break;
				case LogLevel.WARNING : 
					str = "[warning]";
					break;
				case LogLevel.ERROR : 
					str = "[error]";
					break;
			}
			return str;
		}
		
		public function get contextName():String {
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void {
			if (param.hasOwnProperty("source")) {
				source = param["source"];
			}
			if (param.hasOwnProperty("output")) {
				output = param["output"];
			}
		}
		
	}
}