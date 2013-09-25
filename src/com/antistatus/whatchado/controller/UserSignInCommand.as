package com.antistatus.whatchado.controller
{
	import com.antistatus.whatchado.event.UserEvent;
	import com.antistatus.whatchado.model.UserModel;
	
	import robotlegs.bender.bundles.mvcs.Command;

	public class UserSignInCommand extends Command
	{
		[Inject]
		public var event:UserEvent;
		
		[Inject]
		public var model:UserModel;
		
		override public function execute():void
		{
			if (event.session)
				model.signedIn = true;
		}
	}
}