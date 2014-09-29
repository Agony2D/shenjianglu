package models.events
{
	import org.agony2d.events.AEvent;
	
	public class SelectedUiSkillEvent extends AEvent
	{
		public function SelectedUiSkillEvent(type:String)
		{
			super(type);
		}
		
		
		
		public static const SKILL:String  = "skill";
	}
}