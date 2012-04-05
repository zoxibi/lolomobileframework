package reign.mvc.command
{
	import reign.mvc.control.MvcEvent;
	/**
	 * mvc命令接口
	 * @author LOLO
	 */
	public interface ICommand
	{
		/**
		 * 执行命令
		 * @param event
		 */
		function execute(event:MvcEvent):void;
		//
	}
}