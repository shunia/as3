package me.shunia.smedia.core.video
{
	import flash.events.NetStatusEvent;
	import flash.utils.Dictionary;
	
	import me.shunia.smedia.core.interfaces.IMediaResponse;

	public class VideoResponse implements IMediaResponse
	{
		
		private var _nc:Object = null;
		private var _ns:Object = null;
		
		protected var _callDict:Dictionary = null;
		
		public function VideoResponse()
		{
			_callDict = new Dictionary();
		}
		
		public function init():void {
			
		}
		
		public function set netConnection(value:Object):void {
			_nc = value;
			_nc.client = this;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}
		
		public function set netStream(value:Object):void {
			_ns = value;
			_ns.client = this;
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}
		
		protected function onStatus(e:NetStatusEvent):void {
			if (e.info.code) {
				triggerStatus(e.info.code);
			}
		}
		
		public function onMetaData(info:Object):void {
			triggerStatus(VideoStatus.NS_META, info);
		}
		
		public function onBWDone():void {
			triggerStatus(VideoStatus.NS_BW_DONE);
		}
		
		public function onCuePoint(info:Object):void {
			triggerStatus(VideoStatus.NS_CUE, info);
		}
		
		public function onPlayStatus(info:Object):void {
			triggerStatus(info.code);
		}
		
		protected function triggerStatus(type:String, data:Object = null):void {
			//find out the right queue, to split out every callback for calling back
			var vec:Vector.<Function> = _callDict[type];
			if (vec) {
				//loop out every callback
				for each (var func:Function in vec) {
					//try to give out the minimun parameters
					if (func.length == 0) {
						func.apply(null, null);
					} else {
						func.apply(null, [data]);
					}
				}
			}
		}
		
		public function dispose():void {
			//remove ref
			_nc.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_nc = null;
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_ns = null;
			//clean dictionary
			for (var k:String in _callDict) {
				delete _callDict[k];
			}
		}
		
		public function listen(type:String, callback:Function):void {
			//initialize push queue
			var vec:Vector.<Function> = _callDict[type];
			if (!vec) {
				vec = new Vector.<Function>();
				_callDict[type] = vec;
			}
			//if the callback has not been registered, then push into array
			if (vec.indexOf(callback) == -1) {
				vec.push(callback);
			}
		}
		
		public function remove(type:String, callback:Function=null):void {
			//initialize push queue
			var vec:Vector.<Function> = _callDict[type];
			if (vec && vec.indexOf(callback) != -1) {
				//try to remove only when has registered callbacks
				vec.splice(vec.indexOf(callback), 1);
			}
		}
		
	}
}