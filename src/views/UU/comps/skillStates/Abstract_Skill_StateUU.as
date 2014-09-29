package views.UU.comps.skillStates
{
	import models.battle.actions.SkillAction;
	
	import org.agony2d.flashApi.StateUU;
	
	import views.UU.battle.Battle_active_StateUU;
	
	public class Abstract_Skill_StateUU extends StateUU
	{
		public function Abstract_Skill_StateUU()
		{
			super();
		}
		
		
		// 狀態對象.
		public var stateForBattleActive:Battle_active_StateUU;
		
		// 技能動作.
		public var skillAction:SkillAction;
		
		
		
		override public function onEnter():void {
			this.skillAction = this.stateArgs[0];
			this.stateForBattleActive = this.stateArgs[1];
			
			
		}
		
		
	}
}