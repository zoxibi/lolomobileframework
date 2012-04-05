package game.net
{
	import com.adobe.serialization.json.AdobeJSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import reign.common.Common;
	import reign.components.AlertText;
	import reign.data.RequestModel;
	import reign.net.IService;
	
	/**
	 * 与后台通信的HTTP服务
	 * @author LOLO
	 */
	public class HttpService implements IService
	{
		/**单例的实例*/
		private static var _instance:HttpService;
		/**请求的代号（唯一标识符）*/
		private static var _token:Number = 0;
		
		/**通信实例列表（RequestModel为key）*/
		private var _loaderList:Dictionary;
		
		
		
		/**
		 * 获取单例的实例
		 * @return 
		 */
		public static function getInstance():HttpService
		{
			if(_instance == null) _instance = new HttpService(new Enforcer());
			return _instance;
		}
		
		
		
		public function HttpService(enforcer:Enforcer)
		{
			super();
			if(enforcer == null) {
				throw new Error("请通过Common.service获取实例");
				return;
			}
			
			_loaderList = new Dictionary();
		}
		
		
		public function send(rm:RequestModel, data:Object=null, callback:Function=null, alertError:Boolean=true):void
		{
			if(rm.modal) Common.ui.requesModal.startModal(rm);
			rm.token = ++_token;
			
			var loader:HttpLoader = getLoader(rm);
			loader.close();
			loader.callback = callback;
			loader.alertError = alertError;
			loader.mousePoint = new Point(Common.stage.mouseX, Common.stage.mouseY);
			
			var url:String = Common.serviceUrl + rm.command + "?t=" + rm.token;
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			if(data != null)
			{
				var vars:URLVariables = new URLVariables();
				for(var key:String in data) vars[key] = data[key];
				request.data = vars;
			}
			
			loader.load(request);
		}
		
		
		public function setTimeout(rm:RequestModel):void
		{
			getLoader(rm).close();
			var msg:String = Common.language.getLanguage("010303");
			callback(rm, false, {msg:msg}, true);
		}
		
		
		
		/**
		 * 获取数据完成
		 * @param event
		 */
		private function completeHandler(event:Event):void
		{
			var rm:RequestModel = (event.target as HttpLoader).requestModel;
			var bytes:ByteArray = event.target.data as ByteArray;
			var msg:String;
			
			//解压数据
			if(Common.decompress)
			{
				try {
					bytes.uncompress();
				}
				catch(error:Error) {
					msg = Common.language.getLanguage("010301");
					callback(rm, false, {msg:msg});
					return;
				}
			}
			
			//转换数据
			var data:Object;
			try {
				data = AdobeJSON.decode(bytes.toString());
			}
			catch(error:Error) {
				msg = Common.language.getLanguage("010302");
				callback(rm, false, {msg:msg});
				return;
			}
			
			var state:int = data.action.state;
			
			//操作成功
			if(state == 1)
			{
				callback(rm, true, data.action.data);
			}
			
			//操作异常
			else if(state == 2)
			{
				msg = Common.language.getLanguage("010304", data.action.data.msg);
				callback(rm, false, {msg:msg});
			}
			
			//操作失败
			else {
				callback(rm, false, data.action.data);
			}
		}
		
		/**
		 * 通信发生错误
		 * @param event
		 */
		private function errorHandler(event:Event):void
		{
			var msg:String = Common.language.getLanguage("010305");
			callback(event.target.requestModel, false, {msg:msg});
		}
		
		
		
		/**
		 * 请求已有结果，进行回调
		 * @param rm 通信接口模型
		 * @param success 通信是否成功
		 * @param data 数据
		 * @param timeout 通信是否超时
		 */
		private function callback(rm:RequestModel, success:Boolean, data:Object, timeout:Boolean=false):void
		{
			var loader:HttpLoader = getLoader(rm);
			data.timeout = timeout;
			
			if(rm.modal) Common.ui.requesModal.endModal(rm);
			if(timeout) loader.close();
			
			if(!success && loader.alertError)
			{
				var alertText:AlertText = AlertText.getInstance("serviceError");
				alertText.x = loader.mousePoint.x;
				alertText.y = loader.mousePoint.y;
				alertText.show(data.msg);
			}
			
			if(loader.callback != null) loader.callback(success, data);
		}
		
		
		
		/**
		 * 通过rm获取对应的HttpLoader
		 * @param rm
		 */
		private function getLoader(rm:RequestModel):HttpLoader
		{
			if(_loaderList[rm] == null)
			{
				var loader:HttpLoader = new HttpLoader(rm);
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loaderList[rm] = loader;
			}
			return _loaderList[rm];
		}
		//
	}
}


class Enforcer{}