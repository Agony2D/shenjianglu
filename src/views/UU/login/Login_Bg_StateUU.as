package views.UU.login
{
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.resources.TResourceManager;
	
	public class Login_Bg_StateUU extends StateUU
	{
		override public function onEnter() : void {
			var img:BitmapLoaderUU;
			
			
			// 大背景.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("temp/bg/bg.jpg");
			this.fusion.addNode(img);
			
			
		}
	}
}