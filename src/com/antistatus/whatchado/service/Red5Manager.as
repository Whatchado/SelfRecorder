//......................................
//				Antistatus 2012 
//......................................

package com.antistatus.whatchado.service
{
	import com.antistatus.whatchado.base.BaseActor;
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.controls.Alert;

	public class Red5Manager extends BaseActor
	{
		private static const RED5_FOLDER:String = "server";

		/**
		 * Constructor
		 */
		public function Red5Manager():void
		{
		}

		/**
		 * Inject the <code>MainModel</code> Singleton.
		 */
		[Inject]
		public var model:MainModel;
		
		private var forceCloseProcessTimer:Timer = new Timer(10000);

		private var startRed5Process:NativeProcess;

		public function launchRed5():void
		{
			invokeRed5(true);
		}

		public function shutdownRed5():void
		{
			invokeRed5(false);
		}

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

		private function processLogEvent(log:String):void
		{
			var LAUNCHED:String = "Installer service created";
			var SHUTTED_DOWN:String = "Stopping Coyote";
			var ADDRESS_IN_USE:String = "Address already in use";
			
			if (log.indexOf(LAUNCHED) > -1)
				dispatch(new Event("started", true));
			if (log.indexOf(SHUTTED_DOWN) > -1)
				dispatch(new Event("shuttedDown", true));
			if (log.indexOf(ADDRESS_IN_USE) > -1)
				dispatch(new Event("addressInUse", true));
			
			dispatch(new DataEvent("logging", false, false, log));
		}

		private function invokeRed5(launch:Boolean):void
		{
			var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			startupInfo.executable = model.getJavaFile();
			startupInfo.workingDirectory = File.applicationStorageDirectory.resolvePath(RED5_FOLDER);

			var separator:String = model.isWin ? ";" : ":";
			
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
			processLogEvent(v);
		}

		private function onOutput(event:ProgressEvent):void
		{
			var process:NativeProcess = event.target as NativeProcess;
			var v:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
			processLogEvent(v);
			NativeApplication.nativeApplication.activate();
		}

		private function onProcessExit(e:Event = null):void
		{
			Trace.log(this, e.toString());
			dispatch(new Event("stopped"));
			dispatch(new SystemEvent(SystemEvent.RED5_ENDED));
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
