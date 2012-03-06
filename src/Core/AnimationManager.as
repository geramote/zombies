package Core 
{
	import flash.display.MovieClip;
	import flash.events.*;
	/**
	 * ...
	 * @author gera
	 */
	public class AnimationManager 
	{
		
		public function AnimationManager() 
		{
			
		}
		
		public static function animateExplosionDusty(clipToExplode: MovieClip)
		{

			
			var mcExplode: MovieClip = Utils.getClassMovieClip("mc_explosion_dusty");
			
			if (mcExplode)
			{
				mcExplode.x = clipToExplode.x;
				mcExplode.y = clipToExplode.y;
				clipToExplode.parent.addChild(mcExplode);
				mcExplode.addEventListener(Event.ENTER_FRAME, handleExplosionEnterFrame, false, 0, true);
				mcExplode.gotoAndPlay(0);
			}
			
			if (clipToExplode.parent)
			{
				clipToExplode.parent.removeChild(clipToExplode);
			}			
		}
		
		static private function handleExplosionEnterFrame(e:Event):void 
		{
			var mc: MovieClip = e.currentTarget as MovieClip;
			
			if ((mc.currentFrame == mc.totalFrames) && (mc.parent))
			{
				mc.parent.removeChild(mc);
			}
		}
		
		public static function animateExplosionFiry()
		{}
		
	}

}