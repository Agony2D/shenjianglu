package configs.battle
{
	import flash.geom.Point;
	
	import models.GameModel;
	
	import org.agony2d.collections.CsvUtil;
	
	import proto.cs.ChessPos;

	public class BattleConfigurator
	{

		public static const GRID_TO_COORD_LIST:Array = [null, 
			new Point(60, 495), new Point(180, 495), new Point(301, 495), new Point(423, 495), new Point(546, 495),
			new Point(66, 374), new Point(183, 374), new Point(301, 374), new Point(420, 374), new Point(538, 374),
			new Point(74, 258), new Point(187, 258), new Point(301, 258), new Point(418, 258), new Point(531, 258),
			new Point(79, 149), new Point(190, 149), new Point(301, 149), new Point(415, 149), new Point(527, 149),
			new Point(85, 44),  new Point(194, 44),  new Point(301, 44),  new Point(414, 44),  new Point(522, 44)];
	
	
		
		public static function initGrids( v:Vector.<Array> ) : void {
			var i:int;
			var l:int;
			var vo:GridCfg;
			
			_grid2CoordList = [];
			const ROLE_FIELDS:Array = ["id", "whose", "type", null, null ];	
			l = v.length;
			while(i<l){
				vo = new GridCfg;
				CsvUtil.setValues(vo, v[i++], ROLE_FIELDS);
				_grid2CoordList[vo.id] = vo;
			}
			GameModel.getLog().simplify("初期化: csv - [ Grid ].");
		}
		
		
		// 由格子id獲取格子cfg.
		public static function getCfgByGridId( v:int ) : GridCfg {
			return _grid2CoordList[v];
		}
		
		// 由格子id獲取coord.
		public static function getCoordByGridId( v:int ) : Point {
			return GRID_TO_COORD_LIST[v];
		}
		
		// 由行列信息獲取coord.
		public static function getCoordByPos( x:int, y:int ) : Point {
			return GRID_TO_COORD_LIST[x + 1 + y * 5];
		}
		
		// 格子id => 行列.
		public static function gridToPos( v:int ) : Point {
			return new Point((v - 1) % 5, int((v - 1) / 5));
		}
		
		// 行列 => 格子id.
		public static function posToGrid( x:int, y:int ) : int {
			return x + 1 + y * 5;
		}
		
		// 行列 => 格子id.
		public static function posToGrid2( v:ChessPos ) : int {
			return v.x + 1 + v.y * 5;
		}

		// 行列 => 格子id.
		public static function posToGrid3( v:Point ) : int {
			return v.x + 1 + v.y * 5;
		}
		
		
		
		private static var _grid2CoordList:Array;
	}
}