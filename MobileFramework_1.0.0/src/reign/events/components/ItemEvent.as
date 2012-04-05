package reign.events.components
{
	import flash.events.Event;
	
	import reign.components.IItemRenderer;

	/**
	 * 子项事件
	 * @author LOLO
	 */
	public class ItemEvent extends Event
	{
		/**鼠标按下子项*/
		public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
		
		/**鼠标点击子项*/
		public static const ITEM_CLICK:String = "itemClick";
		
		/**选中子项*/
		public static const ITEM_SELECTED:String = "itemSelected";
		
		
		
		/**触发事件的子项*/
		public var item:IItemRenderer;
		
		
		
		public function ItemEvent(type:String, item:IItemRenderer=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.item = item;
		}
		//
	}
}