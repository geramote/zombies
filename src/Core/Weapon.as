package Core 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	import gs.plugins.RemoveTintPlugin;
	/**
	 * ...
	 * @author gera
	 */
	public class Weapon extends EventDispatcher
	{
		public static const ON_SHOOT: String = "ON_SHOOT";
		public static const ON_RELOAD_NEEDED: String = "ON_RELOAD_NEEDED";
		public static const ON_BULLETS_OUT: String = "ON_BULLETS_OUT";
		
		public static const STATE_RELOADING: String = "STATE_RELOADING";
		var _state: String = "";
		
		var _movie: MovieClip;
		
		var _movieClassName: String = "";
		
		var _bulletsType: String = "";
		var _bulletsLeft: int = 10;
		var lastFireTime: Number = 0;
		var fireInterval: Number = 1;		
		var _type: String = "";
		var _damage: Number = 0;
		
		var _clipCapacity: Number = 10;
		var _bulletsInClip: Number = clipCapacity;
		
		var outMovie: MovieClip = null;
		
		var reloadTime: Number = 5000;		
		var rechargeTimer: Timer;
		
		var mcShoot: MovieClip = null;
		
		var sndClass: String = "shotgun.mp3";
		
		var maxBulletsCount: int = 1000;
		
		
		public function getOutPoint(): Point
		{
			var res: Point = new Point();
			
			if (outMovie)
			{
				res.x = outMovie.x;
				res.y = outMovie.y;				
			}
			else
			{
				res.x = movie.x;
				res.y = movie.y;
			}
			
			return res;
		}
		
		public function Weapon() 
		{
			lastFireTime = Time.instance.getMilliseconds();
			
			rechargeTimer = new Timer(1);
			rechargeTimer.addEventListener(TimerEvent.TIMER, onRechargeTimer, false, 0, true);
			
		}
		
		private function onRechargeTimer(e:TimerEvent):void 
		{	
			var rechargeTo: Number = clipCapacity;
			
			if (bulletsLeft < clipCapacity)
			{
				rechargeTo = _bulletsLeft;
			}
			
			bulletsInClip += clipCapacity / (reloadTime / 20);
			
			if (bulletsInClip >= rechargeTo)
			{
				state = "";
				rechargeTimer.stop();
			}
		}
		
		
		
		
		public function generateBullet(): Bullet
		{
			var bullet: Bullet = new Bullet();
			bullet.movie = Utils.getClassMovieClip(bulletsType);
			bullet.damage = damage;
			return bullet;
		}
		
		public function init()
		{
			_movie = Utils.getClassMovieClip(movieClassName);
			mcShoot = MovieClip(_movie.getChildByName("i_mc_shoot"));
			if (mcShoot)
			{
				
				mcShoot.addEventListener(Event.ENTER_FRAME, handleShootEnterFrame, false, 0, true);
				mcShoot.gotoAndStop(0);
/*				for (var i:int = 0; i < mcShoot.numChildren; i++) 
				{
					var dobj: DisplayObject = mcShoot.getChildAt(i);///mcShoot.gotoAndStop(0);
					
					if (dobj is MovieClip)
					{
						MovieClip(dobj).gotoAndStop(0);
					}
				}
*/				
			}
			outMovie = MovieClip(_movie.getChildByName("i_wc_out"));
			outMovie.visible = false;
			
		}
		
		private function handleShootEnterFrame(e:Event):void 
		{
			var mc: MovieClip = MovieClip(e.currentTarget);
			
			if (mc.totalFrames == mc.currentFrame)
			{
				mc.gotoAndStop(0);
			}
			
		}
		
		public function get movie():MovieClip 
		{
			return _movie;
		}
		
		public function set movie(value:MovieClip):void 
		{
			_movie = value;
		}
		
		public function get movieClassName():String 
		{
			return _movieClassName;
		}
		
		public function set movieClassName(value:String):void 
		{
			_movieClassName = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get damage():Number 
		{
			return _damage;
		}
		
		public function set damage(value:Number):void 
		{
			_damage = value;
		}
		
		public function get bulletsType():String 
		{
			return _bulletsType;
		}
		
		public function set bulletsType(value:String):void 
		{
			_bulletsType = value;
		}
		
		public function get bulletsLeft():int 
		{
			return _bulletsLeft;
		}
		
		public function set bulletsLeft(value:int):void 
		{
			_bulletsLeft = value;
		}
		
		public function get clipCapacity():Number 
		{
			return _clipCapacity;
		}
		
		public function set clipCapacity(value:Number):void 
		{
			_clipCapacity = value;
		}
		
		public function get bulletsInClip():Number 
		{
			return _bulletsInClip;
		}
		
		public function set bulletsInClip(value:Number):void 
		{
			_bulletsInClip = value;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			_state = value;
		}
		
		
		public function fire(): Bullet
		{			
			if ((bulletsInClip > 0) && (state != STATE_RELOADING) && (bulletsLeft > 0))
			{
				if ((Time.instance.getMilliseconds() - lastFireTime) >= fireInterval)
				{
					lastFireTime = Time.instance.getMilliseconds();
					bulletsLeft --;
					bulletsInClip --; 
					
					SoundManager.inst.play(Utils.getClass(sndClass));
					dispatchEvent(new Event(ON_SHOOT));
					
					
					if (mcShoot)
					{
						mcShoot.gotoAndPlay(0);
						
					}
					if (mcShoot)
					{
						
					}
					var bullet: Bullet = generateBullet();
					return bullet;
					
				}
			}
			else
			{
				if (bulletsLeft > 0)
				{
					if (state != STATE_RELOADING)
					{
						state = STATE_RELOADING;
						rechargeTimer.start();
					}
				}
				else
				{
					if (mcShoot)
					{
						mcShoot.gotoAndStop(0);
					}
					dispatchEvent(new Event(ON_BULLETS_OUT));
				}
				///dispatchEvent(new Event(ON_RELOAD_NEEDED));
				return null;
				
			}
			
			return null;
		}
		
	}

}