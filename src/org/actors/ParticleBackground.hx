package org.actors;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

import entities.game.misc.Projectile;

class ParticleBackground extends Entity
{
	private var spawnDelay:Float;
	private var spawnTimer:Float = 0;
	private var velocity:Float;
	private var size:Float;
	private var alpha:Float;
	private var react:Bool;

	public function new(spawnDelay:Float, velocity:Float, scale:Float, alpha:Float, react:Bool = true)
	{
		super(0, 0);

		this.spawnDelay = spawnDelay;
		this.velocity = velocity;
		this.size = scale;
		this.alpha = alpha;

		this.react = react;
	}

	override public function update()
	{
		spawnTimer -= HXP.elapsed;

		if(react)
			updateFields(getUpdateFields());

		if(spawnTimer < 0)
			spawn();
	}

	private function spawn()
	{
		var randX:Int = Std.random(HXP.width - 3) + 3;

		scene.add(new BackgroundParticle(randX, 0, velocity, size, alpha));

		spawnTimer = spawnDelay;
	}

	private function getUpdateFields():Array<GravityField>
	{
		var entities:Array<Projectile> = [];
		var fields:Array<GravityField> = [];

		scene.getClass(Projectile, entities);

		for(e in entities)
			fields.push(e.gravityField);

		return fields;
	}

	private function updateFields(fields:Array<GravityField>)
	{
		var particles:Array<BackgroundParticle> = [];//cast(scene, scenes.GameScene).getBackgroundParticles(size);

		for(particle in particles)
			if(particle.size == size)
			{
				var strongFields:Array<GravityField> = [];

				for(field in fields)
					if(fieldForce(field, particle.x, particle.y) != 0)
						strongFields.push(field);

				particle.updateFields(strongFields);
			}
	}

	private function fieldForce(field:GravityField, px:Float, py:Float):Float
	{
		var distance:Float = Math.sqrt((field.positionX - px) * (field.positionX - px) + (field.positionY - py) * (field.positionY - py));

		if(distance < Math.abs(field.mass))
			return field.mass;

		return 0;
	}
}