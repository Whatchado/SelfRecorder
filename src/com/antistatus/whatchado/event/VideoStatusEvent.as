
package com.antistatus.whatchado.event
{
	import flash.events.Event;

	/**
	 * A custom event for the application.
	 */
	public class VideoStatusEvent extends Event
	{
		/**
		 * Dispatched by the <code></code>.
		 */
		public static const PAUSED:String = "paused";

		/**
		 * Dispatched by the <code></code>.
		 */
		public static const PLAYING:String = "playing";

		/**
		 * Dispatched by the <code></code>.
		 */
		public static const STATUS_CHANGED:String = "statusChanged";

		public function VideoStatusEvent(type:String, videoStatus:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_videoStatus = videoStatus;
			super(type, bubbles, cancelable);
		}

		private var _videoStatus:String;


		public function get videoStatus():String
		{
			return _videoStatus;
		}

		override public function clone():Event
		{
			return new VideoControlsEvent(type, bubbles, cancelable);
		}
	}
}

