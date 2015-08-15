package me.shunia.smedia.core
{
	import flash.utils.Dictionary;
	
	import me.shunia.smedia.core.interfaces.IMediaInfo;
	import me.shunia.smedia.core.interfaces.IMediaResponse;

	public class MediaInfo implements IMediaInfo
	{
		
		protected var _props:Dictionary = null;
		protected var _response:IMediaResponse = null;
		
		public function MediaInfo(response:IMediaResponse) {
			_response = response;
			_props = new Dictionary();
		}
		
		public function getProp(key:String):*
		{
			return _props[key];
		}
		
		public function offStatus(status:String, callback:Function):void
		{
			if (_response) {
				_response.remove(status, callback);
			}
		}
		
		public function onStatus(status:String, callback:Function):void
		{
			if (_response) {
				_response.listen(status, callback);
			}
		}
		
		public function setProp(key:String, value:*):IMediaInfo
		{
			_props[key] = value;
			return this;
		}
		
	}
}