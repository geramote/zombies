package  Core
{
	import Core.Bullet;
	import Core.Weapon;
	/**
	 * ...
	 * @author gera
	 */
	public class WeaponShotgun extends Weapon
	{
		
		public function WeaponShotgun() 
		{
			_movieClassName = "mc_weapon_shotgun";
			
			bulletsType = "mc_yellow_fat";
			bulletsLeft = 24;
			lastFireTime = 0;
			fireInterval = 500;
			clipCapacity = 8;
			reloadTime = 1000;
			_type = "mc_weapon_shotgun";
			bulletsInClip = clipCapacity;
			damage = 2;			
		}
		
		override public function generateBullet(): Bullet
		{
			var bul: Bullet = super.generateBullet();			
			bul.movie.scaleY = 0.4;
			bul.movie.scaleX = 0.4;
			return bul;
		}
		
	}

}