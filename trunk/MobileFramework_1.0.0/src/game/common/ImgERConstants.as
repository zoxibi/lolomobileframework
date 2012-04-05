package game.common
{
	/**
	 * 图像数据包资源
	 * 图像包中不允许有同名不同后缀的文件存在，例如：abc.jpg与abc.png是不允许存在一个包中的
	 * 注意：[Class变量]、[文件夹]、[压缩包]的名称要一致，例如：首字母小写驼峰式
	 * @author LOLO
	 */
	public class ImgERConstants
	{
		/**动物头像 */
		[Embed(source="../../../../../res/zh_CN_v1.0.0/img/animalPic/animalPic.zip", mimeType="application/octet-stream")]
		public static const animalPic:Class;
		//
	}
}