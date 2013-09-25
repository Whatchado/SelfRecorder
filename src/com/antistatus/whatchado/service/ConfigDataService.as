
package com.antistatus.whatchado.service
{

	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.ErrorVO;
	import com.antistatus.whatchado.model.vo.LocalesVO;
	import com.antistatus.whatchado.model.vo.NavigationButtonVO;
	import com.antistatus.whatchado.model.vo.NavigationTypeVO;
	import com.antistatus.whatchado.model.vo.QuestionVO;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	


	/**
	 * A Service class that handles loading and parsing of the config xml data.
	 */
	public class ConfigDataService
	{

		public function ConfigDataService()
		{
			//
		}

		/**
		 * Inject the <code>MainModel</code> Singleton.
		 */
		[Inject]
		public var model:MainModel;


		/**
		 * Loads the config.xml file using a URLLoader instance.
		 */
		public function loadConfigData():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);

			loader.load(new URLRequest("config.xml"));
		}
		
		/**
		 * Loads the config.xml file from local applicationDirectory.
		 */
		public function loadLocalConfig():void
		{
			var file:File = copyFileToStorage("config.xml");
			
			var stream:FileStream = new FileStream();
			stream.open( file, FileMode.READ );
			parseConfigData( stream.readUTFBytes( stream.bytesAvailable ));
			stream.close();
		}

		/**
		 * Handler for the URLLoader's Event.COMPLETE event.
		 */
		private function loadCompleteHandler(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);

			// Parses the xml data and stores the config Strings and 
			// the streamDataProvider in the MainModel Singleton.
			var xml:XML = new XML(loader.data);

			model.header = xml.header.text();


			//dispatch(new SystemEvent(SystemEvent.INIT_STANDALONE_VIEW));
		}

		private function parseConfigData(xmlData:String):void
		{
			var xml:XML = new XML(xmlData);

			model.header = xml.header.text();
			
			var menuXml:XMLList = xml..button;
			var button:XML;
			var menuButtons:Array = [];
			var questionsButtons:Array = [];
			var index:int=0;
			for each (button in menuXml)
			{
				var navButton:NavigationButtonVO = new NavigationButtonVO(button.@title.toString())
				var navigationType:NavigationTypeVO = new NavigationTypeVO(button.@type.toString());
				if(button.@id.length())
					navigationType.id =  int(button.@id.toString());
				navButton.type = navigationType;
				navButton.index = index;
				
				if(navigationType.type == "question")
				{
					navButton.enabled = false;
					navButton.completed = false;
					questionsButtons.push(navButton);					
				}
				else if(navigationType.type == "upload")
				{
					navButton.enabled = true;
					navButton.completed = true;
					questionsButtons.push(navButton);					
				}
				else
				{
					menuButtons.push(navButton);
				}
				
				index++;
			}
			model.questionsButtonsDataProvider = new ArrayCollection(questionsButtons);
			model.menuButtonsDataProvider = new ArrayCollection(menuButtons);
			
			var questionXml:XMLList = xml..question;
			var question:XML;
			var questions:Array = [];
			var file:File;
			
			for each (question in questionXml)
			{
				var questionObj:QuestionVO = new QuestionVO(question.@text.toString(), question.@video.toString(), int(question.@time));
				questions.push(questionObj);
				file = copyFileToStorage(questionObj.video);
			}
			model.questionsDataProvider = new ArrayCollection(questions);
			
			model.tippsVideo = xml.tippsLabel.@video.toString();
			file = copyFileToStorage(model.tippsVideo);
			
			model.locales.tippsLabel = xml.tippsLabel.@label.toString();
			model.locales.settingsCameraHeadline = xml.cameraSettings.@headline.toString();
			model.locales.settingsCameraSubHeadline = xml.cameraSettings.@subHeadline.toString();
			model.locales.settingsCameraSelectorLabel = xml.cameraSettings.@selectorLabel.toString();
			model.locales.settingsMicrophoneHeadline = xml.microphoneSettings.@headline.toString();
			model.locales.settingsMicrophoneSubHeadline = xml.microphoneSettings.@subHeadline.toString();
			model.locales.settingsMicrophoneSelectorLabel = xml.microphoneSettings.@selectorLabel.toString();
			model.locales.settingsMicrophoneVolumeLabel = xml.microphoneSettings.@volumeLabel.toString();
			model.locales.introText = xml.introText.toString();
			
			
			
			
			Trace.log(this, "config complete!");
		}
		
		private function copyFileToStorage(filename:String):File
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filename);
			if(!file.exists)
			{
				var fileOriginal:File = File.applicationDirectory.resolvePath(filename);
				fileOriginal.copyTo(file,true);
			}
			
			return file;
		}
		
		/**
		 * Handler for the URLLoader's Event.IO_ERROR event.
		 */
		private function IOErrorHandler(event:Event):void
		{
			Trace.error(this, "IOError: " + event.toString());
			var error:ErrorVO = new ErrorVO('IOError', 'Error', 'Config file not found!');
			model.error = error;
		}
	}
}

