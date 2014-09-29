package models.battle
{
	import com.netease.protobuf.UInt64;
	
	import models.player.RoleVo;
	
	import proto.com.BattleMemberInfo;
	import proto.com.CampBattleCard;

	public class BattleRoleVo
	{
		public function initialize( v:BattleMemberInfo ) : void
		{
			this.playerId = v.uid;
			this.roleVo = new RoleVo;
			this.roleVo.setValue(v.roleInfo);
			
			this.chairId = v.roomMemberInfo.chairId;
			this.campId = v.roomMemberInfo.campId;
			this.ready = v.roomMemberInfo.ready;
			
			this.campBattleCards = v.campBattleCards;
			this.cardBagIndex = v.cardBagIndex;
			this.useBagCard = v.useBagCard;
			this.isRobot = v.isRobot;
			
		}
		
		
		
		public var playerId:UInt64;
		
		public var roleVo:RoleVo;
		
		
		public var chairId:int;
		
		public var campId:int;
		
		public var ready:Boolean;
		
		public var campBattleCards:Array;
//		CAMP_ID_SHANG = 1;		// 商国
//		CAMP_ID_ZHOU = 2;		// 周国
//		CAMP_ID_YAO = 3;		// 妖
//		CAMP_ID_WU = 4;			// 巫
		public var cardBagIndex:int;
		
		public var useBagCard:Boolean;
		
		public var isRobot:Boolean;
		
	}
}