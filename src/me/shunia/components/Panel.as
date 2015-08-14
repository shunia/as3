/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.components {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Panel extends Sprite{
		
		/**
		 * Panel用Layout来进行布局计算,这就是该layout的定义.
		 */		
	    protected var _layout:Layout = new Layout(paint);
		/**
		 * 可以启动debug模式来观察该控件的实际区域 
		 */		
		protected var _debug:Boolean = false;
		/**
		 * 设置的高宽 
		 */		
		protected var _w:int = 0;
		/**
		 * 设置的高宽 
		 */		
		protected var _h:int = 0;
		/**
		 * 可以设置背景,会自动计算尺寸并扩展 
		 */		
		protected var _bg:DisplayObject = null;
		/**
		 * 设置位图数据当背景 
		 */		
		protected var _bgGraphic:BitmapData = null;
		/**
		 * debug的时候用来画背景的颜色 
		 */		
		protected var _defaultPaintColor:uint = 0;
		/**
		 * debug的时候用来画背景的透明度 
		 */		
		protected var _defaultPaintAlpha:Number = 0;
		
		public function set lazyRender(value:Boolean):void {
			_layout._lazyRender = value;
		}
		
		public function set background(value:*):void {
			if (value is DisplayObject) 
				_bg = value;
			else if (value is Class) 
				_bg = new value();
		}
		
		override public function set width(value:Number):void {
			if (value && value != _w) {
				_w = value;
				paint();
			}
		}
		override public function get width():Number {
			return _w ? _w : _layout.width;
		}
		
		override public function set height(value:Number):void {
			if (value && value != _h) {
				_h = value;
				paint();
			}
		}
		override public function get height():Number {
			return _h ? _h : _layout.height;
		}
		
		public function set debug(value:Boolean):void {
			_debug = value;
			paint();
		}
	    public function get layout():Layout {
	        return _layout;
	    }
	    public function get elements():Array {
	        return _layout.elms;
	    }
		
	    public function add(d:DisplayObject):DisplayObject {
			if (!contains(d)) {
		        addChild(d);
			}
			_layout.add(d);
	        return d;
	    }
		
		public function remove(d:DisplayObject):void {
			if (d && contains(d)) {
				removeChild(d);
				_layout.remove(d);
			}
		}
		
		public function removeAll():void {
			lazyRender = true;
			for each (var d:DisplayObject in _layout.elms) {
				remove(d);
			}
			lazyRender = false;
			_layout.updateDisplay();
		}
		
		/**
		 * 每次layout计算过布局就会调用这个方法来更新背景区域,可以方便获取此控件的高宽.<br/>
		 * 可以覆写来实现自己的更新逻辑.
		 */		
		protected function paint():void {
			if (_bg && !contains(_bg) && layout.elms.length) 
				addChildAt(_bg, 0);
			if (_bg) {
				_bg.width = width;
				_bg.height = height;
			}
			if (!_bg) {
				graphics.clear();
				var c:uint = _debug ? Math.random() * 0xFFFFFF : _defaultPaintColor;
				var a:Number = _debug ? 1 : _defaultPaintAlpha;
				graphics.beginFill(c, a);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
		}
	
	    public function clear():void {
	        while (numChildren) removeChildAt(0);
	        _layout.addElms([]);
	        graphics.clear();
	    }
	
	}
}
