package level;

import entities.Enemy;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Grid;

import model.consts.EntityTypeConsts;
import model.dto.EnemyDTO;
//import model.events.LevelEvent;

class Level extends Entity
{
	private var checkpoints:Array<Int>;
	private var checkPointsPassed:Int = 0;

	private var enemyImages:Hash<String>;

	private var spawnTimer:Float = 0;

	public function new(enemyAssets:Hash<String>)
	{
		super(0, 0);

		checkpoints = [500, 1000];

		enemyImages = enemyAssets;
	}

	public function init()
	{
		drawBackground();

		initGrid(40);
	}

	override public function update()
	{
		super.update();

		checkIfReachedCheckpoint();

		spawnTimer -= HXP.elapsed;

		if(spawnTimer < 0)
			spawn();
	}

	private function initGrid(gridCellSize:Int)
	{
		var mask:Grid = new Grid(1000, 500, gridCellSize, gridCellSize); // app W/H
		var maskEntity = new Entity(0, 0, null, mask);

		//mask.setRect(20, 20, 1, 1);

		maskEntity.type = EntityTypeConsts.LEVEL;

		scene.add(maskEntity);

		addLevelEntity(400, 100, 40, mask, gridCellSize);
		addLevelEntity(400, 220, 40, mask, gridCellSize);
	}

	private function drawBackground()
	{
		var b:Backdrop = new Backdrop("gfx/bg.png", true, true);

		b.scrollX = 0.5;
		b.scrollY = 0.5;

		graphic = b;
	}

	private function spawn()
	{
		var enemyAsset:String = (Std.random(2) % 2 == 0) ? enemyImages.get("enemy1") : enemyImages.get("enemy2");
		var enemyData:EnemyDTO = new EnemyDTO({type: "asd", health: 200, damage: 5, score: 5, speed: 2, asset: enemyAsset, width: 32, height: 32});
		var y:Float = Math.random() * (HXP.height - 32);

		scene.add(new Enemy(scene.camera.x + HXP.width, y, enemyData));

		spawnTimer = 1;
	}

	private function addEntity(x:Float, y:Float, size:Int)
	{
		var a:Entity = new Entity(x, y);

		a.graphic = Image.createRect(size, size, 0xDDEEFF);

		scene.add(a);
	}

	private function addLevelEntity(x:Float, y:Float, entitySize:Int, gridMask:Grid, gridCellSize:Int)
	{
		gridMask.setRect(Std.int(x / gridCellSize), Std.int(y / gridCellSize), 1, 1);

		addEntity(x, y, entitySize);
	}

	private function checkIfReachedCheckpoint()
	{
		if(checkpoints.length == 0)
			return;

		if(scene.camera.x > checkpoints[0])
		{
			checkpoints.splice(0, 1);

			//dispatcher.dispatchEvent(new LevelEvent(LevelEvent.PASSED_CHECKPOINT, ++checkPointsPassed));
		}
	}
}