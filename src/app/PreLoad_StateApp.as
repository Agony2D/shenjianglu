package app
{
	import org.agony2d.base.StateApp;
	import org.agony2d.flashApi.UUFacade;
	
	import views.UU.loading.Preload_StateUU;
	
	public class PreLoad_StateApp extends StateApp
	{
		
		override public function onEnter():void{
			UUFacade.getModule(Preload_StateUU).init();
		}
		
		override public function onExit() : void {
			UUFacade.getModule(Preload_StateUU).close();
		}
	}
}