// TRIÁNGULO DE SIERPINSKI INTERACTIVO Y PERSONALIZADO
// Controles: Teclas ↑/↓ para cambiar profundidad
// Mouse: Click para cambiar modo de color

int depth = 5;
int maxDepth = 8;
int minDepth = 0;
float triangleHeight;
PVector p1, p2, p3;
float rotation = 0;
boolean animating = true;
int colorMode = 0;
float hueOffset = 0;

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100);
  triangleHeight = sqrt(3) / 2 * width;
  p1 = new PVector(width / 2, 50);
  p2 = new PVector(50, height - 50);
  p3 = new PVector(width - 50, height - 50);
}

void draw() {
  background(0);
  
  // Título y controles
  fill(255);
  textSize(14);
  text("Profundidad: " + depth + " | Presiona ↑/↓ para cambiar", 10, 20);
  text("Click: Cambiar colores | Espacio: Pausa animación", 10, 40);
  text("Modo color: " + colorMode, 10, 60);
  
  // Animación de rotación
  if (animating) {
    rotation += 0.005;
    hueOffset += 0.5;
  }
  
  // Trasladar al centro para rotar
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(rotation);
  translate(-width / 2, -height / 2);
  
  noStroke();
  drawTriangle(depth, p1, p2, p3, 0);
  
  popMatrix();
}

void drawTriangle(int d, PVector v1, PVector v2, PVector v3, int level) {
  if (d == 0) {
    // Diferentes modos de colorización
    float h, s, b;
    
    switch(colorMode) {
      case 0: // Arcoíris dinámico
        h = (level * 30 + hueOffset) % 360;
        s = 80;
        b = 90;
        break;
      case 1: // Gradiente azul-púrpura
        h = map(level, 0, depth, 200, 300);
        s = 90;
        b = 80;
        break;
      case 2: // Fire (fuego)
        h = map(level, 0, depth, 0, 60);
        s = 100;
        b = 100;
        break;
      case 3: // Cian-Verde
        h = map(level, 0, depth, 120, 180);
        s = 70;
        b = 85;
        break;
      default:
        h = 0;
        s = 0;
        b = 100;
    }
    
    fill(h, s, b, 80);
    triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
  } else {
    PVector mid1 = new PVector((v1.x + v2.x) / 2, (v1.y + v2.y) / 2);
    PVector mid2 = new PVector((v2.x + v3.x) / 2, (v2.y + v3.y) / 2);
    PVector mid3 = new PVector((v1.x + v3.x) / 2, (v1.y + v3.y) / 2);
    
    drawTriangle(d - 1, v1, mid1, mid3, level + 1);
    drawTriangle(d - 1, mid1, v2, mid2, level + 1);
    drawTriangle(d - 1, mid3, mid2, v3, level + 1);
  }
}

void keyPressed() {
  if (keyCode == UP && depth < maxDepth) {
    depth++;
  } else if (keyCode == DOWN && depth > minDepth) {
    depth--;
  } else if (key == ' ') {
    animating = !animating;
  }
}

void mousePressed() {
  colorMode = (colorMode + 1) % 4;
  hueOffset = 0;
}