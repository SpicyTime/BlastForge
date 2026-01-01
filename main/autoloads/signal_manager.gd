extends Node
# Health System
signal health_changed(diff: int) # The difference can be used for further calculations
signal max_health_changed(diff: int) # The difference can be used for further calculations
signal health_depleted
signal damage_taken(value: int)
 
# bombs
signal bomb_detonated(shapes_broken: Array[Node2D])


# Breakable
signal shape_broken(instance: Shape)

# Ui
signal points_changed(new_value: int)


# Spawn System
signal spawn_shape_request(position: Vector2, shape_type: Enums.ShapeType)
signal spawn_shape_bunch_request(amount: int, positions: Array[Vector2], shape_types: Array[Enums.ShapeType])

# World
signal spawn_bomb(bomb_position: Vector2)

# Upgrades
signal upgrade_purchased(upgrade: Upgrade)
signal purchase_amount_changed(value: int)
