package models.battle
{
	import flash.geom.Point;
	
	import configs.battle.BattleConfigurator;
	
	import models.GameModel;
	import models.battle.actions.MovementAction;
	
	import proto.cs.ChessPos;
	
	import utils.path.AStar;
	import utils.path.Grid;
	import utils.path.Node;

	public class MapModel
	{

		
		public static function initialize() : void {
//			_astar = new AStar;
			_pathGrid = new Grid(5, 5);
			// 天元.
			setPathNodeWalkable(13, false);
		}
		
		/**
		 * 獲取方向值.
		 */
		public static function getDirection( startX:int, startY:int, targetX:int, targetY:int ) : int {
			// 向左
			if(targetX < startX){
				return 4;
			}
				// 向右
			else if(targetX > startX){
				return 6;
			}
				// 向下
			else if(targetY < startY){
				return 2;
			}
				// 向上
			else if(targetY > startY){
				return 8;
			}
			return 0;
		}
		
		public static function getDirection2( startPos:Point, targetPos:Point ) : int {
			return getDirection(startPos.x, startPos.y, targetPos.x, targetPos.y);
		}
		
		public static function getDirection3( startPos:ChessPos, targetPos:ChessPos ) : int {
			return getDirection(startPos.x, startPos.y, targetPos.x, targetPos.y);
		}
		
		
		
		///////////////////////////////////////
		// path
		///////////////////////////////////////
		
		
		
		
		/**
		 * 設定節點是否可通過.
		 *  
		 * @param gridId
		 * @param b
		 */		
		// 尋路地圖 and 遊戲地圖，Y軸為顛倒.
		public static function setPathNodeWalkable( gridId:int, b:Boolean ) : void {
			var x:int;
			var y:int;
			
			x = (gridId - 1) % 5;
			y = 4 - int((gridId - 1) / 5);
			
			_pathGrid.setWalkable(x, y, b);
		}
		
		/**
		 * 自動更新格子通過狀態.
		 *  
		 * @param gridId
		 * 
		 */		
		public static function autoUpdatePathNodeWalkable( gridId:int ) : void {
			var x:int;
			var y:int;
			var vo:CharacterVo;
			
			x = (gridId - 1) % 5;
			y = 4 - int((gridId - 1) / 5);
			vo = BattleModel.getVoByGridId(gridId);
			
			// 可能是空格子.
			_pathGrid.setWalkable(x, y, !vo || vo.isFriend);
		}
		
		
		/**
		 * 尋路
		 * 
		 * @return 
		 */
		public static function findPath( startGridId:int, endGridId:int, exclude:Boolean = false ): Array {
			var path:Array;
			var chessPos:ChessPos;
			var node:Node;
			var i:int;
			var l:int;
			var AY:Array; // 當自動移動後攻擊時，可能會站到有人物的位置上，這個列表保存這些人物.
			var vo:CharacterVo;
			var gridId:int;
			
			_pathGrid.setStartNode2(startGridId);
			_pathGrid.setEndNode2(endGridId);
			
			astar ||= new AStar;
			
			// 當自動移動後攻擊時，可能會站到有人物的位置上.
			if(exclude){
				while(true){
					if(!astar.findPath(_pathGrid)){
						GameModel.getLog().error("BattleModel", "findPath", "尋路錯誤: {0} -> {1}.", startGridId, endGridId);
					}
					path = astar.path;
					node = path[path.length - 2];
					gridId = BattleConfigurator.posToGrid(node.posX, node.posY);
					if(BattleModel.getVoByGridId(gridId) != null){
						// walkable暫時設為false.
						MapModel.setPathNodeWalkable(gridId, false);
						(AY ||= []).push(gridId);
					}
					else {
						break;
					}
				}
				// 檢查并還原walkable.
				if(AY){
					l = AY.length;
					while(i < l){
						gridId = AY[i++];
						MapModel.setPathNodeWalkable(gridId, true);
					}
				}
			}
			else{
				if(!astar.findPath(_pathGrid)){
					GameModel.getLog().error("BattleModel", "findPath", "尋路錯誤: {0} -> {1}.", startGridId, endGridId);
				}
				path = astar.path;
			}
			
			i = 0;
			l = path.length;
			while(i<l){
				node = path[i];
				chessPos = path[i++] = new ChessPos;
				chessPos.x = node.posX;
				chessPos.y = node.posY;
			}
			
			return path;
		}
		
		
		
		
		
		public static var cachedStartGridId:int;
		
		public static var cachedAssaultGridId:int;
		
		
		private static var astar:AStar;
		
		private static var _pathGrid:Grid;
	}
}