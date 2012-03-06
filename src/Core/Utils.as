package  Core
{	
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.xml.XMLDocument;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Utils 
	{
		
		public static function getClassObject(className: String): Object
		{
			var ClassReference:Class = getDefinitionByName(className) as Class;
			var mc: Object = (new ClassReference() as Object);
			return mc;
		}
		
		
		public static function getClassMovieClip(className: String): MovieClip
		{
			var ClassReference:Class = getDefinitionByName(className) as Class;
			var mc: Object = (new ClassReference() as Object);
			return MovieClip(mc);
		}
		
		
		public static function getClass(className: String): Class
		{
			var ClassReference:Class = getDefinitionByName(className) as Class;
			return ClassReference;
		}
		
		public  static function randRange(minNum:int, maxNum:int):int
		{
				return int(Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		
		public static function moveToPoint(obj:Object, target:Point, speed:Number = 1, objRot:Boolean = false):void
		{
			// get the difference between obj and target points.
			var diff:Point = target.subtract(new Point(obj.x, obj.y)); 
			var dist = diff.length;
			
			if (dist <= speed)  // if we will go past when we move just put it in place.
			{
				obj.x = target.x;
				obj.y = target.y;
			}
			else // If we are not there yet. Keep moving.
			{ 
				diff.normalize(1);
				obj.x += diff.x * speed;
				obj.y += diff.y * speed;
				
				if (objRot) // If we want to rotate with our movement direction.
				{ 
					obj.rotation = Math.atan2(diff.y, diff.x) * (180 / Math.PI) + 90;
				}
			}
		}
		
		public static function rasterizeMovieClip(obj: Sprite, bdLev: int): Bitmap
		{
			
			var _par: DisplayObjectContainer = obj.parent;
			
			var _lev = (bdLev) ? bdLev : _par.numChildren-1;
			
			var bd_mc: MovieClip = new MovieClip();
			bd_mc.name = obj.name + "BD";
			_par.addChild(bd_mc);
			////_par.createEmptyMovieClip(obj._name + "BD", _lev);
			
			var bd = new BitmapData(obj.width, obj.height, true, 0x00000000);
			
			bd.draw(obj);
			var bmp: Bitmap = new Bitmap(bd);
			bd_mc.addChild(bmp);
			
			
			
			
			
			bd_mc.x = obj.x;
			bd_mc.y = obj.y;
			////obj.swapDepths(_par.getNumChildren());
			
			_par.removeChild(obj);
			
			return bmp;
		}
		
		public static function desaturateClipSepia(clip:DisplayObject, saturation:Number = 1)
		{
			var sepia:ColorMatrixFilter = new flash.filters.ColorMatrixFilter();
		   sepia.matrix = [0.3930000066757202, 0.7689999938011169, 
				0.1889999955892563, 0, 0, 0.3490000069141388, 
				0.6859999895095825, 0.1679999977350235, 0, 0, 
				0.2720000147819519, 0.5339999794960022, 
				0.1309999972581863, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			var filtersArr:Array = clip.filters;
			filtersArr.unshift(sepia);
			clip.filters = filtersArr;
			
		}		

		
	}	
}