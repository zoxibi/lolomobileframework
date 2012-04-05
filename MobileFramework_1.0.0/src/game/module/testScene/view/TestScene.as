package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import reign.common.Common;
	import reign.components.Image;
	import reign.core.Scene;
	
	/**
	 * 测试场景
	 * @author LOLO
	 */
	public class TestScene extends Scene implements ITestScene
	{
		private var img:Image;
		
		public function TestScene()
		{
			super();
			
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, Common.ui.stageWidth, Common.ui.stageHeight);
			this.graphics.endFill();
			
			img = new Image();
			img.title = "animalPic";
			this.addChild(img);
			
			
			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, test);
		}
		
		
		/**
		 * 
		 * @param event
		 */
		private function test(event:MouseEvent):void
		{
			var id:int = int(Math.random() * 3 + 1);
			img.id = id;
		}
		//
	}
}