package net.responses
{
	import app.Hall_StateApp;
	
	import configs.ConfigNet;
	
	import models.GameModel;
	
	import net.NetManager;
	import net.NetUtil;
	
	import org.agony2d.Agony;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.resources.TAssetBundle;
	import org.agony2d.resources.TResourceManager;
	
	import proto.cs.AccountLoginRes;
	import proto.cs.CmdCodeLogin;
	import proto.cs.CmdCodeSign;
	import proto.cs.CmdType;
	import proto.cs.LoginBody;
	import proto.cs.LoginRes;
	import proto.cs.LoginSelectArenaRes;
	import proto.cs.SignZoneIpReq;
	
	import views.UU.login.Login_Servers_StateUU;
	import views.UU.login.Login_UserInput_StateUU;
	
	public class LoginResponsor implements IResponsor
	{
		public function onHandle(cmd_B:int, subMsg:Object):void
		{
			var subMsg_A:LoginBody;
			
			subMsg_A = subMsg as LoginBody;
			switch(cmd_B){
				// 登入賬號.
				case CmdCodeLogin.CC_ACCOUNT_LOGIN_RES:
					this.onAccountLogin(subMsg_A.accountLoginRes as AccountLoginRes)
					break;
				
				// 選擇專區.
				case CmdCodeLogin.CC_LOGIN_SELECT_ARENA_RES:
					this.onLoginSelectArena(subMsg_A.loginSelectArenaRes as LoginSelectArenaRes)
					break;
				
				// 登入場景.
				case CmdCodeLogin.CC_LOGIN_LOGIN_RES:
					this.onLoginLogin(subMsg_A.loginRes as LoginRes)
					break;
				
				case CmdCodeLogin.CC_LOGIN_LOGOUT_RES:
					
					break;

				default:
					
					break;
			}
		}
		
		private function onAccountLogin( v:AccountLoginRes ) : void{
			var bundle:TAssetBundle;
			
			if(!v.ret){
				GameModel.getLog().warning(this, "onAccountLogin", "登陸失敗.");
			}
//			Global.getLog().simplify("Uid: {0}, LastArena: {1}. desc:{2}.", v.uid, v.lastArenaId, v.desc)
			
			ConfigNet.uid = v.uid;
				
			// 輸入Ui關閉.
			UUFacade.getRoot().getWindow(Login_UserInput_StateUU).close();
			
			if(GameModel.isReadyForLoginServers){
				// 選擇服務器Ui.
				UUFacade.getRoot().getWindow(Login_Servers_StateUU).activate([v.arenaServers, v.lastArenaId]);
			}
			else {
				// 加載[ 登陸 - (選擇服務器) ]資源.
				bundle = TResourceManager.loadAssets("servers.zip");
				bundle.addEventListener(AEvent.COMPLETE, ____onLoginServersAssetsLoaded);
				bundle.userData = v;
			}
		}
		
		private function ____onLoginServersAssetsLoaded(e:AEvent):void{
			TResourceManager.loadAssets("servers.zip").removeEventListener(AEvent.COMPLETE, ____onLoginServersAssetsLoaded);
			
			// 選擇服務器Ui.
			UUFacade.getRoot().getWindow(Login_Servers_StateUU).activate([(e.target.userData as AccountLoginRes).arenaServers]);
		}
		
		
		private function onLoginSelectArena( v:LoginSelectArenaRes ) : void{
			var AY:Array;
			
			if(v.ret){
				GameModel.getLog().message(this, v.desc);
				AY = NetUtil.getIpAndPort(ConfigNet.currArena.arenaIp);
				NetManager.connect(AY[0], AY[1]);
				NetManager.addEventListener(AEvent.COMPLETE, ____onNetConnected2);
			}
			else{
				GameModel.getLog().warning(this, "onLoginSelectArena", v.desc);
			}
		}
		
		/**
		 * 選擇專區後，連接專區ip成功.
		 */
		public static function ____onNetConnected2(e:AEvent):void{
			NetManager.removeEventListener(AEvent.COMPLETE, ____onNetConnected2);
			
			GameModel.getLog().simplify("連接專區ip成功.");
			
			// 驗證客戶端.
			var msg:SignZoneIpReq;
			
			msg = new SignZoneIpReq;
			msg.uid = ConfigNet.uid;
			NetManager.sendRequest(CmdType.CT_AUTH, CmdCodeSign.CC_AUTH_ZONE_IP_REQ, msg);
		}
		
		
		private function onLoginLogin(v:LoginRes):void{
			GameModel.getLog().simplify("登入場景成功!!! 時間: [ {0} ].", v.servTime);
			
			// 進入大廳view狀態.
			Agony.setStateForApp(Hall_StateApp);
		}
	}
}