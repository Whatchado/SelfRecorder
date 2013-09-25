
package com.antistatus.whatchado.event
{
	import flash.events.Event;

	/**
	 * This Event is dipatched wehnever the user interacted with a Control in the View
	 */
	public class UserEvent extends Event
	{
		public static const RECORDING_STATUS:String = "recordingStatus";

		/**
		 * Dispatched when the user
		 */
		public static const SIGN_IN:String = "signIn";
		public var session:String;

		public function UserEvent(type:String, session:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.session = session;
			super(type, bubbles, cancelable);
		}


		override public function clone():Event
		{
			return new UserEvent(type, session, bubbles, cancelable);
		}
	}
}

