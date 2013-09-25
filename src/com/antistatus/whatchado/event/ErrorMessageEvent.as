
package com.antistatus.whatchado.event
{
	import com.antistatus.whatchado.model.vo.ErrorVO;
	
	import flash.events.Event;

	/**
	 * A custom Error event for the application.
	 */
	public class ErrorMessageEvent extends Event
	{
		/**
		 * Dispatched by....
		 */
		public static const ERROR:String = "error";

		public function ErrorMessageEvent(type:String, error:ErrorVO, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_error = error;
			super(type, bubbles, cancelable);
		}

		private var _error:ErrorVO;

		public function get error():ErrorVO
		{
			return _error;
		}

		override public function clone():Event
		{
			return new ErrorMessageEvent(type, error, bubbles, cancelable);
		}
	}
}

