
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.QuestionVO;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class QuestionViewMediator extends Mediator
	{

		public function QuestionViewMediator()
		{
			//
		}

		[Inject]
		public var model:MainModel;

		[Inject]
		public var view:QuestionView;

		override public function initialize():void
		{
			addContextListener(SystemEvent.NEXT_QUESTION, nextQuestionHandler);
			addContextListener(SystemEvent.VIDEO_COMPLETE, videoCompleteHandler);
			addViewListener(ViewEvent.CLICK, tippsClickHandler);
			nextQuestion();
		}
		
		private function tippsClickHandler(event:ViewEvent):void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.STOP_VIDEO));
			model.currentVideo = model.tippsVideo;
			view.currentState = "start";
			dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
		}
		
		private function nextQuestionHandler(event:SystemEvent):void
		{
			model.currentQuestion = event.value;
			nextQuestion();
		}
		
		public function nextQuestion():void
		{
			view.currentState = "start";
			view.questionText.text = QuestionVO(model.questionsDataProvider.getItemAt(model.currentQuestion)).text;
		 	model.currentVideo = QuestionVO(model.questionsDataProvider.getItemAt(model.currentQuestion)).video;
			dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
		}
		private function videoCompleteHandler(event:SystemEvent):void
		{
			view.currentState = "record";
		}
	}
}

