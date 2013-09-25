
package com.antistatus.whatchado.event
{
	import flash.events.Event;

	public class StreamClientEvent extends Event
	{
		public static const MESSAGE:String = "message";
		public static const META_DATA:String = "metaData";
		public static const PLAY_COMPLETE:String = "playComplete";
		public static const PLAY_STATUS:String = "playStatus";

		public function StreamClientEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}

		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}
	}
}