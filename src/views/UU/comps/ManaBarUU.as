package views.UU.comps
{
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.FusionUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.Scale9BitmapUU;
	import org.agony2d.flashApi.core.NodeUU;
	import org.agony2d.resources.TResourceManager;
	
	public class ManaBarUU extends FusionUU
	{
		public function ManaBarUU()
		{
			var img:BitmapLoaderUU;
			var scale9Img:Scale9BitmapUU;
			var img_A:BitmapLoaderUU;
			var i:int;
			var l:int;
			
			scale9Img = new Scale9BitmapUU;
			scale9Img.source = TResourceManager.getAsset("battle/img/magic_bg_A.png");
			scale9Img.width = 200;
			this.addNode(scale9Img);
			scale9Img.x = 8;
			
			
			l = 5;
			while(i<l){
				img = new BitmapLoaderUU;
				img.source = TResourceManager.getAsset("battle/img/magicBg.png");
				this.addNode(img);
				img.x = i * 44;
				
				img_A = new BitmapLoaderUU;
				img_A.source = TResourceManager.getAsset("battle/img/magic.png");
				this.addNode(img_A);
				img_A.locatingTypeForHoriz = LocatingType.L___A___L;
				img_A.locatingTypeForVerti = LocatingType.L___A___L;
				
				_list[i++] = img_A;
			}
			
			
			
		}
		
		
		/**
		 * 設定當前魔法值
		 *  
		 * @param mana
		 * 
		 */		
		public function setValue( mana:int ) : void {
			var i:int;
			var l:int;
			
			i = 1;
			l = 5;
			while(i <= l){
				if(i <= mana){
					_list[i - 1].visible = true;
				}
				else {
					_list[i - 1].visible = false;
				}
				i++;
			}
			
		}
		
		
		private var _list:Vector.<NodeUU> = new <NodeUU>[];
	}
}