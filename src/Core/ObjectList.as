package Core
{
	
	public class ObjectList
	{
		private var list_: Array;
		
		public function ObjectList()
		{
			list_ = new Array();
		}
		
		public function add(obj:Object)
		{
			list_.push(obj);
		}
		
		public function getItem(index:int):Object
		{
			return list_[index];
		}
		
		public function get count():Number
		{
            return list_.length;
        }
		
		public function remove(index:int, allInstances: Boolean = true)
		{
			var removedItem:Object = Object(list_[index]);
			
			var newArray:Array = new Array();
			
			for (var i:int = 0; i < list_.length; i++)
			{
				if (removedItem != Object(list_[i]))
				{
					newArray.push(Object(list_[i]));
				}
				else
				{
					if (!allInstances)
					{
						removedItem = null;
					}					
				}				
			}
			
			clear();
			list_ = newArray;
		}
		
		public function clear()
		{
			while (list_.length > 0)
			{
				list_.pop();
			}
		}
		
		public function getItemIndex(item: Object): int
		{
			for (var i: int = 0; i < count; i ++ )
			{
				var obj: Object = getItem(i);
				if (obj == item)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function removeObject(item: Object, allInstances: Boolean = true)
		{
			for (var iIndex: int = 0; iIndex < count; iIndex ++)
			{
				var object: Object = getItem(iIndex);
				if (object == item)
				{
					remove(iIndex, allInstances);
					return;
				}
			}
		}
		
		public function insert(index: int, item: Object)
		{
			var newArray: Array = new Array();
			
			for (var i: int = 0; i < index; i ++)
			{
				newArray.push(list_[i]);				
			} 
			
			newArray.push(item);
			
			for (i = i; i < list_.length; i ++)
			{
				newArray.push(list_[i]);
			}
			
			list_ = newArray;
		}
		
		
		
		public function setItem(index: int, item: Object)
		{
			list_[index] = item;
		}
		
		public function sort()
		{
			list_.sort();
		}
		
		public function reverse()
		{
			var tmpList: ObjectList = new  ObjectList();
			
			for (var i:int = count - 1; i >= 0; i --) 			
			{
				tmpList.add(getItem(i));
			}
			
			assign(tmpList);			
		}
		
		public function assign(lst: ObjectList)
		{
			clear();
			
			for (var i:int = 0; i < lst.count; i++) 
			{
				add(lst.getItem(i));
			}
		}
	
		
	}
}