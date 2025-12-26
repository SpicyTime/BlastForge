class_name UpgradeNode
extends Control
@export var data: UpgradeData 
var upgrade: Upgrade = null 
var is_locked: bool = false
var can_purchase: bool = false

@onready var name_label: Label = $UpgradeDataDisplay/NameDisplay/NameLabel
@onready var description_label: Label = $UpgradeDataDisplay/NumberDataDisplay/InfoContainer/Labels/DescriptionLabel
@onready var before_after_label: Label = $UpgradeDataDisplay/NumberDataDisplay/InfoContainer/Labels/BeforeAfterLabel
@onready var price_label: Label = $UpgradeDataDisplay/NumberDataDisplay/InfoContainer/Labels/PriceLabel


func _ready() -> void:
	SignalManager.points_changed.connect(func(value: int): 
		# Ignores any values changing if the upgrade is already at max tier
		if upgrade.has_reached_max_tier():
			return
		# Checks if the player can now purchase the current buyable tier
		if can_purchase_tier(upgrade.current_unpurchased_tier, value):
			can_purchase = true
		else:
			can_purchase = false
		)
	if data:
		upgrade = Upgrade.new()
		upgrade.data = data
		name_label.text = str(upgrade.get_name())
		before_after_label.text = upgrade.get_before_after()
		description_label.text = upgrade.data.description
		price_label.text = "$" + str(upgrade.get_current_price())


func can_purchase_tier(tier: int, player_points: int) -> bool:
	var tier_index: int = tier - 1
	return not is_locked and upgrade.data.tier_prices[tier_index] <= player_points


func purchase_tier(tier: int) -> void:
	var _tier_index: int = tier - 1
	StatManager.unlocked_upgrades[data.modify_stat_name] = upgrade
	upgrade.current_purchased_tier = tier 
	upgrade.current_unpurchased_tier = upgrade.current_purchased_tier + 1
	SignalManager.upgrade_purchased.emit(upgrade)
	_update_display(upgrade.current_unpurchased_tier - 1)
	if upgrade.has_reached_max_tier():
		can_purchase = false


func unlock_upgrade() -> void:
	is_locked = false


func _update_display(tier_index: int) -> void:
	before_after_label.text = upgrade.get_before_after()
	if upgrade.has_reached_max_tier():
		price_label.text  = ""
		return
	name_label.text = str(upgrade.data.tier_names[tier_index])
	price_label.text = "$" + str(upgrade.get_current_price())


func _on_purchase_button_mouse_entered() -> void:
	$UpgradeDataDisplay.visible = true


func _on_purchase_button_mouse_exited() -> void:
	$UpgradeDataDisplay.visible = false


func _on_purchase_button_pressed() -> void:
	if can_purchase:
		# Purchases the tier above 
		purchase_tier(upgrade.current_unpurchased_tier)
		
