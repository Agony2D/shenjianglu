package views.UU.comps.cardStates
{
	import configs.ConfigTxt;
	import configs.cards.CardConfigurator;
	import configs.cards.CharacterCardCfg;
	import configs.cards.EquipmentCardCfg;
	import configs.skills.SkillCfg;
	
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.resources.TResourceManager;
	
	import utils.TextUtil;
	
	import views.UU.comps.CardUU;

	public class EquipmentCard_StateUU extends StateUU
	{
		
		override public function onEnter():void 
		{
			var img:BitmapLoaderUU;
			var i:int;
			var label:LabelUU;
			var cardVo:EquipmentCardCfg;
			var hasDesc:Boolean;
			
			// roleVo.
			cardVo = this.stateArgs[0];
			// has desc.
			hasDesc = true;//this.stateArgs[1];
			
			var name:String = cardVo.name;
			var magic:int = cardVo.mana;
			var imageURL:String = "assets/temp/cards/magic_equip/" + cardVo.imageURL + ".png"
			
			
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
			
			// 沒有文本描述...
			if(!hasDesc){
				return;
			}
			
			// 下部外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_desc_A.png");
			this.fusion.addNode(img);
			img.y = 230;
			
			// 下部描述外框.
			img = new BitmapLoaderUU;
			img.source = TResourceManager.getAsset("card/img/frame_desc_B.png");
			this.fusion.addNode(img);
			img.x = 16;
			img.y = 246;
			
			var pos_A:Number;
			var pos_B:Number;
			
			pos_A = 16;
			pos_B = 248;
			
			// 技能A描述
			label = TextUtil.createLabel4(cardVo.desc, 16, 0x0, ConfigTxt.CARD_DESC_SIZE);
			this.fusion.addNode(label);
			label.x = pos_A + 11;
			label.y = pos_B + 22;
		}
		
	}
}