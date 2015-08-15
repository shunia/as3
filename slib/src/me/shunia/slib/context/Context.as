package me.shunia.slib.context
{
	
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * 注册上下文所需要用到的类定义.
	 *  
	 * @author shunia-17173
	 */	
	public class Context
	{
		
		private static var _config:IContextConfig = null;
		
		private static var _contextDict:Dictionary = new Dictionary();
		private static var _contextArr:Array = [];
		private static var _log:Function = trace;
		private static var _variables:Object = {};
		private static var _stage:Stage = null;
		
		public function Context() {
		}
		
		public static function set config(value:IContextConfig):void {
			_config = value;
			
			if (_config) {
				_log = _config.log;
				
				for each (var conf:Object in _config.contexts) {
					regContext(conf.name, conf.context, conf.defaultContext, conf.param);
				}
			}
		}
		
		/**
		 * 注入context.
		 *  
		 * @param name
		 * @param context
		 * 
		 */		
		public static function injectContext(name:String, context:*):void {
			_contextDict[name] = {"name":name, "context":context, "default":null, "param":null, "inited":true};
		}
		
		/**
		 * 增加context.
		 * 增加的context如果用于initAll方法,将会按照增加的先后顺序进行处理.
		 *  
		 * @param name 定义的上下文类的名称.
		 * @param context 上下文的实际定义,可以是类(Class)或者实例(Instance).
		 */		
		public static function regContext(name:String, context:*, defaultContext:* = null, param:* = null):void {
			if (!hasContext(name)) {
				var context:Object = {"name":name, "context":context, "default":defaultContext, "param":param, "inited":false};
				_contextDict[name] = context;
				_contextArr.push(context);
			}
		}
		
		/**
		 * 是否存在指定的context
		 *  
		 * @param name
		 */		
		public static function hasContext(name:String):Boolean {
			return _contextDict.hasOwnProperty(name) && _contextDict[name] && (_contextDict[name]["context"] || _contextDict[name]["default"]);
		}
		
		/**
		 * 获取context.
		 *  
		 * @param name 定义的上下文类的名称.
		 * @return 上下文类的实例.
		 */		
		public static function getContext(name:String):* {
			if (hasContext(name)) {
				if (_contextDict[name]["inited"]) {
					return _contextDict[name]["context"];
				} else {
					initContext(_contextDict[name]);
					return getContext(name);
				}
			}
			return null;
		}
		
		/**
		 * 初始化指定的context.
		 *  
		 * @param name
		 */		
		private static function initContext(context:Object):void {
			var specContext:* = context["context"];
			var defaultContext:* = context["default"];
			specContext = specContext ? specContext : defaultContext;
			var item:IContextItem = null;
			if (specContext is Class) {
				item = new specContext() as IContextItem;
			} else {
				item = specContext as IContextItem;
			}
			context["context"] = item;
			context["inited"] = true;
		}
		
		/**
		 * 启动所有的context,进行注册.将会按照注册顺序进行初始化. 
		 */		
		public static function initAll():void {
			while (_contextArr.length) {
				var context:Object = _contextArr.shift();
				var contextItem:IContextItem = getContext(context.name) as IContextItem;
				if (contextItem) {
					contextItem.startUp(context.hasOwnProperty("param") && context["param"] ? context["param"] : variables);
				}
			}
		}

		/**
		 * 上下文环境变量
		 *  
		 * @return 
		 * 
		 */		
		public static function get variables():Object {
			return _variables;
		}
		
		/**
		 * 全局log方法,默认为trace,当通过config注入后,将会是自定义的log方法.
		 * 默认为trace,默认接受连续或者非连续的字符串.为保证一致性,接收方法应和trace一样支持任意形式的参数输入.
		 *  
		 * @return 
		 */		
		public static function get log():Function {
			return _log;
		}

		/**
		 * 全局stage 
		 * @return 
		 */		
		public static function get stage():Stage {
			return _stage;
		}

		public static function set stage(value:Stage):void {
			_stage = value;
		}

		
	}
}