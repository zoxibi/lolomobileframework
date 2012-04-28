package lolo.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.IDataInput;
	
	import game.common.ImgERConstants;
	import game.common.XmlERConstants;
	
	import lolo.common.Common;
	

	/**
	 * 嵌入资源处理工具
	 * @author LOLO
	 */
	public class EmbedResUtils
	{
		
		/**
		 * 传入嵌入xml的名称，获取对应的xml内容
		 * @param xmlClass
		 * @return 
		 */
		public static function getXML(xmlName:String):XML
		{
			if(Common.bin == "debug")
			{
				var dataFile:File = new File(Common.resPath + "xml\\" + xmlName + ".xml");
				var stream:FileStream = new FileStream();
				stream.open(dataFile, FileMode.READ);
				return new XML(stream.readUTFBytes(stream.bytesAvailable));
			}
			
			return XML(new XmlERConstants[xmlName]());
		}
		
		
		
		
		/**
		 * 获取图像数据包
		 * @param imgClass
		 * @return 
		 */
		public static function getImgPackage(packageName:String):IDataInput
		{
			if(Common.bin == "debug")
			{
				var dataFile:File = new File(Common.resPath + "img\\" + packageName + "\\" + packageName + ".zip");
				var stream:FileStream = new FileStream();
				stream.open(dataFile, FileMode.READ);
				return stream;
			}
			
			return new ImgERConstants[packageName]();
		}
		//
	}
}