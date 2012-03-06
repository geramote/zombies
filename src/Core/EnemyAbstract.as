package Core 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.*;
	import gs.TweenMax;
	/**
	 * ...
	 * @author gera
	 */
	public class EnemyAbstract 
	{
		
		private var _movie: MovieClip;
		private var touches: ObjectList = new ObjectList();
		var life: Number = 3;
		var speed: Number = 0.5;
		var startSpeed: Number = speed;
		var damagePoints: Number = 3;
		var damageInterval: Number = 500;
		var state: String = "";
		
		
		var mcHealth: MovieClip = new MovieClip();
		
		var stateMovingUp: String = "stateMovingUp";
		var stateMovingDown: String = "stateMovingDown";
		var stateMovingRight: String = "stateMovingRight";
		var stateMovingLeft: String = "stateMovingLeft";		
		
		var moveStates: StringList = new StringList();
		
		var lastKickTime: Number = Time.instance.getMilliseconds();
		
		const STATE_GO_ROUND: String = "STATE_GO_ROUND";
		
		var go_round_point: Point = new Point();
		
		
		
		function processIntersections(level: Level)
		{
			
			for (var i:int = 0; i < level.objects.count; i++) 
			{
				var so:SceneObject = SceneObject(level.objects.getItem(i));
				
				var rectObject: Rectangle = so.movie.getRect(level.movie);
				var rectEnemy: Rectangle = _movie.getRect(level.movie);
				var rectPlayer: Rectangle = level.player.movie.getRect(level.movie);
				
				if (rectEnemy.intersects(rectObject))
				{
					if (rectEnemy.bottom > rectObject.bottom)
					{
						level.battlefield.addChildAt(so.movie, level.battlefield.getChildIndex(_movie) - 1);
					}
					else
					{
						var index: int = level.battlefield.getChildIndex(so.movie) - 1;
						if (index == 0) index = 1;
						
						level.battlefield.addChildAt(_movie, index);
					}
				}
				
				if (rectEnemy.intersects(rectPlayer))
				{
					var index: int = level.battlefield.getChildIndex(level.player.movie);
					level.battlefield.addChildAt(_movie, index + 1);
				}				
				
			}
		}		
		
		public function init(mc: MovieClip)
		{
			lastKickTime = Time.instance.getMilliseconds();
			_movie = mc;			
			for (var i:int = 0; i < _movie.numChildren; i++)
			{
				var dobj: DisplayObject = _movie.getChildAt(i);
				
				if (dobj.name.indexOf("i_mc_touch_") >= 0)
				{
					dobj.visible = false;
					touches.add(dobj);
				}
			}
			
			////speed = speed + (Utils.randRange( -10, 10)) / 10;
			
			
			var className: String = getQualifiedClassName(mc);
			
			var index: int = Consts.ENEMY_CLASSES.indexOf(className);
			speed = Consts.ENEMY_SPEED[index];			
			damagePoints = Consts.ENEMY_DAMAGE[index];
			
			_movie.scaleX = Consts.MONSTERS_SCALE;
			_movie.scaleY = Consts.MONSTERS_SCALE;
		}
		
		public function EnemyAbstract() 
		{			
		}
		
		public function get clip():MovieClip 
		{
			return _movie;
		}
		
		public function set clip(value:MovieClip):void 
		{
			_movie = value;
		}
		

		
		
		var moveAround: Boolean = false;
		
		function moveToPoint(obj: DisplayObject, point: Point, speed: Number, level: Level)
		{
			
			if (moveAround)
			{
				return;
			}
			
			
			if (level.getDistaceToPLayer(_movie.x, _movie.y) <= 20)
			{
				if ((Time.instance.getMilliseconds() - lastKickTime) > damageInterval)
				{
					level.damagePlayer(damagePoints);
					
					lastKickTime = Time.instance.getMilliseconds();
					
				}
				return;
			}
			
			var object: SceneObject = level.getClosestObjectToPoint(_movie.x, _movie.y, 50);
			moveStates.clear();
			
			if (obj.x < point.x)
			{
				obj.x += speed;
				moveStates.add(stateMovingRight);
			}
			else
			{
				obj.x -= speed;
				moveStates.add(stateMovingLeft);
			}
			
			if (obj.y < point.y)
			{
				obj.y += speed;
				
				
				moveStates.add(stateMovingDown);
			}
			else
			{
				obj.y -= speed;
				
				moveStates.add(stateMovingUp);
			}
			
			_movie.scaleY = ((_movie.y / level.battlefield.height) + 0.6) * 0.7;
			_movie.scaleX = _movie.scaleY;
			
			
			if ((object != null) && (!(object.movie.name.indexOf("_BG") >=0)))
			{
				if ((object.movie.x > _movie.x) && (moveStates.indexOf(stateMovingRight) >= 0))
				{
					_movie.x -= speed;
					TweenMax.to(_movie, 1, { x: _movie.x , y: _movie.y + 20, onComplete: moveAroundComplete, onCompleteParams: [object] } );
					moveAround = true;
					
				}
				
				if ((object.movie.x < _movie.x) && (moveStates.indexOf(stateMovingLeft) >= 0))
				{
					_movie.x += speed;					
					
					TweenMax.to(_movie, 1, { x: _movie.x, y: _movie.y + 20, onComplete: moveAroundComplete, onCompleteParams: [object] } );
					moveAround = true;
					
					
					
				}
				
				if ((object.movie.y > _movie.y) && (moveStates.indexOf(stateMovingDown) >= 0))
				{
					_movie.y -= speed;
					
					TweenMax.to(_movie, 0.1, { x: _movie.x +  20 , y: _movie.y, onComplete: moveAroundComplete, onCompleteParams: [object] } );
					
					moveAround = true;
				
					
				}
				
				if ((object.movie.y < _movie.y) && (moveStates.indexOf(stateMovingUp) >= 0))
				{
					_movie.y += speed;
					
					moveAround = true;
					TweenMax.to(_movie, 0.1, { x: _movie.x + 20, y: _movie.y, onComplete: moveAroundComplete, onCompleteParams: [object] } );					
				}
			}
		}
		
		private function moveAroundComplete(obj: SceneObject):void 
		{
			moveAround = false;
		}
		
		
		public function live(level: Level)
		{	
			moveToPoint(_movie, new Point(level.player.movie.x, level.player.movie.y), speed, level);
			processIntersections(level);
			return;
		}
		
		public function damage(points: Number)
		{
			life -= points;
		}
		
	}

}