package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import game.common.ImportSwcClass;
	import game.common.XmlERConstants;
	import game.module.core.view.GameUIManager;
	import game.net.HttpService;
	
	import mainUI.DeveloperMovie;
	
	import reign.common.Common;
	import reign.common.ConfigManager;
	import reign.common.LanguageManager;
	import reign.common.SoundManager;
	import reign.common.StyleManager;
	import reign.components.Alert;
	import reign.ui.Console;
	import reign.utils.EmbedResUtils;
	import reign.utils.TimeUtil;
	
	/**
	 * LOLO的移动平台框架
	 * @author LOLO
	 */
	[SWF(backgroundColor="#000000", frameRate="25")]
	public class Main extends Sprite
	{
		private var _developerMovie:DeveloperMovie;
		
		
		public function Main()
		{
			super();
			ImportSwcClass.init();
			
			
//			Common.bin = "release";//导出发行版时，取消注释
			
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			Common.version = "1.0.0";
			Common.resPath = "E:\\MobileFramework\\res\\zh_CN_v1.0.0\\";
			Common.serviceUrl = "http://192.168.1.100:8080/Service/";//登录和注册的URL地址
			
			if(Common.bin == "release")
			{
				stage.autoOrients = false;
				stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
//				Common.decompress = true;
			}
			
			
			if(stage) addToStageHandler();
			else addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		
		
		/**
		 * 添加到舞台上时
		 * @param event
		 */
		private function addToStageHandler(event:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler);
		}
		
		
		
		/**
		 * 舞台旋转后
		 * @param event
		 */
		private function orientationChangeHandler(event:Event=null):void
		{
			stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler);
			
			Common.style = StyleManager.getInstance();
			Common.config = ConfigManager.getInstance();
			Common.language = LanguageManager.getInstance();
			Common.sound = SoundManager.getInstance();
			Common.service = HttpService.getInstance();
			Common.ui = GameUIManager.getInstance();
			
			Common.stage = stage;
			Console.getInstance().container = Common.stage;
			
			Common.language.initLanguage(EmbedResUtils.getXML(XmlERConstants.LANGUAGE));
			Common.style.initStyle(EmbedResUtils.getXML(XmlERConstants.STYLE));
			Common.config.initUIConfig(EmbedResUtils.getXML(XmlERConstants.UICONFIG));
			
			
			TimeUtil.day	= Common.language.getLanguage("030101");
			TimeUtil.days	= Common.language.getLanguage("030102");
			TimeUtil.hour	= Common.language.getLanguage("030103");
			TimeUtil.minute	= Common.language.getLanguage("030104");
			TimeUtil.second	= Common.language.getLanguage("030105");
			
			TimeUtil.dFormat = Common.language.getLanguage("030201");
			TimeUtil.hFormat = Common.language.getLanguage("030202");
			TimeUtil.mFormat = Common.language.getLanguage("030203");
			TimeUtil.sFormat = Common.language.getLanguage("030204");
			
			Alert.OK	= Common.language.getLanguage("030301");
			Alert.CANCEL= Common.language.getLanguage("030302");
			Alert.YES	= Common.language.getLanguage("030303");
			Alert.NO	= Common.language.getLanguage("030304");
			Alert.CLOSE	= Common.language.getLanguage("030305");
			Alert.BACK	= Common.language.getLanguage("030306");
			
			
			_developerMovie = new DeveloperMovie();
			_developerMovie.x = int( (Common.ui.stageWidth - _developerMovie.width) / 2 );
			_developerMovie.y = int( (Common.ui.stageHeight - _developerMovie.height) / 2 );
			_developerMovie.gotoAndPlay(1);
			_developerMovie.addEventListener("developerMovieEnd", developerMovieEnd);
			this.addChild(_developerMovie);
		}
		
		
		
		/**
		 * 开发团队动画播放完毕
		 * @param event
		 */
		private function developerMovieEnd(event:Event):void
		{
			_developerMovie.removeEventListener("developerMovieEnd", developerMovieEnd);
			this.removeChild(_developerMovie);
			_developerMovie = null;
			
			this.addChild(GameUIManager.getInstance());
			Common.ui.init();
		}
		//
	}
}