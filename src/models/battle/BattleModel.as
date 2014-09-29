package models.battle
{
	import com.netease.protobuf.UInt64;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import configs.battle.BattleConfigurator;
	import configs.cards.CardConfigurator;
	
	import models.GameModel;
	import models.battle.actions.BattleAction;
	import models.battle.actions.DebutAction;
	import models.battle.actions.MovementAction;
	import models.battle.actions.SkillAction;
	import models.events.ActionEvent;
	import models.events.CharacterEvent;
	import models.events.ControlEvent;
	import models.events.ManaCostEvent;
	import models.events.NullSelectedUiEvent;
	import models.events.RoundEvent;
	import models.events.SelectedUiHoverCardEvent;
	import models.events.SelectedUiMovementEvent;
	import models.player.PlayerModel;
	
	import net.NetManager;
	
	import org.agony2d.events.Notifier;
	
	import proto.cs.BoutBeginNtf;
	import proto.cs.BoutEndNtf;
	import proto.cs.CmdCodeBattle;
	import proto.cs.CmdType;
	import proto.cs.SkillUseReq;
	import proto.cs.SkillUseRes;
	import proto.cs.UpdateMonsterNtf;
	
	import utils.GameUtil;
	
	
	// 每個guid對應一個vo.
	public class BattleModel {
		
		
		public static const CREATION:String = "creation";
		public static const MOVEMENT:String = "movement";
		public static const SELECTION:String = "selection";
		public static const TARGET:String = "target";
		
		public static var gridWidth:int;
		public static var gridHeight:int;
		
		
		// event types
		
		public static const BATTLE_START:String = "battleStart";

		
		public static var initCards:Array;
		
		public static var loadCards:Array;

		
		
		
		public static var cachedRoundEndHpResetVoList:Vector.<CharacterVo>
		
		
		// 有過移動的人物.
		public static var cachedMoveDirtyVo:CharacterVo;
		
		
		
		
		/**
		 * 初期化.
		 */		
		public static function initialize() : void {
			_notifier = new Notifier;
			_grid2voMap = {};
			_roleId2MapVoMap = {};
			
		}

		public static function dispose() : void {
			
		}
		
		/**
		 * 偵聽事件.
		 * 
		 * @param type
		 * @param listener
		 */		
		public static function addEventListener( type:String, listener:Function ) : void {
			_notifier.addEventListener(type, listener);
		}
		
		/**
		 * 移除偵聽.
		 * 
		 * @param type
		 * @param listener
		 */		
		public static function removeEventListener( type:String, listener:Function ) : void {
			_notifier.removeEventListener(type, listener);
		}
		
		/**
		 * 獲取人物空閒時的方向值.
		 *  
		 * @param roleId	Null代表是我方 (調試).
		 * @return 
		 * 
		 */		
		private static const DIRECTION_FOR_CHAIR:Object = {0:8, 1:4, 2:2, 3:6};
		
		public static function getIdleDirection( roleId:UInt64 = null ) : int {
//			if(BattleRoleModel.getMyBattleRoleVo().chairId){
//				
//			}
//			return (!roleId || GameUtil.isUint64Equal(roleId, PlayerModel.getInstance().myRole.id)) ? 8 : 2
			return DIRECTION_FOR_CHAIR[BattleRoleModel.getBattleRoleVo(roleId).chairId];
		}
		
		
		
		
		
		// 1. 創建
		// 2. 移動
		// 3. 選中人物
		// 4. 技能目標
		
		// 可能的情況:
		
		// 1. 卡牌hover => 登場×法術×裝備 (單獨)
		// 2. 初次點選人物 => 移動×攻擊標識 (單獨)
		// 3. 初次點選人物 => 技能按鈕 => 技能目標
		
		// 看牌 (選中Ui狀態).
		public static function setSelectedUiStateForHoverCard( cardId:int, gridIdList:Array ) : void {
			setNullSelectedUiState();
			
			_notifier.dispatchEvent(new SelectedUiHoverCardEvent(SelectedUiHoverCardEvent.HOVER_CARD, gridIdList));
		}
		
		// 移動 (選中Ui狀態).
		public static function setSelectedUiStateForMovement( startGridId:int, numStep:int ) : void {
			var pathGridIdList:Vector.<int>;
			var assaultGridIdList:Vector.<int>;
			var i:int;
			var l:int;
			var gridId:int;
			
			setNullSelectedUiState();
			
			
			MapModel.cachedStartGridId = startGridId;
			
			GameUtil.makePath5_5(startGridId, numStep);
			
			
			pathGridIdList = GameUtil.cachedResult_A;
			assaultGridIdList = GameUtil.cachedResult_B;
			
			
			
//			trace(startGridId, numStep, " ---- ", gridIdList)
			_notifier.dispatchEvent(new SelectedUiMovementEvent(SelectedUiMovementEvent.MOVEMENT, pathGridIdList, startGridId, assaultGridIdList));
		}
		
		// 技能 (選中Ui狀態).
		public static function setSelectedUiStateFoSkill() : void {
			
		}
		
		// 清除 (選中Ui狀態).
		public static function setNullSelectedUiState() : void {
			_notifier.dispatchEvent(new NullSelectedUiEvent(NullSelectedUiEvent.NULL_SELECTED));
		}
		
		/**
		 * 移除模型數據.
		 *  
		 * @param vo
		 */		
		public static function killVo( vo:CharacterVo ) : void {
			var gridId:int;
			
			gridId = BattleConfigurator.posToGrid(vo.pos.x, vo.pos.y);
			delete _grid2voMap[gridId];
			delete (_roleId2MapVoMap[vo.role_id])[vo];
			
			// 尋路數據.
			MapModel.autoUpdatePathNodeWalkable(gridId);
			
			GameModel.getLog().simplify("!!!!!!!!死亡({0}): [ {1} ].", vo.getBattleRole().roleVo.name, vo);
			
			_notifier.dispatchEvent(new CharacterEvent(CharacterEvent.KILL_CHARACTER, vo));
			
			
		}
		
		/**
		 * 查找可放置的格子列表.
		 */		
		private static const POS_FOR_CHAIR:Object = {0:[2,4,8], 1:[], 2:[18, 22, 24], 3:[]};
		private static var _cachedIdleGridIdList:Array;
		public static function getIdleGridIdList() : Array {
			var i:int;
			var l:int;
			var gridId:int;
			var gridIdList:Array;
			
			if(!_cachedIdleGridIdList){
				_cachedIdleGridIdList = [];
			}
			else{
				_cachedIdleGridIdList.length = 0;
			}
			gridIdList = POS_FOR_CHAIR[BattleRoleModel.getMyBattleRoleVo().chairId];
			l = gridIdList.length;
			while(i < l){
				gridId = gridIdList[i++];
				if(!getVoByGridId(gridId)){
					_cachedIdleGridIdList.push(gridId);
				}
			}
			return _cachedIdleGridIdList;
		}
		
		/**
		 * guid => gridId.
		 */		
		public static function getGridIdByGuid( guid:UInt64 ) : int {
			var gridId:*;
			
			for (gridId in _grid2voMap){
				if(GameUtil.isUint64Equal(guid, (_grid2voMap[gridId] as CharacterVo).guid)){
					return gridId as int;
				}
			}
			
			return 0;
		}
		
		/**
		 * gridId => vo.
		 */
		public static function getVoByGridId( gridId:int ) : CharacterVo {
			return _grid2voMap[gridId];
		}
		
		/**
		 * guid => vo.
		 */
		public static function getVoByGuid( guid:UInt64 ) : CharacterVo {
			return _grid2voMap[getGridIdByGuid(guid)];
		}
		
		/**
		 * 由角色id返回一個該角色擁有人物的列表.
		 */	
		public static function getVoListByRoleId( roleId:UInt64 ) : Vector.<CharacterVo> {
			var result:Vector.<CharacterVo>;
			var dict:Dictionary;
			var vo:*;
			
			result = new <CharacterVo>[];
			dict = _roleId2MapVoMap[roleId];
			for (vo in dict){
				result.push(vo as CharacterVo);
			}
			return result;
		}
		
		/**
		 * 主動請求回合結束. 
		 */		
		public static function requestRoundOver() : void {
			if(_hasActionExcuting){
				_roundWaitingType = 2;
			}
			else{
				____doRequestRoundOver();
			}
		}
		
		/**
		 * 是否為可攻擊目標.
		 */		
		public static function isAssaultable( vo:CharacterVo ) : Boolean {
			return !PlayerModel.isMyRole(vo.role_id);
		}
		
		/**
		 * 普通攻擊.
		 */		
		public static function commonAttack() : void {
			var msg:SkillUseReq;
			var vo:CharacterVo;
			
			vo = getVoByGridId(MapModel.cachedStartGridId);
			vo.setInteractionFlag(CharacterVo.NONE);
			
			msg = new SkillUseReq;
			msg.fromGuid = vo.guid;
			msg.endGuid = getVoByGridId(MapModel.cachedAssaultGridId).guid;
			msg.skillId = 50000;
			msg.skillSource = 0;
			NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_BATTTE_SKILL_USE_REQ, msg);
			
			MapModel.cachedAssaultGridId = 0;
		}
		
		
		
		
		///////////////////////////////////////
		// members
		///////////////////////////////////////
		
		private static var _grid2voMap:Object // gridId: 人物vo
		
		private static var _roleId2MapVoMap:Object; // roleId: (<人物vo>: bool)
		
		private static var _notifier:Notifier;
		
		
		
		/**
		 * 開始戰鬥.
		 */		
		public static function netStartBattle() : void {
			GameModel.getLog().simplify("開始戰鬥 !!!");
			
			_isStarted = true;
//			if(PlayerModel.isMyRole(_boutBeginNtf.roleId)){
//				____doStartToBattle();
//			}
		}
		
		/**
		 * 更新角色卡牌 (沒有則創建)
		 */		
		public static function netUpdateCharacter( v:UpdateMonsterNtf ) : void {
			var vo:CharacterVo;
			
			vo          =  new CharacterVo;
			vo.card_id  =  v.cardId;
			vo.guid     =  v.guid;
			vo.role_id  =  v.roleId;
			vo.name     =  CardConfigurator.getCardById(v.cardId).name;
			vo.attack   =  v.attack;
			vo.hp       =  v.hp;
			vo.max_hp   =  v.maxHp;
			vo.move     =  v.move;
			vo.pos      =  new Point(v.chessPos.x, v.chessPos.y);
			
			// + 登場動作.
			var action:DebutAction;
			
			action = new DebutAction(v.roleId);
			action.isAlone = !_isStarted; // 王者不需要加入隊列.
			action.vo = vo;
			action.pos = v.chessPos;
			____doQueueAction(action);
		}
		
		/**
		 * 更新魔耗.
		 *  
		 * @param remain_Mp
		 * @param roleId
		 * 
		 */		
		public static function netUpdateMana( remain_Mp:int, roleId:UInt64 = null ) : void {
			GameModel.getLog().simplify("剩餘魔法: [ {0} ].", remain_Mp);
			
			remainMp = remain_Mp;
			
			_notifier.dispatchEvent(new ManaCostEvent(ManaCostEvent.MP_CHANGE, remain_Mp, roleId?roleId:PlayerModel.getInstance().myRole.id));
		}
		
		/**
		 * 當前回合結束. 
		 */		
		public static function netEndRound(v:BoutEndNtf):void{
			_roundWaitingType = 1;
			
			// 如果沒有動作執行，那麼直接結束 (否則執行完動作才結束).
			if(!_hasActionExcuting){
				____doExecFinishRound();
			}
			else {
				GameModel.getLog().simplify("回合結束準備({0}).", BattleRoleModel.getBattleRoleVo(v.roleId).roleVo.name);
			}
		}
		
		/**
		 * 下一回合開始.
		 */		
		public static function netNextRound(v:BoutBeginNtf) : void {
			_boutBeginNtf = v;
			
			if(!_hasActionExcuting){
				____doExecNextRound();
			}
			else {
				GameModel.getLog().simplify("下一回合準備.");
			}
		}
		
		/**
		 * 移動人物.
		 *  
		 * @param guid
		 * @param movePath
		 * 
		 */		
		public static function netMoveCharacter( guid:UInt64, movePath:Array, roleId:UInt64 ) : void {
			var vo:CharacterVo;
			var gridId:int;
			var numStep:int;
			
			gridId = getGridIdByGuid(guid);
			vo = getVoByGridId(gridId);
			numStep = movePath.length;
			
			// + 移動動作.
			var action:MovementAction;
			
			action = new MovementAction(roleId);
			action.vo = vo;
			action.movePath = movePath;
			____doQueueAction(action);
			
			// 如果為我方回合.
//			if(PlayerModel.isMyRole(_currRoleId)){
				// 減少移動力.
				vo.move -= numStep - 1;
				dispatchUpdateValue(vo);
//			}
		}

		public static function netFireSkill( v:SkillUseRes ) : void {
			// + 技能動作.
			var action:SkillAction;
			
			action = new SkillAction(getVoByGuid(v.fromGuid).role_id);
			action.skillId = v.skillId;
			action.effects = v.effects;
			action.buffs = v.buffs;
			action.fromVo = getVoByGuid(v.fromGuid);
			action.targetVo = getVoByGuid(v.endGuid);
			____doQueueAction(action);
		}
		
		
		
		
		
		
		
		public static var remainMp:int;
		
		////////////////////////////////
		// Battle Actions
		////////////////////////////////
		
		// 這些members不只是用於自己，而是用於所有人.
		
		private static var _actionList:Vector.<BattleAction>;
		private static var _hasActionExcuting:Boolean; // 是否有動作正在執行.
		private static var _roundWaitingType:int; // 回合狀態，0:正常，1:回合已經結束，2:回合結束申請 (等待動作隊列).
		private static var _boutBeginNtf:BoutBeginNtf; // 下回合信息 (等待動作隊列).
		private static var _currRoleId:UInt64; // 當前回合的角色id.
		private static var _isStarted:Boolean; // 是否已經開始.

		
		/**
		 * 將動作加入隊列. 
		 * 
		 * @param action
		 * @param useQueue 為false的話，直接執行動作.
		 * 
		 */		
		private static function ____doQueueAction( action:BattleAction ) : void {
			if(action.isAlone){
				____doExecDispatchNextAction(action);
			}
			else {
				GameModel.getLog().simplify("加入動作隊列: {0}", action);
				
				// 初次啟動隊列.
				if(!_actionList){
					_actionList = new <BattleAction>[];
					_hasActionExcuting = true;
					____doExecDispatchNextAction(action);
				}
				// 啟動隊列.
				else if(!_hasActionExcuting){
					_hasActionExcuting = true;
					____doExecDispatchNextAction(action);
				}
				// 加入隊列，等待執行.
				else {
					_actionList.push(action);
				}
			}
			
		}
		
		/**
		 * 迭代下一動作.
		 */		
		public static function doIterateNextAction( hasMyNextAction:Boolean ) : void {
			if(_actionList.length == 0){
				_hasActionExcuting = false;
				
				// 回合已經結束
				if(_roundWaitingType == 1){
					
					____doExecFinishRound();
					
					____doExecNextRound();
					
				}
				// 回合結束申請 (等待動作隊列).
				else if(_roundWaitingType == 2){
					____doRequestRoundOver();
				}
				
				// 不存在連續動作，如移動后攻擊.
				if(!hasMyNextAction){
					// 自己的回合，則操作狀態恢復.
					if(PlayerModel.isMyRole(_currRoleId)){
						dispatchMyControlChanged(true);
						
					}
				}
				
			}
			else {
				____doExecDispatchNextAction(_actionList.shift());
			}
		}
		
		/**
		 * 執行觸發下一動作.
		 * 
		 * @param action 
		 */		
		private static function ____doExecDispatchNextAction( action:BattleAction ) : void {
			var movePath:Array;
			var startGridId:int;
			var endGridId:int;
			
			GameModel.getLog().simplify("\n=> [ {0} ]: Next戰鬥動作: {1}", BattleRoleModel.getBattleRoleVo(action.roleId).roleVo.name, action);
			
			
			// 檢查是否有移動過的人物，操作狀態變為NULL.
			if(cachedMoveDirtyVo){
				if(!(action is MovementAction) || (action as MovementAction).vo != cachedMoveDirtyVo){
					cachedMoveDirtyVo.setInteractionFlag(CharacterVo.NONE);
					cachedMoveDirtyVo = null;
				}
			}
			
			if(action is MovementAction){
				// 更新vo grid(pos).
				movePath = (action as MovementAction).movePath;
				
				startGridId = BattleConfigurator.posToGrid2(movePath[0]);
				endGridId = BattleConfigurator.posToGrid2(movePath[movePath.length - 1]);
				____doUpdatePos(startGridId, endGridId);
				
				// 尋路數據.
				MapModel.autoUpdatePathNodeWalkable(startGridId);
				MapModel.autoUpdatePathNodeWalkable(endGridId);
				
				
				// 為自己的回合時，交互狀態變化.
				if(PlayerModel.isMyRole(_currRoleId)){
					BattleModel.cachedMoveDirtyVo = (action as MovementAction).vo;
					BattleModel.cachedMoveDirtyVo.setInteractionFlag(CharacterVo.MOVE_DIRTY);
				}
			}
			else if(action is DebutAction){
				startGridId = BattleConfigurator.posToGrid2((action as DebutAction).pos);
				
				// 將vo放置于model的行列上.
				_grid2voMap[startGridId] = (action as DebutAction).vo;
				// 編隊.
				(((_roleId2MapVoMap ||= {})[action.roleId]) ||= new Dictionary)[(action as DebutAction).vo] = true;
				
				// 尋路數據.
				MapModel.autoUpdatePathNodeWalkable(startGridId);
			}
			
			_notifier.dispatchEvent(new ActionEvent(ActionEvent.NEXT_ACTION, action));
		}
		
		// 位置的移動只能由服務器決定.
		public static function ____doUpdatePos( beginGridId:int, endGridId:int ) : void {
			var vo:CharacterVo;
			
			vo = _grid2voMap[beginGridId];
			delete _grid2voMap[beginGridId];
			_grid2voMap[endGridId] = vo;
			vo.pos = BattleConfigurator.gridToPos(endGridId);
			
			GameModel.getLog().simplify("更新vo({0}) grid: {1} -> {2}.", vo.name, beginGridId, endGridId);
		}
		
		/**
		 * 執行回合結束. 
		 */		
		private static function ____doExecFinishRound() : void {
			GameModel.getLog().simplify("回合結束({0}).", BattleRoleModel.getBattleRoleVo(_currRoleId).roleVo.name);
			
			var vo:CharacterVo;
			var len:int;
			var AY:Vector.<CharacterVo>;
			
			// 重置生命值，移動力.
			if(!cachedRoundEndHpResetVoList){
				cachedRoundEndHpResetVoList = new <CharacterVo>[];
			}
			else {
				cachedRoundEndHpResetVoList.length = 0;
			}
			for each(vo in _grid2voMap){
				if(vo.resetStatusForRoundEnd()){
					cachedRoundEndHpResetVoList[len++] = vo;
				}
			}
			
			// 如果為自己方，變為不可操作.
			if(PlayerModel.isMyRole(_currRoleId)){
				AY = BattleModel.getVoListByRoleId(_currRoleId);
				len = AY.length;
				while(--len>-1){
					vo = AY[len];
					vo.setInteractionFlag(CharacterVo.NONE);
				}
				
//				updateSelectedUiState(null);
				setNullSelectedUiState();
			}
			
			// 觸發本回合結束事件.
			_notifier.dispatchEvent(new RoundEvent(RoundEvent.ROUND_END, _currRoleId));
		}
		
		/**
		 * 執行下一回合開始
		 */
		private static function ____doExecNextRound() : void {
			_currRoleId = _boutBeginNtf.roleId;
			remainMp = 5;
			_roundWaitingType = 0;
			
			GameModel.getLog().simplify("===================================================\n下一回合開始({0}).", BattleRoleModel.getBattleRoleVo(_currRoleId).roleVo.name);
			
			var vo:CharacterVo;
			var len:int;
			var AY:Vector.<CharacterVo>;
			
			// 如果為自己方，變為可選擇.
			if(PlayerModel.isMyRole(_currRoleId)){
				AY = BattleModel.getVoListByRoleId(_currRoleId);
				len = AY.length;
				while(--len>-1){
					vo = AY[len];
					vo.setInteractionFlag(CharacterVo.SELECTABLE);
				}
			}
			
			_notifier.dispatchEvent(new RoundEvent(RoundEvent.ROUND_BEGIN, _boutBeginNtf.roleId, _boutBeginNtf.cardIds));
		}
		
		/**
		 * 發送回合請求. 
		 */		
		private static function ____doRequestRoundOver():void{
			NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_BOUT_END_REQ, null);
		}
		
		/**
		 * 觸發更新vo數據.
		 *  
		 * @param vo
		 */		
		public static function dispatchUpdateValue( vo:CharacterVo ) : void {
			_notifier.dispatchEvent(new CharacterEvent(CharacterEvent.UPDATE_VALUES, vo));
		}
		
		/**
		 * 觸發更新vo行動狀態.
		 * 
		 * @param vo
		 */		
		public static function dispatchInteractionChanged( vo:CharacterVo ) : void {
			_notifier.dispatchEvent(new CharacterEvent(CharacterEvent.INTERACTION_CHANGED, vo));
		}
		
		public static function dispatchMyControlChanged( isControlable:Boolean ) : void {
			_notifier.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_CHANGE, isControlable));
		}
		

	}
}