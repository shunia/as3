package me.shunia.slib.debug
{
	public interface IDebuggerOutput
	{
		/**
		 * 将传入的消息进行输出
		 *  
		 * @param info
		 */		
		function output(info:String):void;
	}
}