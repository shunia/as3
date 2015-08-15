package me.shunia.smedia.core.video
{
	import flash.display.DisplayObject;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import me.shunia.slib.context.Context;
	import me.shunia.slib.debug.LogLevel;
	import me.shunia.smedia.core.SBaseMedia;
	import me.shunia.smedia.core.interfaces.ISMediaInfo;
	
	/**
	 * Basic video media resource for creating video and offering video instance.
	 * 
	 * When creating video, this class also provides a IMediaInfo instance for 
	 * video status wathing, and stream status trigger.
	 * The stream status trigger can recive a VideoStatus string and a callback function,
	 * when stream status happened, the given callback will be triggered, so 
	 * the stream status can be watched and offering the capability to control
	 * the flow of custom needs.
	 *  
	 * @author 庆峰
	 */	
	public class SVideo extends SBaseMedia
	{
		
		/**
		 * Video display object 
		 */		
		protected var _display:SVideoDisplay = null;
		/**
		 * NetStream instance for play video stream. 
		 */		
		protected var _ns:NetStream = null;
		/**
		 * NetConnection instance for connection to the given FMS server, for playing live streams. 
		 */		
		protected var _nc:NetConnection = null;
		/**
		 * The response instance takes the ability of monitering stream status, and stream status triggers.
		 * It will handle all the NetConnection and NetStream status to a consist process.
		 */		
		protected var _response:SVideoResponse = null;
		/**
		 * NetConnection url to connect to. 
		 */		
		protected var _ncUrl:String = null;
		/**
		 * NetStream url to play. 
		 */		
		protected var _nsUrl:String = null;
		/**
		 * Video info instance to offer video instant status monitering. 
		 */		
		protected var _vInfo:SVideoInfo = null;
		/**
		 * Video meta data. 
		 */		
		private var _meta:Object = null;
		
		public function SVideo()
		{
			_display = new SVideoDisplay();
			super();
		}
		
		/**
		 * Use hardware accelerate or not.<br/>
		 * There was some limitation of this property,because of the limitation of flash player itself.Find out the details from actionscript languange reference of StageVideo.<br/>
		 * Also you may need to set the wmode (html properties of flash object) to "direct" to allow this feature to be enabled.  
		 */
		public function get useHardwareAccelerate():Boolean {
			return _display.useHardwareAccelerate;
		}
		
		/**
		 * @private
		 */
		public function set useHardwareAccelerate(value:Boolean):void {
			_display.useHardwareAccelerate = value;
		}

		override public function get display():DisplayObject {
			return _display;
		}
		
		override protected function initMediaInfo():ISMediaInfo {
			_vInfo = new SVideoInfo();
			return _vInfo;
		}
		
		override protected function startLoad():void {
			dispose();
			//create a parser to filter the url into connection url and stream url, and other infomation
			var parser:SVideoUrlParser = new SVideoUrlParser(_url);
			//if split successfully, start initializing
			if (parser.streamName || parser.connection) {
				_ncUrl = parser.connection;
				_nsUrl = parser.streamName;
				//init connection and response instance for listening up
				init();
				//actually trigger the connection process
				startConnection();
			} else {
				Context.log(LogLevel.ERROR, "[video]", "Url parser error ->" + _url);
			}
		}
		
		protected function init():void {
			_nc = new NetConnection();
			_response = new SVideoResponse();
			//register connection.success code for initializing netstream instance
			_response.listen(SVideoStatus.NC_CONNECT_SUCC, onConnectionSucc);
			_response.listen(SVideoStatus.NS_META, onMeta);
			_response.listen(SVideoStatus.NS_DIMENSION_CHANGE, onVideoPropAvalible);
			_response.listen(SVideoStatus.NS_FULL, onVideoPropAvalible);
			_response.netConnection = _nc;
			_vInfo.response = _response;
		}
		
		/**
		 * When dimension-change(Specific event dispatched by Di lian cdn) or
		 * Buffer full comes, video actual width and height maybe available.
		 */		
		private function onVideoPropAvalible():void {
			if (_display.video) {
				_display.videoWidth = _display.video.videoWidth;
				_display.videoHeight = _display.video.videoHeight;
			}
		}
		
		/**
		 * When meta data event is triggered, the video width or height may be 
		 * available.
		 *  
		 * @param info
		 */		
		private function onMeta(info:Object):void {
			if (info) {
				_meta = info;
				if (info.width) {
					_display.videoWidth = info.width;
				}
				if (info.height) {
					_display.videoHeight = info.height;
				}
				if (info.fps) {
					_vInfo.videoFps = info.fps;
				}
			}
		}
		
		/**
		 * After successfully initialized netConnection, 
		 * create the netStream instance immediately,
		 * and start playing the given stream.
		 */		
		private function onConnectionSucc():void {
			_ns = new NetStream(_nc);
			_response.netStream = _ns;
			_ns.bufferTime = _bufferTime;
			_ns.useHardwareDecoder = true;
			_ns.play(_nsUrl);
			_display.attachNetStream(_ns);
		}
		
		/**
		 * Start connecting to the server, or when playing remote video files, 
		 * connecting to null to create a local connection. 
		 */		
		protected function startConnection():void {
			_nc.connect(_ncUrl);
		}
		
		override public function dispose():void {
			if (_response) {
				_response.dispose();
				_response = null;
			}
			if (_ns) {
				_ns.dispose();
				_ns = null;
			}
			if (_nc) {
				_nc.close();
				_nc.client = null;
				_nc = null;
			}
			if (_display) {
				_display.attachNetStream(null);
			}
		}
		
	}
}