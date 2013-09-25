package com.antistatus.whatchado.event
{
	
	import flash.events.Event;
	
	public class VideoRecorderEvent extends Event
	{
		public function VideoRecorderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const CONNECTED:String = "connected";
		
		override public function clone():Event
		{
			return new VideoRecorderEvent(type, bubbles, cancelable);
		}
	}
}
