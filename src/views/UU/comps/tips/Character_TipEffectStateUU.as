package views.UU.comps.tips
{
	import flash.geom.Point;
	
	import org.agony2d.flashApi.tips.TipViewStateUU;
	
	import views.UU.comps.CardUU;

	public class Character_TipEffectStateUU extends TipViewStateUU
	{

		override public function onEnter():void {
			var cardView:CardUU;
			var coord:Point;
			
			cardView = new CardUU;
			cardView.setCardId(this.tipData.userData as int);
			this.fusion.addNode(cardView);
			
			
			coord = this.target.parent.localToGlobal(this.target.x, this.target.y);
			
			// 左
			if(coord.x + this.target.width / 2 + this.fusion.width > this.fusion.root.width){
				coord.x = coord.x - this.target.width / 2 - this.fusion.width - 66;
			}
			// 右
			else {	
				coord.x = coord.x + this.target.width / 2 + 66;
			}
			// 上
			if(coord.y + this.target.height / 2 + this.fusion.height + 11 > this.fusion.root.height){
				coord.y = coord.y - this.target.height / 2 - this.fusion.height - 11;
			}
			// 下
			else {	
				coord.y = coord.y + this.target.height / 2 + 11;
			}
			
			this.fusion.x = coord.x;
			this.fusion.y = coord.y;
			
			
		}
	}
}