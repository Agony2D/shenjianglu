package views.UU.loading
{
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.resources.TResourceManager;

	public class Loading_StateUU extends StateUU 
	{
		public function Loading_StateUU()
		{
		}
		
		override public function onEnter():void{
			var img:BitmapLoaderUU;
			
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("temp/bg/bg.jpg");
			this.fusion.addNode(img);
			
			this.fusion.spaceWidth = img.width;
			this.fusion.spaceHeight  = img.height;
				
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("temp/logo/logo2.png");
			this.fusion.addNode(img);
			
			img.locatingTypeForHoriz = LocatingType.F___A___F;
			img.y = 150
		}
		
		
		
	}
}