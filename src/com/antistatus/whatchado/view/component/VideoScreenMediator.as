
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.StreamVO;
	import com.antistatus.whatchado.utilities.FileUtility;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.setInterval;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class VideoScreenMediator extends Mediator
	{

		public function VideoScreenMediator()
		{
			super();
		}

		[Inject]
		public var model:MainModel;

		[Inject]
		public var videoScreen:VideoScreen;
		
		private var progressTimer:Number = 0;
		private var volumeWatcher:ChangeWatcher;

		override public function initialize():void
		{
			// context listeners
			addContextListener(VideoControlsEvent.PAUSE_VIDEO, pauseVideoHandler);
			addContextListener(VideoControlsEvent.RESUME_VIDEO, resumeVideoHandler);
			addContextListener(VideoControlsEvent.START_VIDEO, startVideoHandler);
			addContextListener(VideoControlsEvent.STOP_VIDEO, stopVideoHandler);
			addContextListener(VideoControlsEvent.SEEK_VIDEO, seekVideoHandler);

			addViewListener(ViewEvent.COMPLETE, videoCompleteHandler);
			addViewListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			addViewListener(SystemEvent.VIDEO_DURATION_CHANGED, videoDurationChangedHandler);
			addViewListener(ViewEvent.CLICK, enterFullscreenHandler);
			
			volumeWatcher = BindingUtils.bindProperty(videoScreen, "volume", model, "globalVolume");

			progressTimer = setInterval(updateProgress, 20);
		}
		
		private function videoCompleteHandler(event:ViewEvent):void
		{
			dispatch(new SystemEvent(SystemEvent.VIDEO_COMPLETE));
		}		
		
		private function videoDurationChangedHandler(event:SystemEvent):void
		{
			dispatch(event);
		}		

		protected function IOErrorHandler(event:IOErrorEvent):void
		{
			Trace.error(this, "IOError: " + event.toString());
		}

		private function connect():void
		{
				var saStream:StreamVO = new StreamVO("test", "", FileUtility.getFileUrl(model.currentVideo),true,0);

				videoScreen.streamData = saStream;
				videoScreen.vodStartTime = saStream.startTime;
				videoScreen.vodEndTime = saStream.endTime;

				if(!videoScreen.streamData)
					return;

				videoScreen.connect();
				//model.playStatus = model.PLAY;
				Trace.log(videoScreen.id + ":" + this + " streamData.path: ", videoScreen.streamData.path);
				Trace.log(videoScreen.id + ":" + this + " streamData.streamName: ", videoScreen.streamData.streamName);
				Trace.log(videoScreen.id + ":" + this + " vodStartTime: ", videoScreen.vodStartTime);
				Trace.log(videoScreen.id + ":" + this + " vodEndTime: ", videoScreen.vodEndTime);
			
		}

		private function enterFullscreenHandler(event:ViewEvent):void
		{
		}


		private function netStatusHandler(event:NetStatusEvent):void
		{
			event.stopPropagation();

			if (event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Closed")
				model.playStatus = MainModel.STOP;
			else if (event.info.code == "NetConnection.Connect.Success")
				if (!videoScreen.streamData.autoplay)
					model.playStatus = MainModel.PAUSE;
				else
					model.playStatus = MainModel.PLAY;

			if (event.info.code == "NetStream.Play.Start")
			{
				videoScreen.buffer.visible = false;
				model.playStatus = MainModel.PLAY;
			}

			if (event.info.code == "NetStream.Play.Stop")
				model.playStatus = MainModel.PAUSE;

			if (event.info.code == "NetStream.Buffer.Flush")
				model.playStatus = MainModel.PAUSE;
		}

		private function pauseVideoHandler(event:VideoControlsEvent):void
		{
			videoScreen.pauseStream();
		}


		private function resumeVideoHandler(event:VideoControlsEvent):void
		{
			if (videoScreen.stream)
				videoScreen.resumeStream();
			else
				connect();
		}

		private function seekVideoHandler(event:VideoControlsEvent):void
		{
			videoScreen.seekStream(videoScreen.vodStartTime + model.currentSeekPosition);
		}

		private function startVideoHandler(event:VideoControlsEvent):void
		{
			connect();
		}


		private function stopVideoHandler(event:VideoControlsEvent):void
		{
			videoScreen.closeStream();
		}

		private function updateProgress():void
		{
			if (videoScreen.stream && videoScreen.stream.time - videoScreen.vodStartTime > 0)
				model.currentStreamTime = videoScreen.stream.time - videoScreen.vodStartTime;

			if (videoScreen.stream && videoScreen.vodEndTime > 0 && videoScreen.stream.time >= videoScreen.vodEndTime)
			{
				dispatch(new VideoControlsEvent(VideoControlsEvent.PAUSE_VIDEO));
				model.playStatus = MainModel.PAUSE;
			}
		}
	}
}

