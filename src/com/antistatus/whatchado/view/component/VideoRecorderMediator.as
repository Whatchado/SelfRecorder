
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.ErrorMessageEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.QuestionVO;
	
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
			addViewListener(ErrorMessageEvent.ERROR, recorderErrorHandler);
			
			videoRecorder.suggestedTime = QuestionVO(model.questionsDataProvider.getItemAt(model.currentQuestion)).time;
			videoRecorder.currentAnswer = model.currentQuestion;
			videoRecorder.currentTake = 1;
			videoRecorder.currentCamera = model.currentCamera;
			videoRecorder.currentMicrophone = model.currentMicrophone;
		}
		
		private function recorderErrorHandler(event:ErrorMessageEvent):void
		{
			model.error = event.error;
		}
		
		private function videoRecordedHandler(event:ViewEvent):void
		{
			// TODO Auto Generated method stub
		}		
		
	}
}

