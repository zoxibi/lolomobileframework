package lolo.common
{
	
	/**
	 * 语言包管理
	 * @author LOLO
	 */
	public interface ILanguageManager
	{
		/**
		 * 初始化语言包
		 */
		function initLanguage(config:XML):void;
		
		/**
		 * 通过ID在语言包中获取对应的字符串
		 * @param id 在语言包中的ID
		 * @param rest 用该参数替换字符串内的"{n}"标记
		 * @return 
		 */
		function getLanguage(id:String, ...rest):String;
	}
}