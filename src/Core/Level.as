package Core 
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.errors.StackOverflowError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.*;
	import flash.events.*;
	
	
	
	
	import gs.*;
	/**
	 * ...
	 * @author gera
	 */
	public class Level extends EventDispatcher
	{
		public static const ON_COMPLETE: String = "ON_COMPLETE";
		
		
		public var objects: IdableObjectList = new IdableObjectList();
		public var movie: MovieClip;
		public var objectsMovie: MovieClip;
		public var battlefield: MovieClip;
		public var player: Player;
		var _bullet: Bullet;
		
		var spawnPoints: ObjectList = new ObjectList();
		
		var bullets: ObjectList = new ObjectList();
		var enemies: ObjectList = new ObjectList();
		var enemyClasses: ObjectList = new ObjectList();
		
		var totalEnemies: Number = 40;
		var killedEnemies: Number = 0;
		
		
		var waves: ObjectList = new ObjectList();
		
		var enemiesMultiplier: Number = 2;
		var maxEnemiesOnScreen: Number = 2;
		
		var drawingArea: BitmapData;
		var drawingBmp: Bitmap;
		
		var _bloodfield: MovieClip = new MovieClip();
		var bmdBlood: BitmapData;
		
		var lastEnemyGenerationTime: Number = -1000;
		var enemyGeneraionInterval: Number = 1000;
		
		var bonusGenerationProb: Number = 20;
		
		var lifeBonusProb: Number = 30;
		var ammoBonusProb: Number = 50;
		var moneyBonusProb: Number = 100;
		
		var bonuses: ObjectList = new ObjectList();
		
		var tombGenerationProbability: Number = 40;
		var maxTombsCount: Number = 7;
		var tombsCount: Number = 0;
		
		
		var mcBfBG: MovieClip;
		var mcBonusesPlace: MovieClip = new MovieClip();
		var enemiesIncreasingStopped: Boolean = false;
		
		public function checkComplete()
		{
			if (killedEnemies >= totalEnemies)
			{
				dispatchEvent(new Event(ON_COMPLETE));
				return;
			}
			
			if (enemiesIncreasingStopped)
			{
				return;
			}
			
			if (killedEnemies > totalEnemies * 0.7)
			{
				maxEnemiesOnScreen = enemiesMultiplier * 5;
				enemiesIncreasingStopped = true;
				return;
			}

			if (killedEnemies > totalEnemies * 0.4)
			{
				maxEnemiesOnScreen = enemiesMultiplier * 4;
				return;
			}

			
			if (killedEnemies > totalEnemies * 0.2)
			{
				maxEnemiesOnScreen = enemiesMultiplier * 3;
				return;
			}
			
			if (killedEnemies > totalEnemies * 0.1)
			{
				maxEnemiesOnScreen = enemiesMultiplier * 2;
				return;
			}
			
		}
		
		public function checkBonusGet()
		{
			///var dist: Number = Math.sqrt(Math.pow(Math.abs((rect.x + rect.width/2) - x), 2) + Math.pow(Math.abs((rect.y + rect.height/2) - y), 2));
			var bonusesToRemove: ObjectList = new ObjectList();
			var toY: Number = battlefield.height;
			for (var i:int = 0; i < bonuses.count; i++) 
			{
				var mcBonus: MovieClip = MovieClip(bonuses.getItem(i));
				var tf: TextField = mcBonus.getChildByName("i_tf_txt") as TextField;
				
				tf.visible = true;
				
				if ((Math.abs(player.movie.x - mcBonus.x) <= player.movie.width / 2) && (Math.abs(player.movie.y - mcBonus.y) <= player.movie.width / 2))
				{
					var bonusCN: String = getQualifiedClassName(mcBonus);
					
					if (bonusCN == Consts.BONUS_LIFE_CLASS)
					{
						tf.text = Consts.BONUS_LIFE_MESSAGES[Utils.randRange(0, Consts.BONUS_LIFE_MESSAGES.length - 1)];
						player.life += player.totalLife / 2;
						
						if (player.life > player.totalLife)
						{
							player.life = player.totalLife;
						}
						
						toY = battlefield.globalToLocal(new Point(0, 0)).y;
					}
					
					if (bonusCN == Consts.BONUS_MONEY_CLASS)
					{
						var cnt: int = Consts.BONUS_MONEY_MIN_COUNT + 5 * Utils.randRange(2, 10);
						tf.text = "+" + cnt.toString();
						player.money += cnt;/// Consts.BONUS_MONEY_COUNT;
					}
					
					if (bonusCN == Consts.BONUS_AMMO_CLASS)
					{
						var weapon: Weapon = player.weapon;
						
						if (player.weapon is WeaponPistol)
						{
							if (player.weapons.count > 1)
							{
								weapon = Weapon(player.weapons.getItem(Utils.randRange(1, player.weapons.count-1)));
							}
						}
						
						var cnt: int = Utils.randRange(1, Consts.BONUS_AMMO_COUNT) * weapon.clipCapacity;
						
						var mc: MovieClip = Utils.getClassMovieClip(weapon._bulletsType);
						mc.scaleY = 0.3;
						mc.scaleX = 0.3;
						
						mcBonus.addChild(mc);
						
						tf.text = "+" + cnt.toString();
						weapon.bulletsLeft += cnt;
						
					}
					
					
					
					TweenMax.to(mcBonus, 2, { x: battlefield.width / 2, y: toY, alpha: 0, onComplete: handleBonusFlyComplete, onCompleteParams: [mcBonus] } );
					
					bonusesToRemove.add(mcBonus);
				}
			}
			
			for (var j:int = 0; j < bonusesToRemove.count; j++) 
			{
				bonuses.removeObject(bonusesToRemove.getItem(j));
			}
		}
		
		private function handleBonusFlyComplete(mcBonus: MovieClip):void 
		{
			if (mcBonus.parent)
			{
				mcBonus.parent.removeChild(mcBonus);
			}
		}
		
		
		
		private function canGenerateBonus(): Boolean
		{
			return (Utils.randRange(0, 100) <= bonusGenerationProb);			
		}
		
		private function generateBonus(): MovieClip
		{
			var rnd: Number = Utils.randRange(0, 100);
			var res: MovieClip;
			
			if ((rnd <= lifeBonusProb)/* && (player.life < player.totalLife)*/)
			{	
				res = Utils.getClassMovieClip(Consts.BONUS_LIFE_CLASS);
				bonuses.add(res)
				return res;
			}
			
			if (rnd <= ammoBonusProb)
			{
				res = Utils.getClassMovieClip(Consts.BONUS_AMMO_CLASS);
				bonuses.add(res);
				return res;
			}
			
			if (rnd <= moneyBonusProb)
			{
				res = Utils.getClassMovieClip(Consts.BONUS_MONEY_CLASS);
				bonuses.add(res);
				return res;
			}
			
			return null;
			
			
		}
		
		private function canGenerateEnemy(): Boolean
		{
			if ((enemies.count + 1) > (totalEnemies - killedEnemies)) return false;
			
			if (Time.instance.getMilliseconds() - lastEnemyGenerationTime >= enemyGeneraionInterval)
			{				
				if ((enemies.count < maxEnemiesOnScreen))
				{					
					
					lastEnemyGenerationTime = Time.instance.getMilliseconds();
					return true;
				}				
			}
			return false;
		}
		
		
		////DAMAGE PLAYER
		public function damagePlayer(points: Number)
		{
			var bloodIndex: int = Utils.randRange(0, 3);
			var blood: MovieClip = Utils.getClassMovieClip("mc_blood_" + bloodIndex);
			

			//blood.cacheAsBitmap = true;
			//
			//
			//bmdBlood = new BitmapData(blood.width, blood.height, true, 0);
			//bmdBlood.draw(blood);
			//
			//var bmp: Bitmap = new Bitmap(bmdBlood);
			//
			blood.x = player.movie.x;
			blood.y = player.movie.y;
			//bmp.rotationX = 10;
			//
			bloodfield.addChildAt(blood, 0);
			
			var bm: Bitmap = Utils.rasterizeMovieClip(blood, 1);	
			bm.smoothing = true;
			bm.scaleY = ((player.movie.y / battlefield.height) + 0.6);
			bm.scaleX = bm.scaleY;
			
			
			player.damage(points);
			//bm.scaleX = 0.7;
			//bm.scaleY = 0.5;
			
		}
		
		////DAMAGE ENEMY
		public function damageEnemy(enemy: EnemyAbstract)
		{
			enemy.damage(player.weapon.damage);
			
			if (enemy.life <= 0)
			{
				killedEnemies ++;
				enemies.removeObject(enemy);
				
				
				var sndC: String = Consts.zombieDeathSNDS[Utils.randRange(0, Consts.zombieDeathSNDS.length - 1)];
				
				SoundManager.inst.play(Utils.getClass(sndC));
				
				var bloodIndex: int = Utils.randRange(0, 2);
				
				var blood: MovieClip = Utils.getClassMovieClip("mc_green_blood_" + bloodIndex);
				
				//blood.cacheAsBitmap = true;
				//
				//
				//bmdBlood = new BitmapData(blood.width, blood.height, true, 0);
				//bmdBlood.draw(blood);
				//
				//var bmp: Bitmap = new Bitmap(bmdBlood);
				//
				blood.x = enemy.clip.x;
				blood.y = enemy.clip.y;
				//bmp.rotationX = 10;
				//
				bloodfield.addChildAt(blood, 0);
				
				var bm: Bitmap = Utils.rasterizeMovieClip(blood, 0);				
				
				///bm.scaleX = Consts.BLOOD_SCALE;
				////bm.scaleY = Consts.BLOOD_SCALE;
				
				bm.scaleY = ((enemy.clip.y / battlefield.height) + 0.8) * 0.7;
				bm.scaleX = bm.scaleY;
				
				bm.smoothing = true;
			////	TweenMax.to(bm, 15, {alpha: 0, onComplete: handleBloodHideComplete, onCompleteParams: [bm]});
				
				/////bm.alpha = Utils.randRange(50, 100) / 100;
				
				
				////Utils.rasterizeMovieClip(bloodfield, bloodfield.parent.getChildIndex(bloodfield)-1);
				
				enemy.clip.visible = false;
				
				var genBonus: Boolean = false;
				if (canGenerateBonus())
				{
					
					genBonus = true;
					var mcBonus: MovieClip = generateBonus();
					
					if (mcBonus)
					{
						var tf: TextField = mcBonus.getChildByName("i_tf_txt") as TextField;
						tf.visible = false;
						mcBonusesPlace.addChild(mcBonus);
						mcBonus.x = enemy.clip.x;
						mcBonus.y = enemy.clip.y;
					}
				}
				else
				{
					var rnd: int =  Utils.randRange(0, 100);
					
					if ((rnd <= tombGenerationProbability) && tombsCount < maxTombsCount)
					{
						tombsCount++;
						rnd = Utils.randRange(0, Consts.TOMBS_CLASSES.length - 1);
						var mcTomb: MovieClip = Utils.getClassMovieClip(Consts.TOMBS_CLASSES[rnd]);
						
						enemy.clip.parent.addChild(mcTomb);
						mcTomb.x = enemy.clip.x;
						mcTomb.y = enemy.clip.y;
						
						var so: SceneObject = new SceneObject();
						so.movie = mcTomb;
						
						objects.add(so);
					}
				}
				
				
				enemy.clip.parent.removeChild(enemy.clip);
				
				checkComplete();
				////Exploder.explode(enemy.movie, 10, 100);
			}
		}
		
		private function handleBloodHideComplete(bm: Bitmap):void 
		{
			bm.parent.removeChild(bm);			
		}
		
		private function generateEnemy()
		{
			var index: int = Utils.randRange(0, enemyClasses.count - 1);
			var enemy: EnemyAbstract = new EnemyAbstract();
			
			var mc: MovieClip = Utils.getClassMovieClip(String(enemyClasses.getItem(index)));
			enemies.add(enemy);			
			enemy.init(mc);
			
			battlefield.addChild(mc);
			
			index = Utils.randRange(0, spawnPoints.count - 1);
			
			var dobj : DisplayObject = DisplayObject(spawnPoints.getItem(index));
			mc.x = dobj.x;
			mc.y = dobj.y;
			
		
		}
		
		
		public function doPlayerShot(toX: Number, toY: Number)
		{
			var bul: Bullet = player.weapon.fire();
			
			var bulletsToRun: ObjectList = new ObjectList();
			
			if (bul)
			{
				bulletsToRun.add(bul);
				
				//if (player.weapon is WeaponShotgun)
				//{
					//for (var j:int = 0; j < 4; j++) 
					//{
						//var bul: Bullet = player.weapon.generateBullet();
						//bulletsToRun.add(bul);
					//}
					//
				//}
			}
			
			
			var yToRun: Number = toY;
			var area: Number = 400;
			
			var angle: Number = Math.atan(toY / toX);
			
			
			
			//if (player.weapon is WeaponShotgun)
			//{
				//angle -= area / 2;
				//toY -= area / 2;
			//}
			
			var rad: Number = angle * Math.PI / 180;
			
			for (var i:int = 0; i < bulletsToRun.count; i++) 
			{
				var bullet: Bullet = Bullet(bulletsToRun.getItem(i));
				
				if (bullet)
				{
					bullet.damage = player.weapon.damage;
					bullets.add(bullet);
					
					var globP: Point = player.weapon.movie.localToGlobal(player.weapon.getOutPoint());
					
					var loc: Point = battlefield.globalToLocal(globP);
					
					bullet.movie.x =  loc.x;
					bullet.movie.y = loc.y;
					
					if (player.weapon is WeaponShotgun)
					{
						
						///toX += Utils.randRange(-500 , 500);
						///toY += Utils.randRange(-500, 500);
						//var mult: Number = 1;
						//
						//var dist: Number = Math.sqrt(Math.pow(Math.abs(toX  - loc.x), 2) + Math.pow(Math.abs(toY - loc.y), 2));						
						//
						//if (toX < 0)
						//{
							//mult = - 1;
						//}
						//toX = (loc.x + Math.cos(rad) * (dist)) * mult;
						//
						//
						//toY = loc.y + Math.sin(rad) * dist ;
						//
						//angle += area / bulletsToRun.count;
						//rad = angle * Math.PI / 180;
					}
					
					/*
					 centerX + Math.cos(angle) * radius ;
centerY + Math.sin(angle) * radius ;					

					 * */
					bullet.setDestination(toX, toY);
					
					battlefield.addChild(bullet.movie);
					

					
					//if (player.weapon is WeaponShotgun)
					//{
						//if (Math.abs(battlefield.mouseX - player.movie.x) < 200)
						//{
							//toX = toX + Utils.randRange( -500, 500);
						//}
						//
						//{
							//toY += area / bulletsToRun.count;
						//}
					//}
				}				
			}

		}
		
		
		public function destroyBullet(bul: Bullet)
		{
			bullets.removeObject(bul);
			
			if (bul.movie.parent)
			{
				bul.movie.parent.removeChild(bul.movie);
			}
		}
		
		public function damageObject(points: Number, object: SceneObject)
		{
			object.life -= points;
			
			if (object.life <= 0)
			{
				if (getQualifiedClassName(object.movie).indexOf("tomb") > -1)
				{
					tombsCount --;
				}
				
				objects.removeObject(object);
				var mcBonus: MovieClip = generateBonus();
					
				if (mcBonus)
				{
					var tf: TextField = mcBonus.getChildByName("i_tf_txt") as TextField;
					tf.visible = false;
					mcBonusesPlace.addChild(mcBonus);
					mcBonus.x = object.movie.x;
					mcBonus.y = object.movie.y;
					
					///object.movie.parent.addChild(mcBonus);
				}				
				////Exploder.explode(object.movie, 30, 200);
				AnimationManager.animateExplosionDusty(object.movie);
			}
		}
		
		public function Level() 
		{
			lastEnemyGenerationTime = Time.instance.getMilliseconds();
		}
		
		public function live()
		{
			
			if (canGenerateEnemy())
			{
				generateEnemy();
			}
			
			for (var i:int = 0; i < bullets.count; i++) 
			{
				var bul: Bullet = Bullet(bullets.getItem(i));
				bul.live(this);
			}
			
			for (var i:int = 0; i < enemies.count; i++) 
			{
				var enemy: EnemyAbstract = EnemyAbstract(enemies.getItem(i));
				enemy.live(this);
			}	
			
			checkBonusGet();
			/////Utils.rasterizeMovieClip(battlefield, battlefield.parent.getChildIndex(battlefield));
			
			////drawingArea.draw(battlefield);
		}
		
		public function init(mc: MovieClip)
		{
			
			////objectsMovie = MovieClip(movie.getChildByName("i_mc_objects"));
			movie = mc;
			movie.addEventListener(MouseEvent.CLICK, handleSceneClick, false, 0, true);
			
			battlefield = MovieClip(mc.getChildByName("i_mc_battlefield"));
			///battlefield.visible = false;
			
			mcBfBG = MovieClip(battlefield.getChildByName("i_mc_bg"));
			
			drawingArea = new BitmapData(battlefield.width, battlefield.height, true, 0x000000);
			
			drawingBmp = new Bitmap(drawingArea, "auto", true);
			
			for (var i:int = 0; i < battlefield.numChildren; i++) 
			{
				var child: DisplayObject = battlefield.getChildAt(i);
				
				if (getQualifiedClassName(child).indexOf("mc_object") == 0)
				{
					var sceneObject: SceneObject = new SceneObject();
					sceneObject.movie = MovieClip(child);
					objects.add(sceneObject);
				}
				if (getQualifiedClassName(child).indexOf("mc_touch") == 0)
				{
					spawnPoints.add(child);
					child.visible = false;
				}				
			}
			
			for (var i:int = 0; i < battlefield.numChildren; i++) 
			{
				var child: DisplayObject = battlefield.getChildAt(i);
				
			}			
			
			for (var j:int = 0; j < movie.numChildren; j++) 
			{
				var ch: DisplayObject = movie.getChildAt(j);
				var cn: String = getQualifiedClassName(ch);
				
				if (cn.indexOf("mc_enemy") == 0)
				{
					enemyClasses.add(cn);
					
					ch.visible = false;
				}
			}
			
		////	drawingArea.draw(battlefield);
			battlefield.addChildAt(bloodfield, battlefield.getChildIndex(mcBfBG) + 1);
			////bloodfield.alpha = 0.2;
			battlefield.addChildAt(mcBonusesPlace, battlefield.getChildIndex(bloodfield) + 1);
			
			
			////drawingBmp.x = battlefield.x;
			////drawingBmp.y = battlefield.y;
			
			/////battlefield.parent.addChildAt(drawingBmp, battlefield.parent.getChildIndex(battlefield) - 1);
			
			///Utils.rasterizeMovieClip(battlefield);
		/////	Utils.rasterizeMovieClip(battlefield, battlefield.parent.getChildIndex(battlefield));
		
		
		}
		
		private function handleSceneClick(e:MouseEvent):void 
		{

		}
		
		public function getIntersectedByPlayerObject(): SceneObject
		{
			for (var i:int = 0; i < objects.count; i++) 
			{
				var obj: SceneObject = SceneObject(objects.getItem(i));
				
				if (obj.movie.getRect(battlefield).intersects(player.movie.getRect(battlefield)))
				{
					return obj;
				}
			}
			
			return null;
		}
		
		public function getClosestObjectToPoint(x: Number, y: Number, minDistance: Number): SceneObject
		{
			for (var i:int = 0; i < objects.count; i++) 
			{
				var obj: SceneObject = SceneObject(objects.getItem(i));
				
				var rect: Rectangle = obj.movie.getBounds(battlefield);
				
				var dist: Number = Math.sqrt(Math.pow(Math.abs((rect.x + rect.width/2) - x), 2) + Math.pow(Math.abs((rect.y + rect.height/2) - y), 2));
				
				if (dist <= minDistance)
				{
					return obj;
				}
			}
			
			return null;
		}
		
		public function getClosestEnemyToPoint(x: Number, y: Number, minDistance: Number, exception: EnemyAbstract): EnemyAbstract
		{
			for (var i:int = 0; i < enemies.count; i++) 
			{
				var enemy: EnemyAbstract = EnemyAbstract(enemies.getItem(i));
				
				if (enemy != exception)
				{				
					var rect: Rectangle = enemy.clip.getBounds(battlefield);
					
					var dist: Number = Math.sqrt(Math.pow(Math.abs((rect.x + rect.width/2) - x), 2) + Math.pow(Math.abs((rect.y + rect.height/2) - y), 2));
					
					if (dist <= minDistance)
					{
						return enemy;
					}
				}
			}
			
			return null;
		}
		
		public function getDistaceToPLayer(x: Number, y: Number): Number
		{
			var rect: Rectangle = player.movie.getBounds(battlefield);
			
			var dist: Number = Math.sqrt(Math.pow(Math.abs((rect.x + rect.width/2) - x), 2) + Math.pow(Math.abs((rect.y + rect.height/2) - y), 2));
			
			return dist;
		}
	
		
		public function getObjectHitTested(x: Number, y: Number): SceneObject
		{
			for (var i:int = 0; i < objects.count; i++) 
			{
				var obj: SceneObject = SceneObject(objects.getItem(i));
				
				if (obj.mask.hitTestPoint(x, y, true))
				{
					return obj;
				}
			}
			
			return null;
		}
		
		public function getEnemyHitTested(x: Number, y: Number): EnemyAbstract
		{
			for (var i:int = 0; i < enemies.count; i++) 
			{
				var enemy: EnemyAbstract = EnemyAbstract(enemies.getItem(i));
				
				if (enemy.clip.hitTestPoint(x, y))
				{
					return enemy;
				}
			}
			
			return null;
		}		
		
		public function hittestObject(x: Number, y: Number, obj: SceneObject): Boolean
		{
			if (obj.mask.hitTestPoint(x, y, true))
			{
				return true;
			}			
			
			return false;
		}
		
		public function get bullet():Bullet 
		{
			return _bullet;
		}
		
		public function set bullet(value:Bullet):void 
		{
			_bullet = value;
		}
		
		public function get bloodfield():MovieClip 
		{
			return _bloodfield;
		}
		
		public function set bloodfield(value:MovieClip):void 
		{
			_bloodfield = value;
		}
		
	}

}