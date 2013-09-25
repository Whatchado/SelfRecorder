package com.antistatus.whatchado.service
{
	import com.antistatus.whatchado.model.vo.ConfigVO;
	import com.antistatus.whatchado.utilities.Trace;
	import com.antistatus.whatchado.view.component.ConfigPopup;
	
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
		private var configPopup:ConfigPopup;
		
		/**
		 * Configuration
		 * 
		 */
		public function ConfigurationManager(enforcer:SingletonEnforcer)
		{
			if (!enforcer) throw new Error("ConfigurationManager can't be explicitly instantiated");
			
			configFile = File.applicationStorageDirectory.resolvePath(CONFIG_FILE);
		}
		
		public static function getInst() : ConfigurationManager
		{
			if (!instance)
				instance = new ConfigurationManager(new SingletonEnforcer());
			return instance;
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
				configPopup = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, ConfigPopup, true) as ConfigPopup;
				configPopup.addEventListener("saveConfig", save);
				PopUpManager.centerPopUp(configPopup);
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
			
			PopUpManager.removePopUp(configPopup);
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
		
		public static function get isWin() : Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("win") > -1;
		}
	}
}
class SingletonEnforcer{}