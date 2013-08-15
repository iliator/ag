package entities.inventory;

import model.dto.ItemDTO;
import model.events.InventoryEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.TooltipButton;

class Hardpoint extends TooltipButton
{
	private var data:Dynamic; // HardpointDTO;
	private var itemData:ItemDTO;

	public function new(x:Float, y:Float, data:Dynamic)
	{
		super(x, y, {defaultImage:data.assetPath});

		this.data = data;
	}

	override public function added()
	{
		super.added();

		setTooltipText(data.name);
		addListener(MouseEvent.CLICK, onClick);
	}

	public function mountItem(item:ItemDTO)
	{
		if(!isAvailable())
			return;

		itemData = item;

		initImage(itemData.assetPath);
		setTooltipText(data.name + "\n" + itemData.name);
	}

	public function supports(itemType:String):Bool
	{
		return (data.type == itemType);
	}

	public function isAvailable():Bool
	{
		return (itemData == null);
	}

	private function onClick(e:MouseEvent)
	{
		if(isAvailable())
			return;

		initImage(data.assetPath);
		setTooltipText(data.name);

		EventManager.cloneInstance().dispatchEvent(new InventoryEvent(InventoryEvent.UNEQUIP_ITEM, itemData));

		itemData = null;
	}
}