extends Node
# Health System
signal health_changed(diff: int) # The difference can be used for further calculations
signal max_health_changed(diff: int) # The difference can be used for further calculations
signal health_depleted
signal damage_taken(value: int)
 
# Breakable
signal breakable_broken(instance: Breakable)


# Ui
signal points_changed(new_value: int)
