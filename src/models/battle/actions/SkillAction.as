package models.battle.actions
{
	import com.netease.protobuf.UInt64;
	
	import configs.skills.SkillConfigurator;
	
	import models.battle.CharacterVo;
	
	
	// 技能動作.
	public class SkillAction extends BattleAction
	{
		public function SkillAction(roleId:UInt64)
		{
			super(roleId);
		}
		
		
		public var ret:int
		
		public var fromVo:CharacterVo;
		
		public var targetVo:CharacterVo;
		
		public var skillId:int;

		public var effects:Array;
		
		public var buffs:Array;
		
		public var costCardIdList:Array;
		
		public var costDeadCardIdList:Array;
		
		public var costMp:int;
		
		public var skillSourceType:int;
		
		
		
		public function toString() : String {
			return "[ 技能 ]: " + SkillConfigurator.getSkillById(skillId).name + ", " + fromVo + " => " + targetVo;
		}
	}
}