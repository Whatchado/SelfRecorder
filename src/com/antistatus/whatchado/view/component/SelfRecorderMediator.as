
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.service.Red5Manager;
	import com.antistatus.whatchado.utilities.Trace;
	import com.antistatus.whatchado.view.LoggerWindow;
	
	import flash.desktop.NativeApplication;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class SelfRecorderMediator extends Mediator
	{

		public function SelfRecorderMediator()
		{
			//
		}

		[Inject]
		public var red5Manager:Red5Manager;

		override public function initialize():void
		{
			Trace.log(this, "initialized!");
			
			addViewListener(ViewEvent.EXIT, exitAppHandler);
			addViewListener(ViewEvent.CLICK, selectMenuHandler);
			addContextListener(SystemEvent.RED5_ENDED, red5EndedHandler);
		}
		
		private function selectMenuHandler(event:ViewEvent):void
		{
			if(event.targetObject.label == "Logger")
				new LoggerWindow().open();
			else
				dispatch(new SystemEvent(SystemEvent.INIT_FULLSCREEN_VIEW));
		}
		
		private function red5EndedHandler(event:SystemEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function exitAppHandler(event:ViewEvent):void
		{
			red5Manager.stop();
		}
	}
}

