/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.components {
	
	import flash.display.DisplayObject;
	
	public class Layout {
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		public static const NONE:String = "none";
		
	    public var hGap:int = 2;
	    public var vGap:int = 2;
	    public var direction:String = HORIZONTAL;
	
	    public var elms:Array = null;
	    protected var _w:int = 0;
		protected var _wDirty:Boolean = false;
		protected var _h:int = 0;
		protected var _hDirty:Boolean = false;
		protected var _rendered:Function = null;
		internal var _lazyRender:Boolean = false;
		
		public function Layout(rendered:Function = null) {
			elms = [];
			_rendered = rendered;
		}
	
		public function set width(value:int):void {
			_w = value;
			_wDirty = true;
		}
		
	    public function get width():int {
	        return _w;
	    }
		
		public function set height(value:int):void {
			_h = value;
			_hDirty = true;
		}
		
	    public function get height():int {
	        return _h;
	    }
	
	    public function addElms(value:Array):void {
			// 启动延迟更新布局
			_lazyRender = true;
			for each (var d:DisplayObject in value) {
				add(d);
			}
			_lazyRender = false;
	        updateDisplay();
	    }
		
		public function removeElms(value:Array):void {
			_lazyRender = true;
			for each (var d:DisplayObject in value) {
				remove(d);
			}
			_lazyRender = false;
			updateDisplay();
		}
		
	    public function add(elm:DisplayObject):void {
	        var i:int = elms.indexOf(elm);
			// 假如队列里已经有该元素,说明是要把它放到最后的位置
			// 所以需要更新该元素的index,并且重新计算布局
	        if (i != -1)
	            elms.splice(i, 1);
	        elms.push(elm);
	        updateDisplay();
	    }
		
		public function remove(elm:DisplayObject):void {
			var i:int = elms.indexOf(elm);
			if (i != -1) {
				elms.splice(i, 1);
				updateDisplay();
			}
		}
	
	    public function updateDisplay():void {
			if (_lazyRender) return;
			
	        if (elms.length == 0) {
	            _w = 0;
	            _h = 0;
	        } else if (direction == VERTICAL || direction == HORIZONTAL) {
				var elm:DisplayObject = null, mw:int, mh:int;
				for (var i:int = 0; i < elms.length; i ++) {
					elm = elms[i];
					if (direction == HORIZONTAL) {
						elm.x = mw + hGap;
						elm.y = vGap;
						mw = elm.x + elm.width;
						mh = elm.y + (mh < elm.height ? elm.height : mh);
					} else {
						elm.x = hGap;
						elm.y = mh + vGap;
						mh = elm.y + elm.height;
						mw = elm.x + (mw < elm.width ? elm.width : mw);
					}
				}
				_w = mw + hGap;
				_h = mh + vGap;
			} else {
				_w = width;
				_h = height;
			}
			
			if (_rendered != null) _rendered.apply();
	    }
		
	}
}
