package views.UU.comps
{
	import com.netease.protobuf.UInt64;
	
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import configs.ConfigRes;
	import configs.battle.BattleConfigurator;
	import configs.cards.CardConfigurator;
	import configs.cards.CharacterCardCfg;
	
	import models.GameModel;
	import models.battle.BattleModel;
	import models.battle.CharacterVo;
	import models.battle.MapModel;
	import models.player.PlayerModel;
	
	import net.NetManager;
	
	import org.agony2d.flashApi.AnimatorUU;
	import org.agony2d.flashApi.FusionUU;
	import org.agony2d.flashApi.ImageLoaderUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.inputs.events.ATouchEvent;
	import org.agony2d.resources.TResourceManager;
	
	import proto.cs.CmdCodeBattle;
	import proto.cs.CmdType;
	import proto.cs.MoveChessReq;
	
	import utils.TextUtil;

	public class CharacterUU extends FusionUU
	{
		public function CharacterUU( vo:CharacterVo, isEight:Boolean = true )
		{
			var isSelf:Boolean;
			
			
			_vo = vo;
			_cfg = CardConfigurator.getCardById(_vo.card_id) as CharacterCardCfg;
			_bitmapID = _cfg.quality > 4 ? "atlas/zhouwang" : "atlas/shang/shield";
			_animId = isEight ? "common.eight" : "common.ten";
			_animator = new AnimatorUU;
			_animator.pivotX = ConfigRes.FRAME_SIZE * .5;
			_animator.pivotY = ConfigRes.FRAME_SIZE * .5 + 38;
			this.addNode(_animator);
			_animator.addEventListener(ATouchEvent.CLICK, ____onClickAnimator);

			// 是否為我方.
			isSelf = !_vo || (_vo.role_id && PlayerModel.isMyRole(vo.role_id));
			
			
			_nameLabel = TextUtil.createLabel(_vo.name, 15, isSelf ? 0x33dd33 : 0xdd3333);
			this.addNode(_nameLabel);
			_nameLabel.x = - 44 -_nameLabel.width / 2;
			_nameLabel.y = -65;
			
			_attackLabel = TextUtil.createLabel(_vo.attack, 17, NORMAL_COLOR);
			this.addNode(_attackLabel);
			_attackLabel.x = -52;
			_attackLabel.y = -40;
			
			_hpLabel = TextUtil.createLabel(_vo.hp, 17, NORMAL_COLOR);
			this.addNode(_hpLabel);
			_hpLabel.x = -52;
			_hpLabel.y = -15;
			
			_moveLabel = TextUtil.createLabel(_vo.move, 17, NORMAL_COLOR);
			this.addNode(_moveLabel);
			_moveLabel.x = -52;
			_moveLabel.y = 10;
			
			_nameLabel.touchable = _attackLabel.touchable = _hpLabel.touchable = _moveLabel.touchable = false;
			
			this.____doUpdateColor();
		}
		
		
		
		public static const NORMAL_COLOR:uint = 0xffffff;
		
		public static const INCREASE_COLOR:uint = 0x3366dd;
		
		public static const DECREASE_COLOR:uint = 0xffff00;
		
		
		
		public function get vo() : CharacterVo {
			return _vo;
		}
		
		public function get cfg() : CharacterCardCfg {
			return _cfg;
		}

		// direction 方向，根據Numpad
		// 8 - 上
		// 2 - 下
		// 4 - 左
		// 6 - 右
		
		/**
		 * 攻擊動畫.
		 * 
		 * @param direction
		 * @param count
		 * @param callback
		 */		
		public function attack( direction:int, count:int = 1, callback:Function = null ) : void {
			_animator.play(_animId, _bitmapID + "/attack/" + this.____toDirection(direction), count, callback);
		}
		
		/**
		 * 閒置動畫.
		 * 
		 * @param direction
		 */		
		public function idle( direction:int ) : void {
			_animator.play(_animId, _bitmapID + "/idle/" + this.____toDirection(direction), 0);
		}
		
		/**
		 * 奔跑動畫. 
		 * 
		 * @param direction
		 */		
		public function run( direction:int ) : void {
			_animator.play(_animId, _bitmapID + "/run/" + this.____toDirection(direction), 0);
		}
		
		/**
		 * 擁有該人物的角色id
		 *  
		 * @param role_id
		 * 
		 */		
		public function idleNormal( role_id:UInt64 = null ) : void {
			this.idle(BattleModel.getIdleDirection(role_id));
		}
		
		/**
		 * 更新數值.
		 */
		public function updateValues() : void {
			_attackLabel.text = String(_vo.attack);
			_hpLabel.text = String(_vo.hp);
			_moveLabel.text = String(_vo.move);
			
			this.____doUpdateColor();
		}
		
		
		
		
		
		private var _assaultImg:ImageLoaderUU;
		
		private var _animator:AnimatorUU;
		
		private var _bitmapID:String;
		
		private var _animId:String;
		
		private var _vo:CharacterVo;
		
		private var _nameLabel:LabelUU;
		
		private var _attackLabel:LabelUU;
		
		private var _hpLabel:LabelUU;
		
		private var _moveLabel:LabelUU;
		
		private var _cfg:CharacterCardCfg;
		
		
		
		
		
		
		
		/** 
		 * 更新操作狀態.
		 */		
		public function changeViewByOperationFlag() : void{
			// 清除之前交互狀態.
			if(_vo.oldInteractionFlag == CharacterVo.SELECTABLE || _vo.oldInteractionFlag == CharacterVo.MOVE_DIRTY){
				_animator.filters = null;
			}
			else if(_vo.oldInteractionFlag == CharacterVo.ASSAULT){
				_assaultImg.kill();
				_assaultImg = null;
			}
			// 新的交互狀態
			if(_vo.interactionFlag == CharacterVo.MOVE_DIRTY){
				_animator.filters = [new GlowFilter(0xdddd33, 0.88, 16, 16)];
			}
			else if(_vo.interactionFlag == CharacterVo.SELECTABLE){
				_animator.filters = [new GlowFilter(0xdd33dd, 0.88, 16, 16)];
			}
			else if(_vo.interactionFlag == CharacterVo.ASSAULT){
				_assaultImg = new ImageLoaderUU;
				this.addNode(_assaultImg);
				_assaultImg.source = TResourceManager.getAsset("battle/img/assault.png");
				_assaultImg.pivotX = _assaultImg.width / 2;
				_assaultImg.pivotY = _assaultImg.height / 2;
				_assaultImg.x = - 3;
				_assaultImg.y = - 6;
				_assaultImg.touchable = false;
			}
		}
		
		// 自動更新數字顏色.
		private function ____doUpdateColor():void{
			// 攻擊.
			if(_vo.attack > _cfg.attack){
				this._attackLabel.color = INCREASE_COLOR;
			}
			else if(_vo.attack < _cfg.attack){
				this._attackLabel.color = DECREASE_COLOR;
			}
			else {
				this._attackLabel.color = NORMAL_COLOR;
			}
			// 生命.
			if(_vo.hp > _cfg.hp){
				this._hpLabel.color = INCREASE_COLOR;
			}
			else if(_vo.hp < _cfg.hp){
				this._hpLabel.color = DECREASE_COLOR;
			}
			else {
				this._hpLabel.color = NORMAL_COLOR;
			}
			// 移動.
			if(_vo.move > _cfg.movement){
				this._moveLabel.color = INCREASE_COLOR;
			}
			else if(_vo.move < _cfg.movement){
				this._moveLabel.color = DECREASE_COLOR;
			}
			else {
				this._moveLabel.color = NORMAL_COLOR;
			}
		}
		
		
		
		private function ____toDirection( direction:int ) : String {
			var result:String;
			
			if(direction == 8){
				_animator.scaleX = 1.0;
				result = "back";
			}
			else if(direction == 2){
				_animator.scaleX = 1.0;
				result = "front";
			}
			else if(direction == 4){
				_animator.scaleX = -1.0;
				result = "left";
			}
			else if(direction == 6){
				_animator.scaleX = 1.0;
				result = "left";
			}
			return result;
		}
		
		private function ____onClickAnimator( e:ATouchEvent ) : void {
			// 可控制.
			if(_vo.interactionFlag == CharacterVo.SELECTABLE || _vo.interactionFlag == CharacterVo.MOVE_DIRTY){
				BattleModel.setSelectedUiStateForMovement(BattleConfigurator.posToGrid(_vo.pos.x, _vo.pos.y), _vo.move);
			}
			// 可被攻擊.
			else if(_vo.interactionFlag == CharacterVo.ASSAULT){
				// 攻擊 or 移動后攻擊.
				
				var assaultGridId:int;
				var msg:MoveChessReq;
				var startVo:CharacterVo;
				var movePath:Array;
				
				
				// 清空Ui狀態.
				BattleModel.setNullSelectedUiState();
				
				// 將接下來要攻擊的人物緩存.
				assaultGridId = MapModel.cachedAssaultGridId = BattleConfigurator.posToGrid3(_vo.pos);
				startVo = BattleModel.getVoByGridId(MapModel.cachedStartGridId)
				
				// 判斷是否為臨位，為true則直接攻擊.
				if((startVo.pos.x - _vo.pos.x)*(startVo.pos.x - _vo.pos.x) + (startVo.pos.y - _vo.pos.y)*(startVo.pos.y - _vo.pos.y) == 1){
					BattleModel.commonAttack();
				}
				else {
					
					// 暫時先把assault的walkable設為true，之後再設回false.
					MapModel.setPathNodeWalkable(assaultGridId, true);
					
					movePath = MapModel.findPath(MapModel.cachedStartGridId, assaultGridId, true);
					
					MapModel.setPathNodeWalkable(assaultGridId, false);
					
					
					movePath.pop();
					
					// 起始點重置.
					MapModel.cachedStartGridId = BattleConfigurator.posToGrid2(movePath[movePath.length - 1]);
					
					msg = new MoveChessReq;
					msg.chessUid = startVo.guid;
					msg.movePath = movePath;
					NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_MOVE_CHESS_REQ, msg);

					GameModel.getLog().simplify("客戶端尋路: {0}", movePath);
				}
				
				// 交互狀態變化.
				_vo.setInteractionFlag(CharacterVo.NONE);
				
				// 攻擊動作進行時，暫不可操控其他.
				BattleModel.dispatchMyControlChanged(false);
			}
			
		}
		
	}
}