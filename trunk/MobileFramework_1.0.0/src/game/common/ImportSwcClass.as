package game.common
{
	import mainUI.*;
	import skin.*;
//	import sound.*;
	

	/**
	 * 该类的目的是显式的导入swc中的类
	 * 因SWC文件中所包含的类没有显式的使用过，FB最终将不会编译
	 * @author LOLO
	 */
	public class ImportSwcClass
	{
		public static function init():void
		{
			//Component.swc
			Alert_BG;
			Window_BG;
			Button1;
			CloseBtn;
			CheckBox1;
			ComboBox1_ListItem; ComboBox1_ListBG; ComboBox1_ArrowBtn;
			RadioButton1;
			HScrollBar1_Thumb;
			VScrollBar1_Thumb;
			ToolTip_BG;
			
			
			//MainUI.swc
			DeveloperMovie;
			RequestModal;
			
			
			//GameUI.swc
			
			
			//Sound.swc
//			BG1;
		}
		//
	}
}