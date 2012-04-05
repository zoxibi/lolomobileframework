package game.common
{
	/**
	 * XMl文件，嵌入资源常量定义
	 * @author LOLO
	 */
	public class XmlERConstants
	{
		/**语言包*/
		[Embed("../../../../../res/zh_CN_v1.0.0/xml/Language.xml", mimeType="application/octet-stream")]
		public static const Language:Class;
		public static const LANGUAGE:String = "Language";
		
		/**样式*/
		[Embed("../../../../../res/zh_CN_v1.0.0/xml/Style.xml", mimeType="application/octet-stream")]
		public static const Style:Class;
		public static const STYLE:String = "Style";
		
		/**UI配置*/
		[Embed("../../../../../res/zh_CN_v1.0.0/xml/UIConfig.xml", mimeType="application/octet-stream")]
		public static const UIConfig:Class;
		public static const UICONFIG:String = "UIConfig";
		
		/**主UI*/
		[Embed("../../../../../res/zh_CN_v1.0.0/xml/MainUI.xml", mimeType="application/octet-stream")]
		public static const MainUI:Class;
		public static const MAINUI:String = "MainUI";
		
		
		
		/**测试场景*/
		[Embed("../../../../../res/zh_CN_v1.0.0/xml/TestScene.xml", mimeType="application/octet-stream")]
		public static const TestScene:Class;
		public static const TESTSCENE:String = "TestScene";
		
		
		/**游戏UI*/
		[Embed("../../../../../res/zh_CN_v1.0.0/xml/GameUI.xml", mimeType="application/octet-stream")]
		public static const GameUI:Class;
		public static const GAMEUI:String = "GameUI";
		
		
		
//		/**邮件窗口*/
//		[Embed("../../../../../res/zh_CN_v1.0.0/xml/Mail.xml", mimeType="application/octet-stream")]
//		public static const Mail:Class;
//		public static const MAIL:String = "Mail";
		//
	}
}