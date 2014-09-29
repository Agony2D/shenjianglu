package views.UU.comps.skillStates
{
	import models.battle.BattleModel;
	import models.battle.MapModel;
	
	import proto.cs.BattleEffect;
	
	import views.UU.comps.CharacterUU;
	
	// 普通攻擊.
public class CommonAttack_Skill_StateUU extends Abstract_Skill_StateUU
{
	
	override public function onEnter():void{
		super.onEnter();
		
		_fromView = this.stateForBattleActive.getView(this.skillAction.fromVo);
		_toView = this.stateForBattleActive.getView(this.skillAction.targetVo);
		_Effect1 = this.skillAction.effects[0];
		_Effect2 = this.skillAction.effects[1];
		
		
		// 攻擊.
		this.____doAttack();
		
	}
	
	
	
	private var _fromView:CharacterUU;
	private var _toView:CharacterUU;
	
	private var _Effect1:BattleEffect;
	private var _Effect2:BattleEffect;
	
	
	
	private function ____doAttack() : void {
		_fromView.attack(MapModel.getDirection2(_fromView.vo.pos, _toView.vo.pos), 1, onAttack);
	}
	
	private function onAttack() : void {
		// 攻擊後恢復idle.
		_fromView.idleNormal(_fromView.vo.role_id);
		
		// 攻擊失血view.
		this.stateForBattleActive.showLostHp(_Effect1.effectValue, _toView.x, _toView.y);
		
		// 改變vo.
		_toView.vo.updateValue(_Effect1);
		
		// 反擊.
		this.____doCounter();
	}
	
	
	private function ____doCounter() : void {
		// 王者死亡不會反擊.
		if(!_Effect2){
			// 判斷死亡.
			if(_Effect1.remainHp == 0){
				BattleModel.killVo(_toView.vo);
			}
			this.skillAction.next();
			return;
		}
		
		_toView.attack(MapModel.getDirection2(_toView.vo.pos, _fromView.vo.pos), 1, onCounter);
		
		
		
	}
	
	private function onCounter() : void {
		// 攻擊後恢復idle.
		_toView.idleNormal(_toView.vo.role_id);
		
		// 改變vo.
		_fromView.vo.updateValue(_Effect2);
		
		// 反擊失血view.
		this.stateForBattleActive.showLostHp(_Effect2.effectValue, _fromView.x, _fromView.y);
		
		// 判斷死亡.
		if(_Effect1.remainHp == 0){
			BattleModel.killVo(_toView.vo);
		}
		if(_Effect2.remainHp == 0){
			BattleModel.killVo(_fromView.vo);
		}
		
		this.skillAction.next();
	}
	
	
	
}
}