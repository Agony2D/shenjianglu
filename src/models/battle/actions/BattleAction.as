package models.battle.actions
{
	import com.netease.protobuf.UInt64;
	
	import models.battle.BattleModel;
	
	public class BattleAction {
		
		public function BattleAction( roleId:UInt64 ) {
			this.roleId = roleId;
		}
		
		public function next(hasMyNextAction:Boolean = false) : void {
			if(!isAlone){
				BattleModel.doIterateNextAction(hasMyNextAction);
			}
		}
		
		public var roleId:UInt64;
		
		public var isAlone:Boolean;
	}
}