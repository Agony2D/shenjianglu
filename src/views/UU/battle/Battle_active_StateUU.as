package views.UU.battle
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Strong;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import configs.ConfigBattle;
	import configs.ConfigRes;
	import configs.battle.BattleConfigurator;
	import configs.skills.SkillConfigurator;
	
	import models.GameModel;
	import models.battle.BattleModel;
	import models.battle.CharacterVo;
	import models.battle.MapModel;
	import models.battle.actions.BattleAction;
	import models.battle.actions.DebutAction;
	import models.battle.actions.MovementAction;
	import models.battle.actions.SkillAction;
	import models.events.ActionEvent;
	import models.events.CharacterEvent;
	import models.events.ControlEvent;
	import models.events.NullSelectedUiEvent;
	import models.events.RoundEvent;
	import models.events.SelectedUiMovementEvent;
	
	import org.agony2d.base.AdvanceManager;
	import org.agony2d.base.events.TickEvent;
	import org.agony2d.events.AEvent;
	import org.agony2d.flashApi.AnimatorUU;
	import org.agony2d.flashApi.BitmapLoaderUU;
	import org.agony2d.flashApi.FusionUU;
	import org.agony2d.flashApi.ImageLoaderUU;
	import org.agony2d.flashApi.LabelUU;
	import org.agony2d.flashApi.LocatingType;
	import org.agony2d.flashApi.StateFusionUU;
	import org.agony2d.flashApi.StateUU;
	import org.agony2d.flashApi.core.NodeUU;
	import org.agony2d.flashApi.tips.UUToolTip;
	
	import proto.cs.ChessPos;
	
	import utils.TextUtil;
	
	import views.UU.comps.CharacterUU;
	import views.UU.comps.skillStates.CommonAttack_Skill_StateUU;
	import views.UU.comps.tips.Character_TipEffectStateUU;
	
public class Battle_active_StateUU extends StateUU {
	
	override public function onEnter():void
	{
		var img:BitmapLoaderUU;
		var pos:Point;
		
		_gameObjectList = new <NodeUU>[];
		_vo2ViewList = new Dictionary;
		
		this.fusion.spaceWidth = BattleModel.gridWidth;
		this.fusion.spaceHeight = BattleModel.gridHeight;
		this.fusion.locatingOffsetY = -70;
		
		// 遊戲對象圖層.
		_objectFusion = new FusionUU;
		this.fusion.addNode(_objectFusion);
		
		// 天元.
		pos = BattleConfigurator.gridToPos(13);
		this.____doAddTianyuan(pos.x, pos.y);
		
		// 特效圖層.
		_effectFusion = new StateFusionUU;
		this.fusion.addNode(_effectFusion);
		
		// 技能狀態列表.
		if(!_skillStateList){
			_skillStateList = {};
			_skillStateList[50000] = CommonAttack_Skill_StateUU;
			
			
		}
		
		this.fusion.root.addEventListener(AEvent.RESIZE, onResize);
		this.onResize(null);
		
		
		
		BattleModel.addEventListener(CharacterEvent.UPDATE_VALUES,       onUpdateValues);
		BattleModel.addEventListener(CharacterEvent.INTERACTION_CHANGED, onInteractionChanged);
		BattleModel.addEventListener(CharacterEvent.KILL_CHARACTER,      onKillCharacter);
		BattleModel.addEventListener(ActionEvent.NEXT_ACTION,            onNextAction);
		BattleModel.addEventListener(RoundEvent.ROUND_END,               onRoundEnd);
		
		BattleModel.addEventListener(SelectedUiMovementEvent.MOVEMENT,    onSelectedUiMovement);
		BattleModel.addEventListener(NullSelectedUiEvent.NULL_SELECTED,   onNullSelectedUi);
		BattleModel.addEventListener(ControlEvent.CONTROL_CHANGE, onControlChanged);
		
		
		
		// 不斷監測人物"z軸"更新.
		AdvanceManager.addEventListener(TickEvent.ENTER_FRAME, ____onUpdateObjectLayer);
	}
	
	override public function onExit():void {
		this.fusion.root.removeEventListener(AEvent.RESIZE, onResize);
		AdvanceManager.removeEventListener(TickEvent.ENTER_FRAME, ____onUpdateObjectLayer);
	}
	
	
	
	//////////////////////////////////////////
	// Useful
	//////////////////////////////////////////

	/**
	 * vo => 人物UU
	 * 
	 * @param vo
	 * @return 
	 * 
	 */	
	public function getView( vo:CharacterVo ) : CharacterUU {
		return _vo2ViewList[vo];
	}
	
	
	/**
	 * 顯示失去的hp. 
	 */	
	public function showLostHp( v:int, coordX:Number, coordY:Number ) : void {
		var hpView:LabelUU;
		
		hpView = TextUtil.createLabel(v, 33, 0xFF0000,true,1,6,22);
		hpView.x = coordX;
		coordY -= 44;
		hpView.y = coordY;
		this.fusion.addNode(hpView);
		TweenLite.to(hpView, ConfigBattle.LOST_HP_OFFSET_DURATION, {y:coordY - 44, ease:Bounce.easeOut});
		TweenLite.to(hpView, ConfigBattle.LOST_HP_ALPHA_DURATION, {delay:ConfigBattle.LOST_HP_OFFSET_DURATION - 0.2, alpha:0.03, overwrite:0, onComplete:function():void{
			hpView.kill();
		}});
		
	}
		
	
	
	
	private static var _skillStateList:Object;
	
	private var _tianyan:AnimatorUU;
	
	private var _gameObjectList:Vector.<NodeUU>;
	private var _numGameObjects:int;
	
	private var _vo2ViewList:Dictionary;
	
	private var _objectFusion:FusionUU;
	private var _effectFusion:StateFusionUU;
	
	
	private var _currAction:BattleAction;
	private var _currPath:Array;
	
	
	
	
	private function onNextAction( e:ActionEvent ) : void {
		var vo:CharacterVo;
		var obj:CharacterUU;
		var debutAction:DebutAction;
		var movementAction:MovementAction;
		
		_currAction = e.action;
		
		// 登場.
		if(_currAction is DebutAction){
			debutAction = _currAction as DebutAction;
			vo = debutAction.vo;
			obj = this.____toAddCharacter(vo, debutAction.pos.x, debutAction.pos.y);
			
			// 判斷角色朝向.
			obj.idle(BattleModel.getIdleDirection(vo.role_id));
		}
		
		// 移動.
		else if(_currAction is MovementAction) {
			movementAction = _currAction as MovementAction;
			_currPath = movementAction.movePath;
			this.____doMoveCharacter(movementAction.vo);
		}
		
		// 技能.
		else if(_currAction is SkillAction){
			this.____doFireSkill(_currAction as SkillAction);
		}
	}
	
	/**
	 * 加入人物.
	 */	
	public function ____toAddCharacter( vo:CharacterVo, posX:int, posY:int ) : CharacterUU {
		var character:CharacterUU
		var coord:Point;
		
		character = new CharacterUU(vo)
		coord = BattleConfigurator.getCoordByPos(posX, posY);
		character.x = coord.x;
		character.y = coord.y;
		this._objectFusion.addNode(character);
		_gameObjectList[_numGameObjects++] = _vo2ViewList[vo] = character;
		
		TweenLite.from(character, 1.0, {alpha:0.3, onComplete:function() : void {
			_currAction.next();
		}});
		
		
		// tip.
		//UUToolTip.registerTip(character, Character_TipEffectStateUU).userData = vo.card_id;
		
		return character;
	}
	
	// 加入天元.
	private function ____doAddTianyuan( posX:int, posY:int ) : void {
		var coord:Point;
		
		_tianyan = new AnimatorUU;
		_tianyan.play("common.eight", "atlas/tianyuan", 0);
		coord = BattleConfigurator.getCoordByPos(posX, posY);
		_tianyan.pivotX = ConfigRes.FRAME_SIZE * .5;
		_tianyan.pivotY = ConfigRes.FRAME_SIZE * .5 + 22;
		_tianyan.x = coord.x;
		_tianyan.y = coord.y;
		_tianyan.touchable = false;
		this._objectFusion.addNode(_tianyan);
		_gameObjectList[_numGameObjects++] = _tianyan;
	}

	// 移動人物.
	public function ____doMoveCharacter( vo:CharacterVo ) : void {
		var pos:ChessPos;

		pos = _currPath.shift();
		this.____doMoveToPos(pos, _vo2ViewList[vo]);
	}
	
	private function ____doMoveToPos( oldPos:ChessPos, view:CharacterUU ) : void {
		var coord:Point;
		var pos:ChessPos;
		
		
		// 當前行列.
		pos = _currPath.shift()
		coord = BattleConfigurator.getCoordByGridId(BattleConfigurator.posToGrid2(pos));
		
		view.run(MapModel.getDirection3(oldPos, pos));
		
		TweenLite.to(view, 0.66, {x:coord.x, y:coord.y, onComplete:function():void {
			if(_currPath.length > 0){
				____doMoveToPos(pos, view);
			}
			else {
				view.idleNormal(view.vo.role_id);
				
				// 移動後自動攻擊.
				if(MapModel.cachedAssaultGridId > 0){
					_currAction.next(true);
					BattleModel.commonAttack();
				}
				else {
					_currAction.next();
				}
			}
		}});
		
	}
	
	private function ____doFireSkill( v:SkillAction ) : void {
		var skillStateRef:Class;
		
		if(v.ret != 0){
			GameModel.getLog().warning(this, "____doFireSkill", "技能釋放失敗.");
			v.next();
			return;
		}
		skillStateRef = _skillStateList[v.skillId];
		if(!skillStateRef){
			GameModel.getLog().simplify("技能( {0}: {1} )尚未製作完成.", v.skillId, SkillConfigurator.getSkillById(v.skillId).name);
			v.next();
		}
		// 釋放技能執行.
		else {
			_effectFusion.setState(skillStateRef, [v, this]);
		}
	}
	
	private function onResize(e:AEvent):void{
		this.fusion.locatingTypeForHoriz = LocatingType.F___A___F;
		this.fusion.locatingTypeForVerti = LocatingType.F___A___F;
		
		
	}
	
	private function onUpdateValues(e:CharacterEvent):void{
		var view:CharacterUU;
		
		view = _vo2ViewList[e.vo];
		view.updateValues();
	}
	
	private function onInteractionChanged(e:CharacterEvent):void{
		var view:CharacterUU;
		
		view = _vo2ViewList[e.vo];
		view.changeViewByOperationFlag();
	}
	
	private function onKillCharacter(e:CharacterEvent):void{
		var view:CharacterUU;
		
		view = _vo2ViewList[e.vo];
		_gameObjectList.splice(_gameObjectList.indexOf(view), 1);
		_numGameObjects--;
		
		delete _vo2ViewList[e.vo];
		TweenLite.to(view, ConfigBattle.LOST_HP_OFFSET_DURATION / 2, {alpha:0.1, onComplete:function():void {
			view.kill();
		}});
	}
	
	private function ____onUpdateObjectLayer(e:TickEvent):void{
		
	}
	
	private function onRoundEnd( e:RoundEvent ):void{
		var view:CharacterUU;
		var voList:Vector.<CharacterVo>;
		var i:int;
		var l:int;
		
		voList = BattleModel.cachedRoundEndHpResetVoList;
		l = voList.length;
		while(i<l){
			view = _vo2ViewList[voList[i++]];
			view.updateValues();
		}
	}
	
	
	
	
	// 選擇可控制人物.
	private static var cachedAssaultableGridIdList:Vector.<int>;
	private function onSelectedUiMovement(e:SelectedUiMovementEvent):void{
		var img:ImageLoaderUU;
		var i:int;
		var l:int;
		var coord:Point;
		var gridId:int;
		var gridIdList:Vector.<int>;
		var vo:CharacterVo;
		
		// 產生可被攻擊圖示.
		cachedAssaultableGridIdList = e.assaultableGridIdList;
		l = cachedAssaultableGridIdList.length;
		while(i<l){
			vo = BattleModel.getVoByGridId(cachedAssaultableGridIdList[i++]);
			vo.setInteractionFlag(CharacterVo.ASSAULT);
		}
		
	}
	
	// Null選擇.
	private function onNullSelectedUi(e:NullSelectedUiEvent):void{
		var i:int;
		var l:int;
		var coord:Point;
		var gridId:int;
		var gridIdList:Vector.<int>;
		var vo:CharacterVo;
		
		// 可被攻擊圖示.
		if(cachedAssaultableGridIdList){
			l = cachedAssaultableGridIdList.length;
			while(i<l){
				vo = BattleModel.getVoByGridId(cachedAssaultableGridIdList[i++]);
				vo.setInteractionFlag(CharacterVo.NONE);
			}
			
			
			cachedAssaultableGridIdList = null;
		}
	}
	
	
	private function onControlChanged(e:ControlEvent):void{
		this.fusion.touchable = e.isControlable;
	}
}
}