//......................................
//				Antistatus 2012 
//......................................

package com.antistatus.whatchado.service
{
	import com.antistatus.whatchado.base.BaseActor;
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.StreamVO;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	

	public class FFmpegManager extends BaseActor
	{
		private static const FFMPEG:String = "ffmpeg/ffmpeg";

		/**
		 * Constructor
		 */
		public function FFmpegManager():void
		{
		}
		
		//
		// ffmpeg -i /Users/antistatus/Library/Application\ Support/SelfRecorder/Local\ Store/videos/DE_STANDARD_01.flv -i /Users/antistatus/Library/Application\ Support/SelfRecorder/Local\ Store/recordings/answer0/0_1_20131020-04.55.07.855_00-24.flv -b:v 4800k -ar 44100 -ac 2 -f flv output.flv
		//
		

		/**
		 * Inject the <code>MainModel</code> Singleton.
		 */
		[Inject]
		public var model:MainModel;
		
		public var startFFmpegProcess:NativeProcess;

		public function start():void
		{
		}


		private function processLogEvent(log:String):void
		{
			Trace.log(this, log);
		}

		public function processVideos(playlist:Array):void
		{
			var ffmpeg:File = File.applicationDirectory;
			var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			startupInfo.executable = ffmpeg.resolvePath(FFMPEG);

			var outputPath:String = File.applicationStorageDirectory.resolvePath("output").nativePath;		
			var processArguments:Vector.<String> = new Vector.<String>();
			
			for each (var videoSource:StreamVO in playlist) 
			{
				processArguments.push("-i");
				processArguments.push(videoSource.streamName);
			}
			
			processArguments.push("-b:v");
			processArguments.push("4800k");
			processArguments.push("-ar");
			processArguments.push("44100");
			processArguments.push("-ac");
			processArguments.push("2");
			processArguments.push("-f");
			processArguments.push("flv");
			processArguments.push("-y");
			processArguments.push(outputPath+"/output.flv");


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
		}

		private function shuttedDown(e:Event):void
		{
			if (startFFmpegProcess)
				startFFmpegProcess.exit();
		}

		private function startProcess(startupInfo:NativeProcessStartupInfo):void
		{
			startFFmpegProcess = new NativeProcess();
			startFFmpegProcess.addEventListener(IOErrorEvent.IO_ERROR, onError);
			startFFmpegProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onError);
			startFFmpegProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onError);
			startFFmpegProcess.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
			startFFmpegProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onError);
			startFFmpegProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutput);
			startFFmpegProcess.start(startupInfo);
		}
	}
}
