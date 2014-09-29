package net.responses
{
	import models.GameModel;
	import models.battle.BattleModel;
	import models.battle.MapModel;
	import models.player.PlayerModel;
	
	import org.agony2d.flashApi.UUFacade;
	
	import proto.cs.ArenaKingDieNtf;
	import proto.cs.ArenaOverNtf;
	import proto.cs.BattleBody;
	import proto.cs.BoutBeginNtf;
	import proto.cs.BoutEndNtf;
	import proto.cs.CmdCodeBattle;
	import proto.cs.EnterArenaNtf;
	import proto.cs.GiveOutIdentityNtf;
	import proto.cs.GiveOutInitCard;
	import proto.cs.MoveChessNtf;
	import proto.cs.MoveChessRes;
	import proto.cs.PlayCardNtf;
	import proto.cs.PlayCardRes;
	import proto.cs.RoleCardCountNtf;
	import proto.cs.SkillUseNtf;
	import proto.cs.SkillUseRes;
	import proto.cs.UpdateMonsterNtf;
	
	import views.UU.battle.Battle_active_StateUU;
	import views.UU.battle.Battle_active_post_StateUU;
	import views.UU.battle.Battle_active_pre_StateUU;
	import views.UU.battle.Battle_bg_StateUU;
	import views.UU.battle.Battle_ready_StateUU;
	import views.UU.battle.Battle_ui_StateUU;
	import views.UU.loading.BattleLoading_StateUU;

	public class BattleResponsor implements IResponsor
	{
		public function onHandle(cmd_B:int, subMsg:Object):void
		{
			var subMsg_A:BattleBody;
			
			subMsg_A = subMsg as BattleBody;
			//if(!subMsg_A){
				//GameModel.getLog().warning(this, "onHandle", "沒有body的server響應.");
				//return;
			//}
			switch(cmd_B){
				// 進入戰鬥場景 (No body?).
				case CmdCodeBattle.CC_ARENA_ENTER_RES:
					this.onEnterArena();//(subMsg_A.enterArenaRes as EnterArenaRes);
					break;
				
				// 進入戰鬥場景.
				case CmdCodeBattle.CC_ARENA_ENTER_NTF:
					this.onEnterArenaNtf(subMsg_A.enterArenaNtf as EnterArenaNtf);
					break;
				
				// 身份牌 (出牌順序).
				case CmdCodeBattle.CC_GIVE_OUT_IDENTITY_NTF:
					this.onGiveOutIdentityNtf(subMsg_A.giveOutIdentityNtf as GiveOutIdentityNtf);
					break;
				
				// 初期手卡牌 × 預加載卡牌.
				case CmdCodeBattle.CC_GIVE_OUT_INIT_CARD_NTF:
					this.onGiveOutInitCardNtf(subMsg_A.giveOutInitCardNtf as GiveOutInitCard);
					break;
				
				// 玩家卡牌攜帶數目.
				case CmdCodeBattle.CC_ROLE_CARD_COUNT_NTF:
					this.onRoleCardCountNtf(subMsg_A.roleCardCountNtf as RoleCardCountNtf);
					break;
				
				// 更新角色位置 (沒有則創建、例如王者) - No body.
				case CmdCodeBattle.CC_ARENA_GAME_START_RES:
					this.onArenaGameStart();
					break;
				
				// 更新角色位置 (沒有則創建).
				case CmdCodeBattle.CC_UPDATE_MONSTER_NTF:
					this.onUpdateMonsterNTF(subMsg_A.updateMonsterNtf as UpdateMonsterNtf);
					break;
				
				// 對方出牌.
				case CmdCodeBattle.CC_PALY_CARD_NTF:
					this.onPlayCardNTF(subMsg_A.playCardNtf as PlayCardNtf);
					break;
				
				// 我方出牌.
				case CmdCodeBattle.CC_PALY_CARD_RES:
					this.onPlayCardRes(subMsg_A.playCardRes as PlayCardRes);
					break;
				
				// 某方回合結束 (開始執行命令隊列).
				case CmdCodeBattle.CC_BOUT_END_NTF:
					this.onBoutEndNTF(subMsg_A.boutEndNtf as BoutEndNtf);  
					break;
				
				// 某方回合結束.
				case CmdCodeBattle.CC_BOUT_BEGIN_NTF:
					this.onBoutBeginNTF(subMsg_A.boutBeginNtf as BoutBeginNtf);
					break;
				
				// 自己的移動成功.
				case CmdCodeBattle.CC_MOVE_CHESS_RES:
					this.onMoveChessRes(subMsg_A.moveChessRes as MoveChessRes);
					break;
				
				// 有人物移動.
				case CmdCodeBattle.CC_MOVE_CHESS_NTF:
					this.onMoveChessNTF(subMsg_A.moveChessNtf as MoveChessNtf);
					break;
				
				// 自己的技能釋放成功.
				case CmdCodeBattle.CC_BATTTE_SKILL_USE_RES:
					this.onSkillUseRes(subMsg_A.skillUseRes as SkillUseRes);
					break;
				
				// 有技能被釋放.
				case CmdCodeBattle.CC_BATTTE_SKILL_USE_NTF:
					this.onSkillUseNTF(subMsg_A.skillUseNtf as SkillUseNtf);
					break;
				
				// 有王者死亡.
//				case CmdCodeBattle.CC_ARENA_KING_DIE_NTF:
//					this.onArenaKingDieNTF(subMsg_A.arenaKingDieNtf as ArenaKingDieNtf);
//					break;
				
				
				// 比賽結束.
				case CmdCodeBattle.CC_ARENA_OVER_NTF:
					this.onArenaOverNTF(subMsg_A.arenaOverNtf as ArenaOverNtf);
					break;
				
				default:
					break;
			}
		}
		
		private function onEnterArena():void{//v:EnterArenaRes):void{
			GameModel.getLog().simplify("進入戰鬥場景res. ");
			//GameModel.getLog().simplify("randBulletSeed: " + v.randBulletSeed);
		}
		
		private function onEnterArenaNtf(v:EnterArenaNtf):void{
			GameModel.getLog().simplify("進入戰鬥場景，服務器時間: " + v.gameTimeTick);
			
		}
		
		private function onGiveOutIdentityNtf(v:GiveOutIdentityNtf):void{
			GameModel.getLog().simplify("出牌順序: [ {0} ].", v.identityType);
		}
		
		private function onGiveOutInitCardNtf(v:GiveOutInitCard):void{
			GameModel.getLog().simplify("初期化卡牌: [ {0} ].", v.initCards);
			
			
			BattleModel.initCards = v.initCards;
			BattleModel.loadCards = v.loadIds
			
			
			
			
			//  關閉載入視窗.
			UUFacade.getRoot().getWindow(BattleLoading_StateUU).close();
			
			// 戰鬥模型初期化.
			BattleModel.initialize();
			
			// 地圖模型初期化.
			MapModel.initialize();
			
			
			UUFacade.getRoot().getWindow(Battle_bg_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_active_pre_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_active_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_active_post_StateUU).activate();
			
			UUFacade.getRoot().getWindow(Battle_ui_StateUU).activate();
			UUFacade.getRoot().getWindow(Battle_ready_StateUU).activate();
		}
		
		private function onRoleCardCountNtf(v:RoleCardCountNtf):void{
			GameModel.getLog().simplify("攜帶卡牌數目: [ {0} ].", v.roleCardCounts);
		}
		
		
		private function onArenaGameStart():void{
			BattleModel.netStartBattle();
		}
		
		
		private function onUpdateMonsterNTF(v:UpdateMonsterNtf) : void{
			BattleModel.netUpdateCharacter(v);
		}
		
		private function onPlayCardNTF(v:PlayCardNtf):void{
			BattleModel.netUpdateMana(v.lastMp, v.roleId);
		}
		
		private function onPlayCardRes(v:PlayCardRes):void{
//			BattleModel.add(v.roleId, v.lastMp);
			BattleModel.netUpdateMana(v.lastMp);
		}
		
		private function onBoutEndNTF(v:BoutEndNtf):void{
			BattleModel.netEndRound(v);
		}
		
		private function onBoutBeginNTF(v:BoutBeginNtf):void{
			BattleModel.netNextRound(v);
		}
		
		
		private function onMoveChessRes(v:MoveChessRes):void{
			BattleModel.netMoveCharacter(v.chessUid, v.movePath, PlayerModel.getInstance().myRole.id);
		}
		
		private function onMoveChessNTF(v:MoveChessNtf):void{
			BattleModel.netMoveCharacter(v.chessUid, v.movePath, v.roleId);
		}
		
		
		private function onSkillUseRes(v:SkillUseRes):void{
			BattleModel.netFireSkill(v);
		}
		
		private function onSkillUseNTF(v:SkillUseNtf):void{
			this.onSkillUseRes(v.skillUseRes)
		}
		
		
//		private function onArenaKingDieNTF(e:ArenaKingDieNtf ) : void{
//			GameModel.getLog().simplify("[ {0} ] 王者死亡.", PlayerModel.isMyRole(e.roleId) ? "我方" : "敵方");
//		}
		
		private function onArenaOverNTF(e:ArenaOverNtf ) : void{
			GameModel.getLog().simplify("比賽結束.");
		}
	}
}