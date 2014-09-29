package models
{
	import org.agony2d.base.DebugLogger;
	import org.agony2d.base.LogMachine;
	import org.agony2d.events.Notifier;

public class GameModel {
	
	public static function getLog() : LogMachine {
		return g_log ||= new LogMachine(new DebugLogger("(G)"));
	}
	
	public static function getNotifier() : Notifier {
		return g_notifier ||= new Notifier;
	}
	
	
	
	
	private static var g_log:LogMachine;
	
	private static var g_notifier:Notifier;
	
	// 種族.
	public static var campIndex:int;
	
	// 遊戲模式
	public static var gameMode:int;
	
	
	public static var isReadyForLoginServers:Boolean;
	
	
	
	
	
}
}