package app
{
	import configs.ConfigNet;
	
	import net.NetManager;
	
	import org.agony2d.base.StateApp;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.skins.ButtonSkinType;
	import org.agony2d.flashApi.skins.ButtonSkinUU;
	import org.agony2d.resources.TResourceManager;
	
	import proto.cs.CmdCodeSign;
	import proto.cs.CmdType;
	import proto.cs.SignReq;
	
	import res.ResUtil;
	
	import views.UU.loading.BattleLoading_StateUU;
	
	
	// bg
	// ui_A
	// active
	// ui_B
	
	public class Battle_StateApp extends StateApp
	{
		override public function onEnter():void{
			var data:Vector.<Array>;
			
			
			// 戰鬥場景Ui
			TResourceManager.addEventListener(AEvent.ABORT, onAssetAbort);
			TResourceManager.addEventListener(AEvent.COMPLETE, onAssetLoaded);
			
			UUFacade.getRoot().getWindow(BattleLoading_StateUU).activate();
			
			ResUtil.loadBattleAssets();
			
			
			
		}
		
		private function onAssetAbort(e:AEvent):void{
			this.____doRequestBattle();
		}
		
		private function onAssetLoaded(e:AEvent):void{
			UUFacade.registerSkin("battle_roundOk", ButtonSkinUU, ButtonSkinType.PRESS, 
				TResourceManager.getAsset("battle/btn/roundOk_release.png").data,
				TResourceManager.getAsset("battle/btn/roundOk_press.png").data);
			
			this.____doRequestBattle();
		}
		
		
		override public function onExit() : void {
			UUFacade.getRoot().closeAllWindows();
		}
		
		private function ____doRequestBattle() : void{
			
			TResourceManager.removeEventListener(AEvent.ABORT, onAssetAbort);
			TResourceManager.removeEventListener(AEvent.COMPLETE, onAssetLoaded);

			
			
			var msg_A:SignReq;
			
			msg_A = new SignReq;
			msg_A.uid = ConfigNet.uid;
			msg_A.cbData = 1;
			NetManager.sendRequest2(CmdType.CT_AUTH, CmdCodeSign.CC_AUTH_SIGN_REQ, msg_A);
			
		}
		
	}
}