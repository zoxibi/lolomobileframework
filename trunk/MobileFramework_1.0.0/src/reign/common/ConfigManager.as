package reign.common
{
	/**
	 * 配置信息管理
	 * @author LOLO
	 */
	public class ConfigManager implements IConfigManager
	{
		/**单例的实例*/
		private static var _instance:ConfigManager;
		
		/**界面配置文件*/
		private var _uiConfig:XML;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():ConfigManager
		{
			if(_instance == null) _instance = new ConfigManager(new Enforcer());
			return _instance;
		}
		
		
		public function ConfigManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.config获取实例");
				return;
			}
		}
		
		
		
		
		
		/**
		 * 初始化界面配置文件
		 * @param resName 配置在资源列表中的名称
		 */
		public function initUIConfig(config:XML):void
		{
			_uiConfig = config;
		}
		
		
		
		/**
		 * 获取界面配置文件信息
		 * @param name 配置的名称
		 * @return
		 */
		public function getUIConfig(name:String):String
		{
			return _uiConfig[name].@value;
		}
		//
	}
}


class Enforcer {}