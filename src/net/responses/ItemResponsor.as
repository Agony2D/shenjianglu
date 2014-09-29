package net.responses
{
	import proto.cs.CmdCodeLogin;
	import proto.cs.LoginBody;

	public class ItemResponsor implements IResponsor
	{
		public function onHandle(cmd_B:int, subMsg:Object):void
		{
			var subMsg_A:LoginBody;
			
			subMsg_A = subMsg as LoginBody;
			switch(cmd_B){
				// 登入賬號.
				case CmdCodeLogin.CC_ACCOUNT_LOGIN_RES:
					
					break;
				
				
				default:
					
					break;
			}
		}
	}
}