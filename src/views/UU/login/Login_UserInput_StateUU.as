package views.UU.login
{
	import net.NetManager;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.ButtonUU;
	import org.agony2d.flashApi.CheckBoxUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.flashApi.TextInputUU;
	import org.agony2d.inputs.events.ATouchEvent;
	import org.agony2d.resources.TResourceManager;
	import org.agony2d.utils.ColorUtil;
	
	import proto.cs.AccountLoginReq;
	import proto.cs.CmdCodeLogin;
	import proto.cs.CmdType;
	
	import utils.TextUtil;
	
	public class Login_UserInput_StateUU extends StateUU
	{
		
		private var _input_A:TextInputUU;
		private var _input_B:TextInputUU;
		private var _checkBox_A:CheckBoxUU;
		
		
		override public function onEnter():void{
			
//			this.fusion.locatingWidth = this.fusion.root.locatingWidth;
//			this.fusion.locatingHeight = this.fusion.root.locatingHeight;
			
			
			var btn:ButtonUU;
			var img:BitmapLoaderUU;
			
			var label:LabelUU;
			
			
			// 小背景.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("login/img/loadingBackground.png");
			this.fusion.addNode(img);
			
			
			this.fusion.spaceWidth = img.width;
			this.fusion.spaceHeight = img.height;
			
			
			// 賬號.
			// 輸入文本1.
			img = new BitmapLoaderUU
			img.source = TResourceManager.getAsset("login/img/inputBox.png");
			this.fusion.addNode(img);
			img.locatingOffsetX = 40;
			img.locatingOffsetY = -93;
			img.locatingTypeForHoriz = LocatingType.F___A___F;
			img.locatingTypeForVerti = LocatingType.F___A___F;
			
			label = TextUtil.createLabel("账号：", 30,  ColorUtil.COFFEE);
			this.fusion.addNode(label);
			label.locatingOffsetX = -8;
			label.locatingOffsetY = -3;
			label.locatingTypeForHoriz = LocatingType.A_L____L;
			label.locatingTypeForVerti = LocatingType.L___A___L;
			
			_input_A = new TextInputUU(true);
			this.fusion.addNode(_input_A);
			_input_A.locatingTypeForHoriz = LocatingType.F___A___F;
			_input_A.locatingTypeForVerti = LocatingType.F___A___F;
			_input_A.locatingOffsetX = 40 + 6;
			_input_A.locatingOffsetY = -93 + 6;
			_input_A.width = 310;
			_input_A.height = 42;
			_input_A.color = 0xFFFFFF
			_input_A.size = 22
			_input_A.maxChars = 33;
			_input_A.font = "Courier New";
			_input_A.text = "AAAA";
			
			// 密碼.
			// 輸入文本2.
			img = new BitmapLoaderUU
			img.source = TResourceManager.getAsset("login/img/inputBox.png");
			this.fusion.addNode(img);
			img.locatingOffsetX = 40;
			img.locatingOffsetY = -30;
			img.locatingTypeForHoriz = LocatingType.F___A___F;
			img.locatingTypeForVerti = LocatingType.F___A___F;
			
			label = TextUtil.createLabel("密码：", 30,  ColorUtil.COFFEE);
			this.fusion.addNode(label);
			label.locatingOffsetX = -8;
			label.locatingOffsetY = -3;
			label.locatingTypeForHoriz = LocatingType.A_L____L
			label.locatingTypeForVerti = LocatingType.L___A___L;
			
			_input_B = new TextInputUU(false);
			this.fusion.addNode(_input_B);
			_input_B.locatingOffsetX = 40 + 6;
			_input_B.locatingOffsetY = -30 + 6;
			_input_B.locatingTypeForHoriz = LocatingType.F___A___F;
			_input_B.locatingTypeForVerti = LocatingType.F___A___F;
			_input_B.width = 310;
			_input_B.height = 42;
			_input_B.color = 0xFFFFFF
			_input_B.size = 22
			_input_B.maxChars = 33;
			_input_B.font = "Courier New";
			_input_B.displayAsPassword = true;
			_input_B.text = "";
			
			// 記住密碼.
			_checkBox_A = new CheckBoxUU("login_checkBox", true);
			this.fusion.addNode(_checkBox_A);
			
			label = TextUtil.createLabel("记住密码", 23,  ColorUtil.COFFEE);
			_checkBox_A.addNode(label);
			label.locatingOffsetX = 8
			label.locatingTypeForHoriz = LocatingType.L____L_A;
			label.locatingTypeForVerti = LocatingType.L___A___L;
			
			_checkBox_A.locatingOffsetX = -2
			_checkBox_A.locatingOffsetY = 25
			_checkBox_A.locatingTypeForHoriz = LocatingType.F___A___F
			_checkBox_A.locatingTypeForVerti = LocatingType.F___A___F;
			label.bold = true;
			
			// 登入按鈕.
			btn = new ButtonUU("login_login");
			this.fusion.addNode(btn);
			btn.locatingOffsetY = 100
			btn.locatingTypeForHoriz = LocatingType.F___A___F;
			btn.locatingTypeForVerti = LocatingType.F___A___F;
			btn.addEventListener(ATouchEvent.CLICK, onLogin);
			
			this.onResize(null);
			
			this.fusion.root.addEventListener(AEvent.RESIZE, onResize);
		}
		
		override public function onExit():void{
			this.fusion.root.removeEventListener(AEvent.RESIZE, onResize);
		}
		
		
		
		private function onLogin(e:ATouchEvent):void{
			var msg:AccountLoginReq;
			
//			Global.getLog().message(this, "[account]: {0}, [password]: {1}, [remember]: {2}.", _input_A.text, _input_B.text, _checkBox_A.selected);
			
			
			msg = new AccountLoginReq;
			msg.openId = _input_A.text;
			msg.openKey = _input_B.text;
			NetManager.sendRequest(CmdType.CT_LOGIN, CmdCodeLogin.CC_ACCOUNT_LOGIN_REQ, msg);
			
			
			this.fusion.touchable = false;
		}
		
		private function onResize(e:AEvent):void{
			this.fusion.locatingTypeForHoriz = LocatingType.F___A___F;	
			this.fusion.locatingTypeForVerti = LocatingType.F___A___F;
		}
		
		
		
		
		
		
	}
}