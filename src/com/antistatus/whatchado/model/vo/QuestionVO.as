package com.antistatus.whatchado.model.vo
{
	public class QuestionVO
	{
		public var text:String;
		public var video:String;
		public var time:int;
		
		public function QuestionVO(text:String,video:String,time:int)
		{
			this.text = text;
			this.video = video;
			this.time = time;
		}
	}
}