
package com.antistatus.whatchado.view.component
{
	import com.antistatus.whatchado.event.ViewEvent;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;

	//--------------------------------------
	//  Skin states
	//--------------------------------------
	/**
	 *  Horizontal State of the Buttons
	 */
	[SkinState("normal")]
	/**
	 *  Fullcontrols State of the Buttons
	 */
	[SkinState("fullcontrols")]
	public class VideoControls extends SkinnableComponent
	{

		public function VideoControls()
		{
			super();


		}

		[SkinPart(required = "true")]

		/**
		 *  A skin part that defines the Playbutton of the VideoControls.
		 */
		public var pause:Button;

		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------

		[SkinPart(required = "true")]

		/**
		 *  A skin part that defines the Playbutton of the VideoControls.
		 */
		public var play:Button;

		public function togglePlayPause():void
		{
			if (play.enabled)
			{
				play.enabled = false;
				pause.enabled = true;
				dispatchEvent(new ViewEvent(ViewEvent.CLICK, play, false));
			}
			else
			{
				play.enabled = true;
				pause.enabled = false;
				dispatchEvent(new ViewEvent(ViewEvent.CLICK, pause, false));
			}

		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if (instance == play)
				play.addEventListener(MouseEvent.CLICK, playClickHandler);

			if (instance == pause)
				pause.addEventListener(MouseEvent.CLICK, pauseClickHandler);
		}

		protected function pauseClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			pause.enabled = false;
			play.enabled = true;
			dispatchEvent(new ViewEvent(ViewEvent.CLICK, pause, false));
		}

		protected function playClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			play.enabled = false;
			pause.enabled = true;
			dispatchEvent(new ViewEvent(ViewEvent.CLICK, play, false));
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);


		}
	}
}
