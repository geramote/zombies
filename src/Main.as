package  {
	
	import Core.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import UI.UIIngame;
	import flash.geom.Point;
	import gs.TweenMax;
	import flash.ui.Mouse;
	
	
	public class Main extends MovieClip {
		
		var uiIngame: UIIngame = new UIIngame();
		var levelPlace: MovieClip = new MovieClip();
		var level: Level = null;
		var player: Player = new Player();
		var mainTimer: Timer;
		
		var levelMovingTween: TweenMax;
		
		var workingLevelBitmap: Bitmap;
		
		var bmd: BitmapData ;
		var mcCursor: MovieClip;
		var shooting: Boolean = false;
		
		var lastPlayedAmbientTime: Number = -100000;
		
		var playEmbientInterval: Number = 5000;
		
		private function initPlayer()
		{
			player = new Player();
			player.addEventListener(Player.ON_LIFE_OVER, handleLifeOver, false, 0, true);
			player.movie = MovieClip(Utils.getClassObject("mc_hero"));
			
			var weapon: Weapon = new WeaponPistol();
			weapon.init();
			player.addWeapon(weapon);
			weapon.addEventListener(Weapon.ON_SHOOT, handleShoot, false, 0, true);				
			player.selectWeapon(weapon.type);
			
			
			weapon = new WeaponShotgun();
			weapon.init();
			player.addWeapon(weapon);
			weapon.addEventListener(Weapon.ON_SHOOT, handleShoot, false, 0, true);
			
			///player.selectWeapon(weapon.type);
		}
		
		private function startGame()
		{	
			
			/////lastPlayedAmbientTime = Time.instance.getMilliseconds();
			this.stage.focus = this;
			initPlayer();
			
			levelPlace.x = 0;
			
			var mc: MovieClip = MovieClip(Utils.getClassObject(Consts.levels[0]))
			if (mc)
			{
				level = new Level();
				level.init(mc);
				levelPlace.addChild(mc);
				
				levelPlace.x -= (mc.width - this.stage.stageWidth) / 2;
				
				level.battlefield.addChild(player.movie);
				
				player.movie.x = level.battlefield.width / 2;
				player.movie.y = level.battlefield.height / 2;
				
				player.movie.scaleX = 0.7;
				player.movie.scaleY = 0.7;
				
				level.player = player;
				processIntersections();
			}
			
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDOWN, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUP, false, 0, true);
			
			uiIngame.init(i_mc_ingame, player);	

		}
		
		public function Main() {
			
			
			SoundManager.inst.addEventListener(SoundManager.ON_SOUND_FINISHED, handleSoundFinished);
			
			SoundManager.inst.play(Utils.getClass("main.mp3"), true);
			SoundManager.inst.volume = 0.4;
			
			mcCursor = MovieClip(Utils.getClassObject("mc_cursor"));
			mcCursor.mouseChildren = false;
			mcCursor.mouseEnabled = false;
			stage.addChild(mcCursor);
			
   			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUPHandler, false, 0, true);
			
			Mouse.hide();
			this.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);

			
			this.addChildAt(levelPlace, 0);
			
			startGame();
			
			uiIngame.updateWeapons();
			
			mainTimer = new Timer(1);
			mainTimer.addEventListener(TimerEvent.TIMER, onMainTimer, false, 0, true);
			
			mainTimer.start();
			
			////addEventListener(Event.ENTER_FRAME, onMainTimer, false, 0, true)
			
			
		}
		
		private function handleSoundFinished(e:Event):void 
		{
			SoundManager.inst.play(Utils.getClass("main.mp3"), true);
		}
		
		var mcGO: MovieClip = null;
		
		
		private function handleLifeOver(e:Event):void 
		{
			mainTimer.stop();
			mcGO = Utils.getClassMovieClip("mc_game_over");			
			var mcAgain: SimpleButton = mcGO.getChildByName("i_mc_again") as SimpleButton;
			addChild(mcGO);
			
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDOWN);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUP);
			
			
			mcAgain.addEventListener(MouseEvent.MOUSE_DOWN, handlePlayAgainClick);
		}
		
		private function handlePlayAgainClick(e:MouseEvent):void 
		{
			removeChild(mcGO);
			
			levelPlace.removeChild(level.movie);
			
			startGame();			
			mainTimer.start();
		}
		
		private function handleMouseUP(e:MouseEvent):void 
		{
			shooting = false;
		}
		
		private function handleMouseDOWN(e:MouseEvent)
		{
			shooting = true;
		}
		
		private function handleShoot(e:Event):void 
		{
			
		}
		
		private function handleMouseMove(e:MouseEvent):void 
		{
			mcCursor.x = this.mouseX;
			mcCursor.y = this.mouseY;
			
			var playerPos: Point = new Point(player.movie.x + player.movie.width / 2, player.movie.y);
			playerPos = level.battlefield.localToGlobal(playerPos);
			
			var div: Number = 0;
			var mult: Number = 1;
			if (playerPos.x < this.mouseX)
			{
				
				TweenMax.to(player.movie, 0.3, {rotationY: 0});
			}
			else
			{
				div = 180;
				mult = -1;
				TweenMax.to(player.movie, 0.3, {rotationY: -180});
			}
		 
			if (player.weapon.type != Consts.WEAPON_TYPE_KNIFE)
			{
				var p: Point = player.movie.localToGlobal(new Point(player.weapon.movie.x, player.weapon.movie.y));
				
				var a1 = stage.mouseY - p.y;
				var b1 = stage.mouseX - p.x;
				var radians1 = Math.atan2(a1,b1);
				var degrees1 = radians1 / (Math.PI / 180);
				player.weapon.movie.rotation = (degrees1 - div) * mult;	
			}
			
		
		}
		
		private function keyUPHandler(event:KeyboardEvent):void 
		{
			if ((event.keyCode == 37) || (event.keyCode == 65))
			{
				player.removeState(Consts.STATE_MOVING_LEFT);

			}			
			if ((event.keyCode == 38) || (event.keyCode == 87))
			{
				player.removeState(Consts.STATE_MOVING_UP);
			}
			if ((event.keyCode == 39) || (event.keyCode == 68))
			{
				////levelMovingTween.complete();
				player.removeState(Consts.STATE_MOVING_RIGHT);
			}
			
			if ((event.keyCode == 40) || ((event.keyCode == 83)))
			{
				player.removeState(Consts.STATE_MOVING_DOWN);
			}
			
		
		}
		
		private function onMainTimer(e: flash.events.TimerEvent):void 
		{
			if (!level) return;
			
			if (Time.instance.getMilliseconds() - lastPlayedAmbientTime >= playEmbientInterval)
			{
				var rnd: int = Utils.randRange(0, 100);
				
				if (rnd < 50)
				{
					var strC:String = Consts.ambients[Utils.randRange(0, Consts.ambients.length  - 1)];					
					
					///try
					{
						SoundManager.inst.play(Utils.getClass(strC));
					}
					////catch(e: Error){}
					
					
				}
				lastPlayedAmbientTime = Time.instance.getMilliseconds();
				
				
			}
			
			if (workingLevelBitmap)
			{
				levelPlace.removeChild(workingLevelBitmap)
			}
		
			player.live(level);
			
			if (shooting)
			{
				var mult: Number = 1;
				if (level.battlefield.mouseX < player.movie.x)
				{
					mult = -1;
				}
				var tan: Number = (level.battlefield.mouseY - player.movie.y) / ((level.battlefield.mouseX - player.movie.x))  ;
				
				if (mult < 0)
				{
					
					tan = ((level.battlefield.mouseY - player.movie.y)) / (((player.movie.x - level.battlefield.mouseX)));
				}

				var tox: Number = level.battlefield.width * mult;
				var toy: Number =  (tox * tan);
				
				var angle: Number = Math.atan(tan);
				var ma: Number = 1;
				
				//if (angle < 0)
				//{
					//ma = -1;					
				//}
				//
				//if (angle < 0.03)
				//{
					//angle = 0.03;
				//}
				//
				//angle *= ma;
				//angle *= ma;
				
				var p:Point = Point.polar(1500, angle);
				level.doPlayerShot((player.movie.x + p.x * mult), player.movie.y + p.y);
				
				/////level.doPlayerShot(tox, toy);
				
			}
			
			level.live();
			processIntersections();
			
			
			if (player.isInState(Consts.STATE_MOVING_LEFT))
			{
				var playerPos: Point = new Point(player.movie.x + player.movie.width / 2, player.movie.y);
				playerPos = level.battlefield.localToGlobal(playerPos);
				
				if ((levelPlace.x < 0) && playerPos.x<= this.stage.stageWidth / 2)
				{
					levelPlace.x += Consts.PLAYER_SPEED;
					
					if (levelPlace.x > 0)
					{
						levelPlace.x = 0;
					}
				}
			}
			
			if (player.isInState(Consts.STATE_MOVING_RIGHT))
			{
				if (levelPlace.x > -1 * ((levelPlace.width - 20) - this.stage.stageWidth))
				{
					var playerPos: Point = new Point(player.movie.x + player.movie.width / 2, player.movie.y);
					playerPos = level.battlefield.localToGlobal(playerPos);
					
					if (playerPos.x >= ((this.stage.stageWidth / 2)))
					{ 
						levelPlace.x -= Consts.PLAYER_SPEED;
						
						
						if (levelPlace.x < this.stage.stageWidth - 1200)
						{
							levelPlace.x = this.stage.stageWidth - 1200;
						}
					}
				}
			}
			
			uiIngame.update();
			
		}
		
		function processIntersections()
		{
			for (var i:int = 0; i < level.objects.count; i++) 
			{
				var so:SceneObject = SceneObject(level.objects.getItem(i));
				
				var rectObject: Rectangle = so.movie.getRect(level.movie);
				var rectPlayer: Rectangle = player.movie.getRect(level.movie);
				
				if (rectPlayer.intersects(rectObject))
				{
					if (rectPlayer.bottom > rectObject.bottom)
					{
						level.battlefield.addChildAt(so.movie, level.battlefield.getChildIndex(player.movie) - 1);
					}
					else
					{
						var index: int = level.battlefield.getChildIndex(so.movie) - 1;
						if (index == 0) index = 1;
						
						level.battlefield.addChildAt(player.movie, index);
					}
				}
			}
			
			if (level.battlefield.getChildIndex(level.bloodfield) > level.battlefield.getChildIndex(level.player.movie))
			{
				level.battlefield.addChildAt(level.player.movie, level.battlefield.getChildIndex(level.bloodfield) + 1);
			}
			
		}
		
		private function keyDownHandler(event:KeyboardEvent)
		{
			
			if ((event.keyCode == 37) || (event.keyCode == 65))
			{
				player.state = Consts.STATE_MOVING_LEFT;
				player.addState(Consts.STATE_MOVING_LEFT);
				
			}			
			if ((event.keyCode == 38) || (event.keyCode == 87))
			{
				player.addState(Consts.STATE_MOVING_UP);
			}
			if ((event.keyCode == 39) || (event.keyCode == 68))
			{
				player.state = Consts.STATE_MOVING_RIGHT;
				player.addState(Consts.STATE_MOVING_RIGHT);
			}
			
			if ((event.keyCode == 40) || ((event.keyCode == 83)))
			{
				player.state = Consts.STATE_MOVING_DOWN;
				player.addState(Consts.STATE_MOVING_DOWN);
			}
			
			
			if ((event.keyCode >= 49) && (event.keyCode <= 58))
			{
				if (player.selectWeaponByIndex((event.keyCode - 49)))
				{
					uiIngame.selectWeapon(event.keyCode - 49);
				}
			}
			
			var playerPos: Point = new Point(player.movie.x + player.movie.width / 2, player.movie.y);
			playerPos = level.battlefield.localToGlobal(playerPos);
			
			var div: Number = 0;
			var mult: Number = 1;
			
			
			if (playerPos.x < this.mouseX)
			{
				
				TweenMax.to(player.movie, 0.3, {rotationY: 0});
			}
			else
			{
				div = 180;
				mult = -1;
				TweenMax.to(player.movie, 0.3, {rotationY: -180});
			}
			
			
			trace(event.keyCode);
			
		
		}
	}
	
}
