package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import me.shunia.slib.context.Context;
	import me.shunia.slib.context.ContextConfigDefault;
	import me.shunia.smedia.core.SVideoManager;
	import me.shunia.smedia.core.conf.SVideoConf;
	import me.shunia.smedia.core.interfaces.ISMedia;
	
	[SWF(backgroundColor="0xfcfcfc")]
	public class smedia_test extends Sprite
	{
		
		private static const TEST_STREAM:String = "test.mp4";
		
		public function smedia_test()
		{
			Context.config = new ContextConfigDefault(stage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// 播放mp3音乐
//			var am:AudioManager = new AudioManager();
//			var a:IMedia = am.createMedia(new AudioConf("test.mp3"));
//			a.play();
			
			// 播放视频
			var vm:SVideoManager = new SVideoManager();
			var v:ISMedia = vm.createMedia(new SVideoConf(TEST_STREAM, -1, -1, true));
//			v.play();
			addChild(v.display);
		}
	}
}