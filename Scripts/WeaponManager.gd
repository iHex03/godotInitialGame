extends Node3D

@onready var animation = $AnimationPlayer
@onready var hitbox = $Sword/hitbox

var can_attack = true

func _process(_delta):
	
	if Input.is_action_just_pressed("attack"):
		if can_attack == true:
			can_attack = false
			animation.play("Sword Attack")
			hitbox.monitoring = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Sword Attack":
		hitbox.monitoring = false
		animation.play("Idle")
		await get_tree().create_timer(0.2).timeout
		can_attack = true


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		print("acertou")
