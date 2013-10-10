package com.antistatus.whatchado.view
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.vo.NavigationButtonVO;
	import com.antistatus.whatchado.model.vo.NavigationTypeVO;
	import com.antistatus.whatchado.utilities.Trace;
	import com.antistatus.whatchado.view.MainView;
	
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
			addViewListener(ViewEvent.START, startQuestionsHandler);
			addViewListener(ViewEvent.CONTINUE, nextQuestionsHandler);
			addViewListener(ViewEvent.VIDEO_RECORDED, videoRecordedHandler);
			
			view.menuButtonsDataProvider = model.menuButtonsDataProvider;
			view.questionsButtonsDataProvider = model.questionsButtonsDataProvider;
			
			setTimeout(switchInfoState, 2000);
		}
		
		private function videoRecordedHandler(event:ViewEvent):void
		{
			if(view.currentState == "testrecord")
			{
				model.currentVideo = "testrecording/test.flv";
				view.testRecordView.showTestVideo();
				dispatch(new VideoControlsEvent(VideoControlsEvent.START_VIDEO));
			}
		}
		
		private function switchInfoState():void
		{
			navigationSelectHandler(new ViewEvent(ViewEvent.SELECT, NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(0)).type));
		}
		
		private function startQuestionsHandler(event:ViewEvent):void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.STOP_VIDEO));
			
			NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(0)).enabled = true;

			view.currentState = "question";
			
			dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, NavigationTypeVO(NavigationButtonVO(model.menuButtonsDataProvider.getItemAt(0)).type).id));
		}		
		private function nextQuestionsHandler(event:ViewEvent):void
		{
			dispatch(new VideoControlsEvent(VideoControlsEvent.STOP_VIDEO));
			
			NavigationButtonVO(model.questionsButtonsDataProvider.getItemAt(model.currentQuestion+1)).enabled = true;

			view.currentState = "question";
			
			dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, model.currentQuestion+1));
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
			view.currentState = NavigationTypeVO(event.targetObject).type;
			setNavigationInactive();
			NavigationTypeVO(event.targetObject).active = true;
			
			if(view.currentState == "question")
				dispatch(new SystemEvent(SystemEvent.NEXT_QUESTION, NavigationTypeVO(event.targetObject).id));
				
			if(view.currentState == "intro")
				view.introText.textFlow = TextConverter.importToFlow(model.locales.introText, TextConverter.TEXT_FIELD_HTML_FORMAT)

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
			
				if(view.settingsView.video.videoObject)
					view.settingsView.start();
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

