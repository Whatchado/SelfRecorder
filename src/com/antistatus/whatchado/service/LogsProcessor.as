package com.antistatus.whatchado.service
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="started", type="flash.events.Event")]
	[Event(name="shuttedDown", type="flash.events.Event")]
	[Event(name="addressInUse", type="flash.events.Event")]
	public class LogsProcessor extends EventDispatcher
	{
		private static const LAUNCHED:String = "Installer service created";
		private static const SHUTTED_DOWN:String = "Stopping Coyote";
		private static const ADDRESS_IN_USE:String = "Address already in use";
		
		public function process(log:String) : void
		{
			if (log.indexOf(LAUNCHED) > -1)
			{
				dispatchEvent(new Event("started", true));
			}
			if (log.indexOf(SHUTTED_DOWN) > -1)
			{
				dispatchEvent(new Event("shuttedDown", true));
			}
			if (log.indexOf(ADDRESS_IN_USE) > -1)
			{
				dispatchEvent(new Event("addressInUse", true));
			}
		}
	}
}