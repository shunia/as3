package me.shunia.slib.event
{
	import me.shunia.slib.context.IContextItem;

	/**
	 * 基于观察者模式的简要消息机制实现.
	 * 通过对注册消息的轮询实现消息派发.
	 * 不同于事件机制的异步机制,这个实现是同步的.
	 *  
	 * @author shunia-17173
	 * 
	 */	
	public class EventManager implements IContextItem, IEventManager
	{
		
		public static const CONTEXT_NAME:String = "eventManager";
		
		/**
		 * 当前已经注册的消息队列. 
		 */		
		private var _events:Array = null;
		/**
		 * 用于记录当前正在派发的消息队列. 
		 */		
		private var _dispatching:Object = null;
		
		public function EventManager() {
		}
		
		public function send(type:String, data:Object = null, target:Object = null):void {
			var listeners:Array = [];
			if (_dispatching == null) {
				_dispatching = {};
			}
			//对已经进行了监听的事件进行筛选
			listeners = _events.filter(function (item:*, index:int, array:Array):Boolean {
				if (item["type"] != type) return false;
				if (target && item && item["target"] && item["target"] != target) return false;
				return true;
			}, null);
			//临时记录,用来进行取消派发的动作
			_dispatching[type] = listeners;
			//优先级排序
			if (listeners.length > 1) {
				listeners.sortOn("priority", Array.NUMERIC);
			}
			//一一派发
			var callback:Function = null;
			var event:Object = null;
			while (_dispatching.hasOwnProperty(type) && _dispatching[type] && _dispatching[type].length) {
				event = listeners.shift();
				callback = event["callback"];
				var thisArg:* = event.hasOwnProperty("target") ? event["target"] : null;
				callback.apply(thisArg, [data]);
			}
			//临时数据清除
			listeners = null;
			delete _dispatching[type];
		}
		
		public function cancel(type:String):void {
			if (_dispatching.hasOwnProperty(type)) {
				var listeners:Array = _dispatching[type];
				delete _dispatching[type];
			}
		}
		
		public function listen(type:String, callback:Function, target:Object = null, priority:int = 0, weakRef:Boolean = false):void {
			var find:Array = _events.filter(function (item:*, index:int, array:Array):Boolean {
				if (type == item["type"] && callback == item["callback"]) return true;
				return false;
			}, null);
			if (find.length == 0) {
				_events.push({"type":type, "callback":callback, "target":target, "priority":priority, "weakRef":weakRef});
			}
		}
		
		public function remove(type:String, callback:Function, target:Object = null):void {
			//先过滤出要移除的监听
			var registered:Array = _events.filter(function (item:*, index:int, array:Array):Boolean {
				if (item["type"] != type) return false;
				if (item["callback"] != callback) return false;
				if (item["target"] && target != item["target"]) return false;
				
				return true;
			}, null);
			//从全局消息中移除
			for each (var event:Object in registered) {
				var index:int = _events.indexOf(event);
				if (index != -1) {
					_events.splice(index, 1);
				}
			}
			registered = null;
		}
		
		public function get contextName():String {
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void {
			_events = [];
		}
	}
}