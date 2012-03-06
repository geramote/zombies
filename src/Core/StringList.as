package Core
{
	import flash.display.DisplayObject;
	
	/**
	* ...
	* @author Default
	*/
	public class StringList	
	{
		private var items_: ObjectList;
		
		public function StringList() {
			items_ = new ObjectList();
		}
		
		public function add(str: String)
		{
			items_.add(str);
		}
		
		public function removeAt(index: int)
		{
			items_.remove(index);
		}
		
		public function indexOf(str: String, ignoreCase: Boolean = false): int
		{
			for (var i: int = 0; i < items_.count; i ++)
			{
				var s: String = String(items_.getItem(i));
				
				if (ignoreCase)
				{
					if (s.toUpperCase() == str.toUpperCase())
					{
						return i;
					}
				}
				else
				{
					if (s == str)
					{
						return i;
					}
				}
			}
			return -1;
		}
		
		public function itemAt(index: int): String
		{
			if (index > items_.count - 1)
			{
				return "";
			}
			
			return String(items_.getItem(index));
		}
		
		public function get count(): int
		{
			return items_.count;
		}
		
		public function clear()
		{
			items_.clear();
		}
		
		public function sort()
		{
/*				for i := 0 to lbNum.Count - 2 do
				begin
				  b_val := StrToInt(lbNum[i]);
				  b_j := i;
				  for j := i + 1 to lbNum.Count - 1 do
				  begin
					if StrToInt(lbNum[j]) < b_val then
					begin
					  b_val := StrToInt(lbNum[j]);
					  b_j := j;
					end;
				  end;
				  lbNum[b_j] := lbNum[i];
				  lbNum[i] := IntToStr(b_val);
				end;
*/
			if (count > 1)
			
			for (var i: int = 0; i < count - 1; i ++)
			{
				var str_t: String = itemAt(i);
				var bj: int = i;
				
				for (var j: int = i + 1; j < items_.count; j ++)
				{
					if (itemAt(j) < str_t)
					{
						str_t = itemAt(j);
						bj = j
					}
				}
				var it: Object = items_.getItem(bj);
				it = items_.getItem(i);
				var it2: Object = items_.getItem(i);
				it2 = str_t;
			}
		}
	}
	
}
