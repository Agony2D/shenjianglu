package app
{
	import configs.cards.CardConfigurator;
	import configs.skills.SkillConfigurator;
	
	import org.agony2d.base.StateApp;
	import org.agony2d.collections.CsvUtil;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.skins.ButtonSkinType;
	import org.agony2d.flashApi.skins.ButtonSkinUU;
	import org.agony2d.resources.TResourceManager;
	
	import views.UU.loading.Loading_StateUU;
	import views.UU.hall.Hall_StateUU;
	import views.UU.login.Login_Bg_StateUU;
	
	public class Hall_StateApp extends StateApp
	{
		
		override public function onEnter():void{
			
			TResourceManager.addEventListener(AEvent.START, onAssetStart);
			TResourceManager.addEventListener(AEvent.ABORT, onAssetAbort);
			TResourceManager.addEventListener(AEvent.COMPLETE, onAssetLoaded);
			TResourceManager.loadAssets2("data/card_character.csv", "data/card_equipment.csv","data/card_magic.csv", "data/skill.csv", "data/buff.csv");
			TResourceManager.loadAssets("hall.zip");
			TResourceManager.loadAssets("card.zip");
		}
		
		private function onAssetStart(e:AEvent):void{
			UUFacade.getRoot().getWindow(Loading_StateUU).activate();
		}
		
		private function onAssetAbort(e:AEvent):void{
			this.____doInitHall();
		}
		
		private function onAssetLoaded(e:AEvent):void{
			
			var data:Vector.<Array>;
			
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
			
			UUFacade.getRoot().getWindow(Loading_StateUU).close();
			this.____doInitHall();
		}
		
		
		
		
		override public function onExit() : void {
			UUFacade.getRoot().closeAllWindows();
			//			UUFacade.getRoot().getModule(Login_Bg_StateUU).close();
			//			UUFacade.getRoot().getModule(Login_UserInput_StateUU).close();
		}
		
		
		
		
		private function ____doInitHall() : void{
			TResourceManager.removeEventListener(AEvent.START, onAssetStart);
			TResourceManager.removeEventListener(AEvent.ABORT, onAssetAbort);
			TResourceManager.removeEventListener(AEvent.COMPLETE, onAssetLoaded);
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Hall_StateUU).activate();
		}
	}
}