
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.StreamVO;
	import com.antistatus.whatchado.utilities.Trace;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class VideoProgressMediator extends Mediator
	{
		public function VideoProgressMediator()
		{
			//
		}

		[Inject]
		public var model:MainModel;

		[Inject]
		public var videoProgress:VideoProgress;


		private var _secondsCurrent:int;

		[Bindable]
		public function get secondsCurrent():int
		{
			return _secondsCurrent;
		}

		public function set secondsCurrent(value:int):void
		{
			_secondsCurrent = value;
			videoProgress.secondsCurrent = value;
		}


		private var secondsCurrentWatcher:ChangeWatcher;

		override public function initialize():void
		{
			Trace.log(this, "initialized!");
			
			addContextListener(SystemEvent.PLAY_STATUS_CHANGED, playStatusChangedHandler);
			addContextListener(SystemEvent.VIDEO_DURATION_CHANGED, videoDurationChangedHandler);
			addViewListener(ViewEvent.CHANGE, progressChangedHandler);
			addViewListener(ViewEvent.START, inSliderChangedHandler);
			addViewListener(ViewEvent.STOP, outSliderChangedHandler);

			videoProgress.secondsCurrent = 0;

			var currentMStream:StreamVO;

			/*			if (remoteConnectionModel.currentRecordedSession)
							currentMStream = remoteConnectionModel.getRecordedStreamByTitle("moderator").stream;
						else
							return;*/

			secondsCurrentWatcher = BindingUtils.bindProperty(this, "secondsCurrent", model, "currentStreamTime");
		}
		
		private function inSliderChangedHandler(event:ViewEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function outSliderChangedHandler(event:ViewEvent):void
		{
			// TODO Auto Generated method stub
		}
			
		private function videoDurationChangedHandler(event:SystemEvent):void
		{
			videoProgress.secondsTotal = event.value;
		}

		private function playStatusChangedHandler(event:SystemEvent):void
		{
		/*if (mainModel.playStatus == MainModel.PLAY)
			videoProgress.active = true;
		else if (mainModel.playStatus == MainModel.STOP)
			videoProgress.active = false;*/
		}

		private function progressChangedHandler(event:ViewEvent):void
		{
			if (model.currentSeekPosition == videoProgress.progress.value)
				return;
			
			model.currentSeekPosition = videoProgress.progress.value;

			dispatch(new VideoControlsEvent(VideoControlsEvent.SEEK_VIDEO));
		}
	}
}

