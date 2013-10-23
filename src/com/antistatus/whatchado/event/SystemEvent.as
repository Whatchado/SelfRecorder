
package com.antistatus.whatchado.event
{
	import flash.events.Event;

	/**
	 * A custom event for the application.
	 */
	public class SystemEvent extends Event
	{

		/**
		 */
		public static const END_FULLSCREEN_VIEW:String = "endFullscreenView";

		/**
		 */
		public static const EXIT_FULLSCREEN_VIEW:String = "exitFullscreenView";


		/**
		 * Dispatched by the <code>AuthService</code> instance when
		 * it has completed loading and parsing the response xml data
		 * and a regular user session was received.
		 */
		public static const INIT_DISPLAY_VIEW:String = "initDisplayView";

		/**
		 */
		public static const INIT_FULLSCREEN_VIEW:String = "initFullscreenView";

		/**
		 * Dispatched by the <code>ConfigDataService</code> instance when
		 * it has completed loading and parsing the config xml data.
		 */
		public static const INIT_LOGIN_VIEW:String = "initLoginView";


		/**
		 */
		public static const OPEN_JUMP_URL:String = "openJumpUrl";

		/**
		 * Dispatched by the <code>MainModel</code> Singleton when its
		 * <code>playStatus</code> property is updated by the
		 * <code>PlayStatusCommand</code>.
		 */
		public static const PLAY_STATUS_CHANGED:String = "playStatusChanged";
		public static const VOLUME_CHANGED:String = "volumeChanged";
		public static const VIDEO_DURATION_CHANGED:String = "videoDuration";
		public static const NEXT_QUESTION:String = "nextQuestion";
		public static const VIDEO_COMPLETE:String = "videoComplete";
		public static const RED5_READY:String = "red5Ready";
		public static const RED5_ENDED:String = "red5Ended";
		public static const QUESTION_FINISHED:String = "questionFinished";
		public static const INIT_LOGGER:String = "initLogger";
		public static const PROCESS_VIDEOS:String = "processVideos";
		
		
		public var value:Number;

		public function SystemEvent(type:String, value:Number=0, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.value = value;
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new SystemEvent(type, value, bubbles, cancelable);
		}
	}
}

