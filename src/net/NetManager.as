package net {
	import com.netease.protobuf.Message;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import models.GameModel;
	
	import net.responses.AuthResponsor;
	import net.responses.BattleResponsor;
	import net.responses.ChatResponsor;
	import net.responses.IResponsor;
	import net.responses.ItemResponsor;
	import net.responses.LoginResponsor;
	import net.responses.QuestResponsor;
	import net.responses.RoleResponsor;
	import net.responses.RoomResponsor;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.events.Notifier;
	import org.agony2d.utils.formatString;
	
	import proto.cs.AuthBody;
	import proto.cs.BattleBody;
	import proto.cs.ChatBody;
	import proto.cs.CmdType;
	import proto.cs.ItemBody;
	import proto.cs.LoginBody;
	import proto.cs.MsgBody;
	import proto.cs.MsgDef;
	import proto.cs.MsgHead;
	import proto.cs.QuestBody;
	import proto.cs.RoleBody;
	import proto.cs.RoomBody;
	
public class NetManager {
	
	/**
	 * 初期化.
	 */
	public static function connect( ip:String, port:int ) : void {
		if(!_notifier){
			_notifier = new Notifier;
			_respMap = [];
		}
		if(_socket){
			_socket.removeEventListener(Event.CONNECT, onConnect);
			_socket.removeEventListener(Event.CLOSE, onClose);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			if(_socket.connected){
				_socket.close();
			}
		}
		_ip = ip;
		_port = port;
		_socket = new Socket;
		_socket.addEventListener(Event.CONNECT, onConnect);
		_socket.addEventListener(Event.CLOSE, onClose);
		_socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		_socket.connect(ip, port);
	}
	
	public static function connect2( ip:String, port:int ) : void {
		_ip2 = ip;
		_port2 = port;
		_socket2 = new Socket;
		_socket2.addEventListener(Event.CONNECT, onConnect2);
		_socket2.addEventListener(Event.CLOSE, onClose2);
		_socket2.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		_socket2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		_socket2.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData2);
		_socket2.connect(ip, port);
	}
	
	public static function close2() : void {
		_socket2.removeEventListener(Event.CONNECT, onConnect2);
		_socket2.removeEventListener(Event.CLOSE, onClose2);
		_socket2.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
		_socket2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		_socket2.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData2);
		if(_socket2.connected){
			_socket2.close();
		}
		_socket2 = null;
	}
	
	/**
	 * 向服務器發送一個請求.
	 *  
	 * @param cmd_A	主命令號.
	 * @param cmd_B	子命令號.
	 * @param msg	具體的消息實例.
	 */	
	public static function sendRequest( cmd_A:int, cmd_B:int, msg:Message ) : void {
		var head:MsgHead;
		var body:MsgBody;

		var count:int;
		var subMsg:Object;
		var msgName:String;
		var index:int;
		
		bytes_H.length = bytes_B.length = bytes_L.length = 0;
		
		// head.
		head = new MsgHead;
		head.cmd = (cmd_A << 16) | cmd_B;
		head.writeTo(bytes_H);
		count = MsgDef.MSG_HEAD_LEN - bytes_H.length;
		while(--count > -1){
			bytes_H.writeByte(0);
		}
		
		// body，msg不存在則跳過.
		if(msg){
			body = new MsgBody;
			switch(cmd_A) {
				case CmdType.CT_AUTH:
					subMsg = body.authBody = new AuthBody;
					break;
				case CmdType.CT_LOGIN:
					subMsg = body.loginBody = new LoginBody;
					break;
				case CmdType.CT_ROLE:
					subMsg = body.roleBody = new RoleBody;
					break;
				case CmdType.CT_QUEST:
					subMsg = body.questBody = new QuestBody;   
					break;
				case CmdType.CT_ITEM:
					subMsg = body.itemBody = new ItemBody;   
					break;
				case CmdType.CT_BATTLE:
					subMsg = body.battleBody = new BattleBody;
					break;
				case CmdType.CT_ROOM:
					subMsg = body.roomBody = new RoomBody;
					break;
				case CmdType.CT_CHAT:
					subMsg = body.chatBody = new ChatBody;
					break;
				default:
					GameModel.getLog().error("NetManager", "sendRequest", "Error cmd A: [ {0} ].", cmd_A);
					break;
			}
			msgName = getQualifiedClassName(msg);
			index = msgName.lastIndexOf("::");
			msgName = String(msgName.charAt(index + 2)).toLowerCase() + msgName.substring(index + 3);
			try {
				subMsg[msgName] = msg;
			}
			catch(e:Error){
				GameModel.getLog().error("NetManager", "sendRequest", "Not found msg member: [ {0} ].", msgName);
			}
			body.writeTo(bytes_B);
		}
		
		
		bytes_L.writeUnsignedInt(msg ? bytes_B.length + 14 : 14);
		_socket.writeBytes(bytes_L);
		_socket.writeBytes(bytes_H);
		if(msg){
			_socket.writeBytes(bytes_B);
		}
		
		GameModel.getLog().simplify("\n========================================================================\n");
		GameModel.getLog().message("NetManager", "Send request: [ {0}, {1}, {2}, {3} ].", msgName, cmd_A, cmd_B, _socket.bytesPending - 4);
		GameModel.getLog().simplify(body);
		
		_socket.flush();
	}
	
	/**
	 * 向戰鬥服務器發送一個請求.
	 *  
	 * @param cmd_A	主命令號.
	 * @param cmd_B	子命令號.
	 * @param msg	具體的消息實例.
	 */	
	public static function sendRequest2( cmd_A:int, cmd_B:int, msg:Message ) : void {
		var head:MsgHead;
		var body:MsgBody;
		
		var count:int;
		var subMsg:Object;
		var msgName:String;
		var index:int;
		
		bytes_H.length = bytes_B.length = bytes_L.length = 0;
		
		// head.
		head = new MsgHead;
		head.cmd = (cmd_A << 16) | cmd_B;
		head.writeTo(bytes_H);
		count = MsgDef.MSG_HEAD_LEN - bytes_H.length;
		while(--count > -1){
			bytes_H.writeByte(0);
		}
		
		// body，msg不存在則跳過.
		if(msg){
			body = new MsgBody;
			switch(cmd_A) {
				case CmdType.CT_AUTH:
					subMsg = body.authBody = new AuthBody;
					break;
				case CmdType.CT_LOGIN:
					subMsg = body.loginBody = new LoginBody;
					break;
				case CmdType.CT_ROLE:
					subMsg = body.roleBody = new RoleBody;
					break;
				case CmdType.CT_QUEST:
					subMsg = body.questBody = new QuestBody;   
					break;
				case CmdType.CT_ITEM:
					subMsg = body.itemBody = new ItemBody;   
					break;
				case CmdType.CT_BATTLE:
					subMsg = body.battleBody = new BattleBody;
					break;
				case CmdType.CT_ROOM:
					subMsg = body.roomBody = new RoomBody;
					break;
				case CmdType.CT_CHAT:
					subMsg = body.chatBody = new ChatBody;
					break;
				default:
					GameModel.getLog().error("NetManager", "sendRequest", "Error cmd A: [ {0} ].", cmd_A);
					break;
			}
			msgName = getQualifiedClassName(msg);
			index = msgName.lastIndexOf("::");
			msgName = String(msgName.charAt(index + 2)).toLowerCase() + msgName.substring(index + 3);
			try {
				subMsg[msgName] = msg;
			}
			catch(e:Error){
				GameModel.getLog().error("NetManager", "sendRequest", "Not found msg member: [ {0} ].", msgName);
			}
			body.writeTo(bytes_B);
		}
		
		
		bytes_L.writeUnsignedInt(msg ? bytes_B.length + 14 : 14);
		_socket2.writeBytes(bytes_L);
		_socket2.writeBytes(bytes_H);
		if(msg){
			_socket2.writeBytes(bytes_B);
		}
		
		GameModel.getLog().simplify("\n========================================================================\n戰鬥請求:\n");
		GameModel.getLog().message("NetManager", "Send request 2: [ {0}, {1}, {2}, {3} ].", msgName, cmd_A, cmd_B, _socket2.bytesPending - 4);
		GameModel.getLog().simplify(body);
		
		_socket2.flush();
	}
	
	/**
	 * 加入事件偵聽器.
	 */
	public static function addEventListener( type:String, listener:Function, priority:int = 0 ) : void {
		_notifier.addEventListener(type, listener, priority);
	}
	
	/**
	 * 移除事件偵聽器.
	 */
	public static function removeEventListener( type:String, listener:Function ) : void {
		_notifier.removeEventListener(type, listener);
	}
	
	
	
	//////////////////////////////////////////////////////
	//////////////////////////////////////////////////////
	//////////////////////////////////////////////////////
	
	private static var _socket:Socket;
	private static var _ip:String;
	private static var _port:int;
	
	private static var _socket2:Socket; // 戰鬥場景.
	private static var _ip2:String;
	private static var _port2:int;
	
	private static var _notifier:Notifier;
	private static var _respMap:Array;
	
	private static var bytes_L:ByteArray = new ByteArray;
	private static var bytes_H:ByteArray = new ByteArray;
	private static var bytes_B:ByteArray = new ByteArray;
	
	
	private static function onConnect(e:Event) : void{
		GameModel.getLog().simplify(formatString("\nsocket連接成功 [ {0} - {1} ].", [_ip, _port]));
		_notifier.dispatchDirectEvent(AEvent.COMPLETE);
	}
	
	private static function onConnect2(e:Event) : void{
		GameModel.getLog().simplify(formatString("\nsocket連接戰鬥服務器成功 [ {0} - {1} ].", [_ip2, _port2]));
		_notifier.dispatchDirectEvent(AEvent.COMPLETE);
	}
	
	private static function onClose(e:Event) : void{
		GameModel.getLog().warning("NetManager", "onClose", "socket中斷: [ {0} - {1} ] !!!", _ip, _port);
		_notifier.dispatchDirectEvent(AEvent.ABORT);
	}
	
	private static function onClose2(e:Event) : void{
		GameModel.getLog().simplify("戰鬥服務器socket關閉.");
	}
	
	private static function onIoError(e:IOErrorEvent) : void{
		GameModel.getLog().message("NetManager", e);
	}
	
	private static function onSecurityError(e:SecurityErrorEvent) : void{
		GameModel.getLog().message("NetManager", e);
	}
	
	// 接收數據.
	private static function onSocketData(e:ProgressEvent) : void {
//		_socket.readBytes(bytes_Z);
		____doNextResponse();
		
	}
	

	private static const LEN:int = 0;
	private static const HALF_LEN:int = 2;
	private static const HEAD:int = 3;
	private static const HALF_HEAD:int = 4;
	private static const BODY:int = 5;
	private static const HALF_BODY:int = 6;
	
	private static var _flag:uint = LEN;
	private static var _length:int;
	private static var _currPosition:int;
//	private static var bytes_LL:ByteArray = new ByteArray;
	private static var bytes_HH:ByteArray = new ByteArray;
	private static var bytes_BB:ByteArray = new ByteArray;
	
	private static function ____doNextResponse() : void {
		if(_flag == LEN){
			if(_socket.bytesAvailable < 4){
				throw new Error("Error len.");
//				_socket.readBytes(bytes_LL, 0, _socket.bytesAvailable);
//				_flag = HALF_LEN;
//				return;
			}
			else {
				_length = _socket.readUnsignedInt();
				_flag = HEAD;
				if(_socket.bytesAvailable == 0){
					return;
				}
			}
		}
		if(_flag == HEAD){
			if(_socket.bytesAvailable < 10){
				_currPosition = _socket.bytesAvailable;
				_socket.readBytes(bytes_HH, 0, 10 - _socket.bytesAvailable);
				_flag = HALF_HEAD;
				return;
			}
			else {
				_socket.readBytes(bytes_HH, 0, 10);
				_flag = BODY;
				if(_socket.bytesAvailable == 0){
					return;
				}
			}
		}
		if(_flag == HALF_HEAD){
			if(_currPosition + _socket.bytesAvailable < 10){
				_currPosition += _socket.bytesAvailable;
				_socket.readBytes(bytes_HH, 0, (10 - _currPosition) - _socket.bytesAvailable);
				return;
			}
			else {
				_socket.readBytes(bytes_HH, 0, 10 - _currPosition);
				_flag = BODY;
				if(_socket.bytesAvailable == 0){
					return;
				}
			}
		}
		if(_flag == BODY){
			if(_socket.bytesAvailable < _length - 14){
				_currPosition = _socket.bytesAvailable;
				_socket.readBytes(bytes_BB, 0, (_length - 14) - _socket.bytesAvailable);
				_flag = HALF_BODY;
				return;
			}
			else {
				_socket.readBytes(bytes_BB, 0, _length - 14);
				_flag = BODY;
			}
		}
		if(_flag == HALF_BODY){
			if(_currPosition + _socket.bytesAvailable < _length - 14){
				_currPosition += _socket.bytesAvailable;
				_socket.readBytes(bytes_BB, 0, (_length - 14 - _currPosition) - _socket.bytesAvailable);
				return;
			}
			else {
				_socket.readBytes(bytes_BB, 0, _length - 14 - _currPosition);
				_flag = LEN;
			}
		}
		
		____doMergeBytes(bytes_HH, bytes_BB);
		
		trace(_socket.bytesAvailable);
		bytes_HH.length = bytes_BB.length = _currPosition = _length = _flag = 0;
		if(_socket.bytesAvailable){
			____doNextResponse();
		}
	}
	
	
	
	// 接收數據 2.
	private static function onSocketData2(e:ProgressEvent) : void {
		//		_socket.readBytes(bytes_Z);
		____doNextResponse2();
		
	}
	
	
	private static var _flag2:uint = LEN;
	private static var _length2:int;
	private static var _currPosition2:int;
	//	private static var bytes_LL2:ByteArray = new ByteArray;
	private static var bytes_HH2:ByteArray = new ByteArray;
	private static var bytes_BB2:ByteArray = new ByteArray;
	
	
	private static function ____doNextResponse2() : void {
		if(_flag2 == LEN){
			if(_socket2.bytesAvailable < 4){
				throw new Error("Error len.");
				//				_socket.readBytes(bytes_LL, 0, _socket.bytesAvailable);
				//				_flag = HALF_LEN;
				//				return;
			}
			else {
				_length2 = _socket2.readUnsignedInt();
				_flag2 = HEAD;
				if(_socket2.bytesAvailable == 0){
					return;
				}
			}
		}
		if(_flag2 == HEAD){
			if(_socket2.bytesAvailable < 10){
				_currPosition2 = _socket.bytesAvailable;
				_socket2.readBytes(bytes_HH2, 0, 10 - _socket2.bytesAvailable);
				_flag2 = HALF_HEAD;
				return;
			}
			else {
				_socket2.readBytes(bytes_HH2, 0, 10);
				_flag2 = BODY;
				if(_socket2.bytesAvailable == 0){
					return;
				}
			}
		}
		if(_flag2 == HALF_HEAD){
			if(_currPosition2 + _socket2.bytesAvailable < 10){
				_currPosition2 += _socket2.bytesAvailable;
				_socket2.readBytes(bytes_HH2, 0, (10 - _currPosition2) - _socket2.bytesAvailable);
				return;
			}
			else {
				_socket2.readBytes(bytes_HH2, 0, 10 - _currPosition2);
				_flag2 = BODY;
				if(_socket2.bytesAvailable == 0){
					return;
				}
			}
		}
		if(_flag2 == BODY){
			if(_socket2.bytesAvailable < _length2 - 14){
				_currPosition2 = _socket2.bytesAvailable;
				_socket2.readBytes(bytes_BB2, 0, (_length2 - 14) - _socket2.bytesAvailable);
				_flag2 = HALF_BODY;
				return;
			}
			else {
				_socket2.readBytes(bytes_BB2, 0, _length2 - 14);
				_flag2 = BODY;
			}
		}
		if(_flag2 == HALF_BODY){
			if(_currPosition2 + _socket2.bytesAvailable < _length2 - 14){
				_currPosition2 += _socket2.bytesAvailable;
				_socket2.readBytes(bytes_BB2, 0, (_length2 - 14 - _currPosition2) - _socket2.bytesAvailable);
				return;
			}
			else {
				_socket2.readBytes(bytes_BB2, 0, _length2 - 14 - _currPosition2);
				_flag2 = LEN;
			}
		}
		
		____doMergeBytes(bytes_HH2, bytes_BB2);
		
		trace(_socket2.bytesAvailable);
		bytes_HH2.length = bytes_BB2.length = _currPosition2 = _length2 = _flag2 = 0;
		if(_socket2.bytesAvailable){
			____doNextResponse2();
		}
	}
		
	private static function ____doMergeBytes( headBytes:ByteArray, bodyBytes:ByteArray ) : void {
		var body:MsgBody;
		var head:MsgHead;
		var cmd_A:int;
		var subMsg:Object;
		var resp:IResponsor;
		
		// Head.
		head = new MsgHead
		head.mergeFrom(headBytes);
		cmd_A = head.cmd >> 16;
		
		GameModel.getLog().message("NetManager", "Response: [ {0}, {1} ].", cmd_A, head.cmd & 0xFFFF);
		
		// Body.
		body = new MsgBody;
		body.mergeFrom(bodyBytes);
		
		// 服務端報錯，莫名其妙...
		if(body.ret < 0){
			GameModel.getLog().error("NetManager", "____doMergeBytes", "服務端返回錯誤.");
		}
		
		switch(cmd_A) {
			case CmdType.CT_AUTH:
				subMsg = body.authBody;
				resp = _respMap[cmd_A] ||= new AuthResponsor;
				break;
			case CmdType.CT_LOGIN:
				subMsg = body.loginBody;
				resp = _respMap[cmd_A] ||= new LoginResponsor;
				break;
			case CmdType.CT_ROLE:
				subMsg = body.roleBody;
				resp = _respMap[cmd_A] ||= new RoleResponsor;
				break;
			case CmdType.CT_QUEST:
				subMsg = body.questBody;
				resp =  _respMap[cmd_A] ||= new QuestResponsor;
				break;
			case CmdType.CT_BATTLE:
				subMsg = body.battleBody;
				resp =  _respMap[cmd_A] ||= new BattleResponsor;
				break;
			case CmdType.CT_ROOM:
				subMsg = body.roomBody;
				resp =  _respMap[cmd_A] ||= new RoomResponsor;
				break;
			case CmdType.CT_CHAT:
				subMsg = body.chatBody;
				resp =  _respMap[cmd_A] ||= new ChatResponsor;
				break;
			case CmdType.CT_ITEM:
				subMsg = body.itemBody;
				resp =  _respMap[cmd_A] ||= new ItemResponsor;
				break;
			default:
				GameModel.getLog().simplify("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				GameModel.getLog().simplify("!!!!!!!!未註冊Responsor的cmd: [ {0} ].", cmd_A);
				GameModel.getLog().simplify("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				return;
		}
		// 記錄body信息.
		GameModel.getLog().simplify(body);
		
		// 處理服務器返回數據.
		resp.onHandle(head.cmd & 0xFFFF, subMsg);
	}
}
}