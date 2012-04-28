package lolo.common
{
	import com.adobe.serialization.json.AdobeJSON;
	
	import flash.utils.Dictionary;
	
	/**
	 * 样式管理
	 * @author LOLO
	 */
	public class StyleManager implements IStyleManager
	{
		/**单例的实例*/
		private static var _instance:StyleManager;
		
		/**已解析好的样式列表*/
		private var _styleList:Dictionary;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():StyleManager
		{
			if(_instance == null) _instance = new StyleManager(new Enforcer());
			return _instance;
		}
		
		
		public function StyleManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.style获取实例");
				return;
			}
			
			_styleList = new Dictionary();
		}
		
		
		/**
		 * 初始化样式表
		 */
		public function initStyle(config:XML):void
		{
			for(var i:int = 0; i < config.style.length(); i++)
			{
				_styleList[String(config.style[i].@name)] = AdobeJSON.decode(config.style[i].@style);
			}
		}
		
		
		/**
		 * 获取样式表
		 * @param name 样式的名称
		 * @return 
		 */
		public function getStyle(name:String):Object
		{
			return _styleList[name];
		}
		//
	}
}


class Enforcer {}