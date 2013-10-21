
package com.antistatus.whatchado.view.component
{
	
	import com.antistatus.whatchado.event.ViewEvent;
	import com.antistatus.whatchado.model.MainModel;
	import com.antistatus.whatchado.utilities.Trace;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class UploadViewMediator extends Mediator
	{

		public function UploadViewMediator()
		{
			//
		}

		[Inject]
		public var model:MainModel;

		[Inject]
		public var view:UploadView;

		override public function initialize():void
		{
			Trace.log(this, "initialized!");
			addViewListener(ViewEvent.CLICK, uploadClickHandler);
		}
		
		private function uploadClickHandler(event:ViewEvent):void
		{
			//get a reference to the desktop and suggets a filename plus extension
			
			var f:File = File.desktopDirectory.resolvePath('story.zip');
			//listen for the select event
			
			f.addEventListener(Event.SELECT, onBrowse);
			//open the browse for save dialogue
			
			f.browseForSave("Save Story");
		}
		
		// actually save the image
		
		private function onBrowse(e:Event):void
		{             
			
			
			var file:File = File(e.target);
			var fileStream:FileStream = new FileStream();
			
			
			//zip = new Zip();
			
			try
			{
				fileStream.open(file,FileMode.WRITE);
				//close the file
				
				fileStream.close();                
			}
			catch(e:Error)
			{                
				Trace.log(this,e.message);                
			}
		}
		
	}
}

