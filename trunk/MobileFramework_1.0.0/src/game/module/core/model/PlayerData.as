package game.module.core.model
{
	import lolo.utils.bind.Data;
	
	/**
	 * 玩家数据
	 * @author LOLO
	 */
	public class PlayerData extends Data
	{
		/**单例的实例*/
		private static var _instance:PlayerData = null;
		/**获取实例*/
		public static function getInstance():PlayerData
		{
			if(_instance == null) _instance = new PlayerData();
			return _instance;
		}
		
		
		/**角色ID*/
		public var roleID:int;
		/**角色名字*/
		public var roleName:String;
		
		
		private var _roleLevel:int;
		private var _gold:int;
		
		
		
		/**角色等级*/
		public function set roleLevel(value:int):void { changeValue("roleLevel", "_roleLevel", value); }
		public function get roleLevel():int { return _roleLevel; }
		
		/**金币*/
		public function set gold(value:int):void { changeValue("gold", "_gold", value); }
		public function get gold():int { return _gold; }
		
		
		
		
		
		
		
		/**获取属性的值(继承时，请拷贝该函数到继承类中，并标记为override)*/
		override protected function getProperty(name:String):* { return this[name]; }
		
		/**设置属性的值 (继承时，请拷贝该函数到继承类中，并标记为override)*/
		override protected function setProperty(name:String, value:*):void { this[name] = value; }
		//
	}
}