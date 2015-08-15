package me.shunia.slib.base
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 基础入口类.应作为入口类的基类进行使用.
	 * 负责监听舞台初始化,和js可用性检测.
	 *  
	 * @author shunia-17173
	 */	
	public class StageIniator extends Sprite
	{
		
		/**
		 * 是否检测基础的js可用性 
		 */		
		protected var _allowJSCheck:Boolean = false;
		
		public function StageIniator(allowJSCheck:Boolean = true)
		{
			_allowJSCheck = allowJSCheck;
			//检测舞台
			if (stage) {
				stageInited();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, stageInited);
			}
		}
		
		/**
		 * 舞台已初始化.
		 *  
		 * @param e
		 */		
		final private function stageInited(e:Event = null):void {
			if (hasEventListener(Event.ADDED_TO_STAGE)) {
				removeEventListener(Event.ADDED_TO_STAGE, stageInited);
			}
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			preInit();
			
			//页面加载完成检查
			if (_allowJSCheck) {
				if (ExternalInterface.available == false) {
					//等待js可调用
					var retry:int = 10;
					var interval:uint = setInterval(function ():void {
						clearInterval(interval);
						retry --;
						if (ExternalInterface.available) {
							init();
						} else if (retry == 0) {
							onInitError("JS not avaliable!");
							//js不可用依然进入初始化流程,需要的话Core中的JSBridge会继续检查js可用性
							init();
						}
					}, 200);
				} else {
					init();
				}
			} else {
				init();
			}
		}
		
		/**
		 * 预初始化的内容. 
		 */		
		protected function preInit():void {
		}
		
		/**
		 * 初始化方法. 
		 * 开始初始化业务逻辑.
		 */		
		protected function init():void {
			//override
		}
		
		protected function onInitError(error:String):void {
			trace(error);
		}
		
	}
}