package reign.common
{
	import flash.utils.Dictionary;
	
	import reign.utils.StringUtil;

	/**
	 * 语言包管理
	 * @author LOLO
	 */
	public class LanguageManager implements ILanguageManager
	{
		/**单例的实例*/
		private static var _instance:LanguageManager;
		
		/**提取完成的语言包储存在此*/
		private var _language:Dictionary;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():LanguageManager
		{
			if(_instance == null) _instance = new LanguageManager(new Enforcer());
			return _instance;
		}
		
		
		public function LanguageManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.language获取实例");
				return;
			}
		}
		
		
		/**
		 * 初始化语言包
		 */
		public function initLanguage(config:XML):void
		{
			_language = new Dictionary();
			
			for(var i:int = 0; i < config.item.length(); i++)
			{
				var content:String = config.item[i];
				content = content.replace(/\[br\]/g, "\n");
				_language[String(config.item[i].@id)] = content;
			}
		}
		
		
		/**
		 * 通过ID在语言包中获取对应的字符串
		 * @param id 在语言包中的ID
		 * @param rest 用该参数替换字符串内的"{n}"标记
		 * @return 
		 */
		public function getLanguage(id:String, ...rest):String
		{
			var str:String = _language[id];
			if(rest.length > 0) {
				str = StringUtil.substitute(str, rest);
			}
			return str;
		}
		//
	}
}


class Enforcer {}