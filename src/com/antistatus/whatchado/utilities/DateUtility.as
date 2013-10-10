
package com.antistatus.whatchado.utilities
{
	public class DateUtility
	{
		public static function getDateString(dateObj:Date):String
		{
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
			var milli:String = String(dateObj.getMilliseconds());
			
			return date+"."+month+"."+year+" "+hours+":"+minutes+":"+seconds;
		}

		public function DateUtility()
		{
		}
	}
}


