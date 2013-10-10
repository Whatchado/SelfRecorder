package com.antistatus.whatchado.model.vo
{
	[Bindable]
	public class RecordedFileVO
	{
		public var duration:String = "";
		public var id:String;
		public var label:String = "";
		public var date:Date;
		public var selected:Boolean = false;

		public function RecordedFileVO(id:String, label:String, date:Date)
		{
			this.id = id;
			this.label = label;
			this.date = date;
		}

	}
}

