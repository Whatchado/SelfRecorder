package com.antistatus.whatchado.model.vo
{
	[Bindable]
	public class NavigationTypeVO
	{
		public var type:String;
		public var id:int;
		public var active:Boolean = false;
		public function NavigationTypeVO(type:String)
		{
			this.type = type;
		}
	}
}