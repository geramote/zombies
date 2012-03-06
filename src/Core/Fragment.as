package Core 
{
	/**
	 * ...
	 * @author ...
	 */
import flash.display.BitmapData;
import flash.geom.*;
import flash.events.*;
import flash.display.MovieClip;
import flash.display.Bitmap;
import flash.utils.Timer;
import gs.*;

/**
 * All script is copyrighted by codemonkey (ultrashock.com)
 * Don't distribute for commercial use without my consent.
 * Don't distribute for non-commercial without this copyright notice.
 *
 * mail me at: b.bottema@planet.nl
 * ------
 *
 * Fragment:
 * - Duplicates a movieclip, applies a mask the size oft he fragment.
 * - Does not calculate where the fragment is supposed to be, but 
 * 
 */
class Fragment {
	// the movieclip the fragment is part of
	private var explodee:MovieClip;	
	// the fragment and its mask
	private var fragment:MovieClip;
	//private var mask:MovieClip;
	
	// fragment characteristics
	public static var flyDeltaX = 10;
	public static var flyDeltaY = 10;
	public static var alphaDelta = 10;
	public static var scaleDeltaX = 20;
	public static var scaleDeltaY = 20;
	
	// the target position of the fragment
	private var targetx:Number;
	private var target_y:Number;
	
	/**
	 * constructor 			Creates the fragment, by duplicating the original movieclip and 
	 *						applying a fragment-mask to it. Does not make the fragment fly.
	 * @param	explodee	the movieclip that's exploding
	 */
	public function Fragment(explodee:MovieClip, w:Number, h:Number, x:Number, y:Number) {
		this.explodee = explodee;
		createFragment();
		createMask(w, h, x, y);
	}
	
	/**
	 * Makes the fragment fly away to the specified target position.
	 * Animates alpha and scale factors along the way, using the delta properties
	 */
	public function explode(targetx:Number, target_y:Number) {
		this.targetx = targetx;
		this.target_y = target_y;
		
		////var zz: Number = Utils.randRange(-400, 400);
		TweenMax.to(fragment, 2, {x: targetx - 20, y: target_y, alpha: 0, scaleX: 0, scaleY: 0, onComplete: handleTweenComplete, onCompleteParams: [fragment]});
		///fragment.addEventListener(Event.ENTER_FRAME, fragmentFly, false, 0, true);////onEnterFrame = Delegate.create(this, fragmentFly);
	////	fragment.play();
	
/*
 		fragment.x += (targetx - fragment.x) / flyDeltaX; 
		fragment.y += (target_y - fragment.y) / flyDeltaY;
		fragment.alpha += (0 - fragment.alpha) / alphaDelta;
		fragment.scaleX += (0 - fragment.scaleX) / scaleDeltaX;
		fragment.scaleY += (0 - fragment.scaleY) / scaleDeltaY;
		
		// check if fragment has finished flying away
		if (fragment.alpha < 5) {
			fragment.parent.removeChild(fragment);
		}
 */	
		
		
		
		
	}
	
	private function handleTweenComplete(mc: MovieClip)
	{
		fragment.parent.removeChild(fragment);
	}
	
	/**
	 * Duplicates the original movieclip
	 */
	private function createFragment() {
		// create a duplicate of the original movieclip for new fragment
		var depth:Number = explodee.parent.numChildren - 1;
		//fragment = explodee.duplicateMovieClip(explodee._name + depth, depth);
		
		fragment = new MovieClip();
		fragment.name = explodee.name + depth;
		
		explodee.parent.addChildAt(fragment, depth);
		//var mask: MovieClip = new MovieClip();
		//
		//mask.graphics.beginFill(0);
		//mask.graphics.drawRect(0, 0, fragment.width, fragment.width);
		//mask.graphics.endFill();
		//mask.x = fragment.x;
		//mask.y = fragment.y;
		//
		//fragment.parent.addChild(mask);
		//
		//fragment.mask = mask;
		
		///explodee.parent.ccreateEmptyMovieClip(explodee._name + depth, depth);
	}
	
	/**
	 * Creates a mask to apply to the duplicate, which 'simulates' a fragment
	 * The size and position are calculated by the explode method in Exploder.
	 */
	private function createMask(w:Number, h:Number, x:Number, y:Number) {
		
		// first draw the explodee to a bitmap
		////Utils.stage.addChild(explodee);
		var rect1:BitmapData = new BitmapData(explodee.width, explodee.height, true, 0x00000000);
		////var m:Matrix = explodee.transform.matrix;
		////m.tx = m.ty = 0; // don't include the translation info
		var colorTransForm:ColorTransform = explodee.transform.colorTransform;
		rect1.draw(explodee, null, colorTransForm, null, new Rectangle(x, y, w, h));
		
		
		// copy the fragment piece to a new smaller bitmap
		var rect2:BitmapData = new BitmapData(w, h, true, 0x00000000);
		rect2.copyPixels(rect1, new Rectangle(x, y, w, h), new Point(0,0));
		var bm: Bitmap = new Bitmap(rect2);		// assign the fragment bitmap to the movieclip
		fragment.addChild(bm);
		
		// synchronize position
		
/*		var mask: MovieClip = new MovieClip();
		
		mask.graphics.beginFill(0);
		mask.graphics.drawCircle(0, 0, bm.width / 2);
		mask.graphics.endFill();
		fragment.addChild(mask);
		bm.mask = mask;*/
		
		
		fragment.x = explodee.x + x;
		fragment.y = explodee.y + y;
	}
	
	/**
	 * The engine function for each fragment. Makes the fragment fly
	 * to its destination and so applying the delta properties to
	 * animate x, _y, _alpha, xscale and _yscale.
	 * When finished (meaninng particle isn't visible anymore), first
	 * deletes the fragment, then the mask.
	 */
	public function handleTimer(e: TimerEvent) {
		// calculate the steps in both directions, and calculate alpha, scale
		fragment.x += (targetx - fragment.x) / flyDeltaX; 
		fragment.y += (target_y - fragment.y) / flyDeltaY;
		fragment.alpha += (0 - fragment.alpha) / alphaDelta;
		fragment.scaleX += (0 - fragment.scaleX) / scaleDeltaX;
		fragment.scaleY += (0 - fragment.scaleY) / scaleDeltaY;
		
		// check if fragment has finished flying away
		if (fragment.alpha < 5) {
			fragment.parent.removeChild(fragment);
		}
	}
}
}