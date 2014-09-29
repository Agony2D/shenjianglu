package views.UU.comps
{
	import configs.cards.CardConfigurator;
	import configs.cards.CharacterCardCfg;
	import configs.cards.EquipmentCardCfg;
	import configs.cards.MagicCardCfg;
	
	import org.agony2d.flashApi.StateFusionUU;
	
	import views.UU.comps.cardStates.CharacterCard_StateUU;
	import views.UU.comps.cardStates.EquipmentCard_StateUU;
	import views.UU.comps.cardStates.MagicCard_StateUU;
	
public class CardUU extends StateFusionUU
{
	
	public static const CARD_NAME_OFFSET:int = 73;
	
	public function get cardId() : int {
		return this.userData as int;
	}
	
	
	
	public function setCardId( v:int ) : void {
		this.userData = v;
		
		// Role.
		if(v >= 10000 && v < 15000){
			this.setState(CharacterCard_StateUU, [CardConfigurator.getCardById(v) as CharacterCardCfg]);
		}
		// Magic
		else if(v >= 20000 && v < 25000){
			this.setState(MagicCard_StateUU, [CardConfigurator.getCardById(v) as MagicCardCfg]);
		}
		// Equipment.
		else if(v >= 30000 && v < 35000){
			this.setState(EquipmentCard_StateUU, [CardConfigurator.getCardById(v) as EquipmentCardCfg]);
		}
	}
	

}
}