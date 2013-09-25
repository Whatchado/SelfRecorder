
package com.antistatus.whatchado.utilities
{
	import com.antistatus.whatchado.event.StreamClientEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class StreamClient extends EventDispatcher
	{

		public function StreamClient(target:IEventDispatcher = null)
		{
			super(target);
		}

		private var _creationDate:Date = new Date();

		/** RTMP Sample handler (what is this for?). **/
		public function RtmpSampleAccess(... rest):void
		{
			forward(rest[0], 'rtmpsampleaccess');
		}

		/** Checking the available bandwidth. **/
		public function close(... rest):void
		{
			forward({close: true}, 'close');
		}

		/** Checking the available bandwidth. **/
		public function onBWCheck(... rest):Number
		{
			return 0;
		}

		/** Receiving the bandwidth check result. **/
		public function onBWDone(... rest):void
		{
			if (rest.length > 0)
			{
				forward({bandwidth: rest[0]}, 'bandwidth');
			}
		}

		/** Captionate caption handler. **/
		public function onCaption(cps:String, spk:Number):void
		{
			forward({captions: cps, speaker: spk}, 'caption');
		}

		/** Captionate metadata handler. **/
		public function onCaptionInfo(obj:Object):void
		{
			forward(obj, 'captioninfo');
		}

		/** Cuepoint handler. **/
		public function onCuePoint(obj:Object):void
		{
			forward(obj, 'cuepoint');
		}

		/** CDN subscription handler. **/
		public function onFCSubscribe(obj:Object):void
		{
			forward(obj, 'fcsubscribe');
		}

		/** TimeCode handler (see http://help.adobe.com/en_US/FlashMediaLiveEncoder/3.0/Using/WS5b3ccc516d4fbf351e63e3d11c104ba9cd-7ffe.html) **/
		public function onFI(obj:Object):void
		{
			//	forward(obj, 'timecode');
		}

		/** Get headerdata information from netstream class. **/
		public function onHeaderData(obj:Object):void
		{
			var dat:Object = new Object();
			var pat:String = "-";
			var rep:String = "_";

			for (var i:String in obj)
			{
				var j:String = i.replace("-", "_");
				dat[j] = obj[i];
			}
			forward(dat, 'headerdata');
		}

		/** Image data (iTunes-style) handler. **/
		public function onID3(... rest):void
		{
			forward(rest[0], 'id3');
		}

		/** Image data (iTunes-style) handler. **/
		public function onImageData(obj:Object):void
		{
			forward(obj, 'imagedata');
		}

		/** Lastsecond call handler. **/
		public function onLastSecond(obj:Object):void
		{
			forward(obj, 'lastsecond');
		}

//		public function onFI(info:Object):void
//		{
//			var st:String = info.st;
//
//			// sample: 09:30:55.592
//			if (!st.match(/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\.[0-9]+$/))
//				return;
//			var parts:Array = st.split(".");
//			var stTime:Number = Date.parse(st);
//			trace(st);
//		}

		/** Get metadata information from netstream class. **/
		public function onMetaData(obj:Object):void
		{
			dispatchEvent(new StreamClientEvent(StreamClientEvent.META_DATA, obj, false));
		}

		/** Receive NetStream playback codes. **/
		public function onPlayStatus(... rest):void
		{
			for each (var dat:Object in rest)
			{
				if (dat && dat.hasOwnProperty('code'))
				{
					if (dat.code == "NetStream.Play.Complete")
					{
						dispatchEvent(new StreamClientEvent(StreamClientEvent.PLAY_COMPLETE, null, false));
					}
					else
					{
						dispatchEvent(new StreamClientEvent(StreamClientEvent.PLAY_STATUS, dat, false));
					}
				}
			}
		}

		/** Quicktime broadcaster pixel. **/
		public function onSDES(... rest):void
		{
			forward(rest[0], 'sdes');
		}

		/** Textdata handler (MP4 text tracks). **/
		public function onTextData(obj:Object):void
		{
			forward(obj, 'textdata');
		}

		public function onXMP(... rest):void
		{
			onXMPData(rest);
		}

		/** Receiving the bandwidth check result. **/
		public function onXMPData(... rest):void
		{
			forward(rest[0], 'xmp');
		}


		/*	*********************************************************************************
		 *	*																				*
		 *	*				PRIVATE METHODS													*
		 *	*																				*
		 *	*********************************************************************************
		 */

		/** Forward calls to callback **/
		private function forward(dat:Object, typ:String):void
		{
			dat['type'] = typ;
			var out:Object = new Object();

			for (var i:Object in dat)
			{
				out[i] = dat[i];
			}
			dispatchEvent(new StreamClientEvent(StreamClientEvent.MESSAGE, out, false));
		}
	}
}

