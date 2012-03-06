package Core 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author gera
	 */
	public class Bullet 
	{
		var _movie: MovieClip;
		var targetPoint: Point;
		var _damage: Number = 0;
		
		var mcTouch: MovieClip = null;
		
		var _speed: Number = 15;
		
		public function Bullet() 
		{
			targetPoint = new Point();
		}
		
		
	
		public function live(level: Level)
		{
			
			Utils.moveToPoint(movie, targetPoint, speed, true);
			
			if ((movie.x < 0) && (movie.x > level.battlefield.width))
			{
				level.destroyBullet(this);
				return;				
			}
			
			//if ((Math.abs(targetPoint.x - movie.x) <= speed) || (Math.abs(targetPoint.y - movie.y) <= speed))
			//{
				//level.destroyBullet(this);
				//return;
			//}
			
			var p: Point = movie.localToGlobal(new Point(mcTouch.x, mcTouch.y));
			
			var dobj: SceneObject = level.getObjectHitTested(p.x, p.y);////level.getClosestObjectToPoint(p.x, p.y, movie.height);
			
			if (dobj)
			{				
			////	if (level.hittestObject(p.x, p.y, dobj))
				{
					movie.visible = false;										
					
					level.damageObject(damage, dobj);
					level.destroyBullet(this);
				}			
			}
			
			var enemy: EnemyAbstract = level.getEnemyHitTested(p.x, p.y);
			
			if (enemy)
			{
				movie.visible = false;									
				
				level.damageEnemy(enemy);
				level.destroyBullet(this);				
			}

			////else
			//{			
				//var moveVector : Point = new Point(movie.x - targetPoint.x, movie.y - targetPoint.y);
				//moveVector.normalize(1);
				//movie.x -= moveVector.x;
				//movie.y -= moveVector.y;
				//
				//
				//var abs1 = Math.abs(targetPoint.x - movie.x);
				//var abs2 = Math.abs(targetPoint.y  - movie.y);
				//if ((abs1 <= 3) &&	(abs2 <= 3))
				//{
					//movie.visible = false;
				//}				
				//
				//var p: Point = movie.parent.localToGlobal(new Point(movie.x, movie.y));
				//
				//var a1 = targetPoint.y - p.y;
				//var b1 = targetPoint.x - p.x;
				//
				//var radians1 = Math.atan2(a1, b1);
				//
				//var degrees1 = radians1 / (Math.PI / 180);
				//movie.rotation = (degrees1);
			//}
			
			
		}
		
		public function setDestination(x: Number, y: Number)
		{
			targetPoint.x = x;
			targetPoint.y = y;
		}
		
		public function get damage():Number 
		{
			return _damage;
		}
		
		public function set damage(value:Number):void 
		{
			_damage = value;
		}
		
		public function get movie():MovieClip 
		{
			return _movie;
		}
		
		public function set movie(value:MovieClip):void 
		{
			_movie = value;
			mcTouch = _movie.getChildByName("i_mc_touch_point") as MovieClip;
			
			if (mcTouch == null)
			{
				mcTouch = movie;
			}
			else			
			{
				mcTouch.visible = false;
			}
			
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
	}

}