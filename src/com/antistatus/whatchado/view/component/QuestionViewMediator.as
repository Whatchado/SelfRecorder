
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.NavigationButtonVO;
	import com.antistatus.whatchado.model.vo.QuestionVO;
	import com.antistatus.whatchado.model.vo.RecordedFileVO;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
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
			Trace.log(this, "initialized!");
			
			addContextListener(SystemEvent.NEXT_QUESTION, nextQuestionHandler);
			addContextListener(SystemEvent.VIDEO_COMPLETE, videoCompleteHandler);
			addViewListener(ViewEvent.VIDEO_RECORDED, videoRecordedHandler);
			addViewListener(ViewEvent.ITEM_SELECT, recordingSelectHandler);
			addViewListener(ViewEvent.DELETE, recordingDeleteHandler);
			nextQuestion();
		}
		
		private function recordingSelectHandler(event:ViewEvent):void
		{
			model.currentVideo = event.targetObject.file;
			view.currentState = "playback";
			model.selectedRecordings[model.currentQuestion] = model.currentVideo.split("/").pop();
			getRecordedFiles();
			setTimeout(startRecordedVideo,500);
		}
		
		private function startRecordedVideo():void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
		}
		
		private function recordingDeleteHandler(event:ViewEvent):void
		{
			var fileToDelete:File = File.applicationStorageDirectory.resolvePath(event.targetObject.file);
			fileToDelete.deleteFile();
			getRecordedFiles();
		}
		
		private function videoRecordedHandler(event:ViewEvent):void
		{
			model.selectedRecordings[model.currentQuestion] = event.targetObject.file;
			model.currentVideo = "recordings/answer"+model.currentQuestion+"/" + event.targetObject.file;

			Trace.log(this, event.targetObject.file);
			var selectedRecordingsStore:SharedObject = SharedObject.getLocal("selectedRecordings");
			if(!selectedRecordingsStore.data.recordings)
				selectedRecordingsStore.data.recordings = [];
			
			selectedRecordingsStore.data.recordings[model.currentQuestion] = event.targetObject.file;
			selectedRecordingsStore.flush();
			getRecordedFiles();
			dispatch(new SystemEvent(SystemEvent.QUESTION_FINISHED));
			view.currentState = "playback";
			setTimeout(startRecordedVideo,500);
		}
		
		private function nextQuestionHandler(event:SystemEvent):void
		{
			NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion)).completed = true;
			model.currentQuestion = event.value;
			nextQuestion();
		}
		
		public function nextQuestion():void
		{
			view.currentState = "start";
			view.interviewButton.enabled = false;
			view.recordingsButton.enabled = true;
			//view.questionText.text = QuestionVO(model.questionsDataProvider.getItemAt(model.currentQuestion)).text;
		 	model.currentVideo = QuestionVO(model.questionsDataProvider.getItemAt(model.currentQuestion)).video;
			dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
			getRecordedFiles();
		}
		private function videoCompleteHandler(event:SystemEvent):void
		{
			if(view.currentState == "start")
			{
				view.currentState = "record";
				view.interviewButton.enabled = false;
				view.recordingsButton.enabled = true;				
			}
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
					var recordedFile:RecordedFileVO = new RecordedFileVO("recordings/"+recordingsFolder.name+"/"+file.name, getFileLabel(file.name), file.creationDate);
					recordedFile.duration = String(file.name.split("_")[3]).replace(".flv","").replace("-", ":");
					
					if(model.selectedRecordings[model.currentQuestion] == file.name)
						recordedFile.selected = true;
					else
						recordedFile.selected = false;
					
					model.recordedFiles[recordedFile.id] = recordedFile;
					recordingsData.push(recordedFile);
				}
				recordingsData.sortOn("date", Array.NUMERIC | Array.DESCENDING);
				view.recordingsDataProvider = new ArrayCollection(recordingsData);
				
			}
			else
			{
				view.recordingsDataProvider = new ArrayCollection([]);
			}
		}
		
		private function getFileLabel(name:String):String
		{
			return "FRAGE " + String(int(name.split("_")[0])+1) + " TAKE " + name.split("_")[1];
		}
	}
}

