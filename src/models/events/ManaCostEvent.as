package models.events
{
	import com.netease.protobuf.UInt64;
	
	import org.agony2d.events.AEvent;
	
	public class ManaCostEvent extends AEvent
	{
		public function ManaCostEvent(type:String,remainMp:int,roleId:UInt64)
		{
			super(type);
			
			this.remainMp = remainMp;
			
			this.roleId = roleId;
		}
		
		
		public static const MP_CHANGE:String = "mpChange";
		
		
		public var remainMp:int;
		
		
		public var roleId:UInt64;
	}
}