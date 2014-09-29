package views.events
{
	import org.agony2d.events.AEvent;
	import org.agony2d.inputs.Touch;
	
	public class CardUUEvent extends AEvent
	{
		public function CardUUEvent(type:String)
		{
			super(type);
			
		}
		
		
		// 卡牌派發完成.
		public static const CARD_COMPLETE:String = "cardComplete";
		
		// 放下卡牌.
		public static const CARD_DROP:String = "cardDrop";
		
		
		public var cardId:int;
		
		public var userData:*;
	}
}