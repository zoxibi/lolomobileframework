package game.common
{
	import reign.data.RequestModel;

	/**
	 * 与后台通信的数据模型列表
	 * @author LOLO
	 */
	public class RmList
	{
		/**注册帐号*/
		public static const USER_REGISTER:RequestModel = new RequestModel("create.action");
		/**登录游戏*/
		public static const USER_LOGION:RequestModel = new RequestModel("login.action");
		//
	}
}