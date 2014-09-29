package views.UU.battle
{
	import flash.geom.Point;
	
	import configs.battle.BattleConfigurator;
	import configs.battle.GridCfg;
	import configs.cards.CardConfigurator;
	import configs.cards.CharacterCardCfg;
	
	import models.GameModel;
	import models.battle.BattleModel;
	import models.battle.CharacterVo;
	import models.events.ControlEvent;
	import models.events.RoundEvent;
	import models.player.PlayerModel;
	
	import net.NetManager;
	
	import org.agony2d.Agony;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.AnimatorUU;
	import org.agony2d.flashApi.ButtonUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.flashApi.UUFacade;
	import org.agony2d.inputs.events.ATouchEvent;
	
	import proto.cs.ChessPos;
	import proto.cs.CmdCodeBattle;
	import proto.cs.CmdType;
	import proto.cs.PlayCardReq;
	
	import utils.TextUtil;
	
	import views.UU.comps.CardGroupUU;
	import views.UU.comps.CardUU;
	import views.events.CardUUEvent;
	
	
	// 卡牌的顯示都在這層.
	public class Battle_active_post_StateUU extends StateUU
	{
		
		
		override public function onEnter():void {
			this.fusion.spaceWidth = Agony.getAdapter().rootWidth;
			this.fusion.spaceHeight = Agony.getAdapter().rootHeight;
			
			
			// 回合結束按鈕.
			_roundOkBtn = new ButtonUU;
			_roundOkBtn.skinName = "battle_roundOk";
			this.fusion.addNode(_roundOkBtn);
			
			_roundOkBtn.x = 1200;
			_roundOkBtn.y = 330;
			
			_roundLabel = TextUtil.createLabel("回合结束", 22, 0xddddaa, false);
			_roundOkBtn.addNode(_roundLabel);
			_roundLabel.x = 22;
			_roundLabel.y = 16;
//			_roundOkBtn.getLabel().locatingOffsetX = -15;
//			_roundOkBtn.getLabel().locatingOffsetY = -11;
			_roundOkBtn.addEventListener(ATouchEvent.CLICK, ____onRoundOkClick);
			_roundOkBtn.alpha = 0.3;
			_roundOkBtn.touchable = false;
			

			
			BattleModel.addEventListener(RoundEvent.ROUND_BEGIN, onRoundBegin);
			BattleModel.addEventListener(RoundEvent.ROUND_END,   onRoundEnd);
			BattleModel.addEventListener(ControlEvent.CONTROL_CHANGE, onControlChanged);
			
			
			
			this.fusion.root.addEventListener(AEvent.RESIZE, onResize);
			this.onResize(null);
			
			
			
			
			
			
//			_cardGroup = new CardGroupUU;
//			_cardGroup.initialize(BattleModel.initCards);
//			this.fusion.addNode(_cardGroup);
//			_cardGroup.x = this.fusion.spaceWidth * .5;
//			_cardGroup.y = 530;
//			
//			var card:CardUU;
//			card = new CardUU
//			card.setCardId(10002);
//			
//			this.fusion.addNode(card);
//			card.x = 400;
//			card.y = 100;
			
			
			
//			this.____onBattleStart(null);
//			this.____onCardComplete(null);
		}
		
		override public function onExit():void {
			this.fusion.root.removeEventListener(AEvent.RESIZE, onResize);
			
		}
		
		
		
		private var _roundOkBtn:ButtonUU;
		private var _roundOkAnimator:AnimatorUU;
		
		private var _roundLabel:LabelUU;
		private var _cardGroup:CardGroupUU;
		
		
		private function onResize(e:AEvent):void{
			this.fusion.locatingTypeForHoriz = LocatingType.F___A___F;
			this.fusion.locatingTypeForVerti = LocatingType.F___A___F;
			
			
		}
		
		private function onRoundBegin(e:RoundEvent):void{
			// 初期化卡牌，最開始.
			if(!this._cardGroup){
				this.____doAddCardGroup();
				// 關閉準備視窗.
				UUFacade.getRoot().getWindow(Battle_ready_StateUU).close();
			}
			
			// 不是自己的回合，跳過.
			if(!PlayerModel.isMyRole(e.roleId)){
				return;
			}
			
			GameModel.getLog().simplify("自己的回合開始: [ {0} ].", e.cardIdList);
			
			_cardGroup.addCards(e.cardIdList);
		}
		
		private function onRoundEnd(e:RoundEvent):void{
			// 不是自己的回合，跳過.
			if(!PlayerModel.isMyRole(e.roleId)){
				return;
			}
			
			// 超過一定時限，服務器會主動push.
			this.____doCheckRoundOver();
		}
		
		private function onControlChanged(e:ControlEvent):void{
			_cardGroup.touchable = e.isControlable;
		}
		
		private function ____onRoundOkClick(e:ATouchEvent):void{
			this.____doCheckRoundOver();
			
			// 等待隊列結束才能向服務器申請.
			BattleModel.requestRoundOver();
		}
		
		private function ____doCheckRoundOver(): void{
			if(!_roundOkAnimator){
				return;
			}
			_roundOkBtn.alpha = 0.3;
			_roundOkBtn.touchable = false;
			if(_roundOkAnimator){
				_roundOkAnimator.kill()
				_roundOkAnimator = null;
			}
			
			_cardGroup.enabled = false;
		}
		
		private function ____doAddCardGroup() : void {
			// 底部卡牌.
			_cardGroup = new CardGroupUU;
			_cardGroup.initialize(BattleModel.initCards);
			this.fusion.addNode(_cardGroup);
			_cardGroup.x = this.fusion.spaceWidth * .5;
			_cardGroup.y = 860;
			_cardGroup.addEventListener(CardUUEvent.CARD_COMPLETE, ____onCardComplete);
			_cardGroup.addEventListener(CardUUEvent.CARD_DROP,     ____onCardDrop);
		}
		
		private function ____onCardComplete(e:CardUUEvent):void{
//			if(_roundOkAnimator){
//				GameModel.getLog().error(this, "____onCardComplete", "回合事件錯誤.");
//			}
			
			// 回合結束按鈕開啟.
			_roundOkBtn.alpha = 1.0;
			_roundOkBtn.touchable = true;
			
			_roundOkAnimator = new AnimatorUU;
			_roundOkBtn.addNode(_roundOkAnimator);
			_roundOkAnimator.play("common.eight", "atlas/roundOk", 0);
			_roundOkAnimator.x = -49;
			_roundOkAnimator.y = -113;
			_roundOkAnimator.touchable = false;
			
			// 如果此時觸摸正在牌上.
		}
		
		private function ____onCardDrop(e:CardUUEvent):void{
			var gridCfg:GridCfg;
			var cardId:int;
			var cardCfg:*;
			
			gridCfg = e.userData as GridCfg;
			cardId = e.cardId;
			cardCfg = CardConfigurator.getCardById(cardId);
			if(cardCfg is CharacterCardCfg){
				var msg:PlayCardReq;
				
				
				msg = new PlayCardReq;
				msg.cardId = cardId;
				var chessPos:ChessPos = new ChessPos;
				var pos:Point = BattleConfigurator.gridToPos(gridCfg.id);
				chessPos.x = pos.x;
				chessPos.y = pos.y;
				msg.chessPos = chessPos;
				NetManager.sendRequest2(CmdType.CT_BATTLE, CmdCodeBattle.CC_PALY_CARD_REQ, msg);
				
				
				
				// 人物登場動作進行時，暫不可操控其他.
				BattleModel.dispatchMyControlChanged(false);
			}
			
			
			
			_cardGroup.removeCard(cardId);
			
		}
		
	}
}