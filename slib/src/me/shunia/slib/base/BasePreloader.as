package me.shunia.slib.base
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import me.shunia.slib.util.PathUtil;

	public class BasePreloader extends StageIniator
	{
		
		protected var _loader:Loader = null;
		protected var _loaderRequest:URLRequest = null;
		
		protected var _relativePathToMainSWF:String = null;
		
		public function BasePreloader(path:String)
		{
			_relativePathToMainSWF = path;
			super(false);
		}
		
		override protected function init():void {
			super.init();
			
			if (_relativePathToMainSWF) {
				var url:String = stage.loaderInfo.url.substring(0, stage.loaderInfo.url.lastIndexOf("/"));
				url = PathUtil.resolve(url, _relativePathToMainSWF);
				startLoad(url);
			}
		}
		
		protected function startLoad(url:String):void {
			var c:LoaderContext = new LoaderContext(true);
			_loaderRequest = new URLRequest(url);
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.load(_loaderRequest, c);
		}
		
		protected function onError(event:IOErrorEvent):void {
			
		}
		
		protected function onInit(event:Event):void {
			
		}
		
		protected function onProgress(event:ProgressEvent):void {
			
		}
		
		protected function onComplete(event:Event):void {
			addChild(_loader.content);
		}
		
	}
}