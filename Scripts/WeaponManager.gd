extends Node3D

@onready var animation = $AnimationPlayer
@onready var hitbox = $Sword/hitbox

var Current_Weapon = null

var Weapon_Stack = []

var Weapon_Indicator = 0

var Next_Weapon: String

var Weapon_List = {}

@export var _weapon_resourses: Array[Weapon_Resource]

@export var Start_Weapons: Array[String]

var can_attack = true
var last_anim

func _ready():
	Initialize(Start_Weapons)
	print(Weapon_List)

func Initialize(_start_weapons: Array):
	for weapon in _weapon_resourses:
		Weapon_List[weapon.Weapon_Name] = weapon
	
	for i in _start_weapons:
		Weapon_Stack.push_back(i)
	
	Current_Weapon = Weapon_List[Weapon_Stack[0]]
	enter()

func enter():
	animation.queue(Current_Weapon.Activate_Anim)

func exit(_next_weapon: String):
	if _next_weapon != Current_Weapon.Weapon_Name:
#		print("_next_weapon: ", _next_weapon, "| current_weapon: ", Current_Weapon.Weapon_Name)
		if animation.get_current_animation() != Current_Weapon.Deactivate_Anim:
			animation.play(Current_Weapon.Deactivate_Anim)
			Change_Weapon(_next_weapon)

func Change_Weapon(weapon_name: String):
	Current_Weapon = Weapon_List[weapon_name]
	Next_Weapon = ""
	enter()

func _input(event):
	if event.is_action_released("weapon_up"):
		Weapon_Indicator = min(Weapon_Indicator+1, Weapon_Stack.size()-1)
#		print("mouse up: ", Weapon_Indicator)
#		print("current wp: ", Weapon_Stack[Weapon_Indicator])
		exit(Weapon_Stack[Weapon_Indicator])
	
	if event.is_action_released("weapon_down"):
		Weapon_Indicator = max(Weapon_Indicator-1,0)
#		print("mouse down: ", Weapon_Indicator)
#		print("current wp: ", Weapon_Stack[Weapon_Indicator])
		exit(Weapon_Stack[Weapon_Indicator])

func _process(_delta):
	
	if Input.is_action_pressed("attack"):
		if can_attack == true:
			can_attack = false
			if last_anim == "Attack":
				animation.play(Current_Weapon.Attack_Anim2)
				last_anim = "Attack2"
			else:
				animation.play(Current_Weapon.Attack_Anim)
				last_anim = "Attack"
			hitbox.monitoring = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == Current_Weapon.Attack_Anim or Current_Weapon.Attack_Anim2:
		hitbox.monitoring = false
		animation.play("Idle")
		can_attack = true
	
	if anim_name == Current_Weapon.Deactivate_Anim:
		Change_Weapon(Next_Weapon)


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		print("acertou")
