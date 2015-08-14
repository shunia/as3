package me.shunia.components
{
	import flash.display.DisplayObject;

	/**
	 * 可以使用数据来进行更新的List控件,通过提供IItemRender的继承类来进行最终渲染,提供数组数据来触发创建和更新.
	 *  
	 * @author qingfenghuang
	 */	
	public class DataList extends List
	{
		
		public static const P_ITEM_RENDERER:String = "itemRenderer";
		public static const P_DATA:String = "data";
		public static const P_SORT_FUNC:String = "sortFunc";
		
		protected var _data:Array = null;
		protected var _render:Class = null;
		protected var _sort:Function = null;
		
		public function DataList()
		{
			super();
			_data = [];
		}
		
		public function addItemsByData(data:*):void {
			if (!data) return;
			
			if (!(data is Array || data is Vector)) data = [data];
			optAddItems(data);
		}
		
		public function addItemByData(data:*):void {
			if (!data) return;
			
			optAddItems([data]);
		}
		
		public function removeItemsByData(data:*):void {
			if (!data) {
				_data = [];
				removeItems(data);
				return;
			}
			
			if (data is Array || data is Vector) {
				var l:int = data.length,
					item:* = null;
				for (var i:int = 0; i < l; i ++) {
					item = data[i];
					removeItemByData(item);
				}
			} else 
				removeItemByData(data);
		}
		
		public function removeItemByData(data:*):void {
			if (!data) return;
			
			var contained:Boolean = false, 
				rendered:IItemRender = null, 
				elms:Array = null;
			if (data) {
				contained = _data.indexOf(data) != -1;
				if (contained) {
					elms = _content.elements;
					for (var i:int = 0; i < elms.length; i ++) {
						rendered = elms[i] as IItemRender;
						if (rendered && rendered.data == data) {
							_data.splice(_data.indexOf(data), 1);
							removeItems(rendered);
						}
					}
				}
			}
		}
		
		public function sort():void {
			if (_sort == null) return;
			
			_content.elements.sort(_sort);
			_content.layout.updateDisplay();
		}
		
		override public function update():void {
			prepSort();
			
			if (_props.hasPorp(P_ITEM_RENDERER)) 
				_render = _props.safeProp(P_ITEM_RENDERER, null);
			
			super.update();
			
			if (_props.hasPorp(P_DATA)) 
				addItemsByData(_props.safeProp(P_DATA, []));
		}
		
		protected function prepSort():void {
			var s:Function = null, 
				sort:Function = null;
			if (_props.hasPorp(P_SORT_FUNC)) {
				sort = _props.safeProp(P_SORT_FUNC, null);
				s = function (item1:IItemRender, item2:IItemRender):Number {
					return sort.apply(null, [item1.data, item2.data]);
				}
			}
			_sort = s;
		}
		
		protected function clear():void {
			_data = [];
			_render = null;
			removeItems(null);
		}
		
		protected function optAddItems(data:*):void {
			var rendered:Array = [], 
				accepted:Array = [], 
				l:int = data.length, 
				d:* = null, 
				s:DisplayObject = null, 
				contained:Boolean = false;
			
			for (var i:int = 0; i < l; i ++) {
				d = data[i];
				if (d) contained = _data.indexOf(d) != -1;
				if (!contained) {
					s = render(d) as DisplayObject;
					
					accepted.push(d);
					rendered.push(s);
				}
			}
			
			// 更新数据源
			_data.concat(accepted);
			// 添加相应的显示对象
			addItems(rendered);
		}
		
		override protected function postLazyRenderList():void {
			// 在准备更新列表时对排列元素提前做排序,最小限度的降低对性能的影响
			sort();
			// 开始更新
			super.postLazyRenderList();
		}
		
		protected function render(data:*):IItemRender {
			if (_render) {
				var r:IItemRender = new _render();
				r.data = data;
				return r;
			}
			return null;
		}
		
	}
}