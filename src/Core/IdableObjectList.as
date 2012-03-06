package Core 
{
	
	/**
	 * ...
	 * @author gera
	 */
	public class IdableObjectList extends ObjectList
	{
		
		public function IdableObjectList() 
		{
			
		}
		
		public function getItemById(id: String): IdableObject
		{
			for (var i: int = 0; i < count; i ++)
			{
				var ob:IdableObject = IdableObject(getItem(i));
				if (ob.id == id) return ob;
			}
			
			return null;
		}
	
		
	}
	
}