package me.shunia.smedia.core.video
{
	
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoDisplay extends Sprite
	{
		
		protected var _connection:NetConnection = null;
		protected var _stream:NetStream = null;
		protected var _connectionUrl:String = null;
		protected var _streamUrl:String = null;
		
		protected var _v:Object = null;
		protected var _layout:VideoMediaLayout = null;
		
		public function VideoDisplay()
		{
			super();
			_layout = new VideoMediaLayout(function ():void {
				_v.width = _layout.width;
				_v.height = _layout.height;
			});
		}
		
		public function init():void {
			rebase();
			
			_connection = new NetConnection();
			_stream = new NetStream(null);
		}
		
		public function get layout():VideoMediaLayout {
			return _layout;
		}
		
		public function dispose():void {
			
		}

		public function get connection():NetConnection
		{
			return _connection;
		}

		public function get stream():NetStream
		{
			return _stream;
		}
		
		protected function rebase():void {
			
		}
		
	}
}

class VideoMediaLayout {
	
	internal var _computingWidth:Number = 0;
	internal var _computingHeight:Number = 0;
	internal var _currentWidth:Number = 0;
	internal var _currentHeight:Number = 0;
	internal var _originalWidth:Number = 0;
	internal var _originalHeight:Number = 0;
	internal var _maintainAspectRatio:Boolean = true;
	
	private var _handler:Function = null;
	private var _vi:Object = null;
	
	public function VideoMediaLayout(handler:Function) {
		_handler = handler;
	}
	
	internal function set videoInstance(value:Object):void {
		_vi = value;
	}
	
	public function compute():void {
		if (_vi == null) return;
		
		_currentWidth = videoInstance.width;
		_currentHeight = videoInstance.height;
		if (!_maintainAspectRatio) {
			_currentWidth = _computingWidth ? _computingWidth : _currentWidth;
			_currentHeight = _computingHeight ? _computingHeight : _currentHeight;
		} else {
			var s1:Number = _computingHeight / _currentHeight;
			var s2:Number = _computingWidth / _currentWidth;
			if (s1 < s2) {
				_currentHeight = _computingHeight;
				_currentWidth = _currentWidth * s1;
			} else {
				_currentWidth = _computingWidth;
				_currentHeight = _currentHeight * s2;
			}
		}
		
		if (_handler != null) {
			_handler();
		}
	}
	
	public function get maintainAspectRatio():Boolean
	{
		return _maintainAspectRatio;
	}

	public function set maintainAspectRatio(value:Boolean):void
	{
		_maintainAspectRatio = value;
	}

	public function get originalHeight():Number
	{
		return _originalHeight;
	}

	public function get originalWidth():Number
	{
		return _originalWidth;
	}

	public function get height():Number
	{
		return _currentHeight;
	}

	public function get width():Number
	{
		return _currentWidth;
	}

	public function set computingHeight(value:Number):void
	{
		_computingHeight = value;
	}

	public function set computingWidth(value:Number):void
	{
		_computingWidth = value;
	}

}