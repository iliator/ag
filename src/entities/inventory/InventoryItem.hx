package entities.inventory;

import model.dto.ItemDTO;
import model.events.InventoryEvent;

import nme.events.MouseEvent;
import nme.geom.Point;

import org.events.EventManager;

import org.ui.TooltipButton;

class InventoryItem extends TooltipButton
{
	private var em:EventManager;
	private var data:ItemDTO;

	public function new(row:Int, col:Int, cellWidth:Int, cellHeight:Int, data:Dynamic)
	{
		var pos:Point = getCoords(row, col, cellWidth, cellHeight);

		super(pos.x, pos.y, {defaultImage: data.assetPath});

		if(Type.getClassName(Type.getClass(data)) != "model.dto.ItemDTO")
			this.data = new ItemDTO(data);
		else
			this.data = data;

		setHitbox(cellWidth, cellHeight);

		em = EventManager.cloneInstance();
	}

	public function matches(item:ItemDTO)
	{
		return (item.name == data.name);
	}

	override public function added()
	{
		super.added();

		addListener(MouseEvent.CLICK, onClick);

		setTooltipText(data.name);
	}
	private function getCoords(row:Int, col:Int, cellWidth:Int, cellHeight:Int):Point
	{
		var result:Point = new Point(col * cellWidth + 2, 450 + row * cellHeight + 2);

		return result;
	}

	private function onClick(e:MouseEvent)
	{
		hideTooltip();

		// should be a message entity
		em.dispatchEvent(new InventoryEvent(InventoryEvent.EQUIP_ITEM, data));
	}
}