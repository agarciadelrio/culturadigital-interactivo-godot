# exhaust_smoke.gd
extends GPUParticles2D

func _ready():
	# === BÁSICO ===
	emitting = false
	amount = 20
	lifetime = 3.0
	one_shot = false
	explosiveness = 0.0
	randomness = 0.3
	local_coords = false

	# === TEXTURA (reimportada a 98x98) ===
	texture = load("res://Coche/smoke_puff.png")

	# === MATERIAL CANVAS (OBLIGATORIO para alpha) ===
	var canvas_mat = CanvasItemMaterial.new()
	canvas_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA
	material = canvas_mat

	# === MATERIAL DE PROCESO ===
	var mat = ParticleProcessMaterial.new()
	process_material = mat

	# --- DIRECCIÓN ---
	mat.direction = Vector3(1, 0, 0)
	mat.spread = 3.0
	mat.initial_velocity_min = 220.0
	mat.initial_velocity_max = 320.0
	mat.linear_accel_min = 80.0
	mat.linear_accel_max = 120.0
	mat.gravity = Vector3(0, -45, 0)

	# --- TAMAÑO (pequeño) ---
	mat.scale_min = 0.1
	mat.scale_max = 0.3
	var scale_curve = Curve.new()
	scale_curve.add_point(Vector2(0.0, 0.0))
	scale_curve.add_point(Vector2(0.1, 0.8))
	scale_curve.add_point(Vector2(0.7, 1.0))
	scale_curve.add_point(Vector2(1.0, 0.0))
	mat.scale_curve = scale_curve

	# === TRANSPARENCIA: ¡AQUÍ ESTÁ LA CLAVE! ===
	# 1. color_ramp con alpha inicial = 0.1 (10%)
	var color_ramp = Gradient.new()
	color_ramp.add_point(0.0, Color(1, 1, 1, 0.1))   # ← ¡10% AL INICIO!
	color_ramp.add_point(0.15, Color(1, 1, 1, 0.7))
	color_ramp.add_point(0.6, Color(0.9, 0.9, 0.9, 0.8))
	color_ramp.add_point(1.0, Color(0.8, 0.8, 0.8, 0.0))  # ← 0% al final
	mat.color_ramp = color_ramp

	# 2. ¡NO uses alpha_curve! → rompe en muchos casos
	# mat.alpha_curve = null  # ← NO LO USES

	# 3. ¡IMPORTANTE! En el nodo GPUParticles2D:
	#    → Inspector → Drawing → Transparency = ON
	#    → (o en código:)
	draw_order = DRAW_ORDER_LIFETIME  # opcional

# === INTENSIDAD ===
func set_intensity(high: bool) -> void:
	amount = 35 if high else 20
	var mat = process_material
	if high:
		mat.initial_velocity_min = 280.0
		mat.initial_velocity_max = 400.0
	else:
		mat.initial_velocity_min = 220.0
		mat.initial_velocity_max = 320.0
	restart()
