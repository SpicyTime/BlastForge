extends Node
# Health System
signal health_changed(diff: int) # The difference can be used for further calculations
signal max_health_changed(diff: int) # The difference can be used for further calculations
signal health_depleted
signal damage_taken(value: int)
 
# bombs
signal bomb_detonated(shapes_broken: Array[Node2D])
signal bomb_created

# Breakable
signal shape_broken(instance: Shape)

# Ui
signal points_changed(new_value: int)
signal place_delay_timer_changed(value: float)

# Spawn System
signal spawn_shape_request(position: Vector2, shape_type: Enums.ShapeType, 
speed: int, direction: Vector2, modifiers: Array[Enums.ShapeModifiers], include_modifiers: bool)
signal spawn_shape_bunch_request(amount: int, 
positions: Array[Vector2], shape_types: Array[Enums.ShapeType], speeds: Array[int], directions: Array[Vector2],
modifier_array: Array[Array], include_modifiers: bool )

# World
signal spawn_bomb(bomb_position: Vector2)
signal unsuccessful_bomb_place

# Upgrades
signal upgrade_purchased(upgrade: Upgrade)
signal purchase_amount_changed(value: int)
