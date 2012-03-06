package Core 
{
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author ...
	 */
public class Exploder {

	/**
	 * constructor: no instance allowed -> static facility
	 */
	public  function Exploder() {
		// private
	}

	/**
	 * The exploding method that makes a movieclip explode.
	 * @param	explodee	The movieclip to explode
	 * @param	pieces		The number of fragments uses in explosion
	 */
	public static function explode(explodee:MovieClip, pieces:Number, radius: Number) {
		var columns:Number = Math.ceil(Math.sqrt((explodee.width / explodee.height) * pieces));
		var rows:Number = (pieces / columns);
		
		// create fragments
		for (var i = 0; i < pieces; i++) {
			// calculate the column and row
			var col:Number = i % columns;
			var row:Number = (i - col) / columns;
			
			// use column and row to determine the size and position of the fragment
			var w:Number = explodee.width / columns;
			var h:Number = explodee.height / rows;			
			var x:Number = col * (explodee.width / columns);
			var y:Number = row * (explodee.height / rows);
			
			
			
			// determine target of the fragment
			
			var kk: int = Utils.randRange(0, 2);
			
			if (kk == 0)
			{
				kk = -1
			}
			
			var tx:Number = Utils.randRange(explodee.x - radius - explodee.width, explodee.x + radius + explodee.width );
			
			
			
			var ty:Number = Utils.randRange(explodee.y - radius - explodee.height, explodee.y + radius + explodee.height);
			
			// create a new fragment	
			
			if (tx > explodee.parent.width)
			{
				tx = explodee.parent.width - 50;
			}
			var fragment:Fragment = new Fragment(explodee, w, h, x, y);
			fragment.explode(tx, ty);
		}

		// make the exploded movieclip go away
		explodee.visible = false;
		explodee.parent.setChildIndex(explodee, explodee.parent.numChildren - 1);

	}
	
	/**
	 * Changes the fragments' flying speed
	 */
	public static function tweakFlyspeed(flyDeltaX:Number, flyDeltaY:Number) {
		Fragment.flyDeltaX = flyDeltaX;
		Fragment.flyDeltaY = flyDeltaY;
	}	
	
	/**
	 * Changes the fragments' alpha'ing speed
	 */
	public static function tweakAlphaspeed(alphaDelta:Number) {
		Fragment.alphaDelta = alphaDelta;
	}	
	
	/**
	 * Changes the fragments' scaling speed
	 */
	public static function tweakScalespeed(scaleDeltaX:Number, scaleDeltaY:Number) {
		Fragment.scaleDeltaX = scaleDeltaX;
		Fragment.scaleDeltaY = scaleDeltaY;
	}
}

}