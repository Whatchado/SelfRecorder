
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.SystemEvent;
	import com.antistatus.whatchado.event.VideoControlsEvent;
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	
	import spark.components.Button;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * Mediator for the corresponding View Component
	 */
	public class VideoControlsMediator extends Mediator
	{

		/**
		 * The constructor.
		 */
		public function VideoControlsMediator()
		{
			//
		}

		/**
		 * Inject the <code>MainModel</code> Singleton.
		 */
		[Inject]
		public var model:MainModel;

		/**
		 * Inject the <code>VideoControls</code> view component.
		 */
		[Inject]
		public var videoControls:VideoControls;

		/**
		 * Override the onRegister() method to perform setup tasks on the
		 * view component when the Mediator is registered with the framework.
		 */
		override public function initialize():void
		{
			addContextListener(SystemEvent.PLAY_STATUS_CHANGED, playStatusChangedHandler);
			addViewListener(ViewEvent.CLICK, videoControlsClickHandler);
			playStatusChangedHandler();
		}

		/**
		 * Handler for the <code>SystemEvent.PLAY_STATUS_CHANGED</code> event.
		 * <p>
		 * Sets the <code>VideoControls</code> Buttons according to the playStatus property in
		 * the <code>MainModel</code>
		 */
		private function playStatusChangedHandler(event:SystemEvent = null):void
		{
			if (model.playStatus == MainModel.PLAY)
			{
				videoControls.pause.enabled = true;
				videoControls.play.enabled = false;
			}
			else if (model.playStatus == MainModel.PAUSE || model.playStatus == MainModel.STOP)
			{
				videoControls.play.enabled = true;
				videoControls.pause.enabled = false;
			}
		}

		/**
		 * Handler for the <code>ViewEvent.CLICK</code> event dispatched
		 * when a Button of the <code>VideoControls</code> is clicked.
		 */
		private function videoControlsClickHandler(event:ViewEvent):void
		{
			if (Button(event.targetObject).id == "play")
				dispatch(new VideoControlsEvent(VideoControlsEvent.RESUME_VIDEO));
			else if (Button(event.targetObject).id == "pause")
				dispatch(new VideoControlsEvent(VideoControlsEvent.PAUSE_VIDEO));
		}
	}
}

