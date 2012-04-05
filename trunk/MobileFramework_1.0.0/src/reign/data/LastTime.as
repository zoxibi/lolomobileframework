package reign.data
{
	import flash.utils.getTimer;
	
	import reign.utils.TimeUtil;

	/**
	 * 剩余时间(CD时间)
	 * @author LOLO
	 */
	public class LastTime
	{
		/**开始计时的时间戳*/
		private var _startTime:Number;
		/**剩余时间*/
		private var _lastTime:Number;
		
		
		
		/**
		 * 构造函数
		 * @param time 剩余时间的值
		 * @param type 剩余时间的类型
		 */		
		public function LastTime(time:Number=0, type:String="ms")
		{
			setTime(time, type);
		}
		
		
		/**
		 * 设置剩余时间
		 * @param time 时间的值
		 * @param type 时间的类型
		 */		
		public function setTime(time:Number, type:String="ms"):void
		{
			_startTime = getTimer();
			_lastTime = TimeUtil.convertType(type, TimeUtil.TYPE_MS, time);
		}
		
		
		
		/**
		 * 获取剩余时间
		 * @param type 时间的类型
		 * @return 
		 */
		public function getTime(type:String="ms"):Number
		{
			var time:Number = _lastTime - (getTimer() - _startTime);
			return TimeUtil.convertType(TimeUtil.TYPE_MS, type, time);
		}
		
		
		/**
		 * 获取初始化时的时间
		 * @return 
		 */
		public function get initTime():Number
		{
			return _lastTime;
		}
		//
	}
}