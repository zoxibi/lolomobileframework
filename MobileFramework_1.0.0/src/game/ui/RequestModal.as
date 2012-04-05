package game.ui
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import game.common.GameConstants;
	import game.common.XmlERConstants;
	
	import reign.common.Common;
	import reign.common.Constants;
	import reign.components.ModalBackground;
	import reign.data.RequestModel;
	import reign.ui.IRequestModal;
	import reign.utils.AutoUtil;
	import reign.utils.EmbedResUtils;
	import reign.utils.RTimer;
	
	/**
	 * 将与服务端通信的请求进行模态的界面
	 * @author LOLO
	 */
	public class RequestModal extends Sprite implements IRequestModal
	{
		/**请求无响应，该时间后显示加载中界面（毫秒）*/
		private static const ING_INTERVAL:int = 3000;
		/**请求无响应，该时间后显示加载失败界面（毫秒）*/
		private static const FAIL_INTERVAL:int = 9000;
		
		/**模态背景*/
		public var modalBG:ModalBackground;
		/**视图界面*/
		public var view:Sprite;
		
		/**背景半模态时的透明度（通信中）*/
		public var bgSemiModalAlpha:Number;
		/**背景全模态时的透明度（通信失败）*/
		public var bgModalAlpha:Number;
		/**隐藏动画的持续时间(单位:秒)*/
		public var hideEffectDuration:Number;
		/**隐藏动画的延迟时间(单位:秒)*/
		public var hideEffectDelay:Number;
		
		/**当前正在通信的接口列表*/
		private var _list:Array;
		/**用于定时检查通信状态*/
		private var _timer:RTimer;
		
		
		
		public function RequestModal()
		{
			super();
			AutoUtil.autoUI(this, new XML(EmbedResUtils.getXML(XmlERConstants.MAINUI).requestModal));
			
			view.getChildByName("bg").visible = false;
			view.getChildByName("ing").visible = false;
			Common.ui.centerToStage(this);
			
			_list = [];
			_timer = RTimer.getInstance(GameConstants.INTERVAL_1000MS, timerHandler);
		}
		
		
		public function startModal(rm:RequestModel):void
		{
			//如果当前正在通信的接口列表中有该接口，不必继续执行
			for each(var item:Object in _list) if(item.rm == rm) return;
			
			this.alpha = 1;
			TweenMax.killTweensOf(this);
			
			view.getChildByName("fail").visible = false;
			Common.ui.addChildToLayer(this, Constants.LAYER_NAME_TOP);
			
			_list.push({ rm:rm, time:getTimer() });
			_timer.start();
			timerHandler();
		}
		
		
		public function endModal(rm:RequestModel):void
		{
			for(var i:int = 0; i < _list.length; i++)
			{
				if(_list[i].rm == rm) _list.splice(i, 1);
			}
			
			if(_list.length == 0 && !view.getChildByName("fail").visible) reset();
		}
		
		
		/**
		 * 重置所有模态的通信
		 */
		public function reset():void
		{
			_timer.reset();
			_list = [];
			Common.ui.removeChildToLayer(this, Constants.LAYER_NAME_TOP);
		}
		
		
		
		/**
		 * 定时检查通信状态
		 */
		private function timerHandler():void
		{
			var time:int = getTimer() - _list[0].time;
			
			view.getChildByName("bg").visible = time >= ING_INTERVAL;
			view.getChildByName("ing").visible = time >= ING_INTERVAL && time < FAIL_INTERVAL;
			modalBG.alpha = (time >= ING_INTERVAL) ? bgModalAlpha : bgSemiModalAlpha;
			
			//通信超时
			if(time >= FAIL_INTERVAL)
			{
				_timer.reset();
				view.getChildByName("fail").visible = true;
				
				//将正在通信的请求，全部设置为超时
				for each(var item:Object in _list) Common.service.setTimeout(item.rm);
				_list = [];
				
				TweenMax.to(this, hideEffectDuration, {alpha:0, delay:hideEffectDelay, onComplete:reset});
			}
		}
		
		
		public function get centerWidth():uint
		{
			return view.width;
		}
		
		public function get centerHeight():uint
		{
			return view.height;
		}
		//
	}
}