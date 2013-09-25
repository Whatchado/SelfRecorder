
package com.antistatus.whatchado.view.component
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import spark.components.supportClasses.SliderBase;
	import spark.events.TrackBaseEvent;

	public class ProgressSlider extends SliderBase
	{

		public function ProgressSlider()
		{
			super();
			addEventListener(TrackBaseEvent.THUMB_PRESS, thumbPressHandler);
			addEventListener(TrackBaseEvent.THUMB_RELEASE, thumbReleaseHandler);
		}

		public function get position():Number
		{
			return pendingValue;
		}

		public function set position(value:Number):void
		{
			if (thumbPressed)
				return;

			pendingValue = Math.min(value, maximum);
			invalidateSkinState();
			invalidateDisplayList();
		}
		private var thumbPressed:Boolean = false;

		/**
		 *  @private
		 */
		override protected function pointToValue(x:Number, y:Number):Number
		{
			if (!thumb || !track)
				return 0;

			var range:Number = maximum - minimum;
			var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
			return minimum + ((thumbRange != 0) ? (x / thumbRange) * range : 0);
		}

		override protected function system_mouseWheelHandler(event:MouseEvent):void
		{
			//do nothing!
		}

		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
		}

		/**
		 *  @private
		 */
		override protected function updateSkinDisplayList():void
		{
			if (!thumb || !track)
				return;

			var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
			var range:Number = maximum - minimum;

			// calculate new thumb position.
			var thumbPosTrackX:Number = (range > 0) ? ((pendingValue - minimum) / range) * thumbRange : 0;

			// convert to parent's coordinates.
			var thumbPos:Point = track.localToGlobal(new Point(thumbPosTrackX, 0));
			var thumbPosParentX:Number = thumb.parent.globalToLocal(thumbPos).x;

			thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.getLayoutBoundsY());
		}

		private function thumbPressHandler(event:TrackBaseEvent):void
		{
			thumbPressed = true;
		}

		private function thumbReleaseHandler(event:TrackBaseEvent):void
		{
			thumbPressed = false;
		}
	}
}