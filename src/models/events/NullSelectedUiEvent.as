package models.events
{
	import org.agony2d.events.AEvent;
	
	public class NullSelectedUiEvent extends AEvent
	{
		public function NullSelectedUiEvent(type:String)
		{
			super(type);
		}
		
		
		public static const NULL_SELECTED:String = "nullSelected";
	}
}