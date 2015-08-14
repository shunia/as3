package me.shunia.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class NewDivider extends Panel
	{
		
		public static const VERTICAL:String = Layout.VERTICAL;
		public static const HORIZONTAL:String = Layout.HORIZONTAL;
		
		public static const P_DIRECTION:String = "direction";
		public static const P_HGAP:String = "hGap";
		public static const P_VGAP:String = "vGap";
		public static const P_CONTENTS:String = "contents";
		public static const P_ASSET_LINE:String = "assetLine";
		public static const P_MIN_PART_SIZE:String = "minPartSize";
		
		protected var _line:DisplayObject = null;
		protected var _c1:DisplayObject = null;
		protected var _c2:DisplayObject = null;
		protected var _drag:Drag = null;
		protected var _props:PropConfig = null;
		protected var _minPartSize:Number = 0;
		
		public function NewDivider()
		{
			super();
			_props = new PropConfig();
			layout.direction = VERTICAL;
			layout.vGap = layout.vGap = 0;
		}
		
		public function setProp(k:String, value:*):NewDivider {
			_props.setProp(k, value);
			return this;
		}
		
		public function update():NewDivider {
			clean();
			updateProps();
			updateContents();
			updateLine();
			combine();
			onEvents();
			return this;
		}
		
		protected function clean():void {
			removeAll();
			_line = null;
			_c1 = null;
			_c2 = null;
			if (_drag) _drag.dispose();
			_drag = null;
		}
		
		protected function updateProps():void {
			if (_props.hasPorp(P_DIRECTION)) layout.direction = _props.safeProp(P_DIRECTION, layout.direction);
			if (_props.hasPorp(P_HGAP)) layout.hGap = _props.safeProp(P_HGAP, layout.hGap);
			if (_props.hasPorp(P_VGAP)) layout.vGap = _props.safeProp(P_VGAP, layout.vGap);
			if (_props.hasPorp(P_MIN_PART_SIZE)) _minPartSize = _props.safeProp(P_MIN_PART_SIZE, _minPartSize);
		}
		
		protected function updateContents():void {
			if (_props.hasPorp(P_CONTENTS)) {
				var a:Array = _props.safeProp(P_CONTENTS, null);
				if (a && a.length) _c1 = a.shift();
				if (a && a.length) _c2 = a.shift();
			}
		}
		
		protected function updateLine():void {
			// 如果不是同时有两个对象,那么根本不需要生成分隔线
			if (!(_c1 && _c2)) return;
			
			if (_props.hasPorp(P_ASSET_LINE)) {
				var d:* = _props.safeProp(P_ASSET_LINE, null);
				if (d) {
					if (d is DisplayObject) {
						_line = d;
					} else if (d is Class) {
						_line = new d() as DisplayObject;
						if (!_line) generateDefaultLine();
					} else 
						generateDefaultLine();
				} else 
					generateDefaultLine();
			} else 
				generateDefaultLine();
			// 手型 
			if (!_line.hasOwnProperty("useHandCursor") && !_line.hasOwnProperty("buttonMode")) 
				_line = new Sprite().addChild(_line);
			(_line as Sprite).useHandCursor = true;
			(_line as Sprite).buttonMode = true;
			// 添加个名字方便debug
			_line.name = "divider_line";
		}
		
		protected function generateDefaultLine():void {
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(2, 0x460620, .8);
			if (layout.direction == VERTICAL) {
				var mw:Number = Math.max(_c1.width, _c2.width);
				s.graphics.lineTo(mw - layout.hGap * 2, 0);
			} else {
				var mh:Number = Math.max(_c1.height, _c2.height);
				s.graphics.lineTo(mh - layout.vGap * 2, 0);
			}
			s.graphics.endFill();
			
			_line = s;
		}
		
		protected function combine():void {
			if (_c1) add(_c1);
			if (_line) add(_line);
			if (_c2) add(_c2);
		}
		
		protected function onEvents():void {
			if (_line) {
				// 添加拖动侦听
				if (!_drag) _drag = new Drag();
				_drag.setUp(_line, onDividing, lineBound);
				_drag.start();
			}
		}
		
		protected function get lineBound():Rectangle {
			var r:Rectangle = new Rectangle();
			if (layout.direction == VERTICAL) {
				r.x = _line.x;
				r.y = _minPartSize;
				r.width = _line.width;
				r.height = height - _minPartSize * 2;
			} else {
				r.x = _minPartSize;
				r.y = _line.y;
				r.width = width - _minPartSize * 2;
				r.height = _line.height;
			}
			return r;
		}
		
		protected function onDividing(dx:Number, dy:Number):void {
			if (layout.direction == VERTICAL) {
				_c1.height += dy;
				_c2.height -= dy;
			} else {
				_c1.width += dx;
				_c2.width -= dx;
			}
			layout.updateDisplay();
		}
		
	}
}