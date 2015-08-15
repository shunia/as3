package me.shunia.slib.util.ease
{
	public class EaseCore
	{
		public function EaseCore()
		{
		}
		
		/**
		 * 固定速度,线性缓动 
		 */		
		public static const LINEAR:Function = function (p:Number):Number {
			return p;
		};
		
	}
}