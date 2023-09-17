class_name BricksComboCalculator
extends Node


var _bricks_groups: Array[BricksGroup]


func get_max_group_color_or_null() -> Variant:
	var max_group: BricksGroup
	for group in _bricks_groups:
		if not max_group or group.size > max_group.size:
			max_group = group
	
	if max_group:
		return max_group.color
	
	return null


func get_groups_sizes_sum() -> int:
	return _bricks_groups.reduce(func(sum: int, group: BricksGroup):
		return sum + group.size, 0)


func calculate(bricks_row: Array[Brick]) -> void:
	var clusters = _split_row_to_clusters(bricks_row)
	
	var continued_groups: Array[BricksGroup]
	for group in _bricks_groups:
		var still_active: bool
		
		for cluster in clusters:
			if (cluster.color == group.color
			and not cluster.connected_groups.has(group)
			and cluster.bricks.any(func(brick: Brick):
					return group.areas.any(func(group_item_area: Area2D):
						return group_item_area.overlaps_area(brick)))):
				still_active = true
				cluster.connected_groups.append(group)
		
		if still_active:
			continued_groups.append(group)
	
	for cluster in clusters:
		var connected_clusters = clusters.filter(func(sibling_cluster: BricksRowCluster):
			return (sibling_cluster != cluster
			and sibling_cluster.connected_groups.any(func(group: BricksGroup):
				cluster.connected_groups.has(group))))
		
		for connected_cluster in connected_clusters:
			cluster.bricks.append_array(connected_cluster.bricks)
			
			for group in connected_cluster.groups:
				if not cluster.connected_groups.has(group):
					cluster.connected_groups.append(group)
			
			clusters.erase(connected_cluster)
	
	var new_bricks_groups: Array[BricksGroup]
	for cluster in clusters:
		if cluster.connected_groups.is_empty():
			new_bricks_groups.append(BricksGroup.new(cluster.bricks))
			continue
		
		var group_size = cluster.bricks.size()
		for connected_group in cluster.connected_groups:
			group_size += connected_group.size
		
		var new_group = BricksGroup.new(cluster.bricks)
		new_group.size = group_size
		new_bricks_groups.append(new_group)
	
	_bricks_groups = new_bricks_groups


func _split_row_to_clusters(row: Array[Brick]) -> Array[BricksRowCluster]:
	var clusters: Array[BricksRowCluster]
	var prev_brick: Brick
	for brick in row:
		if (prev_brick
		and prev_brick.color == brick.color):
			clusters[clusters.size() - 1].bricks.append(brick)
		else:
			clusters.append(BricksRowCluster.new(brick))
		
		prev_brick = brick
	
	return clusters


class BricksRowCluster:
	var color: Color
	var bricks: Array[Brick]
	var connected_groups: Array[BricksGroup]
	
	func _init(brick: Brick) -> void:
		bricks.append(brick)
		color = brick.color


class BricksGroup:
	var id: int = randi()
	var size: int
	var color: Color
	var areas: Array[Area2D]
	
	func _init(bricks: Array) -> void:
		color = bricks[0].color
		areas.assign(bricks)
		size = bricks.size()
