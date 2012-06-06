package game.module.core.view
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.common.GameConstants;
	import game.module.gameUI.view.GameUI;
	import game.module.gameUI.view.IGameUI;
	import game.module.testScene.view.ITestScene;
	import game.module.testScene.view.TestScene;
	import game.ui.RequestModal;
	
	import lolo.common.Common;
	import lolo.common.Constants;
	import lolo.common.UIManager;
	import lolo.components.AlertText;

	/**
	 * 游戏用户界面管理
	 * @author LOLO
	 */
	public class GameUIManager extends UIManager implements IGameUIManager
	{
		/**单例的实例*/
		private static var _instance:GameUIManager;
		
		/**测试场景*/
		private var _testScene:ITestScene;
		
		/**游戏UI*/
		private var _gameUI:IGameUI;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():GameUIManager
		{
			if(_instance == null) _instance = new GameUIManager(new Enforcer());
			return _instance;
		}
		
		
		public function GameUIManager(enforcer:Enforcer)
		{
			if(!enforcer) {
				throw new Error("请通过Common.ui获取实例");
				return;
			}
		}
		
		
		override public function init():void
		{
			super.init();
			
			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler, true, 1);
			Common.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, true, 1);
			
			_requestModal = new RequestModal();
			_gameUI = new GameUI();
			
			enterGame();
		}
		
		
		
		override public function showScene(sceneID:int, ...rest):void
		{
			super.showScene(sceneID, rest);
			switch(sceneID)
			{
				case GameConstants.SID_TEST:
					showTestScene(rest);
					break;
			}
			
			
			if(sceneID == GameConstants.SID_TEST) {
				_gameUI.show();
			}
			else {
				_gameUI.hide();
			}
		}
		
		
		override public function showWindow(windowID:int, ...rest):void
		{
			switch(windowID)
			{
				case GameConstants.WID_MAIL:
					showMailWindow(rest);
					break;
			}
		}
		
		
		
		/**
		 * 进入游戏
		 */
		public function enterGame():void
		{
			addChildToLayer(_gameUI as DisplayObject, Constants.LAYER_NAME_UI);
			
			showScene(GameConstants.SID_TEST);
		}
		
		
		
		
		
		/**
		 * 显示【测试场景】
		 * @param args	[0] 
		 */
		private function showTestScene(args:Array):void
		{
			if(_testScene == null) {
				_testScene = new TestScene();
				_testScene.sceneID = GameConstants.SID_TEST;
			}
			
//			_testScene.data = args[0];
			switchScene(_testScene);
		}
		
		
		
		/**
		 * 显示【邮件窗口】
		 * @param args	[0] 面板的名称
		 */
		private function showMailWindow(args:Array):void
		{
//			if(_mail == null) {
//				_mail = new Mail();
//				_mail.windowID = GameConstants.WID_MAIL;
//			}
//			
//			openOrCloseWindow(_mail, args[0]);
		}
		
		
		
		
		
		
		/**
		 * 鼠标在舞台按下
		 * @param event
		 */
		private function stage_mouseDownHandler(event:MouseEvent):void
		{
			AlertText.lastMousePoint = new Point(Common.stage.mouseX, Common.stage.mouseY);
		}
		
		/**
		 * 鼠标在舞台移动
		 * @param event
		 */
		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			AlertText.lastMousePoint = new Point(Common.stage.mouseX, Common.stage.mouseY);
		}
		
		
		
		
		override public function get stageWidth():int
		{
			return (Common.stage.stageWidth > 1024) ? 1024 : Common.stage.stageWidth;
		}
		
		override public function get stageHeight():int
		{
			return (Common.stage.stageHeight > 768) ? 768 : Common.stage.stageHeight;
		}
		
		override public function get stageMinWidth():int
		{
			return 800;
		}
		
		override public function get stageMinHeight():int
		{
			return 480;
		}
		//
	}
}


class Enforcer {}