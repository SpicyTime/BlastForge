class_name UpgradeNode
extends Control
@export var data: UpgradeData 
var upgrade: Upgrade = null
var is_locked: bool = true
func _ready() -> void:
	if data:
		upgrade = Upgrade.new()
		upgrade.data = data

func can_purchase_tier(tier: int, player_points: int) -> bool:
	return not is_locked and player_points >= upgrade.data.tier_prices[tier]


func purchase_tier(tier: int) -> void:
	upgrade.current_tier = tier
	if upgrade.has_reached_max_tier():
		_handle_max_tier_reached()
	else:
		_handle_tier_increase(tier)


func unlock_upgrade() -> void:
	is_locked = false


func _handle_max_tier_reached() -> void:
	pass


func _handle_tier_increase(tier_number: int) -> void:
	pass
