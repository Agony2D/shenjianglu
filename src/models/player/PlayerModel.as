package models.player
{
	import com.netease.protobuf.UInt64;
	
	import models.GameModel;
	
	import proto.com.RoleInfo;
	
	import utils.GameUtil;

public class PlayerModel
{
	
	private static var g_instance:PlayerModel;
	public static function getInstance() : PlayerModel
	{
		return g_instance ||= new PlayerModel;
	}
	
	public function get myRole() : RoleVo {
		return _myRole;
	}
	
	public function initialize( roleInfo:RoleInfo, campList:Array ) : void{
		_myRole = new RoleVo
		_myRole.setValue(roleInfo);
		_myRole.setCamps(campList);
		
		GameModel.getLog().simplify("初期化玩家信息.");
	}
	
	/**
	 * 是否為自己的角色.
	 *  
	 * @param roldId
	 * @return 
	 * 
	 */		
	public static function isMyRole( roleId:UInt64 ) : Boolean {
		return GameUtil.isUint64Equal(roleId, PlayerModel.getInstance().myRole.id);
	}
	
	
	
	
	
	private var _myRole:RoleVo;
}
}