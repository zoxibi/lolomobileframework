package lolo.common
{
	/**
	 * 配置信息管理
	 * @author LOLO
	 */
	public interface IConfigManager
	{
		/**
		 * 初始化界面配置文件
		 */
		function initUIConfig(config:XML):void;
		
		
		/**
		 * 获取界面配置文件信息
		 * @param name 配置的名称
		 * @return
		 */
		function getUIConfig(name:String):String;
	}
}