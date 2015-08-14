package me.shunia.components
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;

	/**
	 * 类似Flex中的Divider,可伸缩的分割容器.根据提供的现实对象数目划分分割区间.<br/>
	 * 需要注意的是,因为纯AS3种的Sprite设置高宽是无效的,所以需要填入到Divider中的现实对象一定要支持set width/height.
	 *  
	 * @author qingfenghuang
	 */	
	public class Divider extends Sprite
	{
		
		public static const DIRECTION_VERTICAL:String = "vertical";
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		protected static const DEFAULT_MIN_GAP:int = 30;
		protected static const DEFAULT_LINE_LENGTH:int = 10;
		protected static const DEFAULT_GAP:int = 5;
		
		protected var _props:PropConfig = null;
		protected var _wrapper:Panel = null;
		protected var _line:Sprite = null;
		protected var _length:int = 0;
		protected var _width:int = 0;
		protected var _part1:DisplayObject = null;
		protected var _part2:DisplayObject = null;
		protected var _direction:String = DIRECTION_VERTICAL;
		protected var _drag:Drag = null;
		
		public function Divider()
		{
			super();
			
			_props = new PropConfig();
		}
		
		public function get percent():int {
			return _line ? 
				(_direction == DIRECTION_VERTICAL ? 
					_line.y / height * 100 : _line.x / width * 100)
				: (_part1 ? 1 * 100 : 0);
		}
		
		public function setProp(k:String, value:*):Divider {
			_props.setProp(k, value);
			return this;
		}
		
		public function update():void {
			grepProps();
			createLine();
			prepareContainer();
			alignParts();
			listenForInteraction();
			updateCursor();
			initPercentage();
			finnalWork();
		}
		
		public static const P_PARTS:String = "parts";
		public static const P_PERCENT:String = "percent";
		public static const P_CURSOR:String = "cursor";
		public static const P_ASSET:String = "asset";
		public static const P_LENGTH:String = "length";
		public static const P_DIRECTION:String = "direction";
		public static const P_GAP:String = "gap";
		
		public function grepProps():void {
			_length = _props.safeProp(P_LENGTH, _length ? _length : DEFAULT_LINE_LENGTH);
			_direction = _props.safeProp(P_DIRECTION, _direction ? _direction : DIRECTION_VERTICAL);
		}
		
		protected function createLine():void {
			var a:DisplayObject = _props.safeProp(P_ASSET, null);
			if (!_line) {
				_line = new Sprite();
				_line.name = "divider_line";
				_line.buttonMode = true;
				_line.useHandCursor = true;
			}
			if (a) {
				while (_line.numChildren) _line.removeChildAt(0);
				_line.addChild(a);
			} else {
				if (!_line.numChildren) {
					var s:Shape = new Shape();
					s.graphics.lineStyle(1, 0x460620, .8);
					if (_direction == DIRECTION_VERTICAL) 
						s.graphics.lineTo(0, _length);
					else 
						s.graphics.lineTo(_length, 0);
					s.graphics.endFill();
					_line.addChild(s);
				}
			}
			if (_direction == DIRECTION_VERTICAL) {
				_line.width = _length - DEFAULT_GAP * 4;
				_line.x = DEFAULT_GAP * 2;
			}
			else {
				_line.height = _length - DEFAULT_GAP * 4;
				_line.y = DEFAULT_GAP * 2;
			}
		}
		
		protected function updateCursor():void {
			var cursor:BitmapData = _props.safeProp(P_CURSOR, null);
			if (cursor) {
				var d:MouseCursorData = new MouseCursorData();
				d.data = new Vector.<BitmapData>();
				d.data.push(cursor);
				d.hotSpot = new Point(cursor.width / 2, cursor.height / 2);
				Mouse.registerCursor("drag", d);
			}
		}
		
		protected function prepareContainer():void {
			if (!_wrapper) {
				_wrapper = new Panel();
				addChild(_wrapper);
			}
			var gap:int = _props.safeProp(P_GAP, DEFAULT_GAP);
			_wrapper.layout.direction = _direction;
			if (_direction == Layout.VERTICAL) {
				_wrapper.layout.hGap = 0;
				_wrapper.layout.vGap = gap;
			} else {
				_wrapper.layout.hGap = gap;
				_wrapper.layout.vGap = 0;
			}
			_wrapper.layout.updateDisplay();
		}
		
		protected function alignParts():void {
			var parts:Array = _props.safeProp(P_PARTS, [_part1, _part2]);
			_part1 = parts.length ? parts[0] : null;
			_part2 = parts.length > 1 ? parts[1] : null;
			_wrapper.removeAll();
			if (_part1) 
				_wrapper.add(_part1);
			if (_part2) 
				_wrapper.add(_line);
			if (_part2) 
				_wrapper.add(_part2);
			_width = _width ? _width : 
				(_direction == DIRECTION_VERTICAL ? _wrapper.height : _wrapper.width);
		}
		
		protected function listenForInteraction():void {
			var reset:Boolean = false;
			if (_drag && _drag.target != _line) {
				reset = true;
				_drag.dispose();
			}
			if (!_drag) {
				reset = true;
				_drag = new Drag(null, null);
			}
			
			if (reset) {
				_drag.setUp(_line, function (x:int, y:int):void {
						//拖动导致的高宽改变会设置一个最低范围 - DEFAULT_MIN_GAP
						if (_direction == DIRECTION_VERTICAL) {
							if ((_part1.height + y) < DEFAULT_MIN_GAP
								|| (_part2.height - y) < DEFAULT_MIN_GAP) return;
						} else {
							if ((_part1.width + x) < DEFAULT_MIN_GAP
								|| (_part2.width - x) < DEFAULT_MIN_GAP) return;
						}
						updateDivider(x, y);
					});
				_drag.start();
			}
		}
		
		protected function initPercentage():void {
			var p:* = _props.getProp(P_PERCENT);
			if (p != null) {
				var percent:int = parseInt(p);
				if (percent < 0) percent = 0;
				else if (percent > 100) percent = 100;
				if (percent == 0) {
					_wrapper.remove(_part1);
					_wrapper.remove(_line);
					_wrapper.add(_part2);
				} else if (percent == 100) {
					_wrapper.remove(_line);
					_wrapper.remove(_part2);
					_wrapper.add(_part1);
				} else {
					_wrapper.add(_part1);
					_wrapper.add(_line);
					_wrapper.add(_part2);
				}
				
				if (_direction == DIRECTION_VERTICAL) 
					updateDivider(0, _width * percent / 100 - _line.y);
				else 
					updateDivider(_width * percent / 100 - _line.x, 0);
			}
		}
		
		protected function updateDivider(x:int, y:int):void {
			if (_direction == DIRECTION_VERTICAL) {
				_part1.height += y;
				_part2.height -= y;
			} else {
				_part1.width += x;
				_part2.width -= x;
			}
			_wrapper.layout.updateDisplay();
		}
		
		override public function get height():Number {
			return _wrapper ? _wrapper.height : super.height;
		}
		
		override public function get width():Number {
			return _wrapper ? _wrapper.width : super.width;
		}
		
		protected function finnalWork():void {
		}
		
	}
}