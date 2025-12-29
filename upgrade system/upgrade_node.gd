class_name UpgradeNode
extends Control
@export var data: UpgradeData 
var upgrade: Upgrade = null 
var is_locked: bool = false
var can_purchase: bool = false
const UPGRADE_NODE_AFFORDABLE_THEME = preload("uid://bmi00awkluvkt")
const UPGRADE_NODE_CANT_AFFORD_THEME = preload("uid://cpbqs1ys1nkeb")
const UPGRADE_NODE_MAXED_THEME = preload("uid://b6ntk2x4lk85")
@onready var name_label: Label = $UpgradeDataDisplay/NameDisplay/NameLabel
@onready var description_label: Label = $UpgradeDataDisplay/NumberDataDisplay/InfoContainer/Labels/DescriptionLabel
@onready var before_after_label: Label = $UpgradeDataDisplay/NumberDataDisplay/InfoContainer/Labels/BeforeAfterLabel
@onready var price_label: Label = $UpgradeDataDisplay/NumberDataDisplay/InfoContainer/Labels/PriceLabel
@onready var purchase_button: Button = $PurchaseButton



func _ready() -> void:
	SignalManager.points_changed.connect(func(value: int): 
		# Ignores any values changing if the upgrade is already at max tier
		if upgrade.has_reached_max_tier():
			return
		# Checks if the player can now purchase the current buyable tier
		if can_purchase_tier(value):
			can_purchase = true
		else:
			can_purchase = false
		_update_theme()
		)
	if data:
		upgrade = Upgrade.new()
		upgrade.data = data
		name_label.text = str(upgrade.get_name())
		before_after_label.text = upgrade.get_before_after()
		description_label.text = upgrade.data.description
		price_label.text = "$" + str(upgrade.get_current_price())
		purchase_button.icon = data.icon
		_update_theme()


func can_purchase_tier(player_points: int) -> bool:
	return not is_locked and upgrade.get_current_price() <= player_points


func purchase_tier(tier: int) -> void:
	StatManager.unlocked_upgrades[data.modify_stat_name] = upgrade
	upgrade.current_purchased_tier = tier 
	upgrade.current_unpurchased_tier = upgrade.current_purchased_tier + 1
	SignalManager.upgrade_purchased.emit(upgrade)
	_update_display()
	if upgrade.has_reached_max_tier():
		can_purchase = false


func unlock_upgrade() -> void:
	is_locked = false


func _update_display() -> void:
	before_after_label.text = upgrade.get_before_after()
	_update_theme()
	if upgrade.has_reached_max_tier():
		price_label.text  = ""
		return
	name_label.text = str(upgrade.data.name)
	price_label.text = "$" + str(upgrade.get_current_price())


func _update_theme() -> void:
	if not is_locked:
		if upgrade.has_reached_max_tier():
			purchase_button.theme = UPGRADE_NODE_MAXED_THEME
			return
		elif can_purchase:
			purchase_button.theme = UPGRADE_NODE_AFFORDABLE_THEME
		else:
			purchase_button.theme = UPGRADE_NODE_CANT_AFFORD_THEME


func _on_purchase_button_mouse_entered() -> void:
	$UpgradeDataDisplay.visible = true


func _on_purchase_button_mouse_exited() -> void:
	$UpgradeDataDisplay.visible = false


func _on_purchase_button_pressed() -> void:
	if can_purchase:
		# Purchases the tier above 
		purchase_tier(upgrade.current_unpurchased_tier)
