extends Node
## Example demonstrating the spell system in action.
##
## Fully configurable test harness for casting any spell on any creature.
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
@export_group("Battle Participants")
@export var caster: CreatureTemplateData
@export var target: CreatureTemplateData

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
	if caster == null:
		push_error("Caster template not assigned!")
		valid = false
	if target == null:
		push_error("Target template not assigned!")
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
	
	# Create participants
	var caster_participant := _create_caster()
	var target_participant := _create_target()
	
	_print_participant_info("CASTER", caster_participant)
	_print_participant_info("TARGET (Before Cast)", target_participant)
	
	# Create battle context
	var battle := BattleContext.new()
	if caster_participant.is_ally:
		battle.player_team = [caster_participant]
		battle.enemy_team = [target_participant]
	else:
		battle.player_team = [target_participant]
		battle.enemy_team = [caster_participant]
	
	var casters: Array[BattleParticipant] = [caster_participant]
	var targets: Array[BattleParticipant] = [target_participant]
	
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
	
	_print_participant_info("CASTER (After Cast)", caster_participant)
	_print_participant_info("TARGET (After Cast)", target_participant)
	
	print("\n", "=".repeat(60))
	print("TEST COMPLETE")
	print("=".repeat(60), "\n")

func _create_caster() -> BattleParticipant:
	if caster is CharacterTemplateData:
		var save_data := CharacterSaveData.new(caster.id, 1)
		return CharacterBattleParticipant.new(caster, save_data, true)
	else:
		return MonsterBattleParticipant.new(caster, true)

func _create_target() -> BattleParticipant:
	if target is CharacterTemplateData:
		var save_data := CharacterSaveData.new(target.id, 1)
		return CharacterBattleParticipant.new(target, save_data, false)
	else:
		return MonsterBattleParticipant.new(target, false)

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

func _print_participant_info(label: String, participant: BattleParticipant) -> void:
	print("\n", label, ": ", participant.get_template().name)
	print("  HP: ", participant.current_health, " / ", participant.max_health)
	print("  Element Ratio: ", _format_ratio(participant.element_ratio))
	
	if not participant.statuses.is_empty():
		print("  Statuses:")
		for status in participant.statuses:
			var stacks = participant.statuses[status]
			print("    - ", status.name, ": ", stacks, " stack(s)")
	else:
		print("  Statuses: (none)")

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
