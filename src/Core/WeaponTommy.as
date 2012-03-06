package Core 
{
	/**
	 * ...
	 * @author gera
	 */
	public class WeaponTommy extends Weapon
	{
		
		public function WeaponTommy() 
		{
			
			_movieClassName = "mc_weapon_tommy";
			
			
			///mc_yellow_fat, mc_bullet_thin, mc_bullet_red_fat
			bulletsType = "mc_bullet_yellow_normal";
			bulletsLeft = 200;
			lastFireTime = 0;
			fireInterval = 100;
			clipCapacity = 50;
			reloadTime = 2000;
			_type = "";
			bulletsInClip = clipCapacity;
			damage = 1;
		}		
	}

}