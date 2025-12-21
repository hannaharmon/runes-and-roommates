extends Node
## Example demonstrating the spell system in action.
##
## Fully configurable test harness for casting any spell in any battle configuration.
## Configure all parameters in the inspector and run to see detailed output.

# Spell Configuration
@export_group("Spell")
@export var ink: InkTemplateData
@export var spell_name: String = "Test Spell"

# Rune/Mutation selection (drag .gd script files here)
@export_group("Spell Behavior")
@export var rune_script: GDScript
@export var mutation_scripts: Array[GDScript] = []

# Battle Configuration
@export_group("Battle Teams")
@export var player_team: Array[CreatureTemplateData] = []
@export var enemy_team: Array[CreatureTemplateData] = []

@export_group("Spell Participants")
enum Team { PLAYER, ENEMY }
@export var caster_team: Team = Team.PLAYER
@export var caster_indices: Array[int] = [0]
@export var target_team: Team = Team.ENEMY
@export var target_indices: Array[int] = [0]

func _ready():
	if not _validate_configuration():
		return
	test_spell_cast()

func _validate_configuration() -> bool:
	var valid := true
	
	if ink == null:
		push_error("Ink template not assigned!")
		valid = false
	if rune_script == null:
		push_error("Rune script not assigned!")
		valid = false
	
	if player_team.is_empty():
		push_error("Player team is empty!")
		valid = false
	if enemy_team.is_empty():
		push_error("Enemy team is empty!")
		valid = false
	
	# Validate casters
	if caster_indices.is_empty():
		push_error("Must have at least one caster!")
		valid = false
	else:
		var caster_team_size = player_team.size() if caster_team == Team.PLAYER else enemy_team.size()
		var unique_casters = {}
		for idx in caster_indices:
			if idx < 0 or idx >= caster_team_size:
				push_error("Caster index " + str(idx) + " is out of bounds for team size " + str(caster_team_size))
				valid = false
			if unique_casters.has(idx):
				push_error("Duplicate caster at index " + str(idx))
				valid = false
			unique_casters[idx] = true
	
	# Validate targets
	if target_indices.is_empty():
		push_error("Must have at least one target!")
		valid = false
	else:
		var target_team_size = player_team.size() if target_team == Team.PLAYER else enemy_team.size()
		for idx in target_indices:
			if idx < 0 or idx >= target_team_size:
				push_error("Target index " + str(idx) + " is out of bounds for team size " + str(target_team_size))
				valid = false
	
	return valid

func test_spell_cast():
	print("\n", "=".repeat(60))
	print("SPELL CAST TEST")
	print("=".repeat(60), "\n")
	
	# Create spell
	var rune_instance = rune_script.new()
	if not rune_instance is RuneTemplateData:
		push_error("Rune script must extend RuneTemplateData, got: " + str(rune_instance.get_class()))
		return
	var rune: RuneTemplateData = rune_instance
	
	var mutations: Array[MutationTemplateData] = []
	for script in mutation_scripts:
		if script != null:
			var mutation_instance = script.new()
			if not mutation_instance is MutationTemplateData:
				push_error("Mutation script must extend MutationTemplateData, got: " + str(mutation_instance.get_class()))
				continue
			mutations.append(mutation_instance)
	
	var spell_data := SpellSaveData.new(spell_name, ink, rune, mutations)
	var spell := Spell.new(spell_data)
	
	_print_spell_info(spell)
	
	# Create all participants
	var player_participants: Array[BattleParticipant] = []
	for template in player_team:
		player_participants.append(_create_participant(template, true))
	
	var enemy_participants: Array[BattleParticipant] = []
	for template in enemy_team:
		enemy_participants.append(_create_participant(template, false))
	
	# Get casters and targets
	var caster_source = player_participants if caster_team == Team.PLAYER else enemy_participants
	var target_source = player_participants if target_team == Team.PLAYER else enemy_participants
	
	var casters: Array[BattleParticipant] = []
	for idx in caster_indices:
		casters.append(caster_source[idx])
	
	var targets: Array[BattleParticipant] = []
	for idx in target_indices:
		targets.append(target_source[idx])
	
	# Print initial state
	print("\n", "-".repeat(60))
	print("BATTLE STATE (Before Cast)")
	print("-".repeat(60))
	_print_team_info("PLAYER TEAM", player_participants, casters, targets)
	_print_team_info("ENEMY TEAM", enemy_participants, casters, targets)
	
	# Create battle context
	var battle := BattleContext.new()
	battle.player_team = player_participants
	battle.enemy_team = enemy_participants
	
	# PREVIEW
	print("\n", "-".repeat(60))
	print("SPELL PREVIEW")
	print("-".repeat(60))
	var preview := spell.preview(casters, targets, battle)
	_print_preview(preview, spell)
	
	# CAST
	print("\n", "-".repeat(60))
	print("CASTING SPELL")
	print("-".repeat(60))
	spell.cast(casters, targets, battle)
	print("✓ Spell cast complete\n")
	
	# Print final state
	print("-".repeat(60))
	print("BATTLE STATE (After Cast)")
	print("-".repeat(60))
	_print_team_info("PLAYER TEAM", player_participants, casters, targets)
	_print_team_info("ENEMY TEAM", enemy_participants, casters, targets)
	
	print("\n", "=".repeat(60))
	print("TEST COMPLETE")
	print("=".repeat(60), "\n")

func _create_participant(template: CreatureTemplateData, is_player: bool) -> BattleParticipant:
	if template is CharacterTemplateData:
		var save_data := CharacterSaveData.new(template.id, 1)
		return CharacterBattleParticipant.new(template, save_data, is_player)
	else:
		return MonsterBattleParticipant.new(template, is_player)

func _print_spell_info(spell: Spell) -> void:
	print("SPELL: ", spell.data.name)
	print("  Ink: ", spell.data.ink.name, " (Power: ", spell.data.ink.power, ")")
	print("  Rune: ", spell.data.rune.name)
	if not spell.data.mutations.is_empty():
		print("  Mutations:")
		for m in spell.data.mutations:
			print("    - ", m.name)
	print("  Compiled Power: ", spell.power)
	print("  Element Ratio: ", _format_ratio(spell.element_ratio))
	print("  Element Cost: ", _format_points(spell.element_points_cost))
	print("  Description: ", spell.description)

func _print_team_info(label: String, team: Array[BattleParticipant], casters: Array[BattleParticipant], targets: Array[BattleParticipant]) -> void:
	print("\n", label, ":")
	for i in range(team.size()):
		var participant = team[i]
		var tags: Array[String] = []
		if casters.has(participant):
			tags.append("CASTER")
		if targets.has(participant):
			tags.append("TARGET")
		var tag_str = " [" + ", ".join(tags) + "]" if not tags.is_empty() else ""
		
		print("  [", i, "] ", participant.get_template().name, tag_str)
		print("      HP: ", participant.current_health, " / ", participant.max_health)
		print("      Element Ratio: ", _format_ratio(participant.element_ratio))
		
		if not participant.statuses.is_empty():
			print("      Statuses:")
			for status in participant.statuses:
				var stacks = participant.statuses[status]
				print("        - ", status.name, ": ", stacks, " stack(s)")
		else:
			print("      Statuses: (none)")

func _print_preview(preview: SpellPreviewResult, spell: Spell) -> void:
	if not preview.damage_by_target.is_empty():
		print("\nDamage:")
		for t in preview.damage_by_target:
			var damage: int = preview.damage_by_target[t]
			print("  → ", t.get_template().name, " will take ", damage, " damage")
			print("    (Base power: ", spell.power, " * type advantage)")
	
	if not preview.status_changes.is_empty():
		print("\nStatus Changes:")
		for change in preview.status_changes:
			print("  → ", change.target.get_template().name, " will receive:")
			print("    + ", change.stacks, " stack(s) of ", change.status.name)
	
	if preview.damage_by_target.is_empty() and preview.status_changes.is_empty():
		print("  (No predicted effects)")

func _format_ratio(ratio: ElementRatio) -> String:
	if ratio == null or ratio.ratio.is_empty():
		return "(none)"
	var parts: Array[String] = []
	for element in ratio.ratio:
		var element_name = Enums.Element.keys()[element]
		parts.append(element_name + "=" + str(ratio.ratio[element]))
	return "{" + ", ".join(parts) + "}"

func _format_points(points: ElementPoints) -> String:
	if points == null or points.points.is_empty():
		return "(none)"
	var parts: Array[String] = []
	for element in points.points:
		var element_name = Enums.Element.keys()[element]
		parts.append(element_name + "=" + str(points.points[element]))
	return "{" + ", ".join(parts) + "}"
