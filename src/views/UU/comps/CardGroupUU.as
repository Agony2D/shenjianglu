package views.UU.comps
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.filters.GlowFilter;
	
	import configs.cards.CardConfigurator;
	
	import models.battle.BattleModel;
	
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.DragFusionUU;
	import org.agony2d.flashApi.FusionUU;
	import org.agony2d.flashApi.tips.UUToolTip;
	import org.agony2d.inputs.Touch;
	import org.agony2d.inputs.events.ATouchEvent;
	
	import views.UU.comps.tips.Card_TipViewStateUU;
	import views.events.CardUUEvent;
	
	
	
	
	public class CardGroupUU extends FusionUU
	{
		
		public function get enabled() : Boolean {
			return _enabled;
		}
		
		public function set enabled( b:Boolean ) : void {
			_enabled = b;
		}
		
		/**
		 * 初期化卡牌
		 */		
		public function initialize( idList:Array ) : void {
			var i:int;
			var l:int;
			
			_cardList = [];
			_idList = {};
			l = idList.length;
			while(i<l){
				this.____toCreateCard(idList[i++]);
			}
			this.____doUpdateAllPos(false);
		}
		
		/**
		 * 加入卡牌.
		 * 
		 * @param cardIdList
		 * 
		 */		
		public function addCards( cardIdList:Array ) : void {
			_readyCardId = _readyCardId.concat(cardIdList);
			
			
			if(_readyCardId.length > 0){
				_enabled = false;
				this.____doAddCard(_readyCardId.shift());
			}
			else {
				_enabled = true;
				
				// 完成事件.
				dispatchEvent(new CardUUEvent(CardUUEvent.CARD_COMPLETE));
			}
		}
		
		// 移除卡牌.
		public function removeCard( cardId:int, tween:Boolean = true ) : void {
			var index:int;
			var card:CardUU;
			
			card = _idList[cardId];
			index = _cardList.indexOf(card);
			_cardList.splice(index, 1);
			_numCards--;
			delete _cardList[cardId];
			card.kill();
			this.____doUpdateAllPos(tween);
		}
		
		
		
		private const CARD_OFFSET:int = 44;
		private const CARD_OFFSET_DURATION:Number = 0.3;
		private const CARD_SCALE:Number = 0.66;
		private const CARD_UPDATE_DURATION:Number = 0.6;
		
		
		private var _cardList:Array;
		private var _idList:Object; // id:cardUU
		private var _numCards:int;
		private var _totalRotation:int;
		private var _selectedCard:CardUU;
		private var _dragCard:DragFusionUU;
		private var _isHovered:Boolean;
		
		private var _readyCardId:Array = [];
		private var _enabled:Boolean// = true;
		
		
		
		private function ____doAddCard( cardID:int ) : void {
			var card:CardUU;
			
			card = this.____toCreateCard(cardID);
			card.x = 550
			card.y = -130;
			
			card.touchable = false;
			
			TweenLite.to(card, CARD_UPDATE_DURATION * 3, {x:0, y:-430, scaleX:1, scaleY:1, ease:Strong.easeOut, onComplete:function():void{
				TweenLite.to(card, CARD_UPDATE_DURATION, {scaleX:CARD_SCALE, scaleY:CARD_SCALE, onComplete:function():void{
					if(_readyCardId.length > 0){
						____doAddCard(_readyCardId.shift());
					}
					else {
						_enabled = true;
						
						// 完成後排放完成事件.
						dispatchEvent(new CardUUEvent(CardUUEvent.CARD_COMPLETE));
					}
					
					card.touchable = true;
				}});
				____doUpdateAllPos(true);
			}});
		}
		
		// 更新全部卡牌位置.
		private function ____doUpdateAllPos( isTween:Boolean ) : void {
			var i:int;
			var card:CardUU;
			var gapX:Number;
			var gapY:Number;
			
			if(_numCards == 0){
				return;
			}
			gapX = _numCards > 7 ? 980 / _numCards : 130;
			gapY = 22;
			if(isTween){
				while(i<_numCards){
					card = this._cardList[i];
					TweenLite.to(card, CARD_UPDATE_DURATION, {x: -((_numCards - 1) * .5) * gapX + i * gapX, y:Math.abs(i - (_numCards - 1) * .5) * gapY, overwrite:0});
					i++;
				}
			}
			else{
				while(i<_numCards){
					card = this._cardList[i];
					card.x = -((_numCards - 1) * .5) * gapX + i * gapX;
					card.y = Math.abs(i - (_numCards - 1) * .5) * gapY;
	//				card.rotation = (180 - _totalRotation) * .5 + (_totalRotation / (_numCards - 1)) * i - 90;
					i++;
				}
			}
		}
		
		// 生成卡牌.
		private function ____toCreateCard( id:int, scale:Number = NaN ) : CardUU {
			var card:CardUU;
			
			_cardList[_numCards++] = _idList[id] = card = new CardUU;
			card.setCardId(id);
			
			card.pivotX = card.width * .5;
			card.pivotY = card.height * .5;
			
			// tip.
			UUToolTip.registerTip(card, Card_TipViewStateUU).userData = card.cardId;
			
			card.scaleX = card.scaleY = isNaN(scale) ? CARD_SCALE : scale;
			
			card.addEventListener(ATouchEvent.OVER,  ____onHoverCard);
			card.addEventListener(ATouchEvent.LEAVE, ____onLeaveCard);
			card.addEventListener(ATouchEvent.PRESS, ____onSelectCard);
			
			this.addNode(card);
			
			return card;
		}
		
		private function ____onHoverCard(e:ATouchEvent):void{
			if(!_enabled || !e.touch.isReleaseState){
				return;
			}
			
			this.____doHoverCard(e.target as CardUU);
		}
		
		private function ____doHoverCard( card:CardUU ) : void {
			var index_A:int;
			var index_B:int;

			if(!_selectedCard){
				if(!_isHovered){
					
					TweenLite.killTweensOf(card, true);
					TweenLite.to(card, CARD_OFFSET_DURATION, {y:card.y - CARD_OFFSET, ease:Strong.easeOut});
					
//					card.y -= CARD_OFFSET;
					_isHovered = true;
				}
				
			}
			
			if(BattleModel.remainMp >= CardConfigurator.getCardById(card.userData as int).mana){
				BattleModel.setSelectedUiStateForHoverCard(card.cardId, BattleModel.getIdleGridIdList());
			}
			
		}
		
		private function ____onLeaveCard(e:ATouchEvent):void{
			var card:CardUU;
			
			if(!_enabled){
				return;
			}
			
			if(_isHovered && !_selectedCard){
				card = e.target as CardUU;
				
				TweenLite.killTweensOf(card, true);
				TweenLite.to(card, CARD_OFFSET_DURATION, {y:card.y + CARD_OFFSET, ease:Strong.easeOut});
				
//				card.y += CARD_OFFSET;
				_isHovered = false;
			}
			
			
			if(!_selectedCard){
//				BattleModel.updateSelectedUiState(null);
				BattleModel.setNullSelectedUiState();
			}
		}
		
		private function ____onSelectCard(e:ATouchEvent):void{
			var card:CardUU;
			
			if(!_enabled){
				return;
			}
			
			e.touch.addEventListener(AEvent.COMPLETE, ____onTouchComplete, 100000);
			
			_selectedCard = e.target as CardUU;
			_selectedCard.filters = [new GlowFilter(0x33dd33, 0.88, 33, 33)];
			
			
			
			_dragCard = new DragFusionUU;
			card = new CardUU;
			card.setCardId(int(_selectedCard.userData));
			card.scaleX = card.scaleY = CARD_SCALE;
			_dragCard.addNode(card);
			_dragCard.alpha = 0.44;
			
			_dragCard.touchable = false;
			this.addNode(_dragCard);
			_dragCard.startDrag(e.touch, null,  0, -card.spaceHeight / 2 + 33, true);
			
		}
		
		
		// 觸摸彈起.
		private function ____onTouchComplete(e:AEvent):void{
//			trace("滑鼠彈起.");
			var touch:Touch;
			
			
			touch = e.target as Touch;
			
			if(touch.oldHoveringNode == touch.bindingNode){
				this.____doHoverCard(_selectedCard);
			}
			else {
				if(touch.oldHoveringNode && (touch.oldHoveringNode.userData)){
					var evt:CardUUEvent;
					
					evt = new CardUUEvent(CardUUEvent.CARD_DROP);
					evt.userData = touch.oldHoveringNode.userData;
					evt.cardId = _selectedCard.userData as int;
					this.dispatchEvent(evt);
					//trace(touch.hoveringNode.userData);
				}
				
				if(_isHovered){
					TweenLite.killTweensOf(_selectedCard, true);
					TweenLite.to(_selectedCard, CARD_OFFSET_DURATION, {y:_selectedCard.y + CARD_OFFSET, ease:Strong.easeOut});
					
					_isHovered = false;
				}
//				BattleModel.updateSelectedUiState(null);
				BattleModel.setNullSelectedUiState();

			}
			
			_dragCard.kill();
			_dragCard = null;
			
			_selectedCard.filters = null;
			_selectedCard = null;
		}
	}
}