package me.shunia.smedia.core
{
	import flash.utils.Dictionary;
	
	import me.shunia.smedia.core.interfaces.IMediaConf;
	
	public class MediaConf implements IMediaConf
	{
		
		protected var _onUpdate:Function = null;
		protected var _confs:Dictionary = null;
		protected var _dirty:Dictionary = null;
		
		public function MediaConf(onUpdate:Function) {
			_onUpdate = onUpdate;
			_confs = new Dictionary();
		}
		
		public function getProp(key:String):*
		{
			return _confs[key];
		}
		
		public function setProp(key:String, value:*):IMediaConf
		{
			if (_dirty == null) {
				_dirty = new Dictionary();
				simpleCopy(_confs, _dirty);
			}
			
			var v:* = getProp(key);
			// basic-type-value compare
			var changed:Boolean = v != value;
			
			if (changed) 
				_dirty[key] = value;
			
			return this;
		}
		
		protected function simpleCopy(O:Object, o:Object):void {
			for (var k:String in O) {
				o[k] = O[k];
			}
		}
		
		public function update():void {
			if (_onUpdate != null) {
				_onUpdate(_dirty);
			}
			simpleCopy(_dirty, _confs);
			_dirty = null;
		}
		
	}
}