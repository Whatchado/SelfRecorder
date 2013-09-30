
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.service.Red5Manager;
	
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

		[Inject]
		public var model:MainModel;

		[Inject]
		public var view:SelfRecorder;

		override public function initialize():void
		{
			addViewListener(ViewEvent.EXIT, exitAppHandler);
			addContextListener(SystemEvent.RED5_ENDED, red5EndedHandler);
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

