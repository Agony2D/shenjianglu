package res
{
	import configs.battle.BattleConfigurator;
	
	import org.agony2d.display.animation.AnimationManager;
	import org.agony2d.collections.CsvUtil;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.resources.TResourceManager;

	public class ResUtil
	{
		
		
		public static function loadBattleAssets():void
		{
			var data:Vector.<Array>;
			
			
			
			// Ui
			TResourceManager.loadAssets("battle.zip");
			
			// 動畫data.
			TResourceManager.loadAssets2("animation/common.xml", "data/5-5_grid.csv").addEventListener(AEvent.COMPLETE, function(e:AEvent):void{
				AnimationManager.addFrameClips(TResourceManager.getAsset("animation/common.xml").data);
				data = CsvUtil.parse(TResourceManager.getAsset("data/5-5_grid.csv").data);
				BattleConfigurator.initGrids(data);
			})
				
			// 動畫atlas.
			TResourceManager.loadAssets2("atlas/shang/shield.atlas", "atlas/zhouwang.atlas", "atlas/tianyuan.atlas", "atlas/roundOk.atlas").addEventListener(AEvent.COMPLETE, function(e:AEvent):void{
				UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/shang/shield.atlas").data);
				UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/zhouwang.atlas").data);
				UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/tianyuan.atlas").data);
				UUFacade.cache.addAtlas(TResourceManager.getAsset("atlas/roundOk.atlas").data);
			});
		}
	}
}