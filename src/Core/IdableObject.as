package  Core
{
	
	/**
	 * ...
	 * @author gera
	 */
	public class IdableObject
	{
		private var ID: String = "";
		
		public function IdableItem() 
		{			
		}
		
		public function get id(): String 
		{
			return ID;
		}
		
		public function set id(val: String)
		{
			ID = val;
		}
	}
	
}