
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class VideoRecorderMediator extends Mediator
	{

		public function VideoRecorderMediator()
		{
			super();
		}

		[Inject]
		public var model:MainModel;

		[Inject]
		public var videoRecorder:VideoRecorder;
		

		override public function initialize():void
		{
			// context listeners
			addContextListener(ViewEvent.VIDEO_RECORDED, videoRecordedHandler);

			
			videoRecorder.currentAnswer = model.currentQuestion;
			videoRecorder.currentTake = 1;
			videoRecorder.currentCamera = model.currentCamera;
			videoRecorder.currentMicrophone = model.currentMicrophone;
		}
		
		private function videoRecordedHandler(event:ViewEvent):void
		{
			// TODO Auto Generated method stub
		}		
		
	}
}

