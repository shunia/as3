package me.shunia.components
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Button extends Sprite
	{
		
		protected static const DEFAULT_LABEL_SIZE:int = 18;
		protected static const DEFAULT_LABEL_COLOR:uint = 0xFFFFFF;
		protected static const DEFAULT_V_GAP:int = 5;
		protected static const DEFAULT_H_GAP:int = 10;
		protected static const DEFAULT_SIZE_WIDTH:int = 26;
		protected static const DEFAULT_SIZE_HEIGHT:int = 15;
		
		protected var _props:PropConfig = null;
		protected var _state:State = null;
		protected var _on:Function = null;
		protected var _currentState:int = -1;
		protected var _currentFrame:DisplayObject = null;
		protected var _labelDisplay:Label = null;
		protected var _vgap:int = DEFAULT_V_GAP;
		protected var _hgap:int = DEFAULT_H_GAP;
		protected var _selected:Boolean = false;
		protected var _allowToggle:Boolean = false;
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		public function Button()
		{
			super();
			_props = new PropConfig();
			buttonMode = true;
			useHandCursor = true;
		}
		
		internal function setPropDelegation(props:PropConfig):Button {
			_props = props;
			return this;
		}
		
		public function setProp(k:String, value:*):Button {
			_props.setProp(k, value)
			return this;
		}
		
		public function update():Button {
			clear();
			// 先更新label和设置的三态来确认可能的最大高宽,用以后续进行正确的布局
			updateFrame();
			updateLabel();
			updateSize();
			layout();
			ready();
			_props = new PropConfig();
			return this;
		}
		
		public function set selected(value:Boolean):void {
			if (_allowToggle) {
				_selected = value;
				toggle();
			}
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		 * 按钮的文字内容 
		 */		
		public static const P_LABEL:String = "label";
		/**
		 * 文字颜色 
		 */		
		public static const P_LABEL_COLOR:String = "labelColor";
		/**
		 * 文字尺寸 
		 */		
		public static const P_LABEL_SIZE:String = "labelSize";
		/**
		 * 包含多帧的按钮素材 
		 */		
		public static const P_FRAMES:String = "frames";
		/**
		 * UP,OVER,DOWN,假如三个都设置,则使用设置作为三态.
		 * 假如只设置其中一部分,始终按照以下逻辑来将已有的某态复用到没有的态下:
		 *   up没有的情况下,优先取over,其次down.
		 *   over和down没有的情况下,优先取up,其次相互取对方. 
		 */		
		public static const P_FRAME_UP:String = "frameUp";
		/**
		 * UP,OVER,DOWN,假如三个都设置,则使用设置作为三态.
		 * 假如只设置其中一部分,始终按照以下逻辑来将已有的某态复用到没有的态下:
		 *   up没有的情况下,优先取over,其次down.
		 *   over和down没有的情况下,优先取up,其次相互取对方. 
		 */		
		public static const P_FRAME_OVER:String = "frameOver";
		/**
		 * UP,OVER,DOWN,假如三个都设置,则使用设置作为三态.
		 * 假如只设置其中一部分,始终按照以下逻辑来将已有的某态复用到没有的态下:
		 *   up没有的情况下,优先取over,其次down.
		 *   over和down没有的情况下,优先取up,其次相互取对方. 
		 */		
		public static const P_FRAME_DOWN:String = "frameDown";
		/**
		 * 垂直边距 
		 */		
		public static const P_V_GAP:String = "vGap";
		/**
		 * 水平边距 
		 */		
		public static const P_H_GAP:String = "hGap";
		/**
		 * 如果宽度没有设置,则使用文字或者素材的宽度+hgap*2作为宽度. 
		 */		
		public static const P_WIDTH:String = "width";
		/**
		 * 如果高度没有设置,则使用文字或者素材的高度+vgap*2作为宽度. 
		 */		
		public static const P_HEIGHT:String = "height";
		/**
		 * 是否允许设置选中状态 
		 */		
		public static const P_ALLOW_TOGGLE:String = "allowToggle";
		
		protected function toggle():void {
			if (!_allowToggle) return;
			
			if (_selected) {
				_state.state = State.DOWN;
				mouseEnabled = false;
				mouseChildren = false;
			} else {
				_state.state = State.UP;
				mouseEnabled = true;
				mouseChildren = true;
			}
		}
		
		protected function clear():void {
			
		}
		
		/**
		 * 获取设置的三态,用以计算高宽. 
		 */		
		protected function updateFrame():void {
			if (!_state) 
				_state = new State();
			if (_props.hasPorp(P_FRAMES)) {
				var f:* = _props.safeProp(P_FRAMES, null);
				if (f is MovieClip) 
					_state.setFrames(f).confirm();
				else if (f is Class) 
					_state.setFrames(new f()).confirm();
			} else {
				var up:DisplayObject = _props.safeProp(P_FRAME_UP, null), 
					over:DisplayObject = _props.safeProp(P_FRAME_OVER, null),
					down:DisplayObject = _props.safeProp(P_FRAME_DOWN, null);
				_state.setFrame(State.UP, up)
					.setFrame(State.OVER, over)
					.setFrame(State.DOWN, down)
					.confirm();
			}
			if (!contains(_state)) 
				addChild(_state);
		}
		
		/**
		 * 默认当作文字始终存在. 
		 * 当文字实际不存在时,文字显示对象不会对按钮布局产生影响.
		 */		
		protected function updateLabel():void {
			var p:String = _props.getProp(P_LABEL);
			if (p == null) return;
			var l:String = _props.safeProp(P_LABEL, hasText ? _labelDisplay.text : ""), 
				s:int = _props.safeProp(P_LABEL_SIZE, 
					_labelDisplay ? _labelDisplay.size : DEFAULT_LABEL_SIZE), 
				c:uint = _props.safeProp(P_LABEL_COLOR, 
					_labelDisplay ? _labelDisplay.color : DEFAULT_LABEL_COLOR);
			// init label
			if (!_labelDisplay) {
				_labelDisplay = new Label();
				_labelDisplay.selectable = false;
				_labelDisplay.mouseEnabled = false;
			}
			// update label style
			_labelDisplay.text = l;
			_labelDisplay.size = s;
			_labelDisplay.color = c;
//			_labelDisplay.defaultTextFormat = fmt;
			// add to displaylist
			if (!contains(_labelDisplay)) 
				addChild(_labelDisplay);
		}
		
		/**
		 * 收集并整合尺寸信息.在不设置高宽的情况下,将使用按钮现实对象的实际高宽和两侧边距进行计算.
		 * 纯文字按钮也使用同样逻辑.
		 * 可以通过设置P_H_HAP/P_V_GAP来调整按钮实际大小(使用按钮素材或者graphic填充). 
		 */		
		protected function updateSize():void {
			// 获取设置值和当前值当中优先存在的那个
			_hgap = _props.safeProp(P_H_GAP, _hgap);
			_vgap = _props.safeProp(P_V_GAP, _vgap);
			// 需要和当前的文字和三态比较来确认最终的高宽
			var tw:int = _props.safeProp(P_WIDTH, 0),
				th:int = _props.safeProp(P_HEIGHT, 0),
				cw:int, 
				ch:int;
			// 先计算三态的最大高宽
//			for each (var s:DisplayObject in _states) {
//				if (s && s.width > cw) cw = s.width;
//				if (s && s.height > ch) ch = s.height;
//			}
			if (_state.width > cw) cw = _state.width;
			if (_state.height > ch) ch = _state.height;
			// 再同文字的高宽比较更新最大高宽
			if (hasText) {
				if (cw < _labelDisplay.width) cw = _labelDisplay.width;
				if (ch < _labelDisplay.height) ch = _labelDisplay.height;
			}
			// 优先取设置的高宽,其次取计算的最大高宽,否则使用默认高宽
			if (tw) _w = tw;
			else if (cw) _w = cw;
			else _w = DEFAULT_SIZE_WIDTH;
			if (th) _h = th;
			else if (ch) _h = ch;
			else _h = DEFAULT_SIZE_HEIGHT;
			// plus hgap/vgap
			_w = _w + _hgap * 2;
			_h = _h + _vgap * 2;
			// resize button
			_state.setSize(_w, _h)
				.confirm();
		}
		
		/**
		 * 假如有按钮素材,一一对应并使用. 
		 * 如果是文字按钮,画一个空背景.
		 */		
//		protected function confirmFrame():void {
//			if (!hasFrame) {
//				_states[STATE_UP] = getDefaultFrame(STATE_UP);
//				_states[STATE_OVER] = getDefaultFrame(STATE_OVER);
//				_states[STATE_DOWN] = getDefaultFrame(STATE_DOWN);
//			}
//		}
		
		/**
		 * 因为此时三个状态都已知所以可以计算出按钮最大需要的高宽,然后再以此来计算label的位置.
		 * 假如中间有某个部分不存在,则相应部分无需计算.
		 */		
		protected function layout():void {
			// 居中每个按钮的状态
			_state.x = (_w - _state.width) / 2;
			_state.y = (_h - _state.height) / 2;
			// 居中文字
			if (_labelDisplay) {
				_labelDisplay.x = (_w - _labelDisplay.width) / 2;
				_labelDisplay.y = (_h - _labelDisplay.height) / 2;
			}
		}
		
		protected function ready():void {
			addEventListener(MouseEvent.ROLL_OVER, onMouseInteraction);
			addEventListener(MouseEvent.ROLL_OUT, onMouseInteraction);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseInteraction);
			
			if (_props.hasPorp(P_ALLOW_TOGGLE)) 
				_allowToggle = _props.safeProp(P_ALLOW_TOGGLE, _allowToggle);
		}
		
		protected function onMouseInteraction(e:MouseEvent):void {
			switch (e.type) {
				case MouseEvent.ROLL_OVER : 
					if (!(_allowToggle && selected)) 
						_state.state = State.OVER;
					break;
				case MouseEvent.ROLL_OUT : 
					if (!(_allowToggle && selected)) 
						_state.state = State.UP;
					break;
				case MouseEvent.MOUSE_UP : 
					if (!(_allowToggle && selected)) 
						_state.state = State.UP;
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseInteraction);
					addEventListener(MouseEvent.ROLL_OVER, onMouseInteraction);
					addEventListener(MouseEvent.ROLL_OUT, onMouseInteraction);
					if (_on != null) _on.apply(null, _on.length == 1 ? [this]: null);
					break;
				case MouseEvent.MOUSE_DOWN : 
					if (_allowToggle && !selected) 
						selected = true;
					else 
						_state.state = State.DOWN;
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseInteraction);
					removeEventListener(MouseEvent.ROLL_OVER, onMouseInteraction);
					removeEventListener(MouseEvent.ROLL_OUT, onMouseInteraction);
					break;
			}
		}
		
		public function on(cb:Function):void {
			_on = cb;
		}
		
		public function set state(value:int):void {
			_state.state = value;
		}
		
		public function get state():int {
			return _state.state;
		}
		
		protected function get hasText():Boolean {
			return _labelDisplay && _labelDisplay.text && _labelDisplay.text.length;
		}
		
		override public function set width(value:Number):void {
			setProp(P_WIDTH, value).update();
		}
		override public function get width():Number {
			return _w;
		}
		
		override public function set height(value:Number):void {
			setProp(P_HEIGHT, value).update();
		}
		override public function get height():Number {
			return _h;
		}
		
	}
}
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.utils.Dictionary;

class Frame extends Shape {
	
	protected var _mulitple:Number = 1;
	protected var _w:int = 0;
	protected var _h:int = 0;
	protected var _alpha:Number = 1;
	protected var _color:uint = 0x428bca;
	
	public function Frame(multiple:Number, w:int, h:int, alpha:Number = 1, color:uint = 0x428bca) {
		_mulitple = multiple;
		_alpha = alpha;
		_color = color;
		resize(w, h);
	}
	
	public function resize(w:int, h:int):void {
		graphics.clear();
		graphics.beginFill(_color * _mulitple, _alpha);
		graphics.drawRoundRect(0, 0, w, h, 7);
		graphics.endFill();
	}
}

class State extends Sprite {
	
	public static const UP:int = 1;
	public static const OVER:int = 2;
	public static const DOWN:int = 3;
	
	protected var _w:int = 0;
	protected var _h:int = 0;
	protected var _sizeDirty:Boolean = false;
	protected var _mc:MovieClip = null;
	protected var _states:Dictionary = null;
	protected var _current:int = UP;
	
	public function State() {
		_states = new Dictionary();
	}
	
	public function setSize(w:int, h:int):State {
		_w = w;
		_h = h;
		_sizeDirty = true;
		return this;
	}
	
	public function setFrames(value:MovieClip):State {
		_mc = value;
		return this;
	}
	
	public function setFrame(state:int, value:DisplayObject):State {
		if (value) {
			_states[state] = value;
		}
		return this;
	}
	
	public function confirm():void {
		if (!_mc) {
			if (!_states.hasOwnProperty(UP)) _states[UP] = drawUp(_w, _h);
			if (!_states.hasOwnProperty(OVER)) _states[OVER] = drawOver(_w, _h);
			if (!_states.hasOwnProperty(DOWN)) _states[DOWN] = drawDown(_w, _h);
		}
		state = _current;
	}
	
	public function set state(value:int):void {
		_current = value;
		if (numChildren) removeChildAt(0);
		if (_states.hasOwnProperty(_current)) {
			var f:Frame = _states[_current];
			if (_sizeDirty) {
				_sizeDirty = false;
				f.resize(_w, _h);
			}
			addChild(f);
		} else if (_mc) {
			_mc.gotoAndStop(_current);
			if (_sizeDirty) {
				_sizeDirty = false;
				_mc.width = _w;
				_mc.height = _h;
			}
			addChild(_mc);
		}
	}
	
	public function get state():int {
		return _current;
	}
	
	protected function drawUp(w:int, h:int):DisplayObject {
		return new Frame(0.99997, w, h);
	}
	
	protected function drawOver(w:int, h:int):DisplayObject {
		var d:DisplayObject = new Frame(0.99998, w, h);
		return d;
	}
	
	protected function drawDown(w:int, h:int):DisplayObject {
		var d:DisplayObject = new Frame(0.99999, w, h);
		d.filters = [
			new DropShadowFilter(1, 45, 0, 0.5, 1, 1, 1, 1, true),
			new DropShadowFilter(1, 225, 0, 0.5, 1, 1, 1, 1, true)
		];
		//			d.filters = [new DropShadowFilter(2, 45, 0, 0.7, 2, 2, 1, 1, true)];
		return d;
	}
	
}