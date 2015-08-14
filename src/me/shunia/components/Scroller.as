package me.shunia.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 支持对一个对象增加滚动条功能.
	 *  
	 * @author qingfenghuang
	 */	
	public class Scroller extends Panel
	{
		
		private static const WHEEL_GAP_SCALE:Number = 0.03;
		
		public static const VERTICAL:String = Layout.VERTICAL;
		public static const HORIZONTAL:String = Layout.HORIZONTAL;
		public static const PREFER_TOP:String = "top";
		public static const PREFER_BOTTOM:String = "bottom";
		
		public static const P_HEIGHT:String = "height";
		public static const P_WIDTH:String = "width";
		public static const P_DIRECTION:String = "direction";
		public static const P_CONTENT:String = "content";
		public static const P_PREFER_DIRECTION:String = "barPreferDirection";
		public static const P_AUTO_SCROLL:String = "autoScroll";
		
		protected var _props:PropConfig = null;
		protected var _clip:Clip = null;
		protected var _content:DisplayObject = null;
		protected var _bar:ScrollerBar = null;
		protected var _lock:Boolean = false;
		protected var _direction:String = null;
		protected var _prefer:String = null;
		protected var _autoScroll:Boolean = false;
		
		protected var _lastWidth:Number = 0;
		protected var _lastX:Number = 0;
		protected var _lastHeight:Number = 0;
		protected var _lastY:Number = 0;
		
		protected var _lastContentSize:Rectangle = null;
		protected var _lastClipSize:Rectangle = null;
		protected var _contentSize:Rectangle = null;
		protected var _clipSize:Rectangle = null;
		
		public function Scroller()
		{
			super();
			name = "scroller";
			layout.hGap = layout.vGap = 0;
			_props = new PropConfig();
			_clip = new Clip();
			_clip.layout.vGap = _clip.layout.hGap = 0;
			_bar = new ScrollerBar();
			_direction = VERTICAL;
			_prefer = PREFER_TOP;
			_lastContentSize = new Rectangle();
			_lastClipSize = new Rectangle();
		}
		
		public function set lock(value:Boolean):void {
			_lock = value;
		}
		
		public function setProp(k:String, value:*):Scroller {
			_props.setProp(k, value);
			return this;
		}
		
		public function setPropDelegation(props:PropConfig):Scroller {
			_props = props;
			return this;
		}
		
		public function update():Scroller {
			clearEvents();
			updateProps();
			updateClipAndContent();
			updateBar();
			onUpdateLayout();
			onEvents();
			return this;
		}
		
		protected function clearEvents():void {
			removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function updateProps():void {
			// DIRECTION不删除,用来传递给ScrollerBar
			if (_props.hasPorp(P_DIRECTION)) _direction = _props.safeProp(P_DIRECTION, _direction);
			if (_props.hasPorp(P_PREFER_DIRECTION)) _prefer = _props.safeProp(P_PREFER_DIRECTION, _prefer);
			// 更新当前控件本身的方向,用来排列遮罩区域和滚动条
			if (_direction == VERTICAL) layout.direction = HORIZONTAL;
			else layout.direction = VERTICAL;
			// 是否自动更新
			if (_props.hasPorp(P_AUTO_SCROLL)) _autoScroll = _props.safeProp(P_AUTO_SCROLL, _autoScroll);
		}
		
		protected function updateClipAndContent():void {
			// 更新遮罩区域尺寸
			if (_props.hasPorp(P_HEIGHT)) _clip.height = _props.safeProp(P_HEIGHT, height);
			if (_props.hasPorp(P_WIDTH)) _clip.width = _props.safeProp(P_WIDTH, width);
			// 更新clip的方向,添加子元素的时候会自动排序
			_clip.layout.direction = _direction;
			// 添加子对象
			if (_props.hasPorp(P_CONTENT)) _content = _props.safeProp(P_CONTENT, _content);
			if (_content && !_clip.contains(_content)) {
				_clip.removeAll();
				_clip.add(_content);
			}
			
			if (!contains(_clip)) add(_clip);
		}
		
		protected function updateBar():void {
			if (!_content) return;
			
			_bar.setPropDelegation(_props)
				.setProp(ScrollerBar.P_VIEW_SIZE, clipSizeTmp)
				.setProp(ScrollerBar.P_CONTENT_SIZE, contentSizeTmp)
				.setProp(ScrollerBar.P_ON_UPDATE, onScrolling)
				.update();
			
			if (!contains(_bar)) add(_bar);
		}
		
		protected function onUpdateLayout():void {
			layout.updateDisplay();
		}
		
		protected function onEvents():void {
			if (_content) {
				_content.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}
			if (_autoScroll) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		protected function onWheel(e:MouseEvent):void {
			if (!_content) return;
			
			var dx:Number = 0, dy:Number = 0;
			var offset:Number = e.delta * WHEEL_GAP_SCALE * _content.height;
			if (_direction == VERTICAL) dy = offset;
			else dx = offset;
			offsetContent(-dx, -dy);
		}
		
		protected function onEnterFrame(e:Event):void {
			if (!_content) return;
			
			if (!_lastContentSize.equals(contentSize) || !_lastClipSize.equals(clipSize)) {
				cloneRectTo(_lastContentSize, contentSize);
				cloneRectTo(_lastClipSize, clipSize);
				
				updatePrefer();
				
				reUpdateBar();
			}
		}
		
		/**
		 * 复制rect属性.
		 *  
		 * @param source
		 * @param target
		 */		
		protected function cloneRectTo(source:Rectangle, target:Rectangle):void {
			source.x = target.x;
			source.y = target.y;
			source.width = target.width;
			source.height = target.height;
		}
		
		protected function reUpdateBar():void {
			_bar.setProp(ScrollerBar.P_VIEW_SIZE, clipSizeTmp)
				.setProp(ScrollerBar.P_CONTENT_SIZE, contentSizeTmp)
				.setProp(ScrollerBar.P_ON_UPDATE, onScrolling)
				.update();
		}
		
		protected function updatePrefer():void {
			if (_lock) return;
			if (_direction == HORIZONTAL) {
				if (contentSize.width > clipSize.width) {
					if (_prefer == PREFER_BOTTOM) 
						_content.x = _clip.width - _content.width;
					else 
						_content.x = 0;
				} else 
					_content.x = 0;
			} else {
				if (contentSize.height > clipSize.height) {
					if (_prefer == PREFER_BOTTOM) 
						_content.y = _clip.height - _content.height;
					else 
						_content.y = 0;
				} else 
					_content.y = 0;
			}
		}
		
		protected function onScrolling(dx:Number, dy:Number):void {
			offsetContent(dx, dy);
		}
		
		protected function offsetContent(dx:Number, dy:Number):void {
			_content.x -= dx;
			// 范围限定
			var cts:Rectangle = contentSizeTmp, cls:Rectangle = clipSizeTmp;
			if (_direction == HORIZONTAL && cts.left > cls.left) _content.x -= (cts.left - cls.left);
			if (_direction == HORIZONTAL && cts.right < cls.right) _content.x += (cls.right - cts.right);
			_content.y -= dy;
			// 范围限定
			cts = contentSizeTmp, cls = clipSizeTmp;
			if (_direction == VERTICAL && cts.top > cls.top) _content.y -= (cts.top - cls.top);
			if (_direction == VERTICAL && cts.bottom < cls.bottom) _content.y += (cls.bottom - cts.bottom);
		}
		
		protected function get contentSizeTmp():Rectangle {
			return contentSize.clone();
		}
		
		protected function get contentSize():Rectangle {
			if (!_content) {
				if (!_contentSize) _contentSize = new Rectangle();
				else _contentSize.setEmpty();
			} else {
				if (!_contentSize) _contentSize = new Rectangle();
				_contentSize.x = _content.x;
				_contentSize.y = _content.y;
				_contentSize.width = _content.width;
				_contentSize.height = _content.height;
			}
			return _contentSize;
		}
		
		protected function get clipSizeTmp():Rectangle {
			return clipSize.clone();
		}
		
		protected function get clipSize():Rectangle {
			if (!_clip) {
				if (!_clipSize) _clipSize = new Rectangle();
				else _clipSize.setEmpty();
			} else {
				if (!_clipSize) _clipSize = new Rectangle();
				_clipSize.x = _clip.x;
				_clipSize.y = _clip.y;
				_clipSize.width = _clip.width;
				_clipSize.height = _clip.height;
			}
			return _clipSize;
		}
		
	}
}