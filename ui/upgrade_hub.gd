extends Control
var is_dragging: bool = false
const DRAG_SPEED: float = 1.1
# Left, right, Bottom, Top
const DRAG_BOUNDS: Array[float] = [-200, 700, -175, 100]
@onready var points_label: Label = $BackgroundPanel/PointsLabel
@onready var upgrade_nodes: Control = $DraggableNodes/UpgradeNodes
@onready var draggable_nodes: Control = $DraggableNodes

func _ready() -> void:
	
	SignalManager.points_changed.connect(_on_points_changed)
	$BackgroundPanel/BackToGameButton.mouse_exited.connect(_on_mouse_exited)
	var upgrade_containers = upgrade_nodes.get_children()
	$BackgroundPanel/BackToGameButton.grab_focus()
	# Loops through all the containers to get the upgrade nodes
	for container in upgrade_containers:
		for child in container.get_children():
			if child is not UpgradeNode:
				continue
			var upgrade_node: UpgradeNode = child as UpgradeNode
			
			upgrade_node.purchase_button.mouse_exited.connect(_on_mouse_exited)


func handle_entered() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(Constants.NORMAL_CURSOR_ICON, Input.CURSOR_ARROW)
	draggable_nodes.position = Vector2.ZERO


func _on_points_changed(value: int) -> void:
	points_label.text = "$ " + str(value)
	var upgrade_containers = upgrade_nodes.get_children()
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
	Input.set_custom_mouse_cursor(Constants.OPEN_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.OPEN_HAND_CURSOR_ICON.get_size() / 2)


func _on_mouse_exited() -> void:
	if not is_dragging:
		Input.set_custom_mouse_cursor(Constants.NORMAL_CURSOR_ICON, Input.CURSOR_ARROW)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_pressed("bomb_place_action"):
			is_dragging = true
			Input.set_custom_mouse_cursor(Constants.DRAG_HAND_CURSOR_ICON, Input.CURSOR_ARROW)#, Constants.DRAG_HAND_CURSOR_ICON.get_size() / 2)
		if Input.is_action_just_released("bomb_place_action"):
			is_dragging = false
			Input.set_custom_mouse_cursor(Constants.NORMAL_CURSOR_ICON, Input.CURSOR_ARROW)
	if event is InputEventMouseMotion:
		if is_dragging:
			
			event = event as InputEventMouseMotion
			draggable_nodes.position += event.relative * DRAG_SPEED
			draggable_nodes.position.x = clamp(draggable_nodes.position.x, DRAG_BOUNDS[0], DRAG_BOUNDS[1])
			draggable_nodes.position.y = clamp(draggable_nodes.position.y, DRAG_BOUNDS[2], DRAG_BOUNDS[3])
