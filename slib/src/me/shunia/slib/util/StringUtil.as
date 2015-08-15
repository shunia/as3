package me.shunia.slib.util
{
	public class StringUtil
	{
		
		/**
		 * 验证字符串在if判断中是否有效
		 *  
		 * @param str
		 * @return 
		 */		
		public static function isValid(str:String):Boolean {
			return str && str.length > 0;
		}
		
		/**
		 * 为指定字符串填充直指定长度的填充符.
		 *  
		 * @param str 指定的字符串
		 * @param fillWith 填充用的字符串
		 * @param len 想要填充到的长度
		 * @param isFront 是否从字符串前面填充
		 * @return 填充成指定长度的字符串
		 */		
		public static function fillStr(str:String, fillWith:String, len:int, isFront:Boolean = true):String {
			if (str.length < len) {
				var diff:int = len - str.length;
				for (var i:int = 0; i < diff; i ++) {
					str = fillWith + str;
				}
			}
			return str;
		}
		
		/**
		 * 去除空的字符串
		 *  
		 * @param str
		 * @return 
		 */		
		public static function trim(str:String):String {
			return str.replace("/ /g", "");
		}
		
	}
}