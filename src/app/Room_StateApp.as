package app
{
	import flash.utils.setTimeout;
	
	import org.agony2d.base.StateApp;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.skins.ButtonSkinType;
	import org.agony2d.flashApi.skins.ButtonSkinUU;
	import org.agony2d.resources.TResourceManager;
	
	import views.UU.loading.Loading_StateUU;
	import views.UU.login.Login_Bg_StateUU;
	import views.UU.room.Room_StateUU;
	
	public class Room_StateApp extends StateApp
	{
		
		override public function onEnter():void{
			TResourceManager.addEventListener(AEvent.START, onAssetStart);
			TResourceManager.addEventListener(AEvent.ABORT, onAssetAbort);
			TResourceManager.addEventListener(AEvent.COMPLETE, onAssetLoaded);
			TResourceManager.loadAssets("room.zip");
		}
		
		private function onAssetStart(e:AEvent):void{
			UUFacade.getRoot().getWindow(Loading_StateUU).activate();
		}
		
		private function onAssetAbort(e:AEvent):void{
			this.____doInitRoom();
		}
		
		
		private function onAssetLoaded(e:AEvent):void{
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
			
			
			UUFacade.getRoot().getWindow(Loading_StateUU).close();
			this.____doInitRoom();
			
			
			// 進入房間後開始在後台自動加載戰鬥背景.
			setTimeout(function():void{
				var i:int;
				var l:int;
				var img:BitmapLoaderUU;
				var ass_A:Array = [];
				var ass_B:Array = [];
				var ass_C:Array = [];
				var ass_D:Array = [];
				
				var assetURLs:Array = [];
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
					assetURLs.push("temp/battle/grid_5_5/aoe/" + i + ".png");
				}
				TResourceManager.loadAssets2.apply(null, assetURLs);
			}, 300);
		}
		
		
		override public function onExit():void{
			UUFacade.getRoot().closeAllWindows();
		}
		
		
		private function ____doInitRoom() : void{
			TResourceManager.removeEventListener(AEvent.START, onAssetStart);
			TResourceManager.removeEventListener(AEvent.ABORT, onAssetAbort);
			TResourceManager.removeEventListener(AEvent.COMPLETE, onAssetLoaded);
			
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Room_StateUU).activate();
		}
		
	}
}