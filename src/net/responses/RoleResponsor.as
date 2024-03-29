package net.responses
{
	import models.GameModel;
	import models.player.PlayerModel;
	
	import net.NetManager;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.skins.ButtonSkinType;
	import org.agony2d.flashApi.skins.ButtonSkinUU;
	import org.agony2d.flashApi.skins.ToggleSkinUU;
	import org.agony2d.resources.TResourceManager;
	
	import proto.cs.CmdCodeLogin;
	import proto.cs.CmdCodeRole;
	import proto.cs.CmdType;
	import proto.cs.CreateRoleReq;
	import proto.cs.CreateRoleRes;
	import proto.cs.GetRoleListRes;
	import proto.cs.GetRoleRes;
	import proto.cs.LoginReq;
	import proto.cs.RoleBody;
	
	import views.UU.login.Login_Creation_StateUU;
	import views.UU.login.Login_Servers_StateUU;

	public class RoleResponsor implements IResponsor
	{
		
		public function onHandle(cmd_B:int, subMsg:Object):void
		{
			var subMsg_A:RoleBody;
			
			subMsg_A = subMsg as RoleBody;
			switch(cmd_B){
				
				// 當前專區已創建的角色列表.
				case CmdCodeRole.CC_ROLE_GET_LIST_RES:
					this.onRoleGetList(subMsg_A.getRoleListRes as GetRoleListRes);
					break;
				
				// 登入場景時，獲取角色.
				case CmdCodeRole.CC_ROLE_GET_RES:
					this.onRoleGet(subMsg_A.getRoleRes as GetRoleRes);
					break;
				
				// 創建角色.
				case CmdCodeRole.CC_ROLE_CREATE_RES:
					this.onRoleCreate(subMsg_A.createRoleRes as CreateRoleRes);
					break;
				
				default:
					
					break;
			}
		}
		
		private function onRoleGetList(v:GetRoleListRes):void{
			var list:Array;
			var msg_A:LoginReq;
			var msg_B:CreateRoleReq;
			
//			Global.getLog().message(this, "玩家角色列表: [ {0} ].", v.loginRoleInfos);
			list = v.loginRoleInfos;
			
			// 登入遊戲大廳 (選擇模式).
			if(list && list.length > 0){
				msg_A = new LoginReq;
//				trace(v.uid, v.loginRoleInfos[0].id);
				
				// 暫時只用一個角色.
				msg_A.roleId = v.loginRoleInfos[0].id;
				NetManager.sendRequest(CmdType.CT_LOGIN, CmdCodeLogin.CC_LOGIN_LOGIN_REQ, msg_A);
			}
			// 創建角色.
			else{
				UUFacade.getRoot().getWindow(Login_Servers_StateUU).close();
				
				TResourceManager.loadAssets("creation.zip").addEventListener(AEvent.COMPLETE, onAssetsLoaded);
				
			}
		}
		
		private function onAssetsLoaded(e:AEvent):void{
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
			
			
			UUFacade.getRoot().getWindow(Login_Creation_StateUU).activate();
		}
		
		private function onRoleGet(v:GetRoleRes):void{
			PlayerModel.getInstance().initialize(v.roleInfo, v.campLevels);
		}
		
		private function onRoleCreate(v:CreateRoleRes):void{
			var msg_A:LoginReq;
			
			GameModel.getLog().simplify("角色創建完畢.");
			
			// 用新創建的角色進入場景.
			msg_A = new LoginReq;
			msg_A.roleId = v.roleInfo.id;
			NetManager.sendRequest(CmdType.CT_LOGIN, CmdCodeLogin.CC_LOGIN_LOGIN_REQ, msg_A);
		}
	}
}