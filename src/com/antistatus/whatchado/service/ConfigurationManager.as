package com.antistatus.whatchado.service
{
	import com.antistatus.whatchado.model.vo.ConfigVO;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	[Event(name="configured", type="flash.events.DataEvent")]
	public class ConfigurationManager extends EventDispatcher
	{
		private static const CONFIG_FILE:String = "serverConfig.xml";
			
		private static var instance:ConfigurationManager;
		
		private var configFile:File;
		private var _config:ConfigVO;
		
		/**
		 * Configuration
		 * 
		 */
		public function ConfigurationManager()
		{
			configFile = File.applicationStorageDirectory.resolvePath(CONFIG_FILE);
		}
		
		//-----------------------------------------------------
		//
		//	PUBLIC methods
		//
		//-----------------------------------------------------
		public function get config() : ConfigVO
		{
			return _config;
		}
		
		/**
		 * Check configuration.
		 * If everything is configured, dispatch the event and continue app loading.
		 * Otherwise, show config popup.
		 */
		public function check() : void
		{
			var cfgXml:XML = readConfig();
			populateConfig(cfgXml);
			if (isJavaHomeValid())
			{
				dispatchEvent(new Event("configured"));
			}
			else
			{
				Trace.log(this, "Java path not valid!");
			}
		}
				
		public function getJavaFile() : File
		{
			// Get a file reference to the JVM
			var file:File = new File(_config.javaHome);
			if (isWin)
			{
				file = file.resolvePath("bin/javaw.exe");
			}
			else
			{
				file = file.resolvePath("Home/bin/java");
			}
			return file;
		}
		
		
		//-----------------------------------------------------
		//
		//	PRIVATE methods
		//
		//-----------------------------------------------------
				
		private function save(e:Event) : void
		{
			var xml:XML = 
				<config>
					<javaHome>{config.javaHome}</javaHome>
				</config>;
			var fs:FileStream = new FileStream();
			fs.open(configFile, FileMode.WRITE);
			fs.writeUTFBytes(xml);
			fs.close();
			
			dispatchEvent(new Event("configured"));
		}
		
		private function populateConfig(configXml:XML) : void
		{
			_config = new ConfigVO();
			if (configXml)
			{
				_config.javaHome = new String(configXml..javaHome);
			}
		}
		
		public function isJavaHomeValid() : Boolean
		{
			if (!_config) return false;
			
			// If no known last home, present default/sample values
			if (!_config.javaHome) setDefaultJavaHome();
			
			return getJavaFile().exists;
			
			function setDefaultJavaHome() : void
			{
				_config.javaHome = (isWin) ? 
					"C:\\Program Files\\Java\\jre6" : 
					"/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0";
			}
		}
				
		private function readConfig():XML
		{
			if (configFile.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(configFile, FileMode.READ);
				var xml:XML = XML(fs.readUTFBytes(fs.bytesAvailable));
				fs.close();
				return xml;
			}
			else
			{
				return null;
			}
		}
		
		public function get isWin() : Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("win") > -1;
		}
	}
}
