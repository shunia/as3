package me.shunia.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	[Event(name="change", type="me.shunia.components.CompEvents")]
	
	/**
	 * 一个基本的list,用来装载多个显示对象,因为现实对象的容器实际上是Panel,所以其布局也与Panel相同.</br>
	 * 需要设置高宽来确定显示区域大小.
	 * TODO: 自动计算高宽
	 *  
	 * @author qingfenghuang
	 */	
	public class List extends Sprite
	{
		
		public static const P_DIRECTION:String = "direction";
		
		protected var _props:PropConfig = null;
		protected var _scroller:Scroller = null;
		protected var _content:Panel = null;
		
		public function List()
		{
			super();
			_props = new PropConfig();
		}
		
		public function setProp(k:String, value:*):List {
			_props.setProp(k, value);
			return this;
		}
		
		public function update():void {
			updateContent();
			updateScroller();
		}
		
		/**
		 * 一次性添加一个或者多个显示对象到列表里.
		 * 当添加多个时,会按照数组或者Vector顺序进行添加
		 *  
		 * @param items displayObject或者包含displayObject的数组/Vector.
		 */		
		public function addItems(items:*):void {
			preLazyRenderList();
			
			if (items && items is DisplayObject) 
				_content.add(items as DisplayObject);
			else if (items is Array || items is Vector) {
				var l:int = items.length, 
					item:DisplayObject = null;
				for (var i:int = 0; i < l; i ++) {
					item = items[i];
					if (item) 
						_content.add(item);
				}
			}
			
			postLazyRenderList();
		}
		
		/**
		 * 一次性删除一个或者多个甚至全部显示对象.
		 * 当传入参数为null时,清空显示对象列表.
		 *  
		 * @param items displayObject或者包含displayObject的数组/Vector或者null.
		 */		
		public function removeItems(items:*):void {
			if (!items) {
				_content.removeAll();
			} else {
				preLazyRenderList();
				
				if (items is DisplayObject) 
					_content.remove(items as DisplayObject);
				else if (items is Array || items is Vector) {
					var l:int = items.length,
						item:DisplayObject = null;
					for (var i:int = 0; i < l; i ++) {
						item = items[i] as DisplayObject;
						if (item) 
							_content.remove(item);
					}
				}
				
				postLazyRenderList();
			}
		}
		
		/**
		 * 预懒刷新,提供给子类用以复写 
		 */		
		protected function preLazyRenderList():void {
			_content.lazyRender = true;
		}
		
		/**
		 * 取消懒刷新并立即刷新,提供给子类用以复写 
		 */		
		protected function postLazyRenderList():void {
			_content.lazyRender = false;
			_content.layout.updateDisplay();
		}
		
		protected function updateContent():void {
			if (!_content) {
				_content = new Panel();
				_content.layout.direction = Layout.VERTICAL;
			}
			if (_props.hasPorp(P_DIRECTION)) 
				_content.layout.direction = _props.getProp(P_DIRECTION);
		}
		
		protected function updateScroller():void {
			if (!_scroller) {
				_scroller = new Scroller();
				addChild(_scroller);
			}
			_scroller.setPropDelegation(_props)
				.setProp(Scroller.P_CONTENT, _content)
				.update();
		}
		
	}
}