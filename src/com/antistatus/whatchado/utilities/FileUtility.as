
package com.antistatus.whatchado.utilities
{
	import flash.filesystem.File;

	public class FileUtility
	{

		public static function getFileUrl(fileName:String):String
		{
			if(fileName)
			{
				var f:File = File.applicationStorageDirectory.resolvePath(fileName);
				return f.url;
			}
			else
			{
				return null;
			}
		}

		public function FileUtility()
		{
		}
	}
}


