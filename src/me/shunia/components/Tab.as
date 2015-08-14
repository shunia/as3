package me.shunia.components
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	public class Tab extends Panel
	{
		
		public static const P_DIRECTION:String = "direction";
		public static const P_BUTTON_GAP:String = "buttonGap";
		public static const P_GAP:String = "gap";
		
		protected var _props:PropConfig = null;
		protected var _direction:String = Layout.VERTICAL;
		protected var _btns:Panel = null;
		protected var _currentBtn:Button = null;
		protected var _currentView:DisplayObject = null;
		protected var _pairs:Dictionary = null;
		protected var _selectedIndex:int = 0;
		
		public function Tab()
		{
			super();
			_props = new PropConfig();
			_pairs = new Dictionary();
		}
		
		public function setProp(key:String, value:*):Tab {
			_props.setProp(key, value);
			return this;
		}
		
		public function update():void {
			saveForButtonCreation();
			initBtnPanel();
			updateView();
		}
		
		public function addItem(label:String, view:DisplayObject):void {
			var btn:Button = createBtn(label);
			_pairs[btn] = view;
			_btns.add(btn);
			selectedIndex = _selectedIndex;
		}
		
		/**
		 * 通过设置该属性,可以用来主动切换当前视图.
		 *  
		 * @param value
		 */		
		public function set selectedIndex(value:int):void {
			if (value < 0) value = 0;
			if (value >= _btns.numChildren) value = _btns.numChildren - 1;
			_selectedIndex = value;
			// 确保有按钮
			if (_btns.numChildren >= (_selectedIndex + 1)) {
				var btn:Button = _btns.getChildAt(_selectedIndex) as Button;
				// 确保有相对应的视图
				if (btn && _pairs[btn]) {
					//如果切换的那个跟当前的视图一样,就不管了
					if (_currentView && _currentView == _pairs[btn]) return;
					// 先切换按钮状态
					if (_currentBtn) _currentBtn.selected = false;
					_currentBtn = btn;
					if (!_currentBtn.selected) _currentBtn.selected = true;
					// 尝试移除当前视图
					if (_currentView && contains(_currentView)) 
						remove(_currentView);
					// 替换引用
					_currentView = _pairs[btn];
					// 添加新视图
					add(_currentView);
				}
			}
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		protected function createBtn(label:String):Button {
			var btn:Button = new Button();
			btn.setPropDelegation(_props.clone())
				.setProp(Button.P_LABEL, label)
				.setProp(Button.P_ALLOW_TOGGLE, true)
				.update();
			btn.on(onChange);
			return btn;
		}
		
		protected function onChange(btn:Button):void {
			if (btn) {
				selectedIndex = _btns.getChildIndex(btn);
			}
		}
		
		protected function saveForButtonCreation():void {
			// 这个方法按字面意思是保存按钮的相关设置,实际处理方法就是留空,以下是说明:
			// 当需要创建按钮的时候,相关的设置必须要有来源,如果在创建Tab时给定了这些属性,
			// 怎么才能在创建按钮的时候保留这些属性呢?正常逻辑应该是将他们都保存在Tab里.但是
			// 因为我们使用了PropConfig,所以只要在没创建按钮前不动这些属性就行,即不调用
			// _props.safeProp方法,那么存在PropConfig里面的属性就一直不会消失.
			// 创建按钮的时候通过button.setPropDelegation方法传入当前PropConfig的
			// clone即可.Button拿到这个clone的PropConfig,来完成自己的生命周期.
			// 当然这里要注意一个问题
		}
		
		protected function initBtnPanel():void {
			if (!_btns) {
				_btns = new Panel();
				add(_btns);
			}
			if (_props.hasPorp(P_DIRECTION)) {
				_direction = _props.safeProp(P_DIRECTION, Layout.HORIZONTAL);
				// 按钮的朝向和Tab控件的整体朝向应该是相反的
				_btns.layout.direction = _direction == Layout.HORIZONTAL ? 
					Layout.VERTICAL : Layout.HORIZONTAL;
			}
			if (_props.hasPorp(P_BUTTON_GAP)) 
				_btns.layout.hGap = _btns.layout.vGap = _props.safeProp(P_BUTTON_GAP, _btns.layout.hGap);
		}
		
		protected function updateView():void {
			layout.direction = _direction;
			if (_props.hasPorp(P_GAP)) 
				layout.hGap = layout.vGap = _props.safeProp(P_GAP, layout.hGap);
		}
		
	}
}