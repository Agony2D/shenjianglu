package app
{
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	
	import models.GameModel;
	
	import org.agony2d.base.StateApp;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.skins.ButtonSkinType;
	import org.agony2d.flashApi.skins.ButtonSkinUU;
	import org.agony2d.flashApi.skins.ToggleSkinUU;
	import org.agony2d.inputs.events.ATouchEvent;
	import org.agony2d.resources.TAssetBundle;
	import org.agony2d.resources.TResourceManager;
	
	import views.UU.login.Login_Bg_StateUU;
	import views.UU.login.Login_UserInput_StateUU;
	
	public class Login_StateApp extends StateApp {
		
		override public function onEnter():void{
			TResourceManager.loadAssets2("temp/bg/bg.jpg");
			TResourceManager.loadAssets2("temp/logo/logo2.png");
//			TResourceManager.loadAssets2("temp/mouse/release.png");
			TResourceManager.loadAssets("login.zip").addEventListener(AEvent.COMPLETE, onAssetsLoaded);
			TResourceManager.addEventListener(AEvent.COMPLETE, onAssetsLoaded);
		}
		
		private function onAssetsLoaded(e:AEvent):void{
			TResourceManager.removeEventListener(AEvent.COMPLETE, onAssetsLoaded);
			
			UUFacade.registerSkin("login_login", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
					TResourceManager.getAsset("login/btn/login_release.png").data,
					TResourceManager.getAsset("login/btn/login_hover.png").data,
					TResourceManager.getAsset("login/btn/login_press.png").data);
			UUFacade.registerSkin("login_checkBox", ToggleSkinUU, ButtonSkinType.NONE, 
					TResourceManager.getAsset("login/btn/checkBox_normal.png").data,
					TResourceManager.getAsset("login/btn/checkBox_down.png").data);
			
			//=============================================================
			UUFacade.getRoot().getWindow(Login_Bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Login_UserInput_StateUU).activate();
			//=============================================================
			
			// 加載[ 登陸 - (選擇服務器) ]資源.
//			setTimeout(function():void{
				var bundle:TAssetBundle = TResourceManager.loadAssets("servers.zip");
				bundle.addEventListener(AEvent.COMPLETE, onLoginServersAssetsLoaded);
//			}, 1000)
				
				
//			var mouseCursorData:MouseCursorData;
			
//			mouseCursorData = new MouseCursorData;
//			mouseCursorData.data = new <BitmapData>[];
//			mouseCursorData.data.push(TResourceManager.getAsset("temp/mouse/release.png").data);
//			Mouse.registerCursor("release", mouseCursorData);
//			Mouse.cursor = "release";
		}
		
		private function onLoginServersAssetsLoaded(e:AEvent):void{
			UUFacade.registerSkin("server_server", ButtonSkinUU, ButtonSkinType.PRESS_OVER, 
					TResourceManager.getAsset("servers/btn/server_release.png").data,
					TResourceManager.getAsset("servers/btn/server_hover.png").data,
					TResourceManager.getAsset("servers/btn/server_press.png").data);
			
			GameModel.isReadyForLoginServers = true;
		}
		
		override public function onExit() : void {
			UUFacade.getRoot().closeAllWindows();
//			UUFacade.getRoot().getModule(Login_Bg_StateUU).close();
//			UUFacade.getRoot().getModule(Login_UserInput_StateUU).close();
		}
	}
}