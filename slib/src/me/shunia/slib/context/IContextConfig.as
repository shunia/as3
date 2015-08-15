package me.shunia.slib.context
{
	import flash.display.Stage;

	public interface IContextConfig
	{
		/**
		 * 输出log的方法.
		 *  
		 * @return 
		 */		
		function get log():Function;
		/**
		 * 需要注册的context类集合
		 *  
		 * @return 
		 */		
		function get contexts():Array;
		/**
		 * 当前舞台实例的引用
		 *  
		 * @return 
		 */		
		function get stage():Stage;
		
	}
}