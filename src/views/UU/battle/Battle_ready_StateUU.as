package views.UU.battle
{
	import models.GameModel;
	import models.battle.BattleModel;
	
	import net.NetManager;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.ButtonUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.inputs.events.ATouchEvent;
	
	import proto.cs.CmdCodeBattle;
	import proto.cs.CmdType;
	
	import views.UU.comps.CardUU;

	public class Battle_ready_StateUU extends StateUU
	{
		override public function onEnter():void
		{
			var initCardVoList:Array;
			var i:int;
			var l:int;
			var card:CardUU;
			var btn:ButtonUU;
			
			initCardVoList = BattleModel.initCards
			l = initCardVoList.length;
			while(i<l){
				card = new CardUU;
				card.setCardId(initCardVoList[i]);
				this.fusion.addNode(card);
				card.x = i * 260;
//				card.y = 220;
				card.scaleX = card.scaleY = 0.9
				i++;
			}
			
			
			btn = new ButtonUU("login_login");
			this.fusion.addNode(btn);
			btn.locatingOffsetY = 100
			btn.locatingTypeForHoriz = LocatingType.F___A___F;
			btn.locatingTypeForVerti = LocatingType.F____F_A;
			btn.locatingOffsetY = 80
			btn.addEventListener(ATouchEvent.CLICK, onStart);
			
			
			this.fusion.root.addEventListener(AEvent.RESIZE, onResize);
			
//			this.fusion.locatingOffsetY =
			
			this.onResize(null);
			
			
		}
		
		
		override public function onExit():void {
			this.fusion.root.removeEventListener(AEvent.RESIZE, onResize);
		}
		
		
		
		private function onResize(e:AEvent):void{
			this.fusion.locatingTypeForHoriz = LocatingType.F___A___F;
			this.fusion.locatingTypeForVerti = LocatingType.F___A___F;
		}
		
		
		
		private function onStart(e:ATouchEvent):void{
			GameModel.getLog().simplify("請求戰鬥.");
			
			NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_ARENA_GAME_START_REQ, null);
			
//			BattleModel.startBattle();
			
			this.fusion.touchable = false;
		}
	}
}