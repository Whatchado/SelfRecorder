
package com.antistatus.whatchado.utilities
{
	import flash.net.SharedObject;

	public class Trace
	{

		/**
		 * Traces a warning.
		 * The message will be displayed in yellow.
		 *
		 * @param	message		Message to be traced
		 */
		public static function error(target:Object, message:*):void
		{
			log(target, message, 0xFF0000)
		}

		/**
		 * Traces a message to the Debug-tool
		 *
		 * @param	target		Target that sends trace
		 * @param	message		Message to be traced
		 * @param	color		opt. Color of the message
		 */
		public static function log(target:Object, message:*, color:uint = 0xFEFEFE):void
		{
			var targetStr:String = "";

			if (typeof(target)=="object")
				targetStr = String(target.toString().split(".").pop()).split("[object ").join("").split("]").join("");
			else
				targetStr = target.toString().split("[object ").join("").split("]").join("");

			trace(targetStr + ": " + message);

			targetStr = getDateTime() +" "+ targetStr;
		/*if(typeof(message)=="object")
			t.obj(message);*/
			var sharedObject:SharedObject = SharedObject.getLocal("whatchadoLog");
			if(sharedObject.data.log)
				sharedObject.data.log += targetStr + ": " + message + "\n";
			else
				sharedObject.data.log = targetStr + ": " + message + "\n";
			
			sharedObject.flush();
		}
		private static function getDateTime():String
		{
			var dateObj:Date = new Date();
			var year:String = String(dateObj.getFullYear());
			var month:String = String(dateObj.getMonth() + 1);
			if (month.length == 1) 
				month = "0"+month;
			
			var date:String = String(dateObj.getDate());
			if (date.length == 1) 
				date = "0"+date;
			
		
			var hours:String = String(dateObj.getHours());
			if (hours.length == 1) 
				hours = "0"+hours;
			var minutes:String = String(dateObj.getMinutes());
			if (minutes.length == 1) 
				minutes = "0"+minutes;
			var seconds:String = String(dateObj.getSeconds());
			if (seconds.length == 1) 
				seconds = "0"+seconds;
			
			return year+"/"+month+"/"+date+" "+hours+":"+minutes+":"+seconds;
		}
		/**
		 * Traces an error.
		 * The message will be displayed in red.
		 *
		 * @param	message		Message to be traced
		 * @return				True if successful
		 */
		public static function warning(target:Object, message:*):void
		{
			log(target, message, 0xFF33DD)
		}

		public function Trace()
		{
		}
	}
}


