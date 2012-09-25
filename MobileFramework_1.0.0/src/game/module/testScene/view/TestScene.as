package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import lolo.common.Common;
	import lolo.components.Image;
	import lolo.components.Label;
	import lolo.core.Scene;
	
	/**
	 * 测试场景
	 * @author LOLO
	 */
	public class TestScene extends Scene implements ITestScene
	{
		private var img:Image;
		
		private var label:Label;
		
		
		
		public function TestScene()
		{
			super();
			
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, Common.ui.stageWidth, Common.ui.stageHeight);
			this.graphics.endFill();
			
			img = new Image();
			img.title = "animalPic";
			this.addChild(img);
			
			label = new Label();
			label.multiline = true;
			this.addChild(label);
			
			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, test);
		}
		
		
		/**
		 * 
		 * @param event
		 */
		private function test(event:MouseEvent):void
		{
			var id:int = int(Math.random() * 3 + 1);
//			for(var i:int = 0; i < 10; i++) {
				img.id = id;
//			}
			
		}
		//
	}
}