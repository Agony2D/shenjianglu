package configs.cards
{
	import configs.skills.SkillConfigurator;
	import configs.skills.SkillCfg;
	
public class CharacterCardCfg extends CardCfg
{
	
	//	1=人
	//	2=妖
	//	3=仙
	//	4=神
	//	5=大仙
	//	6=大神
	//	7=鬼
	public var subType:int 
	
	public var attack:int;
	
	public var hp:int;
	
	public var movement:int;
	
	//	1=男
	//	2=女
	public var gender:int;
	
	public function getSkill3() : SkillCfg {
		return SkillConfigurator.getSkillById(skill3);
	}
	
	public var skill3:int;
	
	
}
}