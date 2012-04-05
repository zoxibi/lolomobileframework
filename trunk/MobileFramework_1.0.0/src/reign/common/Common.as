package reign.common
{
	import flash.display.Stage;
	import flash.net.LocalConnection;
	
	import reign.net.IService;

	/**
	 * 公用接口、方法、引用集合
	 * @author LOLO
	 */
	public class Common
	{
		/**舞台*/
		public static var stage:Stage;
		
		/**后台通信服务*/
		public static var service:IService;
		
		/**用户界面管理*/
		public static var ui:IUIManager;
		/**配置信息管理*/
		public static var config:IConfigManager;
		/**语言包管理*/
		public static var language:ILanguageManager;
		/**样式管理*/
		public static var style:IStyleManager;
		
		/**音频管理*/
		public static var sound:ISoundManager;
		
		
		
		/**当前执行环境*/
		public static var bin:String = "debug";
		/**资源库路径*/
		public static var resPath:String;
		/**应用的版本号*/
		public static var version:String;
		/**后台服务器的网络地址*/
		public static var serviceUrl:String = "";
		/**是否需要解压通信数据*/
		public static var decompress:Boolean;
		
		
		
		
		/**
		 * 强制内存回收
		 */
		public static function gc():void
		{
			try {
				new LocalConnection().connect("gc");
				new LocalConnection().connect("gc");
			}
			catch(err:Error) {}
		}
		//
	}
}