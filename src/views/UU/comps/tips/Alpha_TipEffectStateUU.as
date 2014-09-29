package views.UU.comps.tips
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import org.agony2d.flashApi.tips.TipEffectStateUU;
	
	public class Alpha_TipEffectStateUU extends TipEffectStateUU
	{
		public function Alpha_TipEffectStateUU()
		{
			super();
		}
		
		
		override public function onEnter():void {
			TweenLite.from(this.fusion, 0.2, {alpha:0.03});
		}
		
		override public function onExit():void {
			TweenLite.to(this.fusion, 0.2, {alpha:0.03, onComplete:function():void{finish()}});
		}
		
		override public function onAbort():void{
			TweenLite.killTweensOf(this.fusion);
		}
	}
}