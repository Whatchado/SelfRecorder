
package com.antistatus.whatchado.event
{
	import flash.events.Event;

	/**
	 * This Event is dipatched wehnever the user interacted with a Control in the View
	 */
	public class ViewEvent extends Event
	{

		/**
		 * Dispatched in a View Component 
		 */
		public static const CHANGE:String = "vcChange";

		/**
		 * Dispatched in a View Component 
		 */
		public static const CLEAR:String = "vcClear";
		/**
		 * Dispatched in a View Component when a <code>Button</code> Control was clicked
		 */
		public static const CLICK:String = "vcClick";

		/**
		 * Dispatched by the <code>MainView</code> when the transition to the "display" state has
		 * completet and the <code>VideoScreen</code> Views are ready to start.
		 */
		public static const COMPLETE:String = "vcComplete";

		/**
		 * Dispatched in a View Component 
		 */
		public static const CONTINUE:String = "vcContinue";

		/**
		 * Dispatched in a View Component 
		 */
		public static const DELETE:String = "vcDelete";

		/**
		 * Dispatched in a View Component 
		 */
		public static const EXIT:String = "vcExit";

		/**
		 * Dispatched in a View Component 
		 */
		public static const BACK:String = "vcBack";

		/**
		 * Dispatched in a View Component 
		 */
		public static const START:String = "vcStart";

		/**
		 * Dispatched in a View Component 
		 */
		public static const STOP:String = "vcStop";

		/**
		 * Dispatched in a View Component 
		 */
		public static const SELECT:String = "vcSelect";

		/**
		 * Dispatched in a View Component 
		 */
		public static const SUBMIT:String = "vcSubmit";
		/**
		 * Dispatched in a View Component 
		 */
		public static const VIDEO_RECORDED:String = "vcVideoRecorded";

		/**
		 * Dispatched in a View Component 
		 */
		public static const SETTINGS_SUBMIT:String = "vcSettingsSubmit";
		
		
		public static const ITEM_SELECT:String = "vcItemSelectt";
		
		public function ViewEvent(type:String, targetObject:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_targetObject = targetObject;
		}

		private var _targetObject:Object;

		public function get targetObject():Object
		{
			return _targetObject;
		}

		override public function clone():Event
		{
			return new ViewEvent(type, targetObject, bubbles, cancelable);
		}
	}
}

