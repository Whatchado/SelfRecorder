
package com.antistatus.whatchado.controller
{
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.service.ConfigDataService;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/**
	 */
	public class InitConfigCommand extends Command
	{

		[Inject]
		public var model:MainModel;

		[Inject]
		public var configDataService:ConfigDataService;

		/**
		 *
		 */
		override public function execute():void
		{
			
			configDataService.loadLocalConfig();
		}
	}
}

