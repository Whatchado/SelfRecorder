
package com.antistatus.whatchado.model.vo
{

	public class StreamVO
	{
		public var title:String;
		public var path:String;
		public var streamName:String;
		public var autoplay:Boolean;
		public var startTime:int;
		public var previewPic:String;
		public var endTime:int;

		/**
		 * A custom value object for Streams
		 */
		public function StreamVO(title:String, path:String, streamName:String, autoplay:Boolean = true, startTime:int = -1, endTime:int = -1, previewPic:String = "")
		{
			this.title = title;
			this.path = path;
			this.streamName = streamName;
			this.autoplay = autoplay;
			this.startTime = startTime;
			this.endTime = endTime;
			this.previewPic = previewPic;
		}


	}
}

