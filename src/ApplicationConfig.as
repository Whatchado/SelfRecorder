package
{

	import com.antistatus.whatchado.controller.InitConfigCommand;
	import com.antistatus.whatchado.controller.InitRed5Command;
	import com.antistatus.whatchado.controller.UserSignInCommand;
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.UserEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.model.UserModel;
	import com.antistatus.whatchado.service.ConfigDataService;
	import com.antistatus.whatchado.service.FFmpegManager;
	import com.antistatus.whatchado.service.Red5Manager;
	import com.antistatus.whatchado.view.MainView;
	import com.antistatus.whatchado.view.MainViewMediator;
	import com.antistatus.whatchado.view.UserProfileMediator;
	import com.antistatus.whatchado.view.UserProfileView;
	import com.antistatus.whatchado.view.component.QuestionView;
	import com.antistatus.whatchado.view.component.QuestionViewMediator;
	import com.antistatus.whatchado.view.component.SelfRecorderMediator;
	import com.antistatus.whatchado.view.component.UploadView;
	import com.antistatus.whatchado.view.component.UploadViewMediator;
	import com.antistatus.whatchado.view.component.VideoControls;
	import com.antistatus.whatchado.view.component.VideoControlsMediator;
	import com.antistatus.whatchado.view.component.VideoProgress;
	import com.antistatus.whatchado.view.component.VideoProgressMediator;
	import com.antistatus.whatchado.view.component.VideoRecorder;
	import com.antistatus.whatchado.view.component.VideoRecorderMediator;
	import com.antistatus.whatchado.view.component.VideoScreen;
	import com.antistatus.whatchado.view.component.VideoScreenMediator;
	import com.antistatus.whatchado.view.component.VolumeControl;
	import com.antistatus.whatchado.view.component.VolumeControlMediator;
	
	import mx.core.IVisualElementContainer;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.LifecycleEvent;
	
	public class ApplicationConfig implements IConfig
	{
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var commandMap:IEventCommandMap;
		
		[Inject]
		public var contextView:ContextView;
		
		public function configure():void
		{
			// Map UserModel as a context enforced singleton
			injector.map(UserModel).asSingleton();
			injector.map(MainModel).asSingleton();
			injector.map(ConfigDataService).asSingleton();
			injector.map(Red5Manager).asSingleton();
			injector.map(FFmpegManager).asSingleton();
			
			
			
			// Create a UserProfileMediator for each UserProfileView
			// that lands inside of the Context View
			mediatorMap.map(UserProfileView).toMediator(UserProfileMediator);
			mediatorMap.map(MainView).toMediator(MainViewMediator);
			mediatorMap.map(VideoScreen).toMediator(VideoScreenMediator);
			mediatorMap.map(VideoControls).toMediator(VideoControlsMediator);
			mediatorMap.map(VolumeControl).toMediator(VolumeControlMediator);
			mediatorMap.map(VideoProgress).toMediator(VideoProgressMediator);
			mediatorMap.map(VideoRecorder).toMediator(VideoRecorderMediator);
			mediatorMap.map(QuestionView).toMediator(QuestionViewMediator);
			mediatorMap.map(SelfRecorder).toMediator(SelfRecorderMediator);
			mediatorMap.map(UploadView).toMediator(UploadViewMediator);
			
			
			commandMap.map(LifecycleEvent.POST_INITIALIZE, LifecycleEvent).toCommand(InitConfigCommand);
			commandMap.map(SystemEvent.RED5_READY, SystemEvent).toCommand(InitRed5Command);
			
			// Execute UserSignInCommand when UserEvent.SIGN_IN
			// is dispatched on the context's Event Dispatcher
			commandMap.map(UserEvent.SIGN_IN).toCommand(UserSignInCommand);
			
			// The "view" property is a DisplayObjectContainer reference.
			// If this was a Flex application we would need to cast it
			// as an IVisualElementContainer and call addElement().
			IVisualElementContainer(SelfRecorder(contextView.view).container).addElement(new MainView());
		}
	}
}