package Core 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author gera
	 */
	public class SceneObject extends IdableObject
	{
		private var _mask: MovieClip;
		private var _movie: MovieClip;
		private var _life: Number = 10;
		
		public function SceneObject() 
		{			
		}
		
		public function get mask():MovieClip 
		{
			return MovieClip(movie.getChildByName("i_mc_shape"));
		}
		
		public function set mask(value:MovieClip):void 
		{
			_mask = value;
		}
		
		public function get movie():MovieClip 
		{
			return _movie;
		}
		
		public function set movie(value:MovieClip):void 
		{
			_movie = value;
			
			if (mask)
			{
				mask.visible = false;
			}			
		}
		
		public function get life():Number 
		{
			return _life;
		}
		
		public function set life(value:Number):void 
		{
			_life = value;
		}
		
		public function damage(points: Number)
		{
			life -= points;
		}
		
	}

}