package com.antistatus.whatchado.view
{
	import com.antistatus.whatchado.event.UserEvent;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class UserProfileMediator extends Mediator
	{
		[Inject]
		public var view:UserProfileView;
		
		override public function initialize():void
		{
			// Redispatch an event from the view to the framework
			addViewListener(UserEvent.SIGN_IN, dispatch);
		}
	}
}