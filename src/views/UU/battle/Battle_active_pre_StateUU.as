package views.UU.battle
{
	import flash.geom.Point;
	
	import configs.battle.BattleConfigurator;
	import configs.battle.GridCfg;
	
	import models.GameModel;
	import models.battle.BattleModel;
	import models.battle.CharacterVo;
	import models.battle.MapModel;
	import models.events.NullSelectedUiEvent;
	import models.events.SelectedUiHoverCardEvent;
	import models.events.SelectedUiMovementEvent;
	
	import net.NetManager;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.ImageLoaderUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.inputs.events.ATouchEvent;
	import org.agony2d.resources.TResourceManager;
	
	import proto.cs.CmdCodeBattle;
	import proto.cs.CmdType;
	import proto.cs.MoveChessReq;
	
	
	// 相當於外背景層 (地圖格子).
	public class Battle_active_pre_StateUU extends StateUU
	{	
		
		
		public static const CREATION:String = "creation";
		public static const MOVEMENT:String = "movement";
		public static const SELECTION:String = "selection";
		public static const TARGET:String = "target";
		
		
		
		override public function onEnter():void {
			this.fusion.spaceWidth = BattleModel.gridWidth;
			this.fusion.spaceHeight = BattleModel.gridHeight;
			this.fusion.locatingOffsetY = -70;
			
			
			// [ 偵聽器 ] - 戰鬥選中Ui狀態變化.
			BattleModel.addEventListener(SelectedUiHoverCardEvent.HOVER_CARD, onSelectedUiHoverCard);
			BattleModel.addEventListener(SelectedUiMovementEvent.MOVEMENT,    onSelectedUiMovement);
			BattleModel.addEventListener(NullSelectedUiEvent.NULL_SELECTED,   onNullSelectedUi);
			
			// [ 偵聽器 ] - 窗口尺寸變化.
			this.fusion.root.addEventListener(AEvent.RESIZE, ____onResize);
			this.____onResize(null);
			
		}
		
		
		private function ____onResize(e:AEvent):void{
			this.fusion.locatingTypeForHoriz = LocatingType.F___A___F;
			this.fusion.locatingTypeForVerti = LocatingType.F___A___F;
			
			
		}
		
		private function onSelectedUiHoverCard(e:SelectedUiHoverCardEvent):void{
			this.____doUpdateSelectedState(e.girdIdList);
		}
		
		
		private function ____doUpdateSelectedState(  gridIdList:Array ) : void {
			var img:ImageLoaderUU;
			var i:int;
			var l:int;
			var coord:Point;
			var gridId:int;
			
			l = gridIdList.length;
			
			// No item.
			if(l == 0){
				return;
			}
			
			// Update.
			while(i<l){
				gridId = gridIdList[i++];
				
				this.____doAddGridImg(gridId, CREATION);
			}
			
		}
		
		
		private function onSelectedUiMovement(e:SelectedUiMovementEvent):void{
			var img:ImageLoaderUU;
			var i:int;
			var l:int;
			
			var gridId:int;
			var gridIdList:Vector.<int>;
			
			
			
			gridIdList = e.pathGirdIdList;
			
			
//			trace(gridIdList);
			l = gridIdList.length;
			
			// Clear.
			this.fusion.killNodesAt();
			
			// Start pos
			this.____doAddGridImg(e.startGridId, SELECTION);
			
			// Movement pos.
			while(i<l){
				gridId = gridIdList[i++];

				img = this.____doAddGridImg(gridId, MOVEMENT);
				img.addEventListener(ATouchEvent.CLICK, ____onFindPath);
			}
			
		}
		
		
		private function onNullSelectedUi(e:NullSelectedUiEvent):void{
			// Clear.
			this.fusion.killNodesAt();
		}
		
		private function ____doAddGridImg( gridId:int, type:String ) : ImageLoaderUU {
			var img:ImageLoaderUU;
			var coord:Point;
			
			img = new ImageLoaderUU;
			this.fusion.addNode(img);
			img.source = TResourceManager.getAsset("temp/battle/grid_5_5/" + type + "/" + ((4 - int((gridId - 1) / 5)) * 5 + (gridId - 1) % 5 + 1) + ".png");
			img.pivotX = img.width / 2;
			img.pivotY = img.height / 2;
			coord = BattleConfigurator.getCoordByGridId(gridId);
			img.x = coord.x;
			img.y = coord.y;
			
			// UserData - grid cfg.
			img.userData = BattleConfigurator.getCfgByGridId(gridId);
			
			return img;
		}
		
		private function ____onFindPath(e:ATouchEvent):void{
			var endGridId:int;
			var msg:MoveChessReq;
			var vo:CharacterVo;
			var movePath:Array;
			
			// 清空Ui狀態.
			BattleModel.setNullSelectedUiState();
			
			
			endGridId = (e.target.userData as GridCfg).id;
			movePath = MapModel.findPath(MapModel.cachedStartGridId, endGridId);

			vo = BattleModel.getVoByGridId(MapModel.cachedStartGridId);
			msg = new MoveChessReq;
			msg.chessUid = vo.guid;
			msg.movePath = movePath;
			NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_MOVE_CHESS_REQ, msg);
			
			
			// 起始點重置.
			MapModel.cachedStartGridId = endGridId;
			
			GameModel.getLog().simplify("客戶端尋路: {0}", movePath);
			
			// 移動動作進行時，暫不可操控其他.
			BattleModel.dispatchMyControlChanged(false);
		}
		
	}
}