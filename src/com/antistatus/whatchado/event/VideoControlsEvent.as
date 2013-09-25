
package com.antistatus.whatchado.event
{
	import flash.events.Event;

	/**
	 * A custom event for the application.
	 */
	public class VideoControlsEvent extends Event
	{

		/**
		 * Dispatched by the <code>VideoControls</code> Pause Button.
		 */
		public static const PAUSE_VIDEO:String = "pauseVideo";

		/**
		 * Dispatched by the <code>VideoControls</code> Pause Button.
		 */
		public static const RESUME_VIDEO:String = "resumeVideo";

		/**
		 * Dispatched by the <code>VideoProgress</code>.
		 */
		public static const SEEK_VIDEO:String = "seekVideo";
		/**
		 * Dispatched by the <code>MainViewMediator</code> when the View is complete.
		 */
		public static const START_VIDEO:String = "startVideo";

		/**
		 * Dispatched by the <code>VideoControls</code> Pause Button.
		 */
		public static const STOP_VIDEO:String = "stopVideo";

		/**
		 * Dispatched by the <code>VideoControls</code> Next Button.
		 */
		public static const VIDEO_NEXT:String = "videoNext";

		/**
		 * Dispatched by the <code>VideoControls</code> Next Button.
		 */
		public static const VIDEO_PREVIOUS:String = "videoPrevious";

		public function VideoControlsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new VideoControlsEvent(type, bubbles, cancelable);
		}
	}
}

