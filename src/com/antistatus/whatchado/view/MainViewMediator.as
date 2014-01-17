package com.antistatus.whatchado.view
{
	import com.antistatus.whatchado.event.ErrorMessageEvent;
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.NavigationButtonVO;
	import com.antistatus.whatchado.model.vo.NavigationTypeVO;
	import com.antistatus.whatchado.utilities.Trace;
	import com.antistatus.whatchado.view.MainView;
	
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class MainViewMediator extends Mediator
	{

		public function MainViewMediator()
		{
			super();
		}

		[Inject]
		public var view:MainView;
		[Inject]
		public var model:MainModel;

		override public function initialize():void
		{
			// context listeners
			addViewListener(ViewEvent.EXIT, exitFullscreenHandler);
			addViewListener(ViewEvent.SELECT, navigationSelectHandler);
			addViewListener(ViewEvent.SETTINGS_SUBMIT, settingsSubmitHandler);
			addViewListener(ViewEvent.CONTINUE, continueViewHandler);
			addViewListener(ViewEvent.BACK, backViewHandler);
			addViewListener(ViewEvent.VIDEO_RECORDED, videoRecordedHandler);
			
			addContextListener(ErrorMessageEvent.ERROR, errorMessageHandler);
			addContextListener(SystemEvent.QUESTION_FINISHED, questionFinishedHandler);
			addContextListener(SystemEvent.INIT_FULLSCREEN_VIEW, fullscreenHandler);
			
			view.menuButtonsDataProvider = model.menuButtonsDataProvider;
			view.questionsButtonsDataProvider = model.questionsButtonsDataProvider;
			
			
			
			var selectedRecordingsStore:SharedObject = SharedObject.getLocal("selectedRecordings");
			if(selectedRecordingsStore.data.recordings)
			{
				for (var i:int = 0; i <  selectedRecordingsStore.data.recordings.length; i++) 
				{
					model.selectedRecordings[i] = selectedRecordingsStore.data.recordings[i];
					NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(i)).completed = true;						
				}
			}
			
			
			setTimeout(switchInfoState, 2000);
		}
		
		private function fullscreenHandler(event:SystemEvent):void
		{
			view.startFullScreen();
		}		
	
		
		private function questionFinishedHandler(event:SystemEvent):void
		{
			view.forwardButton.label = "speichern und weiter";
			view.forwardButton.enabled = true;
		}
		
		private function errorMessageHandler(event:ErrorMessageEvent):void
		{
			view.showErrorMessage(event.error);
		}
		
		private function videoRecordedHandler(event:ViewEvent):void
		{
			if(view.currentState == "testrecord")
			{
				model.currentVideo = "testrecording/test.flv";
				view.testRecordView.showTestVideo();
				setTimeout(playTestVIdeo, 500);
			}
		}
		
		private function playTestVIdeo():void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
		}
		
		private function switchInfoState():void
		{
			navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(0)).type));
		}
		
		private function backViewHandler(event:ViewEvent):void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.STOP_VIDEO));
			
			if(view.currentState == "test")
			{
				navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(0)).type));
			}
			else if(view.currentState == "testrecord")
			{
					view.testRecordView.videoRecorder.disconnect();
					view.currentState = "test";
					view.testRecordButton.enabled = true;
					view.settingsButton.enabled = false;
					view.settingsView.start();
					view.forwardButton.label = "speichern und weiter";
			}
			else if(view.currentState == "tour")
			{
				navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(1)).type));
			}
			else if(view.currentState == "question")
			{
				if(model.currentQuestion>0)
				{
					NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion-1)).enabled = true;
					dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, model.currentQuestion-1));
					view.forwardButton.enabled = false;
				}
				else
				{
					navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(2)).type));
				}
			}
			else if(view.currentState == "upload")
			{
				model.currentQuestion = model.questionsDataProvider.length-1;
				NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion)).enabled = true;
				dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, model.currentQuestion));
				view.forwardButton.enabled = false;
			}
		}
		
		private function continueViewHandler(event:ViewEvent):void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.STOP_VIDEO));
			
			if(view.currentState == "intro")
			{
				navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(1)).type));
			}
			else if(view.currentState == "test")
			{
				view.currentState = "testrecord";
				view.testRecordButton.enabled = false;
				view.settingsButton.enabled = true;
				view.testRecordView.videoRecorder.connect();
				view.forwardButton.label = "weiter";
			}
			else if(view.currentState == "testrecord")
			{
				view.testRecordView.videoRecorder.disconnect();
				navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(2)).type));
			}
			else if(view.currentState == "tour")
			{
				navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(0)).type));
			}
			else if(view.currentState == "question")
			{
				if(model.currentQuestion<=model.questionsDataProvider.length-1)
				{
					NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion+1)).enabled = true;
					dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, model.currentQuestion+1));
					view.forwardButton.enabled = false;
				}
				else
				{
					navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.questionsButtonsDataProvider.length-1)).type));
				}
			}
		}		
		
		
		private function settingsSubmitHandler(event:ViewEvent):void
		{
			model.currentCamera = view.settingsView.camera;
			model.currentMicrophone = view.settingsView.microphone;
			
			view.settingsVisible = false;
			
			Trace.log(this, "camera: "+model.currentCamera.name);
			Trace.log(this, "microphone: "+model.currentMicrophone.name);
		}
		
		
		private function exitFullscreenHandler(event:ViewEvent):void
		{
		}
		
	
		private function navigationSelectHandler(event:ViewEvent):void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.STOP_VIDEO));
			if(view.currentState == "testrecord")
				view.testRecordView.videoRecorder.disconnect();
				
			view.currentState = NavigationTypeVO(event.targetObject).type;
			setNavigationInactive();
			NavigationTypeVO(event.targetObject).active = true;
			
			if(view.currentState == "question")
			{
				NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion)).enabled = true;
				dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, NavigationTypeVO(event.targetObject).id));
				
				/*if(model.selectedRecordings[model.currentQuestion])
				{
					model.currentVideo = "recordings/answer"+model.currentQuestion+"/" + model.selectedRecordings[model.currentQuestion];
					view.questionView.currentState = "playback";
					view.questionView.interviewButton.enabled = true;
					view.questionView.recordingsButton.enabled = false;
				}
				else
				{
					NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion)).enabled = true;
					dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, NavigationTypeVO(event.targetObject).id));
					view.forwardButton.enabled = false;
				}*/
				
				for each (var button:NavigationButtonVO in model.questionsButtonsDataProvider) 
					button.select = false;
				
				var questionButton:NavigationButtonVO = NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(NavigationTypeVO(event.targetObject).id));
				if(questionButton.completed)
					questionButton.select = true;
				
				
			}
				
			if(view.currentState == "intro")
			{
				view.introText.textFlow = TextConverter.importToFlow(model.locales.introText, TextConverter.TEXT_FIELD_HTML_FORMAT)
				view.forwardButton.label = "weiter";
				view.forwardButton.enabled = true;				
				view.backButton.enabled = false;				
			}
			else
			{
				view.backButton.enabled = true;				
			}

			if(view.currentState == "test")
			{
				
				view.settingsView.settingsCameraHeadline.text = model.locales.settingsCameraHeadline;
				view.settingsView.settingsCameraSubHeadline.text = model.locales.settingsCameraSubHeadline;
				view.settingsView.settingsCameraSelectorLabel.text = model.locales.settingsCameraSelectorLabel;
				view.settingsView.settingsMicrophoneHeadline.text = model.locales.settingsMicrophoneHeadline;
				view.settingsView.settingsMicrophoneSubHeadline.text = model.locales.settingsMicrophoneSubHeadline;
				view.settingsView.settingsMicrophoneSelectorLabel.text = model.locales.settingsMicrophoneSelectorLabel;
				view.settingsView.settingsMicrophoneVolumeLabel.text = model.locales.settingsMicrophoneVolumeLabel;
				view.settingsButton.label = model.locales.settingsButton;
				view.testRecordButton.label = model.locales.testRecordButton;
				view.forwardButton.label = "speichern und weiter";
				
				if(view.settingsView.video.videoObject)
					view.settingsView.start();
			}
			
			if(view.currentState == "upload")
			{
				view.forwardButton.label = "weiter";
				view.forwardButton.enabled = false;
				
				model.currentVideo = "playlist";
				dispatch(new SystemEvent(SystemEvent.PROCESS_VIDEOS));
				dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
			}
		}
		
		private function setNavigationInactive():void
		{
			for each (var item:NavigationButtonVO in model.menuButtonsDataProvider) 
			{
				item.type.active = false;
			}
			
		}
	}
}

