/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.components {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[Event(name="change", type="me.shunia.components.CompEvents")]
	
	public class CheckBox extends Panel {
	
	    private var _selected:Boolean = false;
	    private var _label:Label = null;
	    private var _box:Sprite = null;
	    private var _cb:Function = null;
	
	    public function CheckBox(t:String, cb:Function, selected:Boolean = false) {
	        super();
	
	        _selected = selected;
	        _cb = cb;
	
	        _label = new Label();
	        _label.text = t;
	        _box = new Sprite();
	        drawBox();
	        add(_box);
	        add(_label);
	
	        buttonMode = true;
	
	        addEventListener(MouseEvent.CLICK, function (e:Object):void {
	            selected = !_selected;
	            if (_cb != null) _cb(_selected);
	        });
	    }
	
	    public function get selected():Boolean {
	        return _selected;
	    }
	
	    public function set selected(value:Boolean):void {
	        if (value != _selected) {
	            _selected = value;
	            drawBox();
	            if (_cb != null) _cb(_selected);
	        }
	    }
	
	    protected function drawBox():void {
	        var w:int = _label.height - 2;
	        _box.graphics.clear();
	        _box.graphics.lineStyle(2, 0);
	        _box.graphics.drawRect(1, 1, w, w);
	        if (_selected) {
	            _box.graphics.beginFill(0x000000);
	            _box.graphics.drawRect(4, 4, w - 6, w - 6);
	        }
	        _box.graphics.endFill();
	    }
	
	}
}
