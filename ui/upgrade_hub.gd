extends Control
func _ready() -> void:
	SignalManager.points_changed.connect(_on_points_changed)


func _on_points_changed(value: int) -> void:
	var upgrade_containers = $UpgradeNodes.get_children()
	var purchasable_node_count: int = 0
	# Loops through all the containers to get the upgrade nodes
	for container in upgrade_containers:
		for child in container.get_children():
			if child is not UpgradeNode:
				continue
			var upgrade_node: UpgradeNode = child
			# Ignores any values changing if the upgrade is already at max tier
			if upgrade_node.is_at_max_tier():
				continue
			# Checks if the player can now purchase the current buyable tier
			if upgrade_node.can_purchase_tier(value):
				purchasable_node_count += 1
				upgrade_node.can_purchase = true
			else:
				upgrade_node.can_purchase = false
			upgrade_node.update_theme()
	SignalManager.purchase_amount_changed.emit(purchasable_node_count)


func _on_back_to_game_button_pressed() -> void:
	UiManager.swap_menu("None")
	UiManager.show_overlay("Hud")
