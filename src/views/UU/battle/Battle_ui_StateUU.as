package views.UU.battle
{
	import models.events.ManaCostEvent;
	import models.events.RoundEvent;
	
	import models.battle.BattleModel;
	import models.player.PlayerModel;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.ButtonUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.resources.TResourceManager;
	
	import views.UU.comps.ManaBarUU;
	
	
	
	// 最外層Ui。
	//   隨stage尺寸改變自動調整四周佈局.
	public class Battle_ui_StateUU extends StateUU
	{
		override public function onEnter():void
		{
			var btn:ButtonUU;
			
			
			// 我的頭像
			img_AA = new BitmapLoaderUU;
			img_AA.source = TResourceManager.getAsset("battle/img/profile_male.png");
			this.fusion.addNode(img_AA);
			img_AA.x = 11;
			img_AA.locatingOffsetY = -25;
			
			// 我的頭像外框.
			img_A = new BitmapLoaderUU;
			img_A.source = TResourceManager.getAsset("battle/img/myProfileFrame.png");
			this.fusion.addNode(img_A);

			// 對方頭像
			img_BB = new BitmapLoaderUU;
			img_BB.source = TResourceManager.getAsset("battle/img/profile_female.png");
			this.fusion.addNode(img_BB);
//			img_BB.locatingOffsetX = 1;
//			img_BB.y = 3;
			
			// 對方頭像外框.
			img_B = new BitmapLoaderUU;
			img_B.source = TResourceManager.getAsset("battle/img/rivalProfileFrame.png");
			this.fusion.addNode(img_B);	
			
			
			// 自己的魔法條.
			_manaBar_A = new ManaBarUU;
			this.fusion.addNode(_manaBar_A);
			
			
			// 對方魔法條.
			_manaBar_R = new ManaBarUU;
			this.fusion.addNode(_manaBar_R);
			
			
			
			this.fusion.root.addEventListener(AEvent.RESIZE, onResize);
			this.onResize(null);
			
			
			
			
			BattleModel.addEventListener(ManaCostEvent.MP_CHANGE, onMpChanged);
			BattleModel.addEventListener(RoundEvent.ROUND_BEGIN, ____onRoundBegin);
		}
		
		override public function onExit():void{
			this.fusion.root.removeEventListener(AEvent.RESIZE, onResize);
		}
		
		
		private var img_A:BitmapLoaderUU;
		private var img_AA:BitmapLoaderUU;
		private var img_B:BitmapLoaderUU;
		private var img_BB:BitmapLoaderUU;
		private var _manaBar_R:ManaBarUU;
		private var _manaBar_A:ManaBarUU;
		
		
		private function onResize(e:AEvent):void{
			this.fusion.spaceWidth = this.fusion.root.spaceWidth;
			this.fusion.spaceHeight = this.fusion.root.spaceHeight;
			img_A.locatingTypeForVerti = LocatingType.F____A_F;
			img_AA.locatingTypeForVerti = LocatingType.F____A_F;
			
			img_B.locatingTypeForHoriz = LocatingType.F____A_F;
			img_BB.locatingTypeForHoriz = LocatingType.F____A_F;
			
			_manaBar_A.locatingTypeForHoriz = LocatingType.F____A_F;
			_manaBar_A.locatingTypeForVerti = LocatingType.F____A_F;
		}
		
		
		private function onMpChanged(e:ManaCostEvent):void{
			if(PlayerModel.isMyRole(e.roleId)){
				_manaBar_A.setValue(e.remainMp);
			}
			else {
				_manaBar_R.setValue(e.remainMp);
			}
		}
		
		private function ____onRoundBegin(e:RoundEvent):void{
			if(PlayerModel.isMyRole(e.roleId)){
				_manaBar_A.setValue(5);
			}
			else{
				_manaBar_R.setValue(5);
			}
		}
	}
}


