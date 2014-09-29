package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	import configs.battle.BattleConfigurator;
	import configs.cards.CardConfigurator;
	import configs.skills.SkillConfigurator;
	
	import models.GameModel;
	import models.battle.BattleModel;
	
	import org.agony2d.Agony;
	import org.agony2d.display.animation.AnimationManager;
	import org.agony2d.base.Adapter;
	import org.agony2d.base.DebugLogger;
	import org.agony2d.collections.CsvUtil;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.skins.ButtonSkinType;
	import org.agony2d.flashApi.skins.ButtonSkinUU;
	import org.agony2d.flashApi.skins.ToggleSkinUU;
	import org.agony2d.inputs.TouchManager;
	import org.agony2d.resources.TResourceManager;
	import org.agony2d.utils.Stats;
	
	import views.UU.battle.Battle_active_StateUU;
	import views.UU.battle.Battle_active_post_StateUU;
	import views.UU.battle.Battle_active_pre_StateUU;
	import views.UU.battle.Battle_bg_StateUU;
	import views.UU.battle.Battle_ready_StateUU;
	import views.UU.battle.Battle_ui_StateUU;
	import views.UU.comps.CardUU;
	import views.UU.comps.cardStates.CharacterCard_StateUU;
	import views.UU.hall.Hall_StateUU;
	import views.UU.login.Login_Bg_StateUU;
	import views.UU.login.Login_Creation_StateUU;
	import views.UU.login.Login_Servers_StateUU;
	import views.UU.login.Login_UserInput_StateUU;
	import views.UU.room.Room_StateUU;
	
	[SWF(width="1160", height="720", frameRate="60",backgroundColor = "0x0")]
//	[SWF(width="1280", height="800", frameRate="60",backgroundColor = "0x0")]
	public class UnitTest_For_Ui extends Sprite
	{
		public function UnitTest_For_Ui()
		{
//			Agony.startup(stage, new DebugLogger, null, onInit);
			Agony.startup(stage, new DebugLogger("(A)"), new Adapter(1280, 960, true), onInit);
		}
		
		// login
//		public var assetsList:Array = ["login.zip","servers.zip"]
		
		// hall
//		public var assetsList:Array = ["hall.zip"]
			
		// create role
//		public var assetsList:Array = ["login.zip","creation.zip"]
		
		// room
//		public var assetsList:Array = ["room.zip"]
		
		// battle
		public var assetsList:Array = ["login.zip", "card.zip", "battle.zip"]	
		public var csvList:Array = ["data/card_character.csv", "data/card_equipment.csv","data/card_magic.csv", "data/skill.csv", "data/buff.csv"]
			
			
		private function onInit():void{
			var data:Vector.<Array>;
			
			
			TouchManager.registerListenTarget();
			AnimationManager.defaultFrameRate = 12;
			TResourceManager.initialize();
			UUFacade.registerRoot();
			
			stage.addChild(new Stats(0, 40));
			
			// 屏蔽右鍵.
//			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void{}); 
			
			
			TResourceManager.loadAssets2("temp/bg/bg.jpg");
			
			var i:int;
			while(i<assetsList.length){
				TResourceManager.loadAssets(assetsList[i++]);
			}
			
			if(_isBattleState){
				
//				Agony.getAdapter().pixelRatio = 1;
				
				var img:BitmapLoaderUU;
				
				var l:int;
				var assetURLs:Array = [];
				i = 0;
				l = 28;
				while(++i<=l){
					assetURLs.push("temp/battle/bg/" + i + ".png");
				}
				i = 0;
				l = 25;
				while(++i <= l){
					assetURLs.push("temp/battle/grid_5_5/creation/" + i + ".png");
					assetURLs.push("temp/battle/grid_5_5/movement/" + i + ".png");
					assetURLs.push("temp/battle/grid_5_5/selection/" + i + ".png");
					assetURLs.push("temp/battle/grid_5_5/target/" + i + ".png");
				}
				TResourceManager.loadAssets2.apply(null, assetURLs);
				
				TResourceManager.loadAssets2("animation/common.xml", "data/5-5_grid.csv").addEventListener(AEvent.COMPLETE, function(e:AEvent):void{
					AnimationManager.addFrameClips(TResourceManager.getAsset("animation/common.xml").data);
					data = CsvUtil.parse(TResourceManager.getAsset("data/5-5_grid.csv").data);
					BattleConfigurator.initGrids(data);
				})
				
				TResourceManager.loadAssets2("atlas/shang/shield.atlas", "atlas/zhouwang.atlas", "atlas/tianyuan.atlas", "atlas/roundOk.atlas").addEventListener(AEvent.COMPLETE, function(e:AEvent):void{
					UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/shang/shield.atlas").data);
					UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/zhouwang.atlas").data);
					UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/tianyuan.atlas").data);
					UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/roundOk.atlas").data);
				});
				
				
				
			}
			
			TResourceManager.loadAssets2.apply(null, csvList);
			TResourceManager.addEventListener(AEvent.COMPLETE, onAssetsLoaded);
		}
		
		private static var _isBattleState:Boolean = true;
		
		
		
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		
		private function onAssetsLoaded(e:AEvent):void{
			TResourceManager.removeEventListener(AEvent.COMPLETE, onAssetsLoaded);
			
//			this.doTestLoginInputModule();
//			this.doTestLoginServersModule();
//			this.doTestHallModule();
//			this.doTestCreateRoleModule();
//			this.doTestRoomModule();
			
			this.doTestBattleState();
		}
		
		
		
		
		// 登入輸入
		private function doTestLoginInputModule():void{
			UUFacade.registerSkin("login_btn", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
					TResourceManager.getAsset("login/btn/login_release.png").data,
					TResourceManager.getAsset("login/btn/login_hover.png").data,
					TResourceManager.getAsset("login/btn/login_press.png").data);
			UUFacade.registerSkin("login_checkBox", ToggleSkinUU, ButtonSkinType.NONE, 
					TResourceManager.getAsset("login/btn/checkBox_normal.png").data,
					TResourceManager.getAsset("login/btn/checkBox_down.png").data);
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Login_UserInput_StateUU).activate();
		}
		
		// 登入選服務器
		private function doTestLoginServersModule():void{
			UUFacade.registerSkin("login_login", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
					TResourceManager.getAsset("login/btn/login_release.png").data,
					TResourceManager.getAsset("login/btn/login_hover.png").data,
					TResourceManager.getAsset("login/btn/login_press.png").data);
			UUFacade.registerSkin("login_checkBox", ToggleSkinUU, ButtonSkinType.NONE, 
					TResourceManager.getAsset("login/btn/checkBox_normal.png").data,
					TResourceManager.getAsset("login/btn/checkBox_down.png").data);
			UUFacade.registerSkin("server_server", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
					TResourceManager.getAsset("servers/btn/server_release.png").data,
					TResourceManager.getAsset("servers/btn/server_hover.png").data,
					TResourceManager.getAsset("servers/btn/server_press.png").data);
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Login_Servers_StateUU).activate();
		}
		
		// 大廳 (選擇模式)
		private function doTestHallModule():void{
			UUFacade.registerSkin("hall_practice", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
					TResourceManager.getAsset("hall/btn/practice_release.png").data,
					TResourceManager.getAsset("hall/btn/practice_hover.png").data,
					TResourceManager.getAsset("hall/btn/practice_press.png").data);
			UUFacade.registerSkin("hall_pvp", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/pvp_release.png").data,
				TResourceManager.getAsset("hall/btn/pvp_hover.png").data,
				TResourceManager.getAsset("hall/btn/pvp_press.png").data);
			UUFacade.registerSkin("hall_identity", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/identity_release.png").data,
				TResourceManager.getAsset("hall/btn/identity_hover.png").data,
				TResourceManager.getAsset("hall/btn/identity_press.png").data);
			UUFacade.registerSkin("hall_arena", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/arena_release.png").data,
				TResourceManager.getAsset("hall/btn/arena_hover.png").data,
				TResourceManager.getAsset("hall/btn/arena_press.png").data);
			UUFacade.registerSkin("hall_icon", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/icon_release.png").data,
				TResourceManager.getAsset("hall/btn/icon_hover.png").data,
				TResourceManager.getAsset("hall/btn/icon_press.png").data);
			UUFacade.registerSkin("hall_back", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/back_release.png").data,
				TResourceManager.getAsset("hall/btn/back_hover.png").data,
				TResourceManager.getAsset("hall/btn/back_press.png").data);
			UUFacade.registerSkin("hall_setting", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/setting_release.png").data,
				TResourceManager.getAsset("hall/btn/setting_hover.png").data,
				TResourceManager.getAsset("hall/btn/setting_press.png").data);
			UUFacade.registerSkin("hall_music", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/music_release.png").data,
				TResourceManager.getAsset("hall/btn/music_hover.png").data,
				TResourceManager.getAsset("hall/btn/music_press.png").data);
			UUFacade.registerSkin("hall_mycard", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("hall/btn/mycard_release.png").data,
				TResourceManager.getAsset("hall/btn/mycard_hover.png").data,
				TResourceManager.getAsset("hall/btn/mycard_press.png").data);
			
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Hall_StateUU).activate();
		}
		
		
		// 創建角色.
		private function doTestCreateRoleModule():void{
			UUFacade.registerSkin("login_login", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("login/btn/login_release.png").data,
				TResourceManager.getAsset("login/btn/login_hover.png").data,
				TResourceManager.getAsset("login/btn/login_press.png").data);
			
			UUFacade.registerSkin("creation_dice", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("creation/btn/dice_release.png").data,
				TResourceManager.getAsset("creation/btn/dice_hover.png").data,
				TResourceManager.getAsset("creation/btn/dice_press.png").data);
			
			UUFacade.registerSkin("creation_page", ButtonSkinUU, ButtonSkinType.PRESS_OVER_INVALID, 
				TResourceManager.getAsset("creation/btn/page_release.png").data,
				TResourceManager.getAsset("creation/btn/page_hover.png").data,
				TResourceManager.getAsset("creation/btn/page_press.png").data,
				TResourceManager.getAsset("creation/btn/page_press.png").data);
			
			UUFacade.registerSkin("creation_sex", ToggleSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("creation/btn/sex_unselected.png").data,
				TResourceManager.getAsset("creation/btn/sex_hover.png").data,
				TResourceManager.getAsset("creation/btn/sex_hover.png").data,
				TResourceManager.getAsset("creation/btn/sex_selected.png").data,
				TResourceManager.getAsset("creation/btn/sex_selected.png").data,
				TResourceManager.getAsset("creation/btn/sex_selected.png").data);
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Login_Creation_StateUU).activate();
		}
		
		private function doTestRoomModule() : void {
			UUFacade.registerSkin("room_category", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/category_release.png").data,
				TResourceManager.getAsset("room/btn/category_hover.png").data,
				TResourceManager.getAsset("room/btn/category_press.png").data);
			UUFacade.registerSkin("room_common_A", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/common_A_release.png").data,
				TResourceManager.getAsset("room/btn/common_A_hover.png").data,
				TResourceManager.getAsset("room/btn/common_A_press.png").data);
			UUFacade.registerSkin("room_common_B", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/common_B_release.png").data,
				TResourceManager.getAsset("room/btn/common_B_hover.png").data,
				TResourceManager.getAsset("room/btn/common_B_press.png").data);
			UUFacade.registerSkin("room_common_C", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/common_C_release.png").data,
				TResourceManager.getAsset("room/btn/common_C_hover.png").data,
				TResourceManager.getAsset("room/btn/common_C_press.png").data);
			UUFacade.registerSkin("room_mycard", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/mycard_release.png").data,
				TResourceManager.getAsset("room/btn/mycard_hover.png").data,
				TResourceManager.getAsset("room/btn/mycard_press.png").data);
			UUFacade.registerSkin("room_page", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/page_release.png").data,
				TResourceManager.getAsset("room/btn/page_hover.png").data,
				TResourceManager.getAsset("room/btn/page_press.png").data);
			UUFacade.registerSkin("room_start", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/start_release.png").data,
				TResourceManager.getAsset("room/btn/start_hover.png").data,
				TResourceManager.getAsset("room/btn/start_press.png").data);
			UUFacade.registerSkin("room_tab", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("room/btn/tab_release.png").data,
				TResourceManager.getAsset("room/btn/tab_hover.png").data,
				TResourceManager.getAsset("room/btn/tab_press.png").data);
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Room_StateUU).activate();
		}
		
		
		
		private function doTestBattleState() : void {
			var data:Vector.<Array>;
			
			BattleModel.initialize();
			
			UUFacade.registerSkin("login_login", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
				TResourceManager.getAsset("login/btn/login_release.png").data,
				TResourceManager.getAsset("login/btn/login_hover.png").data,
				TResourceManager.getAsset("login/btn/login_press.png").data);
			
			UUFacade.registerSkin("battle_roundOk", ButtonSkinUU, ButtonSkinType.PRESS, 
				TResourceManager.getAsset("battle/btn/roundOk_release.png").data,
				TResourceManager.getAsset("battle/btn/roundOk_press.png").data);
			
			data = CsvUtil.parse(TResourceManager.getAsset("data/card_character.csv").data);
			CardConfigurator.initCharacterCards(data);
			data = CsvUtil.parse(TResourceManager.getAsset("data/card_equipment.csv").data);
			CardConfigurator.initEquipmentCards(data);
			data = CsvUtil.parse(TResourceManager.getAsset("data/card_magic.csv").data);
			CardConfigurator.initMagicCards(data);
			data = CsvUtil.parse(TResourceManager.getAsset("data/skill.csv").data);
			SkillConfigurator.initSkill(data);
			data = CsvUtil.parse(TResourceManager.getAsset("data/buff.csv").data);
			SkillConfigurator.initBuff(data);
			
			
			BattleModel.initCards = [10008,10025,20012,20014,20015];
//			BattleModel.initCards = [10008,10025,20012,20014,20015,20012,   20014,20015,20012,20014,20015,20014];
			
			
			// 戰鬥管理器初期化.
			BattleModel.initialize();
			
			
			UUFacade.getRoot().getWindow(Battle_bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_active_pre_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_active_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_active_post_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_ui_StateUU).activate();
			
//			UUFacade.getRoot().getWindow(Battle_ready_StateUU).activate();
		}
	}
}