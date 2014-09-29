package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	[SWF(width="1160", height="720", frameRate="60",backgroundColor = "0x0")]
//	[SWF(width="1280", height="800", frameRate="60",backgroundColor = "0x0")]
public class Main_For_Web extends Sprite {
	
	public function Main_For_Web() {
		Security.allowDomain("*");
		
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e:Event):void{
		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		
		
		GameInitializer.startup(stage);
	}
	
}
}