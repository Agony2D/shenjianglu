package models.battle.actions
{
	import com.netease.protobuf.UInt64;
	
	import models.battle.CharacterVo;
	
	public class MovementAction extends BattleAction
	{
		public function MovementAction(roleId:UInt64)
		{
			super(roleId);
		}
		
		public var vo:CharacterVo;
		
		public var movePath:Array;
		
		
		public function toString() : String {
			return "[ 移動 ]: " + vo.name + ", " + movePath;
		}
	}
}