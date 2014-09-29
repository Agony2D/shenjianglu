package models.events
{
	import org.agony2d.events.AEvent;
	
	public class SelectedUiMovementEvent extends AEvent
	{
		public function SelectedUiMovementEvent(type:String, pathGirdIdList:Vector.<int>, startGridId:int, assaultableGridIdList:Vector.<int>)
		{
			super(type);
			
			this.pathGirdIdList = pathGirdIdList;
			this.startGridId = startGridId;
			this.assaultableGridIdList = assaultableGridIdList;
		}
		
		
		
		public static const MOVEMENT:String  = "movement";
		
		
		public var pathGirdIdList:Vector.<int>; // 可移動
		
		public var assaultableGridIdList:Vector.<int>; // 可攻擊
		
		public var startGridId:int;
	}
}