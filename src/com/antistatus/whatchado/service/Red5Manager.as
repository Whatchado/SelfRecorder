//......................................
//				Antistatus 2012 
//......................................

package com.antistatus.whatchado.service
{
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.DisplayObject;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import spark.components.TextInput;

	[Event(name = "started", type = "flash.events.Event")]
	[Event(name = "stopped", type = "flash.events.Event")]
	[Event(name = "logging", type = "flash.events.DataEvent")]
	public class Red5Manager extends EventDispatcher
	{
		//private static const WIN_CMD_PATH:String = "C:/Windows/System32/cmd.exe";
		private static const RED5_FOLDER:String = "server";

		/**
		 * Constructor
		 */
		public function Red5Manager():void
		{
			logsProcessor.addEventListener("started", dispatchEvent);
			logsProcessor.addEventListener("shuttedDown", shuttedDown);
			logsProcessor.addEventListener("addressInUse", addressInUse);
		}

		private var forceCloseProcessTimer:Timer = new Timer(10000);

		private var logsProcessor:LogsProcessor = new LogsProcessor();
		private var startRed5Process:NativeProcess;

		public function launchRed5():void
		{
			invokeRed5(true);
		}

		public function shutdownRed5():void
		{
			invokeRed5(false);
		}

		/*private function executeBatch(batchName:String):void
		{
			var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			startupInfo.executable = new File(WIN_CMD_PATH);
			startupInfo.workingDirectory = File.applicationDirectory.resolvePath(RED5_FOLDER);

			//args
			var processArguments:Vector.<String> = new Vector.<String>();
			processArguments[0] = "/c";
			processArguments[1] = batchName;
			startupInfo.arguments = processArguments;

			startProcess(startupInfo);
		}*/

		public function start():void
		{
			launchRed5();
		}

		public function stop():void
		{
			if (startRed5Process)
			{
				forceCloseProcessTimer.addEventListener(TimerEvent.TIMER, forcedExit);
				forceCloseProcessTimer.start();

				Trace.log(this, "Shutting down... forceCloseProcessTimer");

				shutdownRed5();
			}
			else
			{
				onProcessExit();
			}

			function forcedExit(e:TimerEvent):void
			{
				startRed5Process.exit(true);
			}
		}

		private function addressInUse(e:Event):void
		{
			Alert.show("IP-port is busy. Please stop the process on port 1935.", "Ooops", 4, null, okHandler);

			function okHandler(e:Event):void
			{
				stop();
			}
		}

		private function dispatchLogEvent(log:String):void
		{
			logsProcessor.process(log);
			dispatchEvent(new DataEvent("logging", false, false, log));
		}

		private function invokeRed5(launch:Boolean):void
		{
			var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			startupInfo.executable = ConfigurationManager.getInst().getJavaFile();
			startupInfo.workingDirectory = File.applicationDirectory.resolvePath(RED5_FOLDER);

			var separator:String = ConfigurationManager.isWin ? ";" : ":";
			
			var arg5:String = File.applicationDirectory.resolvePath(RED5_FOLDER + '/boot.jar').nativePath;
			arg5 +=  separator;
			arg5 += File.applicationDirectory.resolvePath(RED5_FOLDER + '/conf').nativePath;
			arg5 +=  separator + "." + separator;

			var processArguments:Vector.<String> = new Vector.<String>();
			processArguments[0] = "-Dpython.home=lib";
			processArguments[1] = "-Dlogback.ContextSelector=org.red5.logging.LoggingContextSelector";
			processArguments[2] = "-Dcatalina.useNaming=true";
			processArguments[3] = "-Djava.security.debug=failure";
			processArguments[4] = "-cp";
			processArguments[5] = arg5;//.replace(" ", "\\ ");

			processArguments[6] = launch ? "org.red5.server.Bootstrap" : "org.red5.server.Shutdown";

			if (!launch)
			{
				processArguments[7] = "9999";
				processArguments[8] = "red5user";
				processArguments[9] = "changeme";
			}
			startupInfo.arguments = processArguments;

			startProcess(startupInfo);
		}
		private function onError(event:ProgressEvent):void
		{
			var process:NativeProcess = event.target as NativeProcess;
			var v:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);
			dispatchLogEvent(v);
		}

		private function onOutput(event:ProgressEvent):void
		{
			var process:NativeProcess = event.target as NativeProcess;
			var v:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
			dispatchLogEvent(v);
		}

		private function onProcessExit(e:Event = null):void
		{
			dispatchEvent(new Event("stopped"));
		}

		private function shuttedDown(e:Event):void
		{
			if (startRed5Process)
				startRed5Process.exit();
		}

		private function startProcess(startupInfo:NativeProcessStartupInfo):void
		{
			startRed5Process = new NativeProcess();
			startRed5Process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			startRed5Process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onError);
			startRed5Process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutput);
			startRed5Process.start(startupInfo);
		}
	}
}
