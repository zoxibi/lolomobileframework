package lolo.components
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import lolo.common.Common;
	import lolo.utils.AutoUtil;
	
	/**
	 * 滚动条
	 * @author LOLO
	 */
	public class ScrollBar extends Sprite
	{
		/**指定滚动条用于水平滚动*/
		public static const HORIZONTAL:String = "horizontal";
		/**指定滚动条用于垂直滚动*/
		public static const VERTICAL:String = "vertical";
		/**像上或左滑动*/
		public static const DIRECTION_UP:String = "up";
		/**像下或右滑动*/
		public static const DIRECTION_DOWN:String = "down";
		
		/**滑块*/
		private var _thumb:Sprite;
		/**内容的遮罩*/
		private var _contentMask:Mask;
		/**滚动的内容*/
		private var _content:Sprite;
		/**内容的显示区域（滚动区域）*/
		private var _disArea:Rectangle;
		
		/**是否启用*/
		private var _enabled:Boolean = true;
		/**滚动方向，水平还是垂直*/
		private var _direction:String;
		
		/**坐标属性的名称，水平:"x"，垂直:"y"*/
		private var _xy:String;
		/**宽高属性的名称，水平:"width"，垂直:"height"*/
		private var _wh:String;
		/**当前是否显示（内容尺寸是否超出了显示区域）*/
		private var _isShow:Boolean;
		/**拖动开始时的信息*/
		private var _startInfo:Object;
		/**移动时的信息*/
		private var _moveInfo:Object = {};
		/**滑块的正常尺寸*/
		private var _thumbNormalSize:int;
		/**内容是否在回滚过程中*/
		private var _isRollback:Boolean;
		/**上次更新时的位置*/
		private var _lastPoint:Point = new Point();
		
		/**隐藏动画的持续时间(单位:秒)*/
		public var hideEffectDuration:Number = 0.5;
		/**隐藏动画的延迟时间(单位:秒)*/
		public var hideEffectDelay:Number = 1;
		/**滑块最小尺寸*/
		public var thumbMinSize:uint = 5;
		/**加速运动的判定时间（毫秒），用于判定是否按下鼠标长时间不释放*/
		public var speedupJudgementTime:int = 200;
		/**从加速到减速缓冲效果的持续时间（毫秒）*/
		public var bufferTime:int = 2.5 * 1000;
		/**内容回滚时间（毫秒）*/
		public var rollbackTime:int = 1 * 1000;
		
		
		
		
		public function ScrollBar()
		{
			super();
			direction = VERTICAL;
			
			alpha = 0;
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		
		/**
		 * 样式
		 */
		public function set style(value:Object):void
		{
			if(value.thumbSkin != null) {
				if(_thumb != null) this.removeChild(_thumb);
				_thumb = AutoUtil.init(AutoUtil.getInstance(value.thumbSkin), this, {mouseChildren:false, mouseEnabled:false});
			}
			
			if(value.direction != null) direction = value.direction;
			if(value.thumbMinSize != null) thumbMinSize = value.thumbMinSize;
		}
		
		/**
		 * 样式的名称
		 */
		public function set styleName(value:String):void
		{
			style = Common.style.getStyle(value);
		}
		
		
		/**
		 * 滑块的属性
		 */
		public function set thumbProp(value:Object):void
		{
			AutoUtil.initObject(_thumb, value);
		}
		
		
		
		/**
		 * 显示更新
		 * @param isShow 在需要显示滚动条时，是否自动显示hideEffectDelay时间，然后自动消失
		 */
		public function update(isShow:Boolean=true):void
		{
			TweenMax.killTweensOf(_content);
			
			var nowIsShow:Boolean = _isShow;//当前是否为显示状态
			
			_content.graphics.clear();
			_isShow = _content[_wh] > _disArea[_wh];
			
			enabled = _enabled;
			
			if(_isShow) {
				_thumbNormalSize = int(_disArea[_wh] / _content[_wh] * _disArea[_wh]);
				if(_thumbNormalSize < thumbMinSize) _thumb[_wh] = thumbMinSize;
				_thumb[_wh] = _thumbNormalSize;
				
				_content.addEventListener(MouseEvent.MOUSE_DOWN, content_mouseDownHandler);
				
				moveContent(_content[_xy], true, true, true);
				
				if(isShow && !nowIsShow) {
					alpha = 1;
					hide(hideEffectDelay);
				}
				
				//绘制内容的空白区域
				_content.graphics.beginFill(0x0, 0.001);
				_content.graphics.drawRect(0, 0, _content.width, _content.height);
				_content.graphics.endFill();
				
			}
			else {
				hide();
				_thumb[_xy] = _disArea[_xy];
				_content[_xy] = _disArea[_xy];
				
				_content.removeEventListener(MouseEvent.MOUSE_DOWN, content_mouseDownHandler);
			}
		}
		
		
		/**
		 * 鼠标在内容上按下
		 * @param event
		 */
		private function content_mouseDownHandler(event:MouseEvent):void
		{
			moveContent(_content[_xy], false, true, true);
			TweenMax.killTweensOf(_content, _isRollback);
			TweenMax.killDelayedCallsTo(decelerationTest);
			TweenMax.killTweensOf(this);
			
			alpha = 1;
			_isRollback = false;
			
			_startInfo = {
				contentX:_content.x, contentY:_content.y,
					mouseX:mouseX, mouseY:mouseY
			};
			_moveInfo = {
				mouseX:mouseX, mouseY:mouseY
			};
			
			stage.addEventListener(Event.ENTER_FRAME, stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
		}
		
		
		/**
		 * 鼠标在场景移动（按下状态）
		 * @param event
		 */
		private function stage_mouseMoveHandler(event:Event):void
		{
			if(_lastPoint.x == mouseX && _lastPoint.y == mouseY) return;
			_lastPoint = new Point(mouseX, mouseY);
			
			
			//移动到正常应该显示的位置
			var p:int = (_direction == VERTICAL)
				? (mouseY - _startInfo.mouseY + _startInfo.contentY)
				: (mouseX - _startInfo.mouseX + _startInfo.contentX);
			moveContent(p);
			
			//移动的距离
			var distance:int = Point.distance(new Point(_moveInfo.mouseX, _moveInfo.mouseY), new Point(mouseX, mouseY));
			//当前方向
			var direction:String;
			if(_direction == VERTICAL) {
				direction = (_moveInfo.mouseY > mouseY) ? DIRECTION_UP : DIRECTION_DOWN;
			}
			else {
				direction = (_moveInfo.mouseX > mouseX) ? DIRECTION_UP : DIRECTION_DOWN;
			}
			
			//方向有改变，清空距离列表和时间列表
			if(direction != _moveInfo.direction) {
				_moveInfo.distanceList = [];
				_moveInfo.timeList = [];
			}
			
			//存入方向、距离、时间、鼠标位置
			_moveInfo.direction = direction;
			_moveInfo.distanceList.push(distance);
			_moveInfo.timeList.push(getTimer());
			_moveInfo.mouseX = mouseX;
			_moveInfo.mouseY = mouseY;
		}
		
		/**
		 * 鼠标在场景释放，或离开舞台（按下状态）
		 * @param event
		 */
		private function stage_mouseUpHandler(event:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
			
			//鼠标没移动过
			if(_moveInfo.direction == null) {
				hide();
				return;
			}
			
			//之前十个移动动作内，是否有加速动作（移动距离大于指定值的动作）
			var isSpeedup:Boolean;//是否有加速
			var distance:int;//加速距离
			var time:int;//加速用时
			var i:int = _moveInfo.distanceList.length - Math.min(10, _moveInfo.distanceList.length);
			for(; i < _moveInfo.distanceList.length; i++) {
				if(!isSpeedup && _moveInfo.distanceList[i] > 40) {
					isSpeedup = true;
					time = _moveInfo.timeList[i];
				}
				if(isSpeedup) {
					distance += _moveInfo.distanceList[i] / 3;
				}
			}
			
			//按下不放的情况，不算加速
			if(isSpeedup && getTimer() - time > speedupJudgementTime) {
				isSpeedup = false;
			}
			
			//有加速
			if(isSpeedup) {
				time = _moveInfo.timeList[_moveInfo.timeList.length - 1] - time;
				
				//加速运动的倍数
				var multiple:Number = (time == 0) ? 0.8 : distance / time;
				
				//减速缓冲的移动值
				var value:int = _disArea[_wh] * multiple;
				if(_moveInfo.direction == "up") value = -value;
				value += _content[_xy];
				
				//进行减速缓冲
				var vars:Object = (_direction == VERTICAL) ? {y:value} : {x:value};
				vars.ease = Expo.easeOut;
				vars.onUpdate = decelerationUpdate;
				vars.onComplete = decelerationComplete;
				TweenMax.to(_content, bufferTime / 1000, vars);
				TweenMax.delayedCall(bufferTime / 1000 * 0.3, decelerationTest);
				TweenMax.delayedCall(bufferTime / 1000 * 0.6, decelerationTest);
				TweenMax.delayedCall(bufferTime / 1000 * 0.8, decelerationTest);
			}
			else {
				moveContent(_content[_xy], false, true, true, true);
			}
		}
		
		
		/**
		 * 减速缓冲过程中
		 */
		private function decelerationUpdate():void
		{
			moveContent(_content[_xy], false, true);
		}
		
		/**
		 * 减速过程已到了缓慢阶段
		 */
		private function decelerationTest():void
		{
			moveContent(_content[_xy], false, true, true);
		}
		
		/**
		 * 减速缓冲完成
		 */
		private function decelerationComplete():void
		{
			moveContent(_content[_xy], false, true, true, true);
		}
		
		
		
		
		/**
		 * 移动内容，并设置和移动滑块
		 * @param p 目标像素位置
		 * @param isSetP 是否需要设置位置
		 * @param isRollback 在内容超出限定范围后，是否需要回滚
		 * @param nowRollback 如果超出显示范围，是否需要立即回滚
		 * @param nowHide 如果不用回滚，是否立即隐藏
		 */
		public function moveContent(p:int, isSetP:Boolean=true, isRollback:Boolean=false, nowRollback:Boolean=false, nowHide:Boolean=false):void
		{
			var minP:int = -_content[_wh] + _disArea[_xy] + _disArea[_wh];//最小位置
			var isExceed:Boolean;//是否有超出限定范围
			var rollbackP:int;//回滚的目标位置
			var thumbSize:int = _thumbNormalSize;//滑块的尺寸
			
			//鼠标往下或往右拖，超出显示范围
			if(p > _disArea[_xy]) {
				if(isSetP) p = _disArea[_xy] + int((p - _disArea[_xy]) / 2);
				if(p - _disArea[_xy] > _disArea[_wh] / 2) {
					p = _disArea[_xy] + _disArea[_wh] / 2;
					isExceed = true;
				}
				rollbackP = _disArea[_xy];
				if(nowRollback) isExceed = true;
				
				thumbSize = _thumbNormalSize - int((p - _disArea[_xy]) / 2);
			}
				//鼠标往上或往左拖，超出显示范围
			else if(p < minP) {
				if(isSetP) p = minP + int((p - minP) / 2);
				if(p - minP < -_disArea[_wh] / 2) {
					p = minP - _disArea[_wh] / 2;
					isExceed = true;
				}
				rollbackP = minP;
				if(nowRollback) isExceed = true;
				
				thumbSize = _thumbNormalSize + int((p - minP) / 2);
			}
			
			if(isSetP) _content[_xy] = p;
			setThumbSize(thumbSize);
			
			//需要回滚，并且超出了限定范围
			if(isRollback && isExceed) {
				TweenMax.killTweensOf(_content);
				TweenMax.killDelayedCallsTo(decelerationTest);
				
				//进行回滚
				_isRollback = true;
				var vars:Object = (_direction == VERTICAL) ? {y:rollbackP} : {x:rollbackP};
				vars.onUpdate = rollbackUpdate;
				vars.onComplete = rollbackComplete;
				TweenMax.to(_content, rollbackTime / 1000, vars);
			}
			else if(nowHide) hide();
			
			moveThumbByContent();
		}
		
		/**
		 * 回滚缓冲过程中
		 */
		private function rollbackUpdate():void
		{
			moveContent(_content[_xy], false);
		}
		
		/**
		 * 回滚缓冲完成
		 */
		private function rollbackComplete():void
		{
			hide();
		}
		
		
		
		/**
		 * 设置滑块的尺寸
		 * 如果小于最小尺寸，将显示成最小尺寸
		 * 如果大于最大尺寸，将显示成最大尺寸
		 */
		public function setThumbSize(size:int):void
		{
			if(size < thumbMinSize) size = thumbMinSize;
			else if(size > _disArea[_wh]) size = _disArea[_wh];
			_thumb[_wh] = size;
		}
		
		
		/**
		 * 通过内容的位置，来移动滑块的位置
		 */
		private function moveThumbByContent():void
		{
			var minP:int = -_content[_wh] + _disArea[_xy] + _disArea[_wh];//最小位置
			var contentXY:int;
			var addXY:int;
			if(_content[_xy] > _disArea[_xy]) {
				contentXY = _disArea[_xy];
			}
			else if(_content[_xy] < minP) {
				contentXY = minP;
				addXY = _thumbNormalSize - _thumb[_wh];
			}
			else {
				contentXY = _content[_xy];
			}
			
			_thumb[_xy] = int(
				- (contentXY - _disArea[_xy])
				/ (_content[_wh] - _disArea[_wh])
				* (_disArea[_wh] - _thumbNormalSize)
				+ _disArea[_xy]
				+ addXY
			);
		}
		
		
		/**
		 * 滚动到底部
		 */
		public function scrollToBottom():void
		{
			scrollToPosition(-_content[_wh] + _disArea[_xy] + _disArea[_wh]);
		}
		
		/**
		 * 滚动到顶部
		 */
		public function scrollToTop():void
		{
			scrollToPosition(_disArea[_xy]);
		}
		
		/**
		 * 将内容移动到指定位置
		 * @param p
		 */
		private function scrollToPosition(p:int):void
		{
			if(!_isShow) return;
			
			var minP:int = -_content[_wh] + _disArea[_xy] + _disArea[_wh];//最小位置
			
			//不是移动到底部和顶部
			if(p != _disArea[_xy] && p != minP)
			{
				p = p + (_disArea[_wh] / 2);
				if(p < minP) p = minP;
				else if(p > _disArea[_xy]) p = _disArea[_xy];
			}
			
			_content[_xy] = p;
			moveThumbByContent();
		}
		
		
		/**
		 * 移动到内容中的指定位置，并将该位置居中
		 * @param p
		 */
		public function scrollToContentPosition(p:int):void
		{
			p = -p + _disArea[_xy];
			scrollToPosition(p);
		}
		
		
		
		
		/**
		 * 隐藏
		 * @param hideDalay 隐藏动画的延迟时间(单位:秒)
		 */
		public function hide(hideDalay:Number=0):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, hideEffectDuration, {alpha:0, delay:hideDalay});
		}
		
		
		/**
		 * 初始化
		 */
		public function init():void
		{
			if(_disArea != null && _content != null)
			{
				_content.x = _disArea.x;
				_content.y = _disArea.y;
				
				if(_contentMask == null) {
					_contentMask = new Mask();
					_contentMask.target = _content;
				}
				_contentMask.x = _disArea.x;
				_contentMask.y = _disArea.y;
				_contentMask.rect = { width:_disArea.width, height:_disArea.height };
				
				if(_direction == VERTICAL) {
					_thumb.x = _disArea.x + _disArea.width - _thumb.width;
					_thumb.y = _disArea.y;
				}
				else {
					_thumb.x = _disArea.x;
					_thumb.y = _disArea.y + _disArea.height - _thumb.height;
				}
				
				update();
			}
		}
		
		
		/**
		 * 内容的显示区域（滚动区域）
		 */
		public function set disArea(value:Object):void
		{
			_disArea = new Rectangle(value.x, value.y, value.width, value.height);
			init();
		}
		public function get disArea():Object { return _disArea; }
		
		
		/**
		 * 滚动的内容
		 */
		public function set content(value:Sprite):void
		{
			_content = value;
			init();
		}
		public function get content():Sprite { return _content; }
		
		
		
		/**
		 * 是否启用
		 */
		public function set enabled(value:Boolean):void { _enabled = value; }
		public function get enabled():Boolean { return _enabled; }
		
		
		
		/**
		 * 滚动方向，水平还是垂直
		 */
		public function set direction(value:String):void
		{
			_direction = value;
			if(value == HORIZONTAL) {
				_xy = "x";
				_wh = "width";
			}
			else {
				_xy = "y";
				_wh = "height";
			}
		}
		public function get direction():String { return _direction; }
		
		
		
		/**
		 * 当前是否显示（内容尺寸是否超出了显示区域）
		 */
		public function get isShow():Boolean { return _isShow; }
		
		
		
		/**
		 * 用于清理引用，释放内存
		 * 在丢弃该组件时，需要主动调用该方法
		 */
		public function dispose():void
		{
			if(_contentMask != null) _contentMask.dispose();
		}
		//
	}
}