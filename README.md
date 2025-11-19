# **Mi Interactivo (sobre remediación)**  
### PEC2 — Asignatura *20.644 · Cultura Digital* — UOC

## 🕹️ **Descripción general del proyecto**
**Mi Interactivo (sobre remediación)** es un proyecto práctico desarrollado para la PEC2 de la asignatura *Cultura Digital*. El objetivo es explorar el concepto de **remediación** propuesto por **Lev Manovich**, aplicándolo al caso de la **evolución de la edición de vídeo lineal hacia los sistemas no lineales**.

El resultado es una experiencia interactiva con estética retro inspirada en los años 90, presentada como un pequeño juego narrativo desarrollado con **Godot 4.5.1** usando **GDScript**. El jugador atraviesa varios escenarios mientras descubre cómo funcionaba la edición lineal y por qué su remediación dio lugar a las herramientas digitales que usamos actualmente.

---

## 🎮 **Concepto y planteamiento**
El proyecto combina:
- **Navegación estilo RPG retro** (top-down, 90s aesthetic)
- **Interacción con objetos e inventario**
- **Un mini-quiz** durante la escena del viaje por carretera
- **Tarjetas informativas** sobre conceptos técnicos
- **Una pequeña narrativa** que contextualiza la experiencia

El juego funciona como metáfora jugable de la “vieja” edición lineal:  
problemas logísticos, dependencia de soportes físicos, limitaciones materiales…  
Y su comparación con las facilidades de la edición digital actual.

---

## 🗺️ **Estructura del juego**

### **Escenarios principales**
1. **Salón principal**  
   Lugar inicial. Sirve para introducir al jugador y esconder la cartera (primer reto).

2. **Sala de edición**  
   Conjunto de cintas, monitores CRT y un sistema de edición lineal. El jugador descubre que falta cinta VHS y debe salir a comprarla.

3. **Garaje**  
   El jugador recoge el coche (Seat Ibiza 1990). Necesita **llaves** y **cartera** para poder avanzar.

4. **Carretera**  
   Minijuego simple donde las preguntas del quiz aparecen conforme el coche avanza.

5. **Tienda**  
   Si el jugador lleva su cartera, puede comprar la cinta y regresar.  
   Si no la lleva → vuelve a casa → se queda sin gasolina → **GAME OVER**.

6. **Final — Sala de edición**  
   Con la cinta, el jugador accede a las tarjetas informativas restantes y ve un fragmento real de vídeo amateur de los 90.

---

## 🧠 **Objetivos de aprendizaje**

El interactivo pretende que el usuario:

- Comprenda el concepto de **remediación** según Manovich.  
- Conozca las limitaciones reales de la **edición lineal analógica**.  
- Compare este sistema con la **edición no lineal digital actual**.  
- Observe cómo los procesos manuales y físicos (cintas, espacio, tiempo real) se transformaron en una interfaz digital flexible y accesible.  

---

## 🛠️ **Tecnologías utilizadas**

- **Godot Engine 4.5.1**
- **GDScript**
- Recursos gráficos estilo pixel-art (32×32 / 64×64)
- Archivos externos (vídeos y contenido documental)
- Imágenes de fondo generadas por Nano banana

Este proyecto ha sido mi **primera toma de contacto con Godot**, y ha supuesto un aprendizaje significativo tanto a nivel técnico como conceptual.

---

## 🧵 **Estado del código**

El código está publicado **con fines educativos**.  
Dado que he ido aprendiendo sobre Godot y GDScript mientras avanzaba:

- El código puede ser considerado **“spaghetti code”** en algunos puntos.  
- No sigue una arquitectura muy estricta.
- La intención es que **sirva de referencia a otras personas que también estén empezando**.

Aun así, el proyecto está completamente funcional y organizado para poder ser seguido sin dificultad.

---

## 🚀 **Cómo ejecutar el proyecto**

1. Instalar **Godot 4.5.1** o superior.  
2. Clonar o descargar este repositorio.  
3. Abrir la carpeta del proyecto desde Godot.  
4. Ejecutar la escena principal:  
   ```
   res://TheGame.tscn
   ```

---

## 📄 **Licencia**

El código está disponible bajo una **licencia libre**.

Los recursos audiovisuales incluidos pueden tener licencias independientes:

- [Vhs insert effect](https://www.youtube.com/watch?v=WJ04husUWqg)
- [Vídeo boda los 90](https://www.youtube.com/watch?v=prELmsS7d5M)
- Imágenes generadas con Nano banana

---

## 💬 **Agradecimientos**

- A la asignatura *Cultura Digital* por motivar este tipo de proyectos creativos.  
- A la comunidad de Godot por su documentación accesible.  
- A los autores de los recursos gratuitos utilizados para completar la estética retro.
