extends Node
# Health System
signal health_changed(diff: int) # The difference can be used for further calculations
signal max_health_changed(diff: int) # The difference can be used for further calculations
signal health_depleted
signal damage_taken(value: int)
 
# Explosives
signal explosive_detonated(breakables_broken: Array[Node2D ])


# Breakable
signal breakable_broken(instance: Breakable)

# Ui
signal points_changed(new_value: int)


# Spawn System
signal spawn_breakable_request(position: Vector2, shape_type: Enums.ShapeType, breakable_type: Enums.BreakableType)
signal spawn_breakable_bunch_request(amount: int, positions: Array[Vector2], shape_types: Array[Enums.ShapeType], breakable_types: Array[Enums.BreakableType])

# World
signal spawn_explosive(explosive_position: Vector2)
