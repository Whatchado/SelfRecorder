
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.QuestionVO;
	import com.antistatus.whatchado.model.vo.RecordedFileVO;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
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
			addViewListener(ViewEvent.VIDEO_RECORDED, videoRecordedHandler);
			addViewListener(ViewEvent.CLICK, tippsClickHandler);
			nextQuestion();
		}
		
		private function videoRecordedHandler(event:ViewEvent):void
		{
			getRecordedFiles();
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
			getRecordedFiles();
		}
		private function videoCompleteHandler(event:SystemEvent):void
		{
			view.currentState = "record";
		}
		
		private function getRecordedFiles():void
		{
			var recordingsFolder:File = File.applicationStorageDirectory.resolvePath("recordings/answer"+model.currentQuestion);
			if(recordingsFolder.exists)
			{
				var recordings:Array = recordingsFolder.getDirectoryListing();
				var recordingsData:Array = [];
				for each (var file:File in recordings) 
				{
					var recordedFile:RecordedFileVO = new RecordedFileVO(file.name, getFileLabel(file.name), file.creationDate);
					recordingsData.push(recordedFile);
				}
				recordingsData.sortOn("date");
				view.recordingsDataProvider = new ArrayCollection(recordingsData);
				
			}
		}
		
		private function getFileLabel(name:String):String
		{
			return name;
		}
	}
}

