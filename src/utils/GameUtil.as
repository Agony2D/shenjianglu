package utils
{
	import com.netease.protobuf.UInt64;
	
	import models.GameModel;
	import models.battle.BattleModel;
	import models.battle.CharacterVo;

	public class GameUtil
	{
		
		public static function isUint64Equal( A:UInt64, B:UInt64 ) : Boolean {
			return (A.low == B.low) && (A.high == B.high);
		}
		
		
		
		public static var cachedResult_A:Vector.<int>; // 路徑.
		public static var cachedResult_B:Vector.<int>; // 可攻擊目標.
		
		
		
		private static var cachedList_A:Vector.<int>; // 正在遍歷
		private static var cachedList_B:Vector.<int>; // 緩存遍歷
		private static var cacheExistList:Array; // 已經存在列表
		private static var cacheFriendList:Array; // 友方
		private static var len_result_A:int;
		private static var len_result_B:int;
		private static var cachedList_len:int;
		
		/**
		 * 尋路5_5.
		 *  
		 * @param startGridId
		 * @param step
		 * 
		 */		
		public static function makePath5_5( startGridId:int, step:int ) : void {
			var tmpList:Vector.<int>;
			var len:int;
			
			var i:int;
			var gridId:int;
			var prevGridId:int;
			
			var startX:int;
			var startY:int;
			
			
			//x + 1 + y * 5
			var a:int; // 左邊界
			var b:int; // 上邊界
			var c:int; // 右邊界
			var d:int; // 下邊界
			
			if(!cachedList_A){
				cachedList_A = new <int>[];
				cachedList_B = new <int>[];
				cachedResult_A = new <int>[];
				cachedResult_B = new <int>[];
				cacheExistList = [];
				cacheFriendList = [];
			}
			else {
				cachedList_A.length = cachedList_B.length = cachedResult_A.length = cachedResult_B.length = cacheExistList.length = cacheFriendList.length = len_result_A = len_result_B = cachedList_len = 0;
			}
			c  =  d  =  5;
			startX = (startGridId - 1) % 5;
			startY = int((startGridId - 1) / 5);
			cacheExistList[startGridId] = true;
			cachedList_B[len++] = startGridId;
			
			// 當step為0時，為檢測最外側可攻擊敵方.
			while (len > 0 && step-- > -1) {
				i                    =  0;
				tmpList              =  cachedList_A;
				cachedList_A         =  cachedList_B;
				cachedList_B         =  tmpList;
				cachedList_B.length  =  cachedList_len  =  0;
				
				while (i < len) {
					prevGridId  =  cachedList_A[i++];
					startX  =  (prevGridId - 1) % 5;
					startY  =  int((prevGridId - 1) / 5);
					
					// 是否已緩存 or 超出棋盤.
					gridId  =  (startX - 1) + 1 + startY * 5;
					if(!cacheExistList[gridId] && startX - 1 >= a && startY >= b && startX - 1 < c && startY < d){
						____doParseGrid(gridId, step, prevGridId);
					}
					gridId  =  (startX + 1) + 1 + startY * 5;
					if(!cacheExistList[gridId] && startX + 1 >= a && startY >= b && startX + 1 < c && startY < d){
						____doParseGrid(gridId, step, prevGridId);
					}
					gridId  =  startX + 1 + (startY - 1) * 5;
					if(!cacheExistList[gridId] && startX >= a && startY - 1 >= b && startX < c && startY - 1 < d){
						____doParseGrid(gridId, step, prevGridId);
					}
					gridId  =  startX + 1 + (startY + 1) * 5;
					if(!cacheExistList[gridId] && startX >= a && startY + 1 >= b && startX < c && startY + 1 < d){
						____doParseGrid(gridId, step, prevGridId);
					}
				}
//				trace("遞歸格子: ", list_B);
				len = cachedList_len;
			}
		}
		
		private static function ____doParseGrid( gridId:int, step:int, prevGridId ) : void {
			var vo:CharacterVo;
			
			// 排除天元.
			if(gridId != 13){
				// 存在人物，無法走到該點.
   				vo = BattleModel.getVoByGridId(gridId);
 				if(vo){
					// 可攻擊的人物.
					if(BattleModel.isAssaultable(BattleModel.getVoByGridId(gridId))){
						// 前一格不能是友方.
						if(!cacheFriendList[prevGridId]){
							cacheExistList[gridId] = cachedResult_B[len_result_B++] = gridId;
						}
					}
					// 友方人物，可穿越.
					else {// if(step >= 1){
						cacheExistList[gridId] = cacheFriendList[gridId] = cachedList_B[cachedList_len++] = gridId;
//						cacheExistList[gridId] = cachedList_B[cachedList_len++] = gridId;
					}
//					else {
//						cacheExistList[gridId] = gridId;
//					}
				}
				// 可走路徑，排除最後一步.
				else if(step >= 0) {
					cachedResult_A[len_result_A++] = cacheExistList[gridId] = cachedList_B[cachedList_len++] = gridId;
				}
			}
		}
	}
}