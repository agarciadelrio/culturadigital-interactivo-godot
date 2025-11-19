class_name Confetti

extends Node2D

# Asegúrate de que el nombre del nodo CPUParticles2D en tu escena sea 'Confetti'
@onready var particle_system: CPUParticles2D = $Confetti 

# --- 1. CONFIGURACIÓN INICIAL (Solo se ejecuta una vez) ---

func _ready() -> void:
	# Solo configuramos todos los parámetros visuales y físicos.
	_configure_particles(particle_system)
	
	# Aseguramos que el sistema esté apagado al inicio.
	particle_system.emitting = false


func _configure_particles(confetti: CPUParticles2D) -> void:
	# --- 1. FÍSICA (Explosión) ---
	confetti.direction = Vector2(0, -1)
	confetti.spread = 60.0
	confetti.gravity = Vector2(0, 150)
	confetti.initial_velocity_min = 300.0
	confetti.initial_velocity_max = 500.0
	confetti.damping_min = 40.0
	confetti.damping_max = 80.0
	confetti.explosiveness = 1.0
	
	# Rotación
	confetti.angular_velocity_min = -300.0
	confetti.angular_velocity_max = 300.0
	
	# --- 2. TEXTURA DE COLORES (Paleta) ---
	var colors = [
		Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN,
		Color.CYAN, Color.BLUE, Color.MAGENTA, Color(1, 0.5, 0.8)
	]
	
	var image = Image.create(colors.size(), 1, false, Image.FORMAT_RGBA8)
	for i in range(colors.size()):
		image.set_pixel(i, 0, colors[i])
		
	confetti.texture = ImageTexture.create_from_image(image)
	
	# --- 3. MATERIAL PARA ANIMACIÓN (Elige color al azar) ---
	var mat = CanvasItemMaterial.new()
	mat.particles_animation = true
	mat.particles_anim_h_frames = colors.size() 
	mat.particles_anim_v_frames = 1
	mat.particles_anim_loop = false
	confetti.material = mat
	
	confetti.anim_offset_max = 1.0 
	confetti.color = Color.WHITE
	
	# --- 4. DESVANECIMIENTO (Alpha) ---
	var fade_gradient = Gradient.new()
	fade_gradient.offsets = PackedFloat32Array([0.0, 0.8, 1.0])
	fade_gradient.colors = PackedColorArray([
		Color(1, 1, 1, 1), 
		Color(1, 1, 1, 1), 
		Color(1, 1, 1, 0)
	])
	confetti.color_ramp = fade_gradient
	
	confetti.hue_variation_min = 0.0
	confetti.hue_variation_max = 0.0

	# --- 5. TAMAÑO Y CURVA ---
	var curve = Curve.new()
	curve.add_point(Vector2(0, 0.0))
	curve.add_point(Vector2(0.2, 1.0))
	curve.add_point(Vector2(1, 0.0))
	confetti.scale_amount_curve = curve
	
	confetti.scale_amount_min = 6.0
	confetti.scale_amount_max = 8.0

	# --- 6. GENERAL ---
	confetti.amount = 150
	confetti.lifetime = 3.0
	confetti.local_coords = false


# --- 2. FUNCIÓN DE DISPARO Y LIMPIEZA ---

# Esta función se llama desde la escena Quiz.gd
func start_explosion() -> void:
	print("START EXPLOSION")
	# Reiniciamos el sistema (limpiando partículas viejas)
	particle_system.one_shot = true
	particle_system.restart()
	
	# Disparamos la explosión
	particle_system.emitting = true
	
	# Limpiamos automáticamente el nodo de la escena
	await particle_system.finished
	queue_free()
