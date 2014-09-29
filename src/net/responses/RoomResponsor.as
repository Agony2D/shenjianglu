package net.responses
{
	import app.Battle_StateApp;
	
	import configs.ConfigNet;
	
	import models.GameModel;
	import models.battle.BattleRoleModel;
	
	import net.NetManager;
	import net.NetUtil;
	
	import org.agony2d.Agony;
	import org.agony2d.events.AEvent;
	
	import proto.cs.CheckCodeNtf;
	import proto.cs.CmdCodeRoom;
	import proto.cs.MatchJoinRes;
	import proto.cs.RoomBody;
	import proto.cs.StartMatchNtf;

	public class RoomResponsor implements IResponsor
	{
		
		public function onHandle(cmd_B:int, subMsg:Object):void
		{
			var subMsg_A:RoomBody;
			
			subMsg_A = subMsg as RoomBody;
			switch(cmd_B){
				// 匹配成功回應.
				case CmdCodeRoom.CC_ROOM_MATCH_JOIN_RES:
					this.onMatchJoin(subMsg_A.matchJoinRes as MatchJoinRes);
					break;
				
				// 獲取服務器校檢碼.
				case CmdCodeRoom.CC_ROOM_CHECK_CODE_NTF:
					this.onCheckCodeNTF(subMsg_A.checkCodeNtf as CheckCodeNtf);
					break;
				
				// 匹配比賽成功，返回比賽相關信息.
				case CmdCodeRoom.CC_ROOM_START_MATCH_NTF:
					this.onStartMatchNTF(subMsg_A.startMatchNtf as StartMatchNtf);
					break;
				
				default:
					break;
			}
		}
		
		private function onMatchJoin(v:MatchJoinRes):void{
			// 不做回應.
		}
		
		private function onCheckCodeNTF(v:CheckCodeNtf):void{
			GameModel.getLog().simplify("校檢碼: [ {0} ].", v.checkCode);
			ConfigNet.checkCode = v.checkCode;
		}
		
		private function onStartMatchNTF(v:StartMatchNtf):void{
			GameModel.getLog().simplify("匹配比賽成功.");
			
			BattleRoleModel.initialize(v.members, v.roomBaseInfo);
			
//			ConfigNet.members = v.members;
//			ConfigNet.roomBaseInfo = v.roomBaseInfo;
			
			// 戰鬥服務器註冊請求.
			var AY:Array;
			
			AY = NetUtil.getIpAndPort(v.roomBaseInfo.pvpIp);
			NetManager.connect2(AY[0], AY[1]);
			NetManager.addEventListener(AEvent.COMPLETE, ____onNetConnected3);
		}
		
		
		/**
		 * 連接戰鬥服務器成功.
		 */
		public static function ____onNetConnected3(e:AEvent):void{
			NetManager.removeEventListener(AEvent.COMPLETE, ____onNetConnected3);
			
			GameModel.getLog().simplify("連接戰鬥服務器ip成功.");
			
			
			
			// 進入戰鬥App (先加載，後請求!!!).
			Agony.setStateForApp(Battle_StateApp);
			
			
			
			//		var msg_A:SignReq;
			//		
			//		msg_A = new SignReq;
			//		msg_A.uid = ConfigNet.uid;
			//		msg_A.cbData = 1;
			//		NetManager.sendRequest2(CmdType.CT_AUTH, CmdCodeSign.CC_AUTH_SIGN_REQ, msg_A);
			
			//		var msg_B:EnterArenaReq;
			//		
			//		msg_B = new EnterArenaReq;
			//		msg_B.roleId = RoleManager.getInstance().myRole.id;
			//		msg_B.checkCode = ConfigNet.checkCode;
			//		NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_ARENA_ENTER_REQ, msg_B);
		}
	}
}