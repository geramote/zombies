package Core 
{
	/**
	 * ...
	 * @author gera
	 */
	public class Consts 
	{
		
		public static const levels: Array = ["mc_scene_1"];
		
		public static const STATE_MOVING_LEFT: String = "STATE_MOVING_LEFT";
		public static const STATE_MOVING_RIGHT: String = "STATE_MOVING_RIGHT";
		public static const STATE_MOVING_UP: String = "STATE_MOVING_UP";
		public static const STATE_MOVING_DOWN: String = "STATE_MOVING_DOWN";
		public static const STATE_STOPPED: String = "STATE_STOPPED";
		
		public static const PLAYER_SPEED: Number = 5;
		
		public static const WEAPON_TYPE_KNIFE: String = "Knife";
		public static const WEAPON_TYPE_TOMPSON: String = "Tommy-Gun";
		
		public static const MONSTERS_SCALE: Number = 0.7;
		
		public static const ambients: Array = ["zombiesAmbient.mp3",  "zombiesAmbient3.mp3", "zombiesAmbient4.mp3", "zombiesAmbient5.mp3"];
		public static const zombieDeathSNDS: Array = ["zombieDeath.mp3", "zombiesAmbient2.mp3"];
		
		public static const BLOOD_SCALE: Number = 0.4;
		
		public static const ENEMY_CLASSES: Array = ["mc_enemy_0", "mc_enemy_1", "mc_enemy_2", "mc_enemy_3", "mc_enemy_4", "mc_enemy_5", "mc_enemy_6", "mc_enemy_7", "mc_enemy_8", "mc_enemy_9", "mc_enemy_10", "mc_enemy_11", ];
		public static const ENEMY_SPEED: Array = [0.5, 0.4, 0.6, 0.3, 0.5, 1, 2, 2, 3, 1, 0.5, 3];
		public static const ENEMY_DAMAGE: Array = [1, 3, 2, 3, 5, 5, 1, 2, 5, 8, 1, 5];
		
		public static const BONUS_LIFE_CLASS: String = "mc_bonus_health";
		public static const BONUS_AMMO_CLASS: String = "mc_object_arm";
		public static const BONUS_MONEY_CLASS: String = "mc_object_money";
				
		public static const BONUS_LIFE_MESSAGES: Array = ["HOORAY!", "WOOHOO!", "YEAH!"];
		
		public static const BONUS_MONEY_MIN_COUNT: int = 50;
		public static const BONUS_MONEY_COUNT: int = 100;
		public static const BONUS_AMMO_COUNT: int = 2; // обоймы
		
		
		
		public function Consts() 
		{
			
		}
		
		
		
	}

}