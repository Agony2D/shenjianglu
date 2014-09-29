package views.UU.room
{
	import app.Battle_StateApp;
	import app.Hall_StateApp;
	
	import models.GameModel;
	
	import net.NetManager;
	
	import org.agony2d.Agony;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.ButtonUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.inputs.events.ATouchEvent;
	import org.agony2d.resources.TResourceManager;
	import org.agony2d.utils.ColorUtil;
	
	import proto.cs.CmdCodeRoom;
	import proto.cs.CmdType;
	import proto.cs.MatchJoinReq;
	
	import utils.TextUtil;
	
	public class Room_StateUU extends StateUU
	{
		
		override public function onEnter():void {
			var btn:ButtonUU;
			var btn_A:ButtonUU;
			var img:BitmapLoaderUU;
			var i:int;
			var l:int;
			
			// 背景.
			_bg = new BitmapLoaderUU;
			_bg.source = TResourceManager.getAsset("room/img/bg_A.jpg");
			this.fusion.addNode(_bg);
			
			// category.
			while(i<4){
				btn = this.____toCategoryView();
				this.fusion.addNode(btn);
				if(i==0){
					btn.x = 42;
					btn.y = 40;
				}
				else{
					btn.locatingTypeForHoriz = LocatingType.L____L_A;
					btn.locatingOffsetX = 17.5;
					btn.locatingTypeForVerti = LocatingType.L_A____L;
				}
				btn.addEventListener(ATouchEvent.CLICK, ____onCamp);
				
				// camp
				btn.userData = ++i;
			}
			
			i = 0;
			while(i<4){
				btn = this.____toCategoryView();
				this.fusion.addNode(btn);
				if(i++==0){
					btn.x = 42;
					btn.y = 260;
				}
				else{
					btn.locatingTypeForHoriz = LocatingType.L____L_A;
					btn.locatingOffsetX = 17.5;
					btn.locatingTypeForVerti = LocatingType.L_A____L;	
				}
			}
			
			// 初期種族.
			GameModel.campIndex = 1;
			
			// 開始遊戲.
			btn = new ButtonUU("room_start");
			this.fusion.addNode(btn);
			btn.x = 363;
			btn.y = 491
			TextUtil.decorateLabel(btn.getLabel(), 33, ColorUtil.COFFEE, true).text = "寻找对手";
			btn.addEventListener(ATouchEvent.CLICK, onStartGame);
			
			// 返回.
			btn = new ButtonUU("room_common_A");
			this.fusion.addNode(btn);
			btn.locatingTypeForHoriz = LocatingType.F____A_F;
			btn.locatingOffsetX = -28;
			btn.y = 26
			TextUtil.decorateLabel(btn.getLabel(), 24, ColorUtil.COFFEE, true).text = "返回";
			btn.addEventListener(ATouchEvent.CLICK, ____onBack);
			
			// 设置.
			btn = new ButtonUU("room_common_A");
			this.fusion.addNode(btn);
			btn.locatingTypeForHoriz = LocatingType.A_L____L;
//			btn.locatingOffsetX = -2;
			btn.y = 26
			TextUtil.decorateLabel(btn.getLabel(),24, ColorUtil.COFFEE, true).text =  "设置";
			
			// 帮助.
			btn = new ButtonUU("room_common_A");
			this.fusion.addNode(btn);
			btn.locatingTypeForHoriz = LocatingType.A_L____L;
//			btn.locatingOffsetX = -2;
			btn.y = 26
			TextUtil.decorateLabel(btn.getLabel(), 24, ColorUtil.COFFEE, true).text = "帮助";
			
			// 声音.
			btn = new ButtonUU("room_common_A");
			this.fusion.addNode(btn);
			btn.locatingTypeForHoriz = LocatingType.A_L____L;
//			btn.locatingOffsetX = -2;
			btn.y = 26
			TextUtil.decorateLabel(btn.getLabel(),24, ColorUtil.COFFEE, true).text =  "声音";
			
			// 形象.
			btn_A = new ButtonUU("room_common_B");
			this.fusion.addNode(btn_A);
			btn_A.locatingTypeForHoriz = LocatingType.L_A____L;
			btn_A.locatingOffsetX = 2
			btn_A.y = 83;
			TextUtil.decorateLabel(btn_A.getLabel(), 23, ColorUtil.COFFEE, true).text = "形\n象";
//			btn_A.getLabel().locatingOffsetX = -2;
//			btn_A.getLabel().locatingOffsetY = 3;
			
			// 战绩.
			btn_A = new ButtonUU("room_common_B");
			btn_A.locatingNode = btn;
			this.fusion.addNode(btn_A);
			btn_A.locatingTypeForHoriz = LocatingType.L_A____L;
			btn_A.locatingOffsetX = 2
			btn_A.y = 179;
			TextUtil.decorateLabel(btn_A.getLabel(), 23, ColorUtil.COFFEE, true).text = "战\n绩";
//			btn_A.getLabel().locatingOffsetX = 2;
//			btn_A.getLabel().locatingOffsetY = 10;
			
			// 财富.
			btn_A = new ButtonUU("room_common_B");
			btn_A.locatingNode = btn;
			this.fusion.addNode(btn_A);
			btn_A.locatingTypeForHoriz = LocatingType.L_A____L;
			btn_A.locatingOffsetX = 2
			btn_A.y = 273;
			TextUtil.decorateLabel(btn_A.getLabel(), 23, ColorUtil.COFFEE, true).text = "财\n富";
//			btn_A.getLabel().locatingOffsetX = 2;
//			btn_A.getLabel().locatingOffsetY = 10;
			
			
			this.fusion.spaceWidth  = _bg.width;
			this.fusion.spaceHeight = _bg.height;
			
			this.fusion.locatingTypeForHoriz = LocatingType.F___A___F;
		}
		
		
		
		
		private var _bg:BitmapLoaderUU;
		
		
		// 開始尋找遊戲.
		private function onStartGame(e:ATouchEvent):void{
			var msg:MatchJoinReq;
			
			msg = new MatchJoinReq;
			msg.mod = GameModel.gameMode;
			msg.campId = GameModel.campIndex;
			NetManager.sendRequest(CmdType.CT_ROOM, CmdCodeRoom.CC_ROOM_MATCH_JOIN_REQ, msg);
			GameModel.getLog().simplify("開始匹配比賽...");
			
			
			
			this.fusion.touchable = false;
		}
		
		// 返回大廳.
		private function ____onBack(e:ATouchEvent):void{
			Agony.setStateForApp(Hall_StateApp);
		}
		
		// 選擇種族.
		private function ____onCamp(e:ATouchEvent):void{
			GameModel.campIndex = e.target.userData;
			trace("選擇種族: ", e.target.userData);
		}
		
		private function ____toCategoryView() : ButtonUU {
			var btn:ButtonUU;
			
			btn = new ButtonUU("room_category");
			return btn;
		}
	}
}