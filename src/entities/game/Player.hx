package entities.game;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import entities.game.Weapon;
import entities.game.misc.Projectile;
import entities.game.ships.PlayerShip;

import model.consts.EntityTypeConsts;
import model.consts.ItemTypeConsts;
import model.dto.HardpointDTO;
import model.dto.ItemDTO;
import model.dto.WeaponDTO;
import model.events.HUDEvent;
import model.proxy.PlayerProxy;
import model.proxy.ProjectileProxy;

import nme.Assets;
import nme.display.BitmapData;

import org.events.EventManager;

import scenes.GameScene;

class Player
{
	private var entity:PlayerShip;
	private var scene:GameScene;

	private var energyRegenTimer:Float = 0.1;
	private var weapons:Array<Weapon>;

	private var em:EventManager;
	private var playerProxy:PlayerProxy;

	public function new(x:Float, y:Float, scene:GameScene)
	{
		this.scene = scene;

		em = EventManager.cloneInstance();
		playerProxy = PlayerProxy.cloneInstance();

		entity = new PlayerShip(x, y, playerProxy.playerData.shipTemplate);
		scene.add(entity);

		defineInput();
	}

	public function handleInput()
	{
		var xAcc:Int = 0, yAcc:Int = 0;

		if(Input.check("up"))
			yAcc = -1;			

		if(Input.check("down"))
			yAcc = 1;

		if(Input.check("left"))
			xAcc = -1;

		if(Input.check("right"))
			xAcc = 1;

		if(Input.check("shoot"))
			entity.fire([EntityTypeConsts.ENEMY]);

		if(energyRegenTimer < 0)
			regenerateEnergy(playerProxy.playerData.shipTemplate.energyRegen);

		entity.setAcceleration(xAcc, yAcc);

		energyRegenTimer -=  HXP.elapsed;
	}

	private function defineInput()
	{
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("shoot", [Key.X]);
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("regen", [Key.Z]);
	}

	private function regenerateEnergy(amount:Int)
	{
		em.dispatchEvent(new HUDEvent(HUDEvent.UPDATE_ENERGY, 0, 0, 0, amount));

		energyRegenTimer = 0.1;
	}
}