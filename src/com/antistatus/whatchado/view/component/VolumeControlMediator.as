
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.view.component.VolumeControl;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class VolumeControlMediator extends Mediator
	{

		public function VolumeControlMediator()
		{
			//
		}

		[Inject]
		public var model:MainModel;

		[Inject]
		public var volumeControl:VolumeControl;

		override public function initialize():void
		{
			addViewListener(ViewEvent.CHANGE, volumeControlChangeHandler);
		}

		private function volumeControlChangeHandler(event:ViewEvent):void
		{
			model.globalVolume = volumeControl.volumeSlider.value;
		}
	}
}

