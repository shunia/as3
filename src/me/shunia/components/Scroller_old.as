package me.shunia.components
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="change", type="me.shunia.components.CompEvents")]
	
	public class Scroller_old extends Sprite
	{
		
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		public static const DIRECTION_VERTICAL:String = "vertical";
		/**
		 * 表示滚动条中添加的元素当超出显示区域时,滚动方向:</br>
		 * 	&nbsp1.当方向为垂直时:从上至下滚动</br>
		 * 	&nbsp2.当方向为水平时:从左至右滚动
		 */
		public static const PREFER_TOP:String = "preferTop";
		/**
		 * 表示滚动条中添加的元素超出显示区域,滚动方向:</br>
		 * 	&nbsp1.当方向为垂直时:从下至上滚动</br>
		 * 	&nbsp2.当方向为水平时:从右至左滚动
		 */
		public static const PREFER_BOTTOM:String = "preferBottom";

		protected static const DEFAULT_WIDTH:int = 200;
		protected static const DEFAULT_HEIGHT:int = 200;
		
		protected static const PIXEL_PER_SCROLL_BY_WHEEL:int = 20;

		protected var _props:PropConfig = null;
		protected var _w:int = 0;
		protected var _h:int = 0;
		protected var _tw:int = 0;
		protected var _th:int = 0;
		protected var _mask:Shape = null;
		protected var _target:DisplayObject = null;
		protected var _bar:ScrollerBarInternal = null;
		protected var _calculator:ScrollerCalculator = null;

		public function Scroller_old()
		{
			super();
			_props = new PropConfig();
		}
		
		internal function setPropDelegation(props:PropConfig):Scroller_old {
			_props = props;
			return this;
		}

		public function setProp(k:String, value:*):Scroller_old {
			_props.setProp(k, value);
			return this;
		}

		public function update():Scroller_old {
			clear();
			prepareTarget();
			prepareScroller();
			prepareSize();
			updateCalculator();
			createScroller();
			updateMask();
			updateBackground();
			handleMouseInteraction();
			calculate();
			mostStrangeHackEver();
			
			_props = new PropConfig();
			return this;
		}
		
		/**
		 * http://stackoverflow.com/a/18971471/1519679 
		 * 用来指示当前容器不给出真实高宽,而是只给出mask区域高宽
		 */		
		protected function mostStrangeHackEver():void {
			new BitmapData(1, 1).draw(this);
		}

		public function clear():void {
			removeEventListener(Event.ENTER_FRAME, checkUpdate);
		}

		protected function prepareTarget():void {
			var nt:DisplayObject = _props.safeProp(P_TARGET, null);
			if (nt && nt != _target) {
				if (_target && contains(_target))
					removeChild(_target);

				_target = nt;
				addChildAt(_target, 0);
			}
			_tw = _target.width;
			_th = _target.height;
		}
		
		protected function prepareScroller():void {
			addEventListener(Event.ENTER_FRAME, checkUpdate);
		}
		
		protected function prepareSize():void {
			if (_props.hasPorp(P_WIDTH))
				_w = _props.safeProp(P_WIDTH, 0);
			else
				if (_w <= 0) _w = DEFAULT_WIDTH;
			if (_props.hasPorp(P_HEIGHT))
				_h = _props.safeProp(P_HEIGHT, 0);
			else
				if (_h <= 0) _h = DEFAULT_HEIGHT;
		}

		protected function checkUpdate(e:Event = null):void {
			var tmpw:int = _target.width,
				tmph:int = _target.height;
			if (tmpw != _tw || tmph != _th) {
				_tw = tmpw;
				_th = tmph;
				calculate();
			}
		}

		protected function createScroller():void {
			if (!_bar) {
				_bar = new ScrollerBarInternal(onContentScroll);
				addChild(_bar);
			}
			_bar.setPropDelegation(_props.clone())
				.update();
		}
		
		protected function updateCalculator():void {
			if (!_calculator) _calculator = new ScrollerCalculator();
			if (_props.hasPorp(Scroller_old.P_DIRECTION))
				_calculator.direction = _props.safeProp(Scroller_old.P_DIRECTION, _calculator.direction);
			if (_props.hasPorp(Scroller_old.P_PREFER))
				_calculator.prefer = _props.safeProp(Scroller_old.P_PREFER, _calculator.prefer);
			if (_props.hasPorp(Scroller_old.P_LOCK))
				_calculator.lock = _props.safeProp(Scroller_old.P_LOCK, _calculator.lock);
		}

		protected function onContentScroll(dx:int, dy:int):void {
			_calculator.scrollBy(dx, dy);
			applyCalculatedValues();
			
			var e:CompEvents = new CompEvents(CompEvents.CHANGE, true);
			e.params = [_calculator.targetRect, _calculator.viewRect];
			dispatchEvent(e);
		}

		protected function updateMask():void {
			if (!_mask) {
				_mask = new Shape();
				addChild(_mask);
				this.mask = _mask;
			}
			if (_bar) {
				var mh:int = _h,
					mw:int = _w;
				if (_calculator.direction == DIRECTION_VERTICAL) {
					_bar.x = mw;
					mw += _bar.width;
				} else {
					_bar.y = mh;
					mh += _bar.height;
				}
				if (_mask.width != mw || _mask.height != mh) {
					_mask.graphics.clear();
					_mask.graphics.beginFill(0, 1);
					_mask.graphics.drawRect(0, 0, mw, mh);
					_mask.graphics.endFill();
				}
			}
		}
		
		protected function updateBackground():void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _mask.width, _mask.height);
			graphics.endFill();
		}
		
		protected function handleMouseInteraction():void {
			if (!hasEventListener(MouseEvent.MOUSE_WHEEL)) 
				addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		protected function onWheel(event:MouseEvent):void {
			if (_calculator.direction == DIRECTION_VERTICAL) 
				onContentScroll(0, event.delta * PIXEL_PER_SCROLL_BY_WHEEL);
			else 
				onContentScroll(event.delta * PIXEL_PER_SCROLL_BY_WHEEL, 0);
		}

		protected function calculate():void {
			var targetRect:Rectangle = new Rectangle(_target.x, _target.y, _target.width, _target.height),
				viewRect:Rectangle = new Rectangle(_mask.x, _mask.y, _mask.width, _mask.height);
			_calculator.targetRect = targetRect;
			_calculator.viewRect = viewRect;
			_calculator.calculate();
			applyCalculatedValues();
		}
		
		protected function applyCalculatedValues():void {
			_target.x = _calculator.targetRect.x;
			_target.y = _calculator.targetRect.y;
			
			// 在这里更新滚动条本身的状态,这里使用目标区域和视图区域进行计算
			if (_bar) {
				_bar.setProp(ScrollerBarInternal.P_TARGET_RECT, _calculator.targetRect)
					.setProp(ScrollerBarInternal.P_VIEW_RECT, _calculator.viewRect)
					.setProp(ScrollerBarInternal.P_DIRECTION, _calculator.direction)
					.update();
			}
		}

//		override public function get width():Number {
//			return _mask ? _mask.width : 0;
//		}
//
//		override public function get height():Number {
//			return _mask ? _mask.height : 0;
//		}

		public static const P_THUMB:String = "thumb";
		public static const P_THUMB_TRACK:String = "thumb_track";
		public static const P_TARGET:String = "target";
		public static const P_DIRECTION:String = "direction";
		public static const P_WIDTH:String = "width";
		public static const P_HEIGHT:String = "height";
		public static const P_ALWAYS_SHOW_SCROLLER:String = "always_show_scroller";
		public static const P_PREFER:String = "prefer";
		public static const P_LOCK:String = "lock";

	}
}
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Rectangle;

import me.shunia.components.Drag;
import me.shunia.components.PropConfig;
import me.shunia.components.Scroller_old;

class ScrollerBarInternal extends Sprite {
	
	/**
	 * TARGET_RECT和VIEW_RECT,THUMB_RECT和TRACK_RECT,这两对都可以用来计算滚动条的位置信息.
	 * 根据实际情况选择即可. 
	 */	
	public static const P_TARGET_RECT:String = "targetRect";
	public static const P_VIEW_RECT:String = "viewRect";
	public static const P_THUMB_RECT:String = "thumbRect";
	public static const P_TRACK_RECT:String = "trackRect";
	public static const P_DIRECTION:String = "direction";

	protected var _thumb:DisplayObject = null;
	protected var _track:DisplayObject = null;
	protected var _assetDirty:Boolean = false;
	protected var _drag:Drag = null;
	protected var _cb:Function = null;
	protected var _direction:String = Scroller_old.DIRECTION_VERTICAL;
	protected var _pPos:String = "y";
	protected var _pSize:String = "height";
	protected var _alwaysShow:Boolean = false;
	
	protected var _props:PropConfig = null;

	public function ScrollerBarInternal(cb:Function = null) {
		_cb = cb;
		if (!_props) _props = new PropConfig();
		// 初始化一个默认的滚动条素材.免得没提供素材的情况下报错
		var thumb:Sprite = new Sprite();
		thumb.graphics.beginFill(0xCCCCCC, .8);
		thumb.graphics.drawRect(0, 0, 5, 10);
		thumb.graphics.endFill();
		_thumb = thumb;
		var track:Shape = new Shape();
		track.graphics.beginFill(0, .8);
		track.graphics.drawRect(0, 0, 5, 10);
		track.graphics.endFill();
		_track = track;
		
		buttonMode = true;
		useHandCursor = true;
	}
	
	public function setPropDelegation(prop:PropConfig):ScrollerBarInternal {
		_props = prop;
		return this;
	}

	public function setProp(k:String, value:*):ScrollerBarInternal {
		_props.setProp(k, value);
		return this;
	}

	public function update():void {
		updateBar();
		updateBarPosition();
		updateDrag();
		_props = new PropConfig();
	}

	protected function updateBar():void {
		// 几率是否替换了素材
		_assetDirty = false;
		// 先尝试替换素材引用
		if (_props.hasPorp(Scroller_old.P_THUMB_TRACK)) {
			var track:DisplayObject = _props.safeProp(Scroller_old.P_THUMB_TRACK, null);
			if (track != _track) {
				_track = track;
				_assetDirty = true;
			}
		}
		if (_props.hasPorp(Scroller_old.P_THUMB)) {
			var thumb:DisplayObject = _props.safeProp(Scroller_old.P_THUMB, null);
			if (thumb != _thumb) {
				_thumb = thumb;
				_assetDirty = true;
			}
		}

		if (_assetDirty) {
			// 清空
			while (numChildren) removeChildAt(0);
			// 逐一添加样式,并重新计算尺寸
			if (_track && !contains(_track)) addChild(_track);
			if (_thumb && !contains(_thumb)) addChild(_thumb);
		}
	}
	
	protected function updateDrag():void {
		if (!_drag) 
			_drag = new Drag(null, null);
		if (_drag.target != _thumb) {
			_drag.setUp(_thumb, onBarScroll);
			_drag.start();
		}
	}

	protected function onBarScroll(dx:int, dy:int):void {
		if (_cb != null) _cb(dx, dy);
	}

	protected function updateBarPosition():void {
		var d:String = _props.safeProp(P_DIRECTION, _direction);
		_pSize = d == Scroller_old.DIRECTION_VERTICAL ? "height" : "width";
		_pPos = d == Scroller_old.DIRECTION_VERTICAL ? "y" : "x";
		if (_props.hasPorp(P_TARGET_RECT) && _props.hasPorp(P_VIEW_RECT)) {
			var t:Rectangle = _props.safeProp(P_TARGET_RECT, null),
				v:Rectangle = _props.safeProp(P_VIEW_RECT, null);
			// 用目标区域和可视区域进行计算
			_track[_pSize] = v[_pSize];
			_thumb[_pSize] = t[_pSize] < v[_pSize] ? 
				v[_pSize] : v[_pSize] / t[_pSize] * v[_pSize];
			_thumb[_pPos] = v[_pPos] - t[_pPos] / v[_pSize] * _thumb[_pSize];
		} else if (_props.hasPorp(P_THUMB_RECT) && _props.hasPorp(P_TRACK_RECT)) {
			// 用滚动条和滚动槽进行计算
			var h:Rectangle = _props.safeProp(P_THUMB_RECT, null),
				r:Rectangle = _props.safeProp(P_TRACK_RECT, null);
			// TODO
		}
		if (_props.hasPorp(Scroller_old.P_ALWAYS_SHOW_SCROLLER)) 
			_alwaysShow = _props.safeProp(Scroller_old.P_ALWAYS_SHOW_SCROLLER, _alwaysShow);
		this.visible = _alwaysShow ? _alwaysShow : (_track[_pSize] != _thumb[_pSize]);
	}
	
}

class ScrollerCalculator {
	
	public var direction:String = Scroller_old.DIRECTION_VERTICAL;
	public var prefer:String = Scroller_old.PREFER_TOP;
	
	public var targetRect:Rectangle = null;
	public var viewRect:Rectangle = null;

	protected var _lock:Boolean = false;
	public function set lock(value:Boolean):void {
		_lock = value;
		_lastTargetPosSaved = !_lock;
	}
	public function get lock():Boolean {
		return _lock;
	}
	
	protected var _lastTargetPos:int = 0;
	protected var _lastTargetPosSaved:Boolean = false;

	protected var _calculated:Boolean = false;

	protected var _pSize:String = "height";
	protected var _pPos:String = "y";
	
	public function scrollBy(dx:int, dy:int):void {
		prepareProp();
		if (_calculated && lock) save();
		_calculated = true;
		
		targetRect[_pPos] += direction == Scroller_old.DIRECTION_VERTICAL ? dy : dx;
	}

	public function calculate():void {
		prepareProp();
		if (_calculated && lock) save();
		_calculated = true;
		
		var pos:Number = 0;
		if (_lock) {
			pos = prefer == Scroller_old.PREFER_TOP ? 
				_lastTargetPos : _lastTargetPos - targetRect[_pSize];
		} else {
			if (prefer == Scroller_old.PREFER_TOP) {
				pos = viewRect[_pSize] >= targetRect[_pSize] ? 
					0 : viewRect[_pSize] - targetRect[_pSize];
			} else {
				pos = viewRect[_pSize] >= targetRect[_pSize] ? 
					viewRect[_pSize] - targetRect[_pSize] : 0;
			}
		}
		targetRect[_pPos] = pos;
	}

	protected function prepareProp():void {
	    _pSize = direction == Scroller_old.DIRECTION_VERTICAL ? "height" : "width";
		_pPos = direction == Scroller_old.DIRECTION_VERTICAL ? "y" : "x";
	}

	/**
	* 保存上一次的位置状态和区域值,用于比对计算
	*/
	protected function save():void {
		if (!_lastTargetPosSaved && targetRect) {
			_lastTargetPosSaved = true;
			_lastTargetPos = prefer == Scroller_old.PREFER_TOP ? 
				targetRect[_pPos] : 
//				(targetRect[_pPos] + targetRect[_pSize]) - (viewRect[_pPos] + viewRect[_pSize]);
				targetRect[_pPos] + targetRect[_pSize];
		}
	}

}
