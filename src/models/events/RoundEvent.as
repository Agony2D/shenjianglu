package models.events
{
	import com.netease.protobuf.UInt64;
	
	import org.agony2d.events.AEvent;
	
	public class RoundEvent extends AEvent
	{
		public function RoundEvent(type:String, roleId:UInt64, cardIdList:Array = null)
		{
			super(type);
			
			this.roleId = roleId;
			this.cardIdList = cardIdList;
		}
		
		
		public static const ROUND_BEGIN:String = "roundBegin";
		
		public static const ROUND_END:String = "roundEnd";
		
		
		public var cardIdList:Array;
		
		public var roleId:UInt64;
	}
}