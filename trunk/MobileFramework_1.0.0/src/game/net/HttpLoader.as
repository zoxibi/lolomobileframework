package game.net
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import lolo.data.RequestModel;
	
	/**
	 * Http请求数据加载器
	 * @author LOLO
	 */
	public class HttpLoader extends URLLoader
	{
		/**对应的通信接口模型*/
		public var requestModel:RequestModel;
		
		/**获取数据结果的回调函数*/
		public var callback:Function;
		/**通信错误时，是否需要自动AlertText提示*/
		public var alertError:Boolean;
		
		
		
		public function HttpLoader(rm:RequestModel)
		{
			super();
			this.requestModel = rm;
			this.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		
		override public function load(request:URLRequest):void
		{
			super.load(request);
		}
		
		
		override public function close():void
		{
			try { super.close();}
			catch(error:Error) {}
		}
		//
	}
}