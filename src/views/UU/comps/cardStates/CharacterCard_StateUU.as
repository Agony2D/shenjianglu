package views.UU.comps.cardStates
{
	import configs.ConfigTxt;
	import configs.cards.CardConfigurator;
	import configs.cards.CharacterCardCfg;
	import configs.skills.SkillCfg;
	
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.resources.TResourceManager;
	
	import utils.TextUtil;
	
	import views.UU.comps.CardUU;
	
	public class CharacterCard_StateUU extends StateUU
	{
		
		
		override public function onEnter():void 
		{
			var img:BitmapLoaderUU;
			var i:int;
			var label:LabelUU;
			var cardVo:CharacterCardCfg;
			var hasDesc:Boolean;
			var skillVo:SkillCfg;
			
			// roleVo.
			cardVo = this.stateArgs[0];
			// has desc.
			hasDesc = true;//this.stateArgs[1];
			
			var name:String = cardVo.name;
			var magic:int = cardVo.mana;
			var attack:int = cardVo.attack;
			var life:int = cardVo.hp;
			var movement:int = cardVo.movement;
			var imageURL:String = "assets/temp/cards/role/" + cardVo.imageURL + ".png"
			
				
			// 上部外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_upper_zhou.png");
			this.fusion.addNode(img);
			
			// 人物圖片.
			img = new BitmapLoaderUU;
			img.source = imageURL;
			img.x = 5;
			img.y = 30;
			this.fusion.addNode(img);
			img.scaleX = 1.26;
			img.scaleY = 1.35
			
			// 人物名字.
			label = TextUtil.createLabel2(name, 22, 0xFFFFFF, 5);
			this.fusion.addNode(label);
//			label.locatingTypeForHoriz = LocatingType.F___A___F;
//			label.locatingOffsetX = 20;
			label.x = CardUU.CARD_NAME_OFFSET;
			
			// 頂部魔耗數字外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_magic.png");
			this.fusion.addNode(img);
			img.x = -3;
			img.y = -14
			
			// 魔耗數字.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset(CardConfigurator.getMagicNumAssetId(magic));
			this.fusion.addNode(img);
			img.x = 14;
			img.y = 2;
			
			// 攻擊外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_life.png");
			this.fusion.addNode(img);
			img.y = 56;
			
			// 攻擊圖標.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/attack.png");
			this.fusion.addNode(img);
			img.x = 10;
			img.y = 56 + 11;
			
			// 攻擊文本.
			label = TextUtil.createLabel(String(attack), 28, 0xFFFFFF);
			this.fusion.addNode(label);
			label.x = 44;
			label.y = 56 + 7;
			
			// 生命外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_life.png");
			this.fusion.addNode(img);
			img.y = 114;
			
			// 生命圖標.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/life.png");
			this.fusion.addNode(img);
			img.x = 14;
			img.y = 114 + 13;
			
			// 生命文本.
			label = TextUtil.createLabel(String(life), 28, 0xFFFFFF);
			this.fusion.addNode(label);
			label.x = 44;
			label.y = 114 + 7;
			
			// 移動力外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_life.png");
			this.fusion.addNode(img);
			img.y = 173;
			
			// 移動力圖標.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/movement.png");
			this.fusion.addNode(img);
			img.x = 10;
			img.y = 173 + 12;
			
			// 移動力文本.
			label = TextUtil.createLabel(String(movement), 28, 0xFFFFFF);
			this.fusion.addNode(label);
			label.x = 44;
			label.y = 173 + 7;
			
			// 沒有文本描述...
			if(!hasDesc){
				return;
			}
			
			// 下部外框.
 			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_desc_A.png");
			this.fusion.addNode(img);
			img.y = 230;
			
//			this.fusion.spaceWidth = this.fusion.width;
//			this.fusion.spaceHeight = this.fusion.height;
			
			// 下部描述外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_desc_B.png");
			this.fusion.addNode(img);
			img.x = 16;
			img.y = 246;
			
			var pos_A:Number;
			var pos_B:Number;
			
			if(cardVo.skill1 > 0){
				pos_A = 16;
				pos_B = 248;
				
				skillVo = cardVo.getSkill1();
				
				// 技能A名字
				label = TextUtil.createLabel(skillVo.name, 16, 0xdddd33, true, 3, 3.5, 22);
				this.fusion.addNode(label);
				label.x = pos_A + 19;
				label.y = pos_B + 3;
				
				// 主動or自動.
				img = new BitmapLoaderUU;
				img.x = pos_A + 177;
				img.y = pos_B + 13;
				this.fusion.addNode(img);
				label = TextUtil.createLabel(skillVo.name, 14, 0xffffff, false, 2, 3.5, 22);
				label.x = pos_A + 183;
				label.y = pos_B + 3;
				
				this.fusion.addNode(label);
				if(skillVo.howRun == 1){
					img.source = TResourceManager.getAsset("card/img/frame_active.png");
					label.text = "主动";
				}
				else if(skillVo.howRun == 2){
					img.source = TResourceManager.getAsset("card/img/frame_passive.png");
					label.text = "自动";
				}
				
				// 技能A描述
				label = TextUtil.createLabel4(skillVo.desc, 14, 0x0, ConfigTxt.CARD_DESC_SIZE);
				this.fusion.addNode(label);
				label.x = pos_A + 8;
				label.y = pos_B + 22;
			}
			else {
				return;
			}
			if(cardVo.skill2 > 0){
				pos_A = 16;
				pos_B = 311;
				
				skillVo = cardVo.getSkill2();
				
				// 技能A名字
				label = TextUtil.createLabel(skillVo.name, 16, 0xdddd33, true, 3, 3.5, 22);
				this.fusion.addNode(label);
				label.x = pos_A + 19;
				label.y = pos_B + 3;
				
				// 主動or自動.
				img = new BitmapLoaderUU;
				img.x = pos_A + 177;
				img.y = pos_B + 13;
				this.fusion.addNode(img);
				label = TextUtil.createLabel(skillVo.name, 14, 0xffffff, false, 2, 3.5, 22);
				label.x = pos_A + 183;
				label.y = pos_B + 3;
				
				this.fusion.addNode(label);
				if(skillVo.howRun == 1){
					img.source = TResourceManager.getAsset("card/img/frame_active.png");
					label.text = "主动";
				}
				else if(skillVo.howRun == 2){
					img.source = TResourceManager.getAsset("card/img/frame_passive.png");
					label.text = "自动";
				}
				
				// 技能A描述
				label = TextUtil.createLabel4(skillVo.desc, 14, 0x0, ConfigTxt.CARD_DESC_SIZE);
				this.fusion.addNode(label);
				label.x = pos_A + 11;
				label.y = pos_B + 22;
			}
		}
		
		
	}
}