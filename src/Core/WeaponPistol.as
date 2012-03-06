package Core 
{
	/**
	 * ...
	 * @author gera
	 */
	public class WeaponPistol extends Weapon
	{		
		public function WeaponPistol() 
		{
			_movieClassName = "mc_weapon_pistol";
			
			bulletsType = "mc_bullet_yellow_normal";
			bulletsLeft = 100000000;
			lastFireTime = 0;
			fireInterval = 500;
			clipCapacity = 6;
			reloadTime = 1500;
			_type = "mc_weapon_pistol";
			bulletsInClip = clipCapacity;
			damage = 1;			
			var sndClass: String = "pistol.mp3";
		}
		
		
		override public function generateBullet(): Bullet
		{
			var bul: Bullet = super.generateBullet();			
			bul.movie.scaleY = 0.5;
			bul.movie.scaleX = 0.5;
			return bul;
		}		
	}

}