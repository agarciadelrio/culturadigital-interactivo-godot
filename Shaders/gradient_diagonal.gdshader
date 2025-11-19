shader_type canvas_item;

// Define los colores para el centro y el borde exterior
// El centro será el azul brillante y el borde será el azul/púrpura muy oscuro
uniform vec4 color_center : source_color = vec4(0.1, 0.3, 0.7, 1.0); // Azul oscuro brillante
uniform vec4 color_edge   : source_color = vec4(0.0, 0.05, 0.2, 1.0); // Azul casi negro con un toque púrpura

// Controla qué tan rápido se desvanece el brillo central
uniform float power : hint_range(0.5, 5.0) = 2.0;

void fragment() {
    // 1. Obtener coordenadas UV centradas (-0.5 a 0.5)
    vec2 uv = UV - 0.5;
    
    // 2. Calcular la distancia desde el centro
    // La longitud (length) de un vector 2D (uv) da su distancia al origen (0,0).
    float distance_from_center = length(uv);
    
    // 3. Crear el factor de mezcla (mix_factor)
    // Elevamos la distancia a una potencia (power) para controlar la curva de atenuación.
    // Cuanto más lejos esté el píxel del centro, mayor será este valor.
    float mix_factor = pow(distance_from_center, power);
    
    // 4. Asegurar que el factor de mezcla esté entre 0.0 y 1.0
    mix_factor = clamp(mix_factor, 0.0, 1.0);
    
    // 5. Mezclar entre el color central y el color del borde.
    // Si mix_factor es 0 (centro), el resultado es color_center.
    // Si mix_factor es 1 (borde), el resultado es color_edge.
    COLOR = mix(color_center, color_edge, mix_factor);
}