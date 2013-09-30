package com.antistatus.whatchado.model
{
	import com.antistatus.whatchado.base.BaseActor;
	import com.antistatus.whatchado.event.ErrorMessageEvent;
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.model.vo.ErrorVO;
	import com.antistatus.whatchado.model.vo.LocalesVO;
	
	import flash.filesystem.File;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;

	public class MainModel  extends BaseActor
	{
		private var _error:ErrorVO;
		
		public function get error():ErrorVO
		{
			return _error;
		}
		
		public function set error(value:ErrorVO):void
		{
			_error = value;
			dispatch(new ErrorMessageEvent(ErrorMessageEvent.ERROR, value));
		}
		
		private var _playStatus:String;
		
		public function get playStatus():String
		{
			return _playStatus;
		}
		
		public function set playStatus(value:String):void
		{
			_playStatus = value;
			dispatch(new SystemEvent(SystemEvent.PLAY_STATUS_CHANGED));
		}

		
		public var globalSeekPosition:int = 0;
		
		private var _globalVolume:Number = 0.7;
		
		
		[Bindable]
		public function get globalVolume():Number
		{
			return _globalVolume;
		}
		
		public function set globalVolume(value:Number):void
		{
			_globalVolume = value;
			dispatch(new SystemEvent(SystemEvent.VOLUME_CHANGED));
		}
		
		public var header:String;
		
		
		public static const PAUSE:String = "pause";
		
		public static const PLAY:String = "play";
		
		public static const STOP:String = "stop";
		
		
		public var menuButtonsDataProvider:ArrayCollection = new ArrayCollection([]);
		public var currentSeekPosition:Number;
		public var currentCamera:Camera;
		public var currentMicrophone:Microphone;
		public var questionsDataProvider:ArrayCollection;
		public var currentQuestion:int = 0;
		public var currentVideo:String;
		
		public var tippsVideo:String;
		public var questionsButtonsDataProvider:ArrayCollection;
		public var locales:LocalesVO = new LocalesVO();
		
		[Bindable]
		public var currentStreamTime:int = -1;

		public var javaHome:String;
		
		public function MainModel()
		{
		}
		
		public function get isWin() : Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("win") > -1;
		}
		
		public function getJavaFile() : File
		{
			// Get a file reference to the JVM
			var file:File = new File(javaHome);
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
		
		public function isJavaHomeValid() : Boolean
		{
			if (!javaHome)
				setDefaultJavaHome();
			
			return getJavaFile().exists;
		}	
		
		private function setDefaultJavaHome() : void
		{
			javaHome = (isWin) ? 
				"C:\\Program Files\\Java\\jre6" : 
				"/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0";
		}
	}
}