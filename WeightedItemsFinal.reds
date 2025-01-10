
public class ItemWeights {
  public static func ClothesWeight() -> Float = 0.45;

  public static func CyberwearWeight() -> Float = 0.25;

  public static func AmmoWeight() -> Float = 0.03;

  public static func EdibleWeight() -> Float = 0.3;

  public static func JunkWeight() -> Float = 0.75;

  public static func PartWeight() -> Float = 0.6;

  public static func GrenadeWeight() -> Float = 0.6;

  //Default weight for MaterialWeight is 0.2
  public static func MaterialsWeight() -> Float = 0.0;

  public static func ShowMaterialsUnderProgramsFilter() -> Bool = true;

  public static func SetText(text: inkTextRef, weight: Float) -> Void {
    inkTextRef.SetText(text, FloatToStringPrec(weight, 2));
  }

  public static func SetText(text: inkTextRef, itemData: ref<gameItemData>) -> Void {
    inkTextRef.SetText(text, FloatToStringPrec(ItemWeights.GetItemWeight(itemData), 3));
  }

  public final static func GetItemStackWeight(itemData: ref<gameItemData>) -> Float {
    return ItemWeights.GetItemWeight(itemData) * Cast<Float>(itemData.GetQuantity());
  }

  public final static func GetItemWeight(itemData: ref<gameItemData>) -> Float {
    let weight: Float = 0.0;
    let itemType: gamedataItemType = itemData.GetItemType();

    if !IsDefined(itemData) {
      return weight;
    }

    if Equals(itemType, gamedataItemType.Invalid) {
      return weight;
    }
    if IsDefined(itemData) {
      weight = itemData.GetStatValueByType(gamedataStatType.Weight);
    }
    if weight == 0.0 {
      switch itemType {
        case gamedataItemType.Clo_Face:
        case gamedataItemType.Clo_Feet:
        case gamedataItemType.Clo_Head:
        case gamedataItemType.Clo_InnerChest:
        case gamedataItemType.Clo_Legs:
        case gamedataItemType.Clo_OuterChest:
        case gamedataItemType.Clo_Outfit:
          return ItemWeights.ClothesWeight();
        case gamedataItemType.Con_Ammo:
          return ItemWeights.AmmoWeight();
        case gamedataItemType.Con_Edible:
        case gamedataItemType.Con_Inhaler:
        case gamedataItemType.Con_Injector:
        case gamedataItemType.Con_LongLasting:
          return ItemWeights.EdibleWeight();
        case /* case gamedataItemType.Cyb_Ability: */ /* case gamedataItemType.Cyb_Launcher: */ /* case gamedataItemType.Cyb_MantisBlades: */ /* case gamedataItemType.Cyb_NanoWires: */ /* case gamedataItemType.Cyb_StrongArms: */ /* return ItemWeights.CyberwearWeight(); */ gamedataItemType.Gen_CraftingMaterial:
          // Can't be dropped, only stashed or sold.
          return ItemWeights.MaterialsWeight();
        case /* case gamedataItemType.Gen_DataBank: */ /* case gamedataItemType.Gen_Keycard: */ /* case gamedataItemType.Gen_Misc: */ /* case gamedataItemType.Gen_Readable: */ gamedataItemType.Gen_Junk:
        case gamedataItemType.Gen_Jewellery:
          return ItemWeights.JunkWeight();
        case gamedataItemType.Prt_Capacitor:
        case gamedataItemType.Prt_Fragment:
        case gamedataItemType.Prt_Magazine:
        case gamedataItemType.Prt_Mod:
        case gamedataItemType.Prt_Muzzle:
        case /* case gamedataItemType.Prt_Program: // Buggy behaviour when equipping & unequipping. */ gamedataItemType.Prt_Receiver:
        case gamedataItemType.Prt_Scope:
        case gamedataItemType.Prt_ScopeRail:
        case gamedataItemType.Prt_Stock:
        case gamedataItemType.Prt_FabricEnhancer:
        case gamedataItemType.Prt_HeadFabricEnhancer:
        case gamedataItemType.Prt_FaceFabricEnhancer:
        case gamedataItemType.Prt_OuterTorsoFabricEnhancer:
        case gamedataItemType.Prt_TorsoFabricEnhancer:
        case gamedataItemType.Prt_PantsFabricEnhancer:
        case gamedataItemType.Prt_BootsFabricEnhancer:
        case gamedataItemType.Prt_HandgunMuzzle:
        case gamedataItemType.Prt_RifleMuzzle:
        case gamedataItemType.Prt_TargetingSystem:
          return ItemWeights.PartWeight();
        case /* case gamedataItemType.Fla_Launcher */ /* case gamedataItemType.Fla_Rifle: */ /* case gamedataItemType.Fla_Shock: */ /* case gamedataItemType.Fla_Support */ gamedataItemType.GrenadeDelivery:
        case gamedataItemType.Grenade_Core:
        case gamedataItemType.Gad_Grenade:
          return ItemWeights.GrenadeWeight();
      }
    }
    return weight;
  }
}

// Start Section - AmmoWeight, EdibleWeight, JunkWeight, PartWeight, GrenadeWeight, MaterialsWeight, ClothesWeight, CyberwearWeight
@wrapMethod(RPGManager)
public final static func GetItemWeight(itemData: ref<gameItemData>) -> Float {
  if IsDefined(itemData) {
    return ItemWeights.GetItemWeight(itemData);
  }
  return wrappedMethod(itemData);
}

// Updates the weight counter when transferring items
@replaceMethod(ItemQuantityPickerController)
protected final func UpdateWeight() -> Void {
  let weight: Float = this.m_itemWeight * Cast<Float>(this.m_choosenQuantity);
  inkTextRef.SetText(this.m_weightText, FloatToStringPrec(weight, 2));
}

// Updates the weight counter when transferring items
@wrapMethod(ItemQuantityPickerController)
private final func SetData() -> Void {
  wrappedMethod();
  this.m_itemWeight = ItemWeights.GetItemWeight(InventoryItemData.GetGameItemData(this.m_gameData));
  this.UpdateWeight();
}

// Updates the drop mechanism to use the non-zero weights
@replaceMethod(MenuHubGameController)
protected cb func OnDropQueueUpdatedEvent(evt: ref<DropQueueUpdatedEvent>) -> Bool {
  let item: ref<gameItemData>;
  let result: Float;
  let dropQueue: array<ItemModParams> = evt.m_dropQueue;
  let i: Int32 = 0;
  while i < ArraySize(dropQueue) {
    item = GameInstance
      .GetTransactionSystem(this.m_player.GetGame())
      .GetItemData(this.m_player, dropQueue[i].itemID);
    result += ItemWeights.GetItemWeight(item) * Cast<Float>(dropQueue[i].quantity);
    i += 1;
  }
  this.HandlePlayerWeightUpdated(result);
}

// Inventory/Backpack/Vendor tooltip.
@wrapMethod(MinimalItemTooltipData)
public final static func FromInventoryTooltipData(tooltipData: ref<InventoryTooltipData>) -> ref<MinimalItemTooltipData> {
  let result: ref<MinimalItemTooltipData> = wrappedMethod(tooltipData);
  result.weight = ItemWeights.GetItemStackWeight(result.itemData);
  return result;
}