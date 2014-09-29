package models.battle
{
	import com.netease.protobuf.UInt64;
	
	import flash.geom.Point;
	
	import configs.cards.CardConfigurator;
	import configs.cards.CharacterCardCfg;
	
	import models.player.PlayerModel;
	
	import proto.cs.BattleEffect;
	
	
	// 戰鬥時的角色即時vo.
	public class CharacterVo
	{

		public var role_id:UInt64; // 屬於的角色.
		
		public var guid:UInt64;
		
		public var card_id:int;
		
		public var hp:int;
		
		public var max_hp:int;
		
		public var attack:int;
		
		public var move:int;

		public var buffs:Array; // BattleBuff.

		public var name:String;
		
		public var pos:Point; // 行列.
		
		
		
		public static const NONE:int = 0;
		
		// 可選擇.
		public static const SELECTABLE:int = 1;
		
		// 可攻擊.
		public static const ASSAULT:int = 2;
		
		// 發生過移動.
		public static const MOVE_DIRTY:int = 3;
		
		
		
		/** 是否為友方. */
		public function get isFriend() : Boolean {
			return PlayerModel.isMyRole(role_id);
		}
		
		
		
		/** 上次可操作狀態. */
		public var oldInteractionFlag:int;
		/** 當前可操作狀態. */
		public var interactionFlag:int; // 是否可操作.
		
		public function setInteractionFlag( v:int ) : void {
			if(interactionFlag == v){
				return;
			}
			
			oldInteractionFlag = interactionFlag;
			interactionFlag = v;
			
			BattleModel.dispatchInteractionChanged(this);
			
		}
		
		/**
		 * 更新數值.
		 *  
		 * @param effect
		 */		
		public function updateValue( effect:BattleEffect ) : void {
			var isChanged:Boolean;
			
			isChanged = (this.attack != effect.attack || this.hp != effect.remainHp || this.move != effect.move);
			this.attack = effect.attack;
			this.hp = effect.remainHp;
			this.move = effect.move;
			this.max_hp = effect.maxHp;
			if(isChanged){
				BattleModel.dispatchUpdateValue(this);
			}
		}

		/**
		 *  獲取戰鬥角色vo.
		 */		
		public function getBattleRole() : BattleRoleVo {
			return BattleRoleModel.getBattleRoleVo(this.role_id);
		}
		
		/**
		 * 回合結束人物屬性重置.
		 *  
		 * @return 是否發生變化.
		 * 
		 */		
		public function resetStatusForRoundEnd() : Boolean {
			var changed:Boolean;
			var cfg:CharacterCardCfg;
			
			cfg = CardConfigurator.getCardById(this.card_id) as CharacterCardCfg;
			// 王者不恢復生命.
			if(cfg.quality < 5){
				if(this.hp != this.max_hp){
					this.hp = this.max_hp;
					changed = true;
				}
			}
			if(cfg.movement != this.move){
				this.move = cfg.movement;
				changed = true;
				
			}
			//				}
			
			return changed;
		}
		
		
		public function toString() : String {
			return this.name + this.pos;
		}
		
	}
}