package lolo.effects
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import lolo.events.BitmapMovieClipEvent;

	/**
	 * 属性动画
	 * 按照指定的数组序列更改目标的属性
	 * 按照约定，frames[0]应该为该动画会更改的属性列表
	 * @author LOLO
	 */
	public class PropertyMovie extends EventDispatcher
	{
		/**震动动画*/
		public static const FRAMES_SHAKE:Array = [["x", "y"], {x:2, y:-3}, {x:-1, y:3}, {x:1, y:2}, {x:-3, y:-2}];
		
		
		/**动画的施加目标*/
		private var _target:DisplayObject;
		/**初始属性*/
		private var _defaultProp:Object = {};
		/**按照该数组序列改变目标的属性值（帧列表）*/
		private var _frames:Array;
		/**当前帧编号*/
		private var _currentFrame:uint;
		/**帧频*/
		private var _fps:uint;
		/**是否正在播放动画*/
		private var _running:Boolean;
		/**重复播放次数*/
		public var repeatCount:uint;
		/**动画当前已重复播放的次数*/
		private var _currentRepeatCount:uint;
		
		
		
		public function PropertyMovie(target:DisplayObject, frames:Array, fps:uint=25)
		{
			_target = target;
			_frames = frames;
			_fps = fps;
		}
		
		
		/**
		 * 进入到下一帧
		 */
		private function nextFrame():void
		{
			_currentFrame++;
			//动画已播放完成
			if(_currentFrame >= _frames.length) {
				dispatchEvent(new BitmapMovieClipEvent(BitmapMovieClipEvent.ENTER_STOP_FRAME));
				
				_currentRepeatCount++;
				//有指定重复播放次数，并且达到了重复播放次数
				if(repeatCount > 0 && _currentRepeatCount >= repeatCount) {
					stop();
					dispatchEvent(new BitmapMovieClipEvent(BitmapMovieClipEvent.MOVIE_END));
				}
				
				_currentFrame = 0;
			}
			
			if(_running) {
				updateTarget();
				TweenMax.delayedCall(1 / _fps, nextFrame);
			}
		}
		
		
		/**
		 * 更新当前动画到目标
		 */
		private function updateTarget():void
		{
			var obj:Object = (_currentFrame == 0) ? _defaultProp : _frames[_currentFrame];
			for(var prop:String in obj) _target[prop] = obj[prop];
		}
		
		
		
		/**
		 * 播放动画
		 * @param repeatCount 动画的重复播放次数（0 :无限循环）
		 */
		public function play(repeatCount:uint=1):void
		{
			if(_running) stop();
			this.repeatCount = repeatCount;
			
			for each(var prop:String in _frames[0]) _defaultProp[prop] = _target[prop];
			
			_running = true;
			nextFrame();
		}
		
		/**
		 * 停止播放动画，并还原属性
		 */
		public function stop():void
		{
			TweenMax.killDelayedCallsTo(nextFrame);
			
			_currentFrame = 0;
			updateTarget();
			
			_running = false;
			_currentRepeatCount = 0;
			_defaultProp = {};
		}
		
		
		
		/**
		 * 帧频
		 */
		public function set fps(value:uint):void { _fps = value; }
		public function get fps():uint { return _fps; }
		
		/**
		 * 是否正在播放动画
		 */
		public function get running():Boolean { return _running; }
		
		/**
		 * 当前帧编号
		 */
		public function get currentFrame():uint { return _currentFrame; }
		
		/**
		 * 动画当前已重复播放的次数
		 */
		public function get currentRepeatCount():uint { return _currentRepeatCount; }
		//
	}
}