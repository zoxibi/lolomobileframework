
package lolo.components
{
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import lolo.utils.EmbedResUtils;
	import lolo.utils.RTimer;
	import lolo.utils.zip.ZipReader;
	
	/**
	 * 图片对象（嵌入资源）
	 * @author LOLO
	 */
	public class Image extends Bitmap
	{
		/**已提取图像的数据包，以及使用信息*/
		private static var _data:Dictionary = new Dictionary();
		/**用于周期清理数据*/
		private static var _clearTimer:RTimer;
		
		
		/**图像数据包的名称*/
		private var _title:String = null;
		/**图像在数据包中的ID（名称，不包括后缀）*/
		private var _id:* = null;
		
		/**临时加载器*/
		private var _loader:Loader;
		
		/**设置的宽度*/
		private var _widht:uint;
		/**设置的高度*/
		private var _height:uint;
		
		/**加载完成后，从不可见到可见，alpha动画的持续时间*/
		public var showEffectDuration:Number = 0.3;
		
		
		public function Image()
		{
			super();
			
			if(_clearTimer == null) {
				_clearTimer = RTimer.getInstance(3 * 60 * 1000, clearTimerHandler);
				_clearTimer.start();
			}
		}
		
		
		
		/**
		 * 周期清理数据
		 */
		private function clearTimerHandler():void
		{
			//克隆一份_data进行，稍候对其进行for操作
			var list:Dictionary = new Dictionary();
			var key:String;
			for(key in _data) list[key] = _data[key];
			
			var info:Object;
			for(key in list) {
				info = _data[key];
				//位图数据已经没有在使用了
				if(info.count == 0) {
					//已经被标记过，可以被清除
					if(info.prepareClear) {
						info.data.dispose();
						delete _data[key];
					}
					else {
						info.prepareClear = true;//标记为可清除
					}
				}
				else {
					info.prepareClear = false;
				}
			}
		}
		
		
		
		
		/**
		 * 图像数据包的名称
		 */
		public function set title(value:String):void
		{
			dispose();
			
			_title = value;
			showImage();
		}
		public function get title():String { return _title; }
		
		
		/**
		 * 图像在数据包中的ID（名称，不包括后缀）
		 */
		public function set id(value:*):void
		{
			dispose();
			
			_id = value;
			showImage();
		}
		public function get id():* { return _id; }
		
		
		
		
		/**
		 * 显示图片
		 */
		private function showImage():void
		{
			if(_title == null || _id == null) return;
			
			//还没创建过图像
			if(_data[_title + "/" + _id] == null)
			{
				var zip:ZipReader = new ZipReader(EmbedResUtils.getImgPackage(_title));
				var bytes:ByteArray;
				//去掉后缀，找出相应的名称
				for(var i:int = 0; i < zip.entries.length; i++) {
					if(zip.entries[i].name.split(".")[0] == _id) {
						bytes = zip.getFile(zip.entries[i].name);
					}
				}
				
				if(bytes == null) {	
					trace("Image 获取", _title, _id, "失败！");
					return;
				}
				
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				_loader.loadBytes(bytes);
			}
			else {
				completeHandler();
			}
		}
		
		/**
		 * 加载图像完成
		 * @param event
		 */
		private function completeHandler(event:Event = null):void
		{
			if(_loader != null)
			{
				_data[_title + "/" + _id] = { data:(_loader.content as Bitmap).bitmapData.clone(), count:0 };
				
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				_loader.unload();
				_loader = null;
			}
			
			
			bitmapData = _data[_title + "/" + _id].data;
			_data[_title + "/" + _id].count++;
			
			if(_widht > 0) super.width = _widht;
			if(_height > 0) super.height = _height;
			
			this.alpha = 0;
			TweenMax.to(this, showEffectDuration, { alpha:1 });
		}
		
		
		
		
		/**
		 * 销毁，释放内存
		 */
		public function dispose():void
		{
			if(bitmapData != null) {
				bitmapData = null;
				_data[_title + "/" + _id].count--;
			}
		}
		
		
		
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_widht = value;
		}
		override public function get width():Number
		{
			return _widht > 0 ? _widht : super.width;
		}
		
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_height = value;
		}
		override public function get height():Number
		{
			return _height > 0 ? _height : super.height;
		}
		//
	}
}