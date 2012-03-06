package Core 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author gera
	 */
	public class Player extends EventDispatcher
	{
		public static const ON_LIFE_OVER: String = "ON_LIFE_OVER";
		
		private var _movie: MovieClip;
		private var _mask: MovieClip = new MovieClip();
		private var _state: String = Consts.STATE_STOPPED;
		
		private var _states:  StringList = new StringList();		
		private var touches: ObjectList = new ObjectList();
		private var _weapon: Weapon;
		
		private var _weapons: ObjectList = new ObjectList();
		
		private var _life: Number = 10;
		private var _totalLife: Number = life;
		
		private var _money: int = 0;
		
		public function addState(st: String)
		{
			if (_states.indexOf(st) == -1)
			{
				_states.add(st);
			}
			
			if (st == Consts.STATE_STOPPED)
			{
				_states.clear();
				_states.add(st);
			}
		}
		
		public function removeState(st: String)
		{
			var ind: int = _states.indexOf(st);
			
			if (ind >= 0)
			{
				_states.removeAt(ind);
			}
		}		
		
		public function Player() 
		{
			
		}
		
		public function get movie():MovieClip 
		{
			return _movie;
		}
		
		public function set movie(value:MovieClip):void 
		{
			_movie = value;
			
			var bmd: BitmapData = new BitmapData(_movie.width, _movie.height, true, 0);
			bmd.draw(movie);
			var bitmap: Bitmap = new Bitmap(bmd);
			mask.addChild(bitmap);
			
			for (var i:int = 0; i < movie.numChildren; i++) 
			{
				var child: DisplayObject = movie.getChildAt(i);
				
				if (child.name.indexOf("i_touch") == 0)
				{
					child.visible = false;
					touches.add(child);
				}
			}
		}
		
		public function get mask():MovieClip 
		{
			return _mask;
		}
		
		public function set mask(value:MovieClip):void 
		{
			_mask = value;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			_state = value;
		}
		
		public function get weapon():Weapon 
		{
			return _weapon;
		}
		
		public function set weapon(value:Weapon):void 
		{
			_weapon = value;
		}
		
		public function get totalLife():Number 
		{
			return _totalLife;
		}
		
		public function set totalLife(value:Number):void 
		{
			_totalLife = value;
		}
		
		public function get life():Number 
		{
			return _life;
		}
		
		public function set life(value:Number):void 
		{
			_life = value;
		}
		
		public function get weapons():ObjectList 
		{
			return _weapons;
		}
		
		public function set weapons(value:ObjectList):void 
		{
			_weapons = value;
		}
		
		public function get money():int 
		{
			return _money;
		}
		
		public function set money(value:int):void 
		{
			_money = value;
		}
		
		
		
		private function isTouchesObject(obj: SceneObject): Boolean
		{
			for (var i:int = 0; i < touches.count; i++)
			{
				var touch: DisplayObject = DisplayObject(touches.getItem(i));
				var gp: Point = movie.localToGlobal(new Point(touch.x, touch.y));
				
				if (obj.mask.hitTestPoint(gp.x, gp.y, true))
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function isInState(st: String): Boolean
		{
			return _states.indexOf(st) > -1;
		}
		
		public function live(level: Level)
		{
			
			var prevPoint: Point = new Point(movie.x, movie.y);
			
			
			
			if (_states.indexOf(Consts.STATE_MOVING_LEFT) > -1)
			{
				
				var obj: SceneObject = level.getIntersectedByPlayerObject();
				
				if (obj)
				{
					movie.x -= Consts.PLAYER_SPEED;
					if (isTouchesObject(obj) && (obj.movie.x < movie.x))
					{
						movie.x += Consts.PLAYER_SPEED * 2;						
						addState(Consts.STATE_STOPPED);
						
						return;
					}
				}
				else
				{
					movie.x -= Consts.PLAYER_SPEED;
					
				}

				////movie.rotationY = -180;
			}
			if (_states.indexOf(Consts.STATE_MOVING_RIGHT) > -1)
			{
				var obj: SceneObject = level.getIntersectedByPlayerObject();
				
				if (obj)
				{
					movie.x += Consts.PLAYER_SPEED;
					
					if (isTouchesObject(obj)&& (obj.movie.x > movie.x))
					{
						movie.x -= Consts.PLAYER_SPEED * 2;
						addState(Consts.STATE_STOPPED);
						return;
					}
					
					
				}
				else
				{
					movie.x += Consts.PLAYER_SPEED;
					
				}
				
				////movie.rotationY = 0;
				
			}
			if (_states.indexOf(Consts.STATE_MOVING_UP) > - 1)
			{
				if ((movie.y - Consts.PLAYER_SPEED) > 0)
				{
					var obj: SceneObject = level.getIntersectedByPlayerObject();
					
					if (obj)
					{
						movie.y -= Consts.PLAYER_SPEED;
						
						if (isTouchesObject(obj))
						{
							movie.y += Consts.PLAYER_SPEED*2;
							addState(Consts.STATE_STOPPED);
							return;
						}
						
						
					}
					else
					{
						movie.y -= Consts.PLAYER_SPEED;
						//movie.scaleY /= 1.03;
						//movie.scaleX = movie.scaleY;

					}
				}
			}
			if (_states.indexOf(Consts.STATE_MOVING_DOWN) > -1)
			{
				if ((movie.y + Consts.PLAYER_SPEED + movie.height) < (movie.parent.height + 80))
				{
					var obj: SceneObject = level.getIntersectedByPlayerObject();
					if (obj)
					{
						movie.y += Consts.PLAYER_SPEED;
						if (isTouchesObject(obj))
						{
							movie.y -= Consts.PLAYER_SPEED * 2;
							addState(Consts.STATE_STOPPED);
							

							
						}					
					}
					else
					{
						movie.y += Consts.PLAYER_SPEED;
						
						//movie.scaleY *= 1.03;
						//movie.scaleX = movie.scaleY;
					}
				}
				
				var obj: SceneObject = level.getIntersectedByPlayerObject();
				
				if (obj)
				{
					if (isTouchesObject(obj))
					{
						movie.x = prevPoint.x;
						movie.y = prevPoint.y;
					}
				}

			}
			
			
			movie.scaleY = ((movie.y / level.battlefield.height) + 0.6) * 0.7;
			movie.scaleX = movie.scaleY;
			
			if (_states.indexOf(Consts.STATE_STOPPED) > -1)
			{}
			
		}
		
		public function selectWeaponByIndex(ind: int): Boolean
		{
			var weapon: Weapon = Weapon(weapons.getItem(ind));
			
			if (weapon && (weapon.bulletsLeft > 0))
			{
				
				selectWeapon(weapon.type);
				return true;
			}
			
			return false;
		}
		
		public function selectWeapon(type: String)
		{
			
			if (weapon)
			{
				movie.removeChild(weapon.movie);
			}
			
			for (var i:int = 0; i < weapons.count; i++) 
			{
				var weapon_in_pack: Weapon = Weapon(weapons.getItem(i));
				
				if (weapon_in_pack.type == type)
				{

					
					weapon = weapon_in_pack;
					
					var place: MovieClip = movie.getChildByName("i_weapon_place") as MovieClip;
					movie.addChild(weapon.movie);
					weapon.movie.x = place.x;
					weapon.movie.y = place.y;
					
					weapon.movie.scaleX = movie.scaleX;
					weapon.movie.scaleY = movie.scaleY;					
					
					return;
				}
			}
		}
		
		public function addWeapon(weapon: Weapon)
		{
			weapons.add(weapon);
			
			
		}
		
		private function handleShoot(e:Event):void 
		{
			
		}
		
		
		public function fire()
		{
			weapon.fire();
		}
		
		public function damage(points: Number)
		{
			life -= points;
			
			if (life <= 0)
			{
				dispatchEvent(new Event(ON_LIFE_OVER));
			}
			
		}
	
		
	}

}