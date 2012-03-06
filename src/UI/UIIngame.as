package UI
{
	import Core.*;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import gs.plugins.RemoveTintPlugin;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author gera
	 */
	public class UIIngame
	{
		private var movie:MovieClip;
		
		var mcAmmo:MovieClip;
		var mcAmmoMask:MovieClip = null;
		var player:Player;
		var mcWeaponsList:MovieClip;
		var tfAmmoCount:TextField;
		var tfAmmoCountUnlim:TextField;
		var selectedWeaponSlot:int = 0;
		var weaponButtons:ObjectList = new ObjectList();
		var mcPlayerHealth:MovieClip;
		var mcPlayerHealthMask:MovieClip = null;
		var phHei:Number = 0;
		var tfMoney:TextField = null;
		
		public function UIIngame()
		{
		
		}
		
		public function init(mc:MovieClip, pl:Player)
		{
			player = pl;
			
			movie = mc;
			
			mcAmmo = mc.getChildByName("i_mc_ammo_") as MovieClip;
			mcPlayerHealth = mc.getChildByName("i_mc_health_mask") as MovieClip;
			phHei = mcPlayerHealth.height;
			
			if (!mcPlayerHealthMask)
			{
				mcPlayerHealthMask = new MovieClip();
			}
			mcPlayerHealthMask.graphics.beginFill(0xFF0000);
			mcPlayerHealthMask.graphics.drawRect(0, 0 /* -1 * mcPlayerHealth.height*/, mcPlayerHealth.width, mcPlayerHealth.height);
			mcPlayerHealthMask.graphics.endFill();
			
			movie.addChild(mcPlayerHealthMask);
			
			mcPlayerHealthMask.x = mcPlayerHealth.x;
			mcPlayerHealthMask.y = mcPlayerHealth.y /* + mcPlayerHealth.height*/;
			
			mcPlayerHealth.mask = mcPlayerHealthMask;
			
////mcPlayerHealth.scaleY = 0;
			
			tfAmmoCount = mc.getChildByName("i_tf_ammo_count") as TextField;
			tfAmmoCountUnlim = mc.getChildByName("i_tf_ammo_count_unlim") as TextField;
			tfAmmoCountUnlim.visible = false;
			
			tfMoney = mc.getChildByName("i_tf_money") as TextField;
			
			if (!mcAmmoMask)
			{
				mcAmmoMask = new MovieClip();
				
				mcAmmoMask.x = mcAmmo.x;
				
				mcAmmoMask.y = mcAmmo.y;
				
				mcAmmoMask.graphics.beginFill(0);
				mcAmmoMask.graphics.drawRect(0, 0, mcAmmo.width, mcAmmo.height);
				mcAmmoMask.graphics.endFill();
			}
			movie.addChild(mcAmmoMask);
			mcAmmo.mask = mcAmmoMask;
			
			mcWeaponsList = mc.getChildByName("i_mc_weapons_list") as MovieClip;
		
		}
		
		public function updateWeapons()
		{
			while (mcWeaponsList.numChildren > 0)
			{
				mcWeaponsList.removeChildAt(0);
			}
			
			weaponButtons.clear();
			
			var dx:Number = 0;
			
			for (var i:int = 0; i < player.weapons.count; i++)
			{
				var w:Weapon = Weapon(player.weapons.getItem(i));
				var mcWeaponButton:MovieClip = Utils.getClassMovieClip(w.movieClassName + "_button");
				weaponButtons.add(mcWeaponButton);
				mcWeaponButton.x = dx;
				dx += mcWeaponButton.width + 5;
				mcWeaponsList.addChild(mcWeaponButton);
				
				if (w != player.weapon)
				{
					mcWeaponButton.scaleX = 0.6;
					mcWeaponButton.scaleY = 0.6;
					mcWeaponButton.alpha = 0.6;
				}
				else
				{
					selectedWeaponSlot = i;
				}
			}
		}
		
		public function selectWeapon(slotNo:int)
		{
			if (selectedWeaponSlot != slotNo)
			{
				var mcSelected:MovieClip = MovieClip(weaponButtons.getItem(selectedWeaponSlot));
				TweenMax.to(mcSelected, 0.3, {scaleX: 0.6, scaleY: 0.6, alpha: 0.6});
				
				mcSelected = MovieClip(weaponButtons.getItem(slotNo));
				
				TweenMax.to(mcSelected, 0.3, {scaleX: 1, scaleY: 1, alpha: 1});
				
				selectedWeaponSlot = slotNo;
			}
		}
		
		public function update()
		{
			var remItems:ObjectList = new ObjectList();
			
//mcPlayerHealthMask.graphics.clear();
//mcPlayerHealthMask.graphics.beginFill(0xFF0000);
//mcPlayerHealthMask.graphics.drawRect(0, -1 * mcPlayerHealth.height, mcPlayerHealth.width, mcPlayerHealth.height * (player.life / player.totalLife));
//mcPlayerHealthMask.graphics.endFill();
			
			tfMoney.text = player.money.toString() + "$";
			
			TweenMax.to(mcPlayerHealthMask, 0.5, {scaleY: 1 - player.life / player.totalLife});
///mcPlayerHealthMask.scaleY = 1 - player.life / player.totalLife;
			
			var num:Number = player.weapon.bulletsLeft / player.weapon.clipCapacity;
			var clipCount:int = num;
			
			if (num.toString().indexOf('.') > -1)
			{
				clipCount++;
			}
			
			if (player.weapon.bulletsLeft < player.weapon.clipCapacity)
				clipCount = 1;
			if (player.weapon.bulletsLeft == 0)
				clipCount = 0;
			
			tfAmmoCount.text = clipCount.toString();
			
			if (player.weapon is WeaponPistol)
			{
				tfAmmoCountUnlim.visible = true;
				tfAmmoCount.visible = false;
			}
			else
			{
				tfAmmoCount.text = clipCount.toString();
				tfAmmoCount.visible = true;
				tfAmmoCountUnlim.visible = false;
			}
			
			for (var j:int = 0; j < mcAmmo.numChildren; j++)
			{
				var dobj:DisplayObject = mcAmmo.getChildAt(j);
				
				if (dobj.name.indexOf("bullet") == 0)
				{
					remItems.add(dobj);
				}
			}
			
			while (remItems.count > 0)
			{
				var dobj:DisplayObject = DisplayObject(remItems.getItem(0));
				dobj.parent.removeChild(dobj);
				remItems.remove(0);
			}
			
			var mcBullet:MovieClip = Utils.getClassMovieClip(player.weapon.bulletsType);
			
			if (mcAmmo.height > mcBullet.height)
			{
				mcBullet.scaleY = mcAmmo.height / mcBullet.height;
				mcBullet.scaleX = mcBullet.scaleY;
			}
			
			var numBullets:int = mcAmmo.width / mcBullet.width;
			
			var dx:Number = (mcBullet.width * mcBullet.scaleX) / 2;
			
			dx += (mcAmmo.width - (numBullets * (mcBullet.width * mcBullet.scaleX))) / 2;
			
			for (var i:int = 0; i < numBullets; i++)
			{
				mcBullet = Utils.getClassMovieClip(player.weapon.bulletsType);
				
				var mcTouch:MovieClip = mcBullet.getChildByName("i_mc_touch_point") as MovieClip;
				mcTouch.visible = false;
				
				mcBullet.name = "bullet" + i.toString();
				mcBullet.x = dx;
				mcBullet.y += ((mcBullet.height * mcBullet.scaleY) / 2) - 5;
				
				dx += mcBullet.width;
				
				mcAmmo.addChild(mcBullet);
			}
			
			var sf:Number = (player.weapon.bulletsInClip / player.weapon.clipCapacity);
			
			mcAmmoMask.scaleX = sf;
			mcAmmoMask.x = mcAmmo.x;
			
			if (player.weapon.state == Weapon.STATE_RELOADING)
			{
				mcAmmo.alpha = 0.2;
			}
			else
			{
				mcAmmo.alpha = 1;
			}
		}
	
	}

}