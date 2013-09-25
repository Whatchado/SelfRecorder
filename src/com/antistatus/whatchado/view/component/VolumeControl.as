
package com.antistatus.whatchado.view.component
{
	
	import com.antistatus.whatchado.event.ViewEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.SliderBase;
	import spark.events.TrackBaseEvent;

	public class VolumeControl extends SkinnableComponent
	{

		public function VolumeControl()
		{
			super();

		}

		/**
		 *  @private
		 *  Storage for the mode property.
		 */
		private var _mode:String = "normal";

		[Inspectable(category = "General", defaultValue = "normal")]

		/**
		 * Setting the <code>mode</code> property changes the Layout orientation and skinning of the Video Controls
		 */
		public function get mode():String
		{
			return _mode;
		}

		/**
		 *  @private
		 */
		public function set mode(value:String):void
		{
			if (value == _mode)
				return;

			_mode = value;
			invalidateSkinState();
		}
		public var volume:Number;



		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------

		[SkinPart]

		/**
		 *  A skin part that defines the Playbutton of the VideoControls.
		 */
		public var volumeButton:Button;

		[SkinPart(required = "true")]

		/**
		 *  A skin part that defines the Playbutton of the VideoControls.
		 */
		public var volumeSlider:SliderBase;

		private var tempVolume:Number = 0.7;

		public function updateVolumeStatus():void
		{
			if (!volumeButton || !volumeSlider)
				return;

			if (volumeSlider.value == 0)
				volumeButton.label = "volumemute";
			else if (volumeSlider.value > .7)
				volumeButton.label = "volume";
			else if (volumeSlider.value > .4)
				volumeButton.label = "volumemedium";
			else
				volumeButton.label = "volumelow";

			dispatchEvent(new ViewEvent(ViewEvent.CHANGE));
		}

		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			return mode;
		}

		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);

			if (instance == volumeSlider)
			{
				volumeSlider.value = volume;
				volumeSlider.addEventListener(TrackBaseEvent.THUMB_DRAG, volumeChangeHandler);
			}

			if (instance == volumeButton)
				volumeButton.addEventListener(MouseEvent.CLICK, volumeButtonClickHandler);

			updateVolumeStatus();
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}

		protected function volumeButtonClickHandler(event:MouseEvent):void
		{

			if (volumeSlider.value == 0)
				volumeSlider.value = tempVolume ? tempVolume : .7;
			else
			{
				tempVolume = volumeSlider.value;
				volumeSlider.value = 0;
			}

			updateVolumeStatus();
			dispatchEvent(new ViewEvent(ViewEvent.CHANGE));
		}

		protected function volumeChangeHandler(event:Event):void
		{
			updateVolumeStatus();
		}
	}
}

