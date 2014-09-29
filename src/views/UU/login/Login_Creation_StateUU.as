package views.UU.login
{
	import net.NetManager;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.ButtonUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.RadioGroupUU;
	import org.agony2d.flashApi.RadioUU;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.flashApi.TextInputUU;
	import org.agony2d.inputs.events.ATouchEvent;
	import org.agony2d.resources.TResourceManager;
	import org.agony2d.utils.ColorUtil;
	
	import proto.cs.CmdCodeRole;
	import proto.cs.CmdType;
	import proto.cs.CreateRoleReq;
	import proto.cs.RoleGender;
	
	import utils.TextUtil;

	public class Login_Creation_StateUU extends StateUU
	{
		public function Login_Creation_StateUU()
		{
		}
		
		override public function onEnter() : void {
			var btn:ButtonUU;
			var img:BitmapLoaderUU;
			var radio:RadioUU;
			var label:LabelUU;
			
			this.fusion.spaceWidth = this.fusion.root.spaceWidth;
			this.fusion.spaceHeight = this.fusion.root.spaceHeight;
			
			// 上部背景.
			_bg_A = new BitmapLoaderUU;
			_bg_A.source = TResourceManager.getAsset("creation/img/bg_up.png");
			this.fusion.addNode(_bg_A);
			_bg_A.height = 100;
			
			// 下部背景.
			_bg_B = new BitmapLoaderUU;
			_bg_B.source = TResourceManager.getAsset("creation/img/bg_down.png");
			this.fusion.addNode(_bg_B);
			_bg_B.height = 100;
			
			// logo.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("creation/img/bg_sex.png");
			this.fusion.addNode(img);
			img.locatingTypeForHoriz = LocatingType.F___A___F;
			
			// 選擇sex.
			_radioGroup = new RadioGroupUU;
			
			// 角色男
			radio = new RadioUU
			radio.skinName = "creation_sex";
			radio.group = _radioGroup;
			this.fusion.addNode(radio);
			radio.locatingTypeForHoriz = LocatingType.L_A____L;
			radio.locatingOffsetX = 47
			radio.y = 155;
			radio.userData = RoleGender.RG_MALE;
			
			label = TextUtil.createLabel("男", 30,  ColorUtil.COFFEE);
			radio.addNode(label);
			label.locatingOffsetX = -3;
			label.locatingOffsetY = -3;
			label.locatingTypeForHoriz = LocatingType.F___A___F;
			label.locatingTypeForVerti = LocatingType.F___A___F;
			
			
			// 角色女.
			radio = new RadioUU
			radio.skinName = "creation_sex";
			radio.group = _radioGroup;
			this.fusion.addNode(radio);
			radio.locatingNode = img;
			radio.image.scaleX = -1;
			radio.image.x = radio.image.width;
			radio.locatingTypeForHoriz = LocatingType.L____A_L;
			radio.locatingOffsetX = -52;
			radio.y = 155;
			radio.userData = RoleGender.RG_FEMALE;
			
			label = TextUtil.createLabel("女", 30,  ColorUtil.COFFEE);
			radio.addNode(label);
			label.locatingOffsetX = 6;
			label.locatingOffsetY = -3;
			label.locatingTypeForHoriz = LocatingType.F___A___F;
			label.locatingTypeForVerti = LocatingType.F___A___F;
			
			_radioGroup.selectedIndex = 0;
			
			// 暱稱bg.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("creation/img/aka_input.png");
			this.fusion.addNode(img);
			img.locatingTypeForHoriz = LocatingType.F___A___F;
			img.locatingTypeForVerti = LocatingType.F____A_F;
			img.locatingOffsetX = 30
			img.locatingOffsetY = -270;
			
			// 暱稱label
			label = TextUtil.createLabel("昵称：", 30,  ColorUtil.SILVER);
			this.fusion.addNode(label);
			label.locatingTypeForHoriz = LocatingType.A_L____L
			label.locatingTypeForVerti = LocatingType.L___A___L;
			label.locatingOffsetX = 6;
			label.locatingOffsetY = -3;
			
			// 暱稱input.
			_input_B = new TextInputUU(true);
			this.fusion.addNode(_input_B);
			_input_B.locatingNode = img;
			_input_B.locatingTypeForHoriz = LocatingType.L_A____L
			_input_B.locatingTypeForVerti = LocatingType.L___A___L;
			_input_B.locatingOffsetX = 6;
			_input_B.locatingOffsetY = 6;
			_input_B.width = 310;
			_input_B.height = 42;
			_input_B.color = 0xFFFFFF
			_input_B.size = 22
			_input_B.maxChars = 15;
			_input_B.font = "Courier New";
			_input_B.text = "";
			
			// 隨機名骰子.
			btn = new ButtonUU("creation_dice");
			this.fusion.addNode(btn);
			btn.locatingNode = img;
			btn.locatingTypeForHoriz = LocatingType.L____A_L;
			btn.locatingTypeForVerti = LocatingType.L___A___L;
//			btn.locatingY = -3;
			
			// 開始遊戲.
			btn = new ButtonUU("login_login");
			this.fusion.addNode(btn);
			btn.locatingOffsetY = -150
			btn.locatingTypeForHoriz = LocatingType.F___A___F;
			btn.locatingTypeForVerti = LocatingType.F____A_F;
			btn.addEventListener(ATouchEvent.CLICK, onStartGame);
			
			
			this.onResize(null);
			
			this.fusion.root.addEventListener(AEvent.RESIZE, onResize);
		}
		
		override public function onExit():void{
			this.fusion.root.removeEventListener(AEvent.RESIZE, onResize);
			
			
		}
		
		
		
		private var _bg_A:BitmapLoaderUU;
		private var _bg_B:BitmapLoaderUU;
		private var _input_B:TextInputUU;
		private var _radioGroup:RadioGroupUU;
		
		
		private function onResize(e:AEvent):void{
			_bg_A.scaleX = _bg_B.scaleX = this.fusion.root.spaceWidth;
			_bg_B.y = this.fusion.root.spaceHeight - 100;
		}
		
		private function onStartGame(e:ATouchEvent):void{
			if(_input_B.text == ""){
				return;
			}
			
			var msg:CreateRoleReq;
			
			msg = new CreateRoleReq;
			msg.name = _input_B.text;
			msg.gender = uint(_radioGroup.selectedUserData);
			msg.icon = "";
			NetManager.sendRequest(CmdType.CT_ROLE, CmdCodeRole.CC_ROLE_CREATE_REQ, msg);
			
			
			this.fusion.touchable = false;
		}
		
	}
}