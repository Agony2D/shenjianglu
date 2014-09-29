package
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import app.Login_StateApp;
	
	import configs.ConfigNet;
	
	import models.GameModel;
	
	import net.NetManager;
	
	import org.agony2d.Agony;
	import org.agony2d.base.Adapter;
	import org.agony2d.base.DebugLogger;
	import org.agony2d.display.animation.AnimationManager;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.flashApi.tips.TipReactionType;
	import org.agony2d.flashApi.tips.UUToolTip;
	import org.agony2d.inputs.KeyboardManager;
	import org.agony2d.inputs.TouchManager;
	import org.agony2d.resources.TResourceManager;
	import org.agony2d.utils.Stats;
	import org.agony2d.utils.gc;
	
	import views.UU.comps.tips.Alpha_TipEffectStateUU;

	public class GameInitializer {
		
		public static function startup( stage:Stage ) : void {
			// Agony2D.
			Agony.startup(stage, new DebugLogger("(A)"), new Adapter(1280, 960, true), onInit);
//			Agony.startup(stage, new DebugLogger("(A)"), null, onInit);
			
			stage.addChild(new Stats(0, 33));
			
			// 屏蔽右鍵.
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void{}); 
		}
		
		private static function onInit():void {
			TouchManager.registerListenTarget();
			
			if(Capabilities.isDebugger){
				KeyboardManager.getInstance().getState().press.addEventListener("G", function(e:AEvent):void{
					gc();
				})
			}
			
			// 動畫速率.
			AnimationManager.defaultFrameRate = 12;
			
			// 資源管.
			TResourceManager.initialize();
			
			// Upper UI.
			UUFacade.registerRoot();
			UUToolTip.setReactionTypeForPress(TipReactionType.EXIT_NO_EFFECT);
			UUToolTip.setDefaultEffect(Alpha_TipEffectStateUU);
			
			
			// 網路管.
			NetManager.connect(ConfigNet.ip, ConfigNet.port);
			// (連接完畢) -> 偵聽器...
			NetManager.addEventListener(AEvent.COMPLETE, ____onNetConnected);
		}
		
		
		/**
		 * 登陸遊戲.
		 */
		public static function ____onNetConnected(e:AEvent):void{
			NetManager.removeEventListener(AEvent.COMPLETE, ____onNetConnected);
			
			GameModel.getLog().simplify("客戶端初期登陸.");
			
			Agony.setStateForApp(Login_StateApp);
			
			//		Agony.setStateForApp(Battle_StateApp);
			
		}
		
	}
}