package game.common
{
	import lolo.common.Common;
	import lolo.utils.StringUtil;

	/**
	 * 游戏相关配置
	 * @author LOLO
	 */
	public class GameConfig
	{
		/**
		 * 获取属性等级颜色
		 * @param type
		 */
		public static function getPropLevelColor(level:int):String
		{
			var colors:Array = Common.config.getUIConfig("propLevelColors").split(",");
			return colors[level];
		}
		
		
		/**
		 * 获取品质对应的字符串（包括颜色）
		 * @param quality
		 * @return 
		 */
		public static function getQuality(quality:int):String
		{
			var str:String = Common.language.getLanguage("0306" + StringUtil.leadingZero(quality));
			return StringUtil.toHtmlFont(str, GameConfig.getPropLevelColor(quality));
		}
		//
	}
}