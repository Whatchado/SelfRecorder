
package com.antistatus.whatchado.controller
{
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.service.Red5Manager;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/**
	 */
	public class InitRed5Command extends Command
	{

		[Inject]
		public var model:MainModel;

		[Inject]
		public var red5Manager:Red5Manager;

		/**
		 *
		 */
		override public function execute():void
		{
			model.isJavaHomeValid();
			red5Manager.start();
		}
	}
}

