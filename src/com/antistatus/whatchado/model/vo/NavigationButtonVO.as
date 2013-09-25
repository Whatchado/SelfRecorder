package com.antistatus.whatchado.model.vo
{
	[Bindable]
	public class NavigationButtonVO
	{
		public var enabled:Boolean = true;
		public var completed:Boolean = true;
		public var name:String;
		public var type:NavigationTypeVO;
		public var index:int;
		
		public function NavigationButtonVO(name:String)
		{
			this.name = name;
		}
	}
}