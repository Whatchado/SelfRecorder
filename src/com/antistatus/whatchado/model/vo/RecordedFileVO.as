package com.antistatus.whatchado.model.vo
{
	[Bindable]
	public class RecordedFileVO
	{
		public var duration:String = "LÄNGE: 00:34";
		public var id:String;
		public var label:String = "AUFNAHME 1";
		public var date:Date;

		public function RecordedFileVO(id:String, label:String, date:Date)
		{
			this.id = id;
			this.label = label;
			this.date = date;
		}

	}
}

