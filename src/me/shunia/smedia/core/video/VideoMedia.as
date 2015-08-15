package me.shunia.smedia.core.video
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import me.shunia.smedia.core.BaseMedia;
	
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
	public class VideoMedia extends BaseMedia
	{
		/**
		 * NetStream instance for play video stream. 
		 */		
		protected var _ns:NetStream = null;
		/**
		 * NetConnection instance for connection to the given FMS server, for playing live streams. 
		 */		
		protected var _nc:NetConnection = null;
		/**
		 * NetConnection url to connect to. 
		 */		
		protected var _ncUrl:String = null;
		/**
		 * NetStream url to play. 
		 */		
		protected var _nsUrl:String = null;
		protected var _isPaused:Boolean = false;
		
		protected var _videoDisplay:VideoDisplay = null;
		/**
		 * The response instance takes the ability of monitering stream status, and stream status triggers.
		 * It will handle all the NetConnection and NetStream status to a consist process.
		 */		
		protected var _videoResponse:VideoResponse = null;
		protected var _videoInfo:VideoMediaInfo = null;
		protected var _videoConf:VideoMediaConf = null;
		
		public function VideoMedia()
		{
			super();
			_videoDisplay = new VideoDisplay();
			_videoResponse = new VideoResponse();
			_videoInfo = new VideoMediaInfo(_videoResponse);
			_videoConf = new VideoMediaConf(onChanged);
			// public linkage
			_display = _videoDisplay;
			_info = _videoInfo;
			_conf = _videoConf;
			// to init with default properties
			_videoConf.init();
		}
		
		protected function onVideoReady():void {
			
		}
		
		protected function onChanged(o:Object):void {
			if (o.hasOwnProperty(VideoConfProps.URL)) 
				startLoad(o);
			
			grabInfo();
		}
		
		protected function startLoad(conf:Object):void {
			_videoResponse.init();
			_videoInfo.init();
			_videoDisplay.init();
			
			_videoResponse.netConnection = _videoDisplay.connection;
			_videoResponse.netStream = _videoDisplay.stream;
			//create a parser to filter the url into connection url and stream url, and other infomation
			var parser:VideoUrlParser = new VideoUrlParser(conf[VideoConfProps.URL]);
			//if split successfully, start initializing
			if (parser.streamName || parser.connection) {
				_ncUrl = parser.connection;
				_nsUrl = parser.streamName;
				//init connection and response instance for listening up
				init();
			} else {
				trace("[video]", "Url parser error ->" + conf[VideoConfProps.URL]);
			}
		}
		
		protected function init():void {
			_nc = new NetConnection();
			//register connection.success code for initializing netstream instance
			_info.onStatus(VideoStatus.NC_CONNECT_SUCC, onConnectionSucc);
			_info.onStatus(VideoStatus.NS_META, onMeta);
			_info.onStatus(VideoStatus.NS_DIMENSION_CHANGE, onVideoPropAvalible);
			_info.onStatus(VideoStatus.NS_FULL, onVideoPropAvalible);
//			_response.netConnection = _nc;
			_nc.connect(_ncUrl);
		}
		
		/**
		 * When 'dimension change'(Specific event dispatched by Di lian cdn) or
		 * 'buffer full' comes,the actual width and height of the video maybe available.
		 */		
		private function onVideoPropAvalible():void {
//			_vInfo.videoWidth = _v.videoWidth;
//			_vInfo.videoHeight = _v.videoHeight;
		}
		
		/**
		 * When meta data event is triggered, the video width or height may be 
		 * available.
		 *  
		 * @param info
		 */		
		private function onMeta(info:Object):void {
			var s:String = "{\n";
			for (var k:String in info) {
				s += k + ":" + info[k] + ",\n";
			}
			s += "}";
			trace("info: " + s);
			
//			if (info.width) 
//				_layout._originalWidth = info.width;
//			if (info.height) 
//				_layout._originalHeight = info.height;
			
			grabInfo();
		}
		
		/**
		 * After successfully initialized netConnection, 
		 * create the netStream instance immediately,
		 * and start playing the given stream.
		 */		
		private function onConnectionSucc():void {
			_ns = new NetStream(_nc);
			_ns.inBufferSeek = true;
//			_response.netStream = _ns;
			_ns.bufferTime = _conf.getProp(VideoConfProps.BUFFER_TIME);
			_ns.useHardwareDecoder = _conf.getProp(VideoConfProps.HARDWARE_ACCELARATE);
			if (_conf.getProp(VideoConfProps.AUTO_PLAY)) {
				play();
			}
//			_v.attachNetStream(_ns);
		}
		
		override public function play():void {
			if (_isPaused) {
				_isPlaying = true;
				_isPaused = false;
				_ns.resume();
			} else {
				try {
					_ns.play(_nsUrl);
					
					_isPlaying = true;
				} catch (e:Error) {
					_isPlaying = false;
				}
			}
		}
		
		override public function pause():void {
			_ns.pause();
			_isPaused = true;
			_isPlaying = true;
		}
		
		override public function seek(time:int):void {
			_isPaused = true;
			
			_ns.seek(time);
		}
		
		override public function stop():void {
			try {
				_ns.close();
				_isPlaying = false;
				_isPaused = false;
			} catch (e:Error) {}
		}
		
		protected function grabInfo():void {
			_info.setProp(VideoInfoProps.URL, _conf.getProp(VideoConfProps.URL));
			_info.setProp(VideoInfoProps.ISPLAYING, _isPlaying);
			_info.setProp(VideoInfoProps.HEIGHT_DISPLAYING, _videoDisplay.layout.height);
			_info.setProp(VideoInfoProps.WIDTH_DISPLAYING, _videoDisplay.layout.width);
			_info.setProp(VideoInfoProps.WIDTH_ORIGINAL, _videoDisplay.layout.originalWidth);
			_info.setProp(VideoInfoProps.HEIGHT_ORIGINAL, _videoDisplay.layout.originalHeight);
		}
		
		override public function dispose():void {
			stop();
			
			if (_videoResponse) {
				_videoResponse.dispose();
			}
			if (_videoDisplay) {
				_videoDisplay.dispose();
			}
		}
		
	}
}