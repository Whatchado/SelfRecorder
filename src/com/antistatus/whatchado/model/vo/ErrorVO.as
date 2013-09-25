
package com.antistatus.whatchado.model.vo
{

	public class ErrorVO
	{

		/**
		 * A custom value object for Error Messages
		 */
		public function ErrorVO(id:String, label:String, content:String)
		{
			_id = id;
			_label = label;
			_content = content;
		}

		private var _content:String;

		public function get content():String
		{
			return _content;
		}
		private var _id:String;

		public function get id():String
		{
			return _id;
		}
		private var _label:String;

		public function get label():String
		{
			return _label;
		}
	}
}

