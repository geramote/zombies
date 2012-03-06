package Core 
{
	import flash.display.MovieClip;
	import gs.TweenMax;
	import flash.events.Event;

	/**
	 * ...
	 * @author gera
	 */
	public class WeaponKnife extends Weapon
	{
		var tm: TweenMax;
		
		
		public function WeaponKnife() 
		{	
			type = Consts.WEAPON_TYPE_KNIFE;
			_movieClassName = "mc_weapon_knife";
			bulletsLeft = -1;
		}
		
		public override function fire(): Bullet
		{
			if (tm)
			{
				tm.complete(true);				
			}
			
			dispatchEvent(new Event(ON_SHOOT));
			tm = TweenMax.to(_movie, 0.1, { rotation: _movie.rotation + 70, onComplete: handleFirstTweenComplete, onCompleteParams: [movie] } );
			
			
			return null;
		}
		
		private function handleFirstTweenComplete(mc: MovieClip):void 
		{
			tm  = TweenMax.to(_movie, 0.1, { rotation: 0} );
		}
	}

}