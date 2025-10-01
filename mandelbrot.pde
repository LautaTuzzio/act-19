// CONJUNTO DE MANDELBROT INTERACTIVO
// Controles: Click para hacer zoom | Teclas +/- para cambiar iteraciones
// Tecla 'r' para resetear | Tecla 'c' para cambiar paleta de colores

float xmin = -2.5;
float ymin = -2;
float w = 4;
float h = 4;
int maxIterations = 100;
int colorPalette = 0;
boolean needsRedraw = true;

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100);
  h = (w * height) / width;
}

void draw() {
  if (needsRedraw) {
    renderMandelbrot();
    needsRedraw = false;
  }
  
  // Información en pantalla
  fill(0);
  rect(0, 0, 350, 80);
  fill(255);
  textSize(12);
  text("Iteraciones: " + maxIterations + " (+/- para cambiar)", 10, 15);
  text("Zoom: " + nf(4.0/w, 1, 2) + "x", 10, 30);
  text("Click: Zoom In | Shift+Click: Zoom Out", 10, 45);
  text("'r': Reset | 'c': Cambiar paleta", 10, 60);
  text("Paleta: " + colorPalette, 10, 75);
}

void renderMandelbrot() {
  loadPixels();
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float a = map(x, 0, width, xmin, xmin + w);
      float b = map(y, 0, height, ymin, ymin + h);
      
      float ca = a;
      float cb = b;
      
      int n = 0;
      float z = 0;
      
      while (n < maxIterations) {
        float aa = a * a - b * b;
        float bb = 2 * a * b;
        
        a = aa + ca;
        b = bb + cb;
        
        z = a * a + b * b;
        if (z > 16) break;
        
        n++;
      }
      
      int pix = x + y * width;
      pixels[pix] = getColor(n, z);
    }
  }
  
  updatePixels();
}

color getColor(int iterations, float z) {
  if (iterations == maxIterations) {
    return color(0, 0, 0);
  }
  
  // Suavizado logarítmico para transiciones más suaves
  float smoothed = iterations + 1 - log(log(z)) / log(2);
  
  float h, s, b;
  
  switch(colorPalette) {
    case 0: // Espectro arcoíris
      h = map(smoothed, 0, maxIterations, 0, 360);
      s = 90;
      b = map(smoothed, 0, maxIterations, 50, 100);
      break;
      
    case 1: // Océano profundo
      h = map(smoothed, 0, maxIterations, 180, 240);
      s = map(smoothed, 0, maxIterations, 60, 100);
      b = map(smoothed, 0, maxIterations, 30, 90);
      break;
      
    case 2: // Fuego cósmico
      h = map(smoothed, 0, maxIterations, 0, 60);
      s = 100;
      b = map(smoothed, 0, maxIterations, 40, 100);
      break;
      
    case 3: // Bosque místico
      h = map(smoothed, 0, maxIterations, 80, 160);
      s = 80;
      b = map(smoothed, 0, maxIterations, 30, 85);
      break;
      
    case 4: // Púrpura eléctrico
      h = map(smoothed, 0, maxIterations, 260, 320);
      s = 90;
      b = map(smoothed, 0, maxIterations, 50, 100);
      break;
      
    default:
      h = 0;
      s = 0;
      b = map(iterations, 0, maxIterations, 0, 100);
  }
  
  return color(h, s, b);
}

void mousePressed() {
  // Calcular el punto clickeado en el plano complejo
  float mouseXComplex = map(mouseX, 0, width, xmin, xmin + w);
  float mouseYComplex = map(mouseY, 0, height, ymin, ymin + h);
  
  if (keyPressed && keyCode == SHIFT) {
    // Zoom out
    w *= 2;
    h *= 2;
  } else {
    // Zoom in
    w *= 0.5;
    h *= 0.5;
  }
  
  // Centrar en el punto clickeado
  xmin = mouseXComplex - w / 2;
  ymin = mouseYComplex - h / 2;
  
  needsRedraw = true;
}

void keyPressed() {
  if (key == '+' || key == '=') {
    maxIterations += 20;
    needsRedraw = true;
  } else if (key == '-' && maxIterations > 20) {
    maxIterations -= 20;
    needsRedraw = true;
  } else if (key == 'r' || key == 'R') {
    // Reset
    xmin = -2.5;
    ymin = -2;
    w = 4;
    h = (w * height) / width;
    maxIterations = 100;
    needsRedraw = true;
  } else if (key == 'c' || key == 'C') {
    colorPalette = (colorPalette + 1) % 5;
    needsRedraw = true;
  }
}