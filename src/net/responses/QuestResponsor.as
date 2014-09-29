package net.responses
{
	import proto.cs.CmdCodeQuest;
	import proto.cs.GetQuestRes;
	import proto.cs.QuestBody;

	public class QuestResponsor implements IResponsor
	{
		
		public function onHandle(cmd_B:int, subMsg:Object):void
		{
			var subMsg_A:QuestBody;
			
			subMsg_A = subMsg as QuestBody;
			switch(cmd_B){
				
				// 任務.
				case CmdCodeQuest.CC_QUEST_GET_RES:
					this.onQuestGet(subMsg_A.getQuestRes as GetQuestRes);
					break;
				
				
				default:
					
					break;
			}
		}
		
		private function onQuestGet(v:GetQuestRes):void{
			//Global.getLog().message(this, v);
		}
	}
}