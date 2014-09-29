package models.player
{
	import com.netease.protobuf.UInt64;
	
	import proto.com.CampLevel;
	import proto.com.RoleInfo;
	

	public class RoleVo
	{
		public function setCamps( campList:Array ) : void
		{
			var i:int;
			var l:int;
			var vo:CampVo;
			var data:CampLevel;
			
			_campList = new <CampVo>[];
			l = campList.length;
			while(i<l){
				data = campList[i];
				vo = _campList[i] = new CampVo;
				vo.exp = data.exp;
				vo.id = data.campId;
				vo.level = data.level;
				i++;
			}
		}
		
		
		public function setValue( roleInfo:RoleInfo ): void {
			this.exp = roleInfo.exp;
			this.gender = roleInfo.gender;
			this.icon = roleInfo.icon;
			this.id = roleInfo.id;
			this.level = roleInfo.level;
			this.money = roleInfo.money;
			this.rmb = roleInfo.rmb;
			this.name = roleInfo.name;
			this.score = roleInfo.score;
		}
		
		
		public var money:int;
		
		public var name:String;
		
		public var level:int;
		
		public var icon:String;
		
		public var gender:int;
		
		public var score:int;
		
		public var id:UInt64;
		
		public var exp:int;
		
		public var rmb:int;
		
		
		
		/**
		 * Shang - 1, Zhou - 2, Yao - 3, Wu - 4.
		 */
		public function getCampVo( id:int ) : CampVo {
			return _campList[id];
		}
		
		
		private var _campList:Vector.<CampVo>;
		
		
	}
}